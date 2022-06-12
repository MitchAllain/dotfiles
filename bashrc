# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}\u@\h \[\033[32m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h \[\033[32m\]\W \$ '
else
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\W\$(parse_git_branch) \$ "
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W \$ '
fi
unset color_prompt force_color_prompt

#   Set default editor using update-alternatives if available
if [ -L "/usr/bin/editor" ] && [ -e "/usr/bin/editor" ] ; then
    export EDITOR=/usr/bin/editor
elif command -v nvim &> /dev/null; then
    export EDITOR=$(command -v nvim)
else
    export EDITOR=/usr/bin/vi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# unbind "readline arguments" to use meta + digits as hotkey
# https://stackoverflow.com/a/50123018/3885499
for i in - {0..9} ; do
    bind -r '\e'$i
done

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Bastian-Specific Environment Setup
# Currently needs to run after to ~/.bash_aliases due to
# nested sourcing of private aliases which use env variables
if [ -f ~/.bastianrc ] && [ -f ~/.aliases/bastian_aliases.sh ]; then
    . ~/.bastianrc
    . ~/.aliases/bastian_aliases.sh
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

export PATH="$HOME/.cargo/bin:$PATH"

# OS-specific setup
if [[ "$ostype" == "linux-gnu"* ]]; then
    # >>> conda initialize >>>
    # !! contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/mallain/anaconda2/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/mallain/anaconda2/etc/profile.d/conda.sh" ]; then
            . "/home/mallain/anaconda2/etc/profile.d/conda.sh"
        else
            export path="/home/mallain/anaconda2/bin:$path"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

elif [[ "$ostype" == "darwin"* ]]; then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/Users/mallain/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/Users/mallain/opt/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/Users/mallain/opt/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/Users/mallain/opt/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

    export BASH_SILENCE_DEPRECATION_WARNING=1
fi


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
bind 'set show-all-if-ambiguous on'
# bind 'TAB:menu-complete'
bind Space:magic-space

#if [[ -f ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh && ! -n $SSH_CONNECTION ]]; then
#    source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
#fi

export TERM=xterm-256color

# go path for building singularity from source
if [ -d "/usr/local/go/bin" ]; then
    export PATH=/usr/local/go/bin:$PATH
fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#eval "$(starship init bash)"

