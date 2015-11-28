# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="af-magic"

ZSH_THEME="af-magic"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew autojump custom-aliases osx)

source $ZSH/oh-my-zsh.sh

if [[ $(uname) == "Darwin" ]]; then
    OS="MAC"
elif [[ $(uname) == "Linux" ]]; then
    OS="LINUX"
else
    echo "Os not recognized!"
fi

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi

if [[ $OS == "LINUX" ]]; then
    export ANDROID_SDK_HOME=/usr/local/google/home/robertkoz/Development/android-sdk-linux
    export clo='/google/src/cloud/robertkoz'
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
    export sdk="/usr/local/google/home/robertkoz/Development/android-sdk-linux"
    if [[ $SESSION_TYPE != "remote/ssh" ]]; then
        xset r rate 200 40
    fi
elif [[ $OS == "MAC" ]]; then
    export ANDROID_JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home
    export IDEA_JDK=/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home
    # mount Android workspace
    function mountAndroid {
        hdiutil attach ~/android.dmg.sparseimage -mountpoint /Volumes/untitled
    }
    alias notf="osascript -e 'display notification \"Build Finished\" with title \"Build\"'"
fi

export PATH="/usr/local/git/current/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/Users/robertkoz/bin:/opt/local/bin:/google/data/ro/teams/plx/"
# export MANPATH="/usr/local/man:$MANPATH"

export EDITOR='vim'

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set vim keymap in the shell prompt
bindkey -v

# Tmux settings
alias tmux="TERM=screen-256color-bce tmux"

# history search in zsh
bindkey -v

bindkey '\e[3~' delete-char

bindkey '^R' history-incremental-search-backward

killit() {
    # Kills any process that matches a regexp passed to it
    ps aux | grep -v "grep" | grep "$@" | awk '{print $2}' | xargs sudo kill
}

grepout() {
    tmux capture-pane -S -5000 ; tmux save-buffer - | grep "$@"
}

ff() {
    emacsclient $@ &
}

hvim() {
    history | grep $@ | vim -
}

gitc() {
  MESSAGE=$@
  if [[ -z "$@" ]]; then
    MESSAGE="Commit at $(date).\nLast 5 zsh commands:\n$(history | tail -n 5)"
  fi
  git add -A
  echo $MESSAGE
  git commit -m "$MESSAGE"
}

