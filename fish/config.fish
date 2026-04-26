source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
set -Ux --export SSL_CERT_FILE '/etc/ssl/certs/ca-certificates.crt'

# aliases
# alias curl="curl -k"
alias v="nvim"
