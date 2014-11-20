export EDITOR=/usr/bin/vim
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything:
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
export  HISTSIZE=10000
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases

if [ "$TERM" != "dumb" ]; then
    TERM=xterm-256color
fi
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    # some more ls aliases
    alias ll='ls  --color -lah'
    #alias la='ls -A'
    #alias l='ls -CF'
    alias ls="ls -h --color=auto"
fi
alias ssh-add="ssh-add -t 43200 -c"
alias grep="grep --color"
alias opannotate-asm='opannotate -a --objdump-params -S'
ulimit -c unlimited
# Environnement
if [ "$PS1" ]; then
    function __prompt_git()
    {
        local git_dir ref br;
        git_dir=$(git-rev-parse --git-dir 2> /dev/null) || return
        ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
        br=${ref#refs/heads/}
        #nb=$(git status |grep modified:|wc -l 2> /dev/null) || return
        #if test $nb -eq 0; then
          echo -e "[git:$br]"
        #else
        #    echo -e "[git:$br($nb)]"
        #fi
    }
#    PS1='\[\e[34;1m\]\u@\[\e[32;1m\]\H:\[\e[31;1m\]$(__prompt_git)\[\e[0m\]\w\[\e[31;1m\]\$ \[\e[0m\]'
    PS1='\[\e[34;1m\]\u@\[\e[32;1m\]\H:\[\e[31;1m\]$(__git_ps1 "[%s]")\[\e[0m\]\w\[\e[31;1m\]\$ \[\e[0m\]'
fi

# Pour plus de sécurité
[[ $UID == 0 ]] && export PS1='\[\033[00;36m\][\h\[\033[00m\]:\w\[\033[00;36m\]]\[\033[00m\] \[\033[01;31m\]\u# \[\033[00m\]'
export LC_ALL="en_AU.UTF-8"


# This line was appended by KDE
# Make sure our customised gtkrc file is loaded.
export GTK2_RC_FILES=$HOME/.gtkrc-2.0
if [ `uname -s` == "SunOS" ]; then
    export PATH=/usr/local/bin:$PATH
    alias vi="vim"
fi
export PATH=/srv/tools/bin:/home/aurel/local/bin:/home/aurel/bin:/home/aurel/.gem/ruby/1.8/bin:$PATH
export PYTHONPATH=/srv/tools/lib/python
export MCMS_HOME=/home/aurel/mcms-aurel
if [ `uname -s` == "SunOS" ]; then
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib:/opt/csw/lib
fi
export LD_LIBRARY_PATH
if [ -d /var/tmp/aurel/ccache ] ; then
    export CCACHE_DIR=/var/tmp/aurel/ccache
    export PATH="/usr/lib/ccache:${PATH}"
    export CCACHE_NOCOMPRESS=1
fi
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

setterm -blength 0
