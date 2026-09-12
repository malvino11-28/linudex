# Linudex Termux host configuration

alias ll='ls -lah'
alias la='ls -A'

alias start-linudex='$HOME/start-linudex.sh'
alias stop-linudex='$HOME/stop-linudex.sh'

alias debian='proot-distro login linudex --user linudex --shared-tmp'

alias update-termux='pkg update && pkg upgrade'

export EDITOR=nano