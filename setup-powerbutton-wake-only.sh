#!/bin/bash
# Wake up from suspend with the power button ONLY.
# Disables USB keyboard/mouse/hub wake, ACPI XHC0 wake and RTC wake so that
# neither key presses nor mains transients (lights, AC switching) resume the PC.
#
# Usage: ./setup-powerbutton-wake-only.sh
# Re-run safely any time; requires sudo for the system-wide install step.
set -euo pipefail

UDEV_RULE=/etc/udev/rules.d/90-disable-usb-wakeup.rules
SLEEP_HOOK=/usr/lib/systemd/system-sleep/10-disable-wakeup
BOOT_SCRIPT=/usr/local/bin/disable-usb-wakeup.sh
BOOT_SERVICE=/etc/systemd/system/disable-usb-wakeup.service

echo "==> Removing legacy setup that re-enabled XHC0 wake (if present)..."
sudo systemctl disable --now disable-wakeup-devices.service 2>/dev/null || true
sudo rm -f /etc/systemd/system/disable-wakeup-devices.service /usr/local/bin/fix-wakeup.sh

echo "==> Installing udev rule (no USB device may wake the system)..."
sudo tee "$UDEV_RULE" >/dev/null <<'EOF'
# No USB device may wake the system - power button only.
# Covers keyboard, mouse, hubs, bluetooth dongle, monitor USB upstream.
ACTION=="add|change", SUBSYSTEM=="usb", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
EOF

echo "==> Installing suspend/resume hook (firmware re-enables XHC0 on resume)..."
sudo tee "$SLEEP_HOOK" >/dev/null <<'EOF'
#!/bin/sh
# Re-disable wakeup sources around suspend/resume.
# Some Gigabyte B550 firmware re-enables XHC0 on resume, which would
# re-arm keyboard wake and mains-transient wakes until next reboot.
LOG=/var/log/disable-wakeup.log
{
    echo "=== $(date '+%F %T') hook argument: $1 ==="
    if grep -q 'XHC0.*\*enabled' /proc/acpi/wakeup 2>/dev/null; then
        echo XHC0 > /proc/acpi/wakeup 2>&1 && echo "XHC0 disabled" || echo "XHC0 toggle FAILED"
    else
        echo "XHC0 already disabled"
    fi
    for f in /sys/bus/usb/devices/*/power/wakeup; do
        [ -w "$f" ] && echo disabled > "$f" 2>/dev/null
    done
    echo "USB sysfs wakeups forced to disabled"
    if [ -w /sys/class/rtc/rtc0/device/power/wakeup ]; then
        echo disabled > /sys/class/rtc/rtc0/device/power/wakeup 2>/dev/null && echo "RTC wakeup disabled"
    fi
} >>"$LOG" 2>&1
EOF
sudo chmod 755 "$SLEEP_HOOK"

echo "==> Installing boot-time lockdown script + service..."
sudo tee "$BOOT_SCRIPT" >/dev/null <<'EOF'
#!/bin/bash
# Boot-time wakeup lockdown (runs as root via disable-usb-wakeup.service).
# udev rule + sleep hook do the durable work; this is belt-and-suspenders with logging.
LOG=/var/log/disable-wakeup.log
{
    echo "=== $(date '+%F %T') boot service ==="
    if grep -q 'XHC0.*\*enabled' /proc/acpi/wakeup 2>/dev/null; then
        echo XHC0 > /proc/acpi/wakeup 2>&1 && echo "XHC0 disabled" || echo "XHC0 toggle FAILED"
    else
        echo "XHC0 already disabled"
    fi
    for f in /sys/bus/usb/devices/*/power/wakeup; do
        [ -w "$f" ] && echo disabled > "$f" 2>/dev/null
    done
    echo "USB sysfs wakeups forced to disabled"
    if [ -w /sys/class/rtc/rtc0/device/power/wakeup ]; then
        echo disabled > /sys/class/rtc/rtc0/device/power/wakeup 2>/dev/null && echo "RTC wakeup disabled"
    fi
} >>"$LOG" 2>&1
EOF
sudo chmod 755 "$BOOT_SCRIPT"

sudo tee "$BOOT_SERVICE" >/dev/null <<'EOF'
[Unit]
Description=Disable USB wakeup in /proc/acpi/wakeup

[Service]
Type=oneshot
ExecStart=/usr/local/bin/disable-usb-wakeup.sh

[Install]
WantedBy=multi-user.target
EOF

echo "==> Activating..."
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=usb --action=change
sudo systemctl daemon-reload
sudo systemctl enable --now disable-usb-wakeup.service

echo "==> Verifying (all lines should show disabled)..."
grep -E 'XHC0|PWRB|PNP0C0C' /proc/acpi/wakeup || true
grep -H . /sys/bus/usb/devices/*/power/wakeup 2>/dev/null || true

cat <<'EOF'

Done. The power button (LNXPWRBN / PNP0C0C) stays armed; everything else is disarmed.
Also confirm these BIOS settings (Gigabyte: Settings -> Platform Power):
  AC BACK            -> Always Off   (Memory/Always On resumes the PC on power dips)
  Power On By Keyboard -> Disabled
  Power On By Mouse    -> Disabled
  Resume by Alarm      -> Disabled
  Wake on LAN          -> Disabled
  ErP                  -> Enabled
Test: suspend, press keys / flip room lights (must stay asleep), press power (wakes).
Log: /var/log/disable-wakeup.log
EOF
