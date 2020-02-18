# .zshrc version 1.0 01/01/2020 jkp
export PATH=$PATH:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$HOME/bin
export ZSH=$HOME/".oh-my-zsh"
ZSH_THEME="jkp"
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
# DISABLE_UPDATE_PROMPT="true"
# export UPDATE_ZSH_DAYS=13

HIST_STAMPS="yyyy.mm.dd"
ZSH_DISABLE_COMPFIX=true

plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration
export NOTESDIR="$HOME/Notes"
# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
  case `uname` in
    Linux)
      export EDITOR='gvim'
      export YESTERDAY=`date --date="1 day ago" +%Y-%m-%d`
    ;;
    Darwin)
      export EDITOR='mvim'
      export YESTERDAY=`date -v-1d +%F`
    ;;
  esac
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

alias zshconfig="vi ~/.zshrc"
alias ohmyzsh="vi ~/.oh-my-zsh"
alias tsftp="sftp -i $HOME/Documents/Tanium/Local_Machine/tancopy_id_rsa"
alias c="clear"
alias h="history"
alias more="less"
alias l="less"
alias s="sudo -Es"
alias lsd="ls -al|grep ^d"
alias vi=$EDITOR

#precmd() { print -Pn "\e]0;$*\a" }

#------------------
# Various Functions
#------------------
#
# Lets declare some vars here so we only do it once, instead of 
# multiple times in each function.
TODAY=`date +%Y-%m-%d`
YEAR=`date +%Y`
YMONTH=`date +%Y-%m`


# Archive older notes to the appropriate Year folder
an() {
  # - Need to update to account for 2020-12-31.md, etc
  ARCHIVE=`find $(echo $NOTESDIR)/ -maxdepth 1 -name "$YEAR*" -type f -atime 1`

  if [ $#ARCHIVE -gt 0 ]
    then
      for a in $(echo $ARCHIVE); do
        echo "Archiving $a"
        mv $a $NOTESDIR/$YEAR/
      done
  fi
}

# Notes - Edit new or existing, defaults to .md
n() { 
  # Check for old dailies and archive if found
  an

  if [ $* ]
    then
      # Strip the file extension and use .md always
      file=$*:r
      $EDITOR $NOTESDIR/"$file".md
    else # The file exists, so open it in insert mode and add a timestamp.
      if [ ! -f $* ]  # Don't add a newline above the date if the file is new
        then 
          $EDITOR +star -c '$r!date +\%T;echo' $NOTESDIR/$TODAY.md
        else
          $EDITOR +star -c '$r!echo;date +\%T;echo' $NOTESDIR/$TODAY.md
      fi
  fi
}

# Notes - List all notes (trim off extension for now)
nl() {
  command clear 
  echo " "
  FILES=""
  DIRS=""
  if [ $* ]
    # Handle subdirectories
  then
    echo $NOTESDIR/$* "\n----"
    ls -c $NOTESDIR/$*|cut -f1 -d'.'
  else 
	  ITEMS=`ls -c $NOTESDIR | cut -f1 -d'.'`
    for f in $( echo "$ITEMS"); do 
      if [[ -d $NOTESDIR/$f ]]
      then 
        DIRS+=( $f )
      else
        FILES+=( $f )
      fi
    done
        
    for d in $DIRS; do
      #echo "[" $d "]"
      printf ' [ %-15s ]\n' $d
      FLIST=`ls -c $NOTESDIR/$d|sed s/\ /_/g`
      #for fl in $(echo $FLIST); do
      #  echo " "$fl:r
      #done
      done
      echo " " 

    for fl in $(echo $FILES); do
        echo " - "$fl:r
    done
  fi
}

# Notes - Search for notes 
# Currently only searches the top level, does not descend directories
ns() { 
	if [ $* ]
	    then
        ITEMS=`find $NOTESDIR/ -name "*.md"`
        for i in $(echo "$ITEMS"); do
		      S=`grep -i $* $i`
          if [[ $? -lt 1 ]]
          then
            echo "$fg_bold[$root]$i $reset_color \n$S\n" #$fg_bold[$root].$reset_color\n"
          fi
        done
	    else
        echo "Please enter a search term\n\nns <search term>"
	fi
}

# Notes View - Show the contents of a given note 
nv() {
	if [ $* ]
	    then 
		view $NOTESDIR/$*.md
	    else
		echo "Please provide the name of a note to view\n\nnv <notename>"
	fi
}

# Notes View - Show the contents of yesterday's note
yn() {
  view $NOTESDIR/$YEAR/$YESTERDAY.md
}