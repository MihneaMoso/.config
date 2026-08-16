source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
set --export OPENAI_BASE_URL "http://localhost:20128/v1"
set --export OMNIROUTE_API_KEY "sk-349d7260628f235b-87224b-50fb20d3"
set --export OPENAI_API_KEY "local-key"
set -Ux --export SSL_CERT_FILE '/etc/ssl/certs/ca-certificates.crt'

# aliases
# alias curl="curl -k"
alias v="nvim"

# nub
set -gx PATH "$HOME/.nub/bin" $PATH

# Editor
set -gx EDITOR nvim
