export UNAME=$(uname)
export HOSTNAME=$(hostname)
export EDITOR=vi
export HISTSIZE=2000;

# Make MAN pages look better, with some color and formatting.
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;38;5;74m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[38;5;246m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[04;38;5;146m'


if [ $(uname) == "Darwin" ]; then
        # OSX specific stuff goes here
        export PATH=$PATH:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/sfw/bin:/opt/csw/bin:/Users/pickellj/bin:/usr/ccs/bin
else
        # Linux specific stuff goes here
        export PATH=$PATH:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/sfw/bin:/opt/csw/bin:/home/pickellj/bin:/usr/ccs/bin
        export MANPATH=$MANPATH:/usr/man:/opt/csw/man:/opt/redhat/rhn/solaris/man
fi

if [ -f "/etc/dircolors" ]
then
  eval $(dircolors -b /etc/dircolors)
  if [ -f "$HOME/.dircolors" ]
  then
    eval $(dircolors -b $HOME/.dircolors)
  fi
fi
export CLICOLOR=1

# Keyboard aliases
alias lsd="ls -al|grep ^d|grep -v '\.'"
alias ld="ls -al|grep drw"
alias ll="ls -al"
alias cl="clear"
alias m="more"
alias ss="sudo -s"
alias lock="open -a /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
alias synergy="/Applications/Synergy.app/Contents/MacOS/synergyc pickellj.wwt.com"
alias webshare='python -m SimpleHTTPServer 8888'
# git aliases
alias ga="git add ."
alias gs="git status"
alias gc="git commit -m"
alias gp="git push"
alias wwt="ssh pickellj@linuxadmin2"
alias mars="ssh jkp@mars.vxrs.com"

source ~/.colors 
rst='\e[0m'    # Text Reset

case "$UNAME" in
        Linux) alias vi="vim"
                ;;
        SunOS) alias vi="vi"
                ;;
        Darwin) alias vi="mvim"
                alias va="mvim --remote-tab"
                ;;
esac

case "$HOSTNAME" in
        sand*) hc=$Cyan
                ;;
        snd*) hc=$Cyan
                ;;
        dev*) hc=$Green
                ;;
        test*) hc=$Yellow
                ;;
        tst*) hc=$Yellow
                ;;
        prod*) hc=$Red
                ;;
        prd*) hc=$Red
                ;;
        *) hc=$White
esac

# check for sudo
# frame=$Cyan;
frame=$hc;

if [ -f "/usr/bin/git" ]; then 

function git-branch-name {
	git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3
}

function git-branch-prompt {
	branch=`git-branch-name`
        if [ $branch ]; then printf "\n[$Yellow%s$frame]\n" $branch; fi
}

else
        function git-branch-name { GIT="Not Installed"; }
        function git-branch-prompt { printf ""; }
fi

case $UID in
        0 ) root=$BRed;
            p=\#;
            P=!!!;
            export PS1="\n\[$frame\][\[$root\]\u\[$frame\]@\[$hc\]\h\[$frame\]] [\[$root\]\d \T\[$frame\]] [\[$root\]\w\[$frame\]] $p\[$frame\]\[$Colour_Off\] "
            ;;

        * ) root=$White;
            p=\$;
            P=;
            export PS1="\n\[$frame\][\[$root\]\u\[$frame\]@\[$hc\]\h\[$frame\]] [\[$root\]\d \T\[$frame\]] [\[$root\]\w\[$frame\]] \$(git-branch-prompt)\n\[$frame\]\[$root\]$p\[$frame\]\[$Colour_Off\] "
            ;;

esac

export PROMPT_COMMAND='echo -ne "\033]0;$P $LOGNAME@$HOSTNAME $P\007"'
