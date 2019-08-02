# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

export EDITOR=vim
export VISUAL="vim"
export GIT_EDITOR="vim"
export PATH="$HOME/.cargo/bin:$PATH"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="\[\e[01;32m\]\u@\h\[\e[1;34m\]:\[\e[01;33m\]\w\[\e[00m\e[0;36m\]\$(parse_git_branch)\[\e[1;34m\]\$\[\e[0m\] "

# Make bash check its window size after a process completes
shopt -s checkwinsize

[ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"
[ -f "/usr/local/etc/bash_completion" ] && . "/usr/local/etc/bash_completion"
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

