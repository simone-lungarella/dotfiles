# .bashrc
set -o vi

# ignore EOF to avoid closing pane or terminal with <C-d>
set -o ignoreeof

alias ls='eza'
alias cat='bat'

PS1='\n\w\n❯ '
