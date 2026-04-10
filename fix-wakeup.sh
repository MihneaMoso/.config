#!/bin/bash
# Make sure this file is executable and is in /usr/local/bin/
# Also, make sure the service to disable wakeup devices is in /etc/systemd/system/disable-wakeup-devices.service
# And run
# sudo systemctl daemon-reload
# sudo systemctl enable --now disable-wakeup-devices.service

# Devices you want DISABLED
declare -a to_disable=("GP12" "GP13" "GPP8" "SWUS" "SWDS" "PT29" "GPP0" "PTXH")

for device in "${to_disable[@]}"; do
    # Only toggle if it is currently enabled
    if grep -q "$device.*enabled" /proc/acpi/wakeup; then
        echo "$device" > /proc/acpi/wakeup
    fi
done

# Ensure XHC0 is ENABLED (for your keyboard/mouse)
if grep -q "XHC0.*disabled" /proc/acpi/wakeup; then
    echo "XHC0" > /proc/acpi/wakeup
fi
