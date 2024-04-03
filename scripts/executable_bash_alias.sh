alias search-history='history | rg '
alias rt-lck='sudo passwd -l root'
alias rt-unlck='sudo passwd -u root'
alias kill-tty='sudo pkill -9 -t '
alias sway-tree='swaymsg -t get_tree'
alias resolution='bash ~/scripts/resolution.sh'
alias float-window='$HOME/scripts/window.sh'
alias config='/usr/bin/git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME/.dotfiles"'
alias ls='ls --color=auto --hyperlink=auto'
alias grep='grep --color=auto'
alias icat='kitten icat'
alias hx='helix'
alias dhistory='$HOME/scripts/dunstctl-history.sh'
alias cz='chezmoi'
alias repo-fast-idn='sudo reflector -f 5 --latest 20 -c Indonesia --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
