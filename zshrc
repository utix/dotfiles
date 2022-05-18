#! /bin/zsh

autoload -U compinit zrecompile

_my_main () {
    local zsh_cache zshrc_snipplet
    setopt extended_glob

    zsh_cache=${HOME}/.cache/zsh

    if [ $UID -eq 0 ]; then
        compinit
    else
        compinit -d $zsh_cache/zcomp-$HOST

        for f in ~/.zshrc $zsh_cache/zcomp-$HOST; do
            zrecompile -p $f && rm -f $f.zwc.old
        done
    fi

    for zshrc_snipplet in ~/.config/zsh/[0-9][0-9][^.]#; do
        source $zshrc_snipplet
    done
}
_my_main
#source /home/aurel/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
