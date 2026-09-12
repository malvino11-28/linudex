# Linudex Bash configuration

# History
HISTCONTROL=ignoreboth
HISTSIZE=2000
HISTFILESIZE=4000

# Better ls aliases
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Package management
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Linudex info
alias ram='free -h'
alias disk='df -h'
alias processes='ps aux'

# Prompt
PS1='\u@\h:\w\$ '