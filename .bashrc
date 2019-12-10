# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions


## Prompt
if [ ! -f ~/.git-prompt.sh ]; then curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o .git-prompt.sh; fi
. ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true

p_dir='\[\e[36m\][\[\e[m\]\[\e[36m\]\w\[\e[m\]\[\e[36m\]]\[\e[m\]'
p_host='\[\e[33m\](\h)\[\e[m\]'
p_user="\$(if [ \$? -ne 0 ]; then echo '\[\e[35m\]'; else echo '\[\e[32m\]'; fi)\u\[\e[m\]"
p_end='\[\e[0m\]\\$\[\e[m\] '
PROMPT_COMMAND='__git_ps1 "\n$p_dir " "\n$p_user $p_end"'

# Functions
is_remote_host() { [[ ! -z "${REMOTEHOST}" || ! -z "${SSH_CONNECTION}" ]]; }

# emacs
function er () {
    emacs "$1" --eval '(setq buffer-read-only t)'
}

# Alias
alias e='emacsclient -t'
alias ls='ls --color'
alias la='ls -la'
alias ll='ls -l'
alias grep='grep --color=always -IHn'


## Remote host (or not)
if is_remote_host; then
    PROMPT_COMMAND='__git_ps1 "\n$p_dir " "\n$p_host $p_user $p_end"'
fi

# TMUX
if [[ -z "$TMUX" && -z "$STY" ]] && type tmux >/dev/null 2>&1; then
  if tmux has-session; then
    tmux attach;
  else
    tmux;
  fi
fi
