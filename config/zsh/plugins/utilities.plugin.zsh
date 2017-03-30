# Aliases
alias fs='stat -c "%s Bytes"' # File Size
alias map="xargs -n1"
alias editvar='vared'
alias v="vim"
alias vim="nvim"
alias ffs='sudo $(fc -ln -1)'
alias ag='ag -f --hidden'
alias ccat='vimcat'
alias mmv='noglob zmv -W'
alias dk='desk .'
alias s='find . -iname'
alias i="idea"
alias help=run-help

# tmux
alias tmux='tmux -2 -f $XDG_CONFIG_HOME/tmux/tmux.conf'
alias ta='tmux attach -d'
alias tnew='tmux new -s'

# dotfile
alias cddot="cd $DOTFILES"
alias dottime='time zsh -ic true';
alias doti="i $DOTFILES"
alias dotc="code $DOTFILES"
alias confv="vimr --cwd $DOTFILES/.config"
alias brewc="code $HOMEBREW_PREFIX/etc"
alias brewi="i $HOMEBREW_PREFIX/etc"

# git
alias g="git"
alias gup='gitup'
alias diffg="git diff --color-words --no-index"
alias dclone="clone -d"

# Global Aliases
alias -g G="| grep -i --"
alias -g P='2>&1 | $PAGER'

# Suffix Aliases
alias -s htm="$BROWSER"
alias -s html="$BROWSER"
alias -s yaml="ccat"
alias -s yml="ccat"
alias -s json="jq ."
alias -s xml="ccat"
alias -s py="python"
alias -s jar="java -jar"
alias -s war="java -jar"
alias -s Dockerfile="docker build - < "

# Url functions
alias urlencode='node -e "console.log(encodeURIComponent(process.argv[1]))"'
alias urldecode='node -e "console.log(decodeURIComponent(process.argv[1]))"'
alias html2text='w3m -dump -T text/html'

# Create a new directory and enter it
take() {
    mkdir -p "$1" && cd "$1"
}

# z is the new j? I guess?
z() {
    text="$@"
    if [[ -z "$text" ]]; then
        # Print with score
        cd "$(fasd -d "$text" | fzf-tmux | awk '{print $2}')"
        return
    fi

    directory=$(fasd -ld "$text" | head -n1)
    if [[ -n $directory ]]; then
        cd "$directory"
    else
        ink -c red -t 2 'No Directory found'
        return 1
    fi
}

# use fasd to select file
f() {
    fasd -f "$1" | fzf-tmux --select-1 | awk '{print $2}'
}

# All the dig info
digga() {
    dig +nocmd "$1" any +multiline +noall +answer
}

# print out aliases and search using it
aliases() {
    alias | grep -E ${1-.} | \
        ccat | \
        fzf-tmux
}

# get external ip
ip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

# copy with progress
cpp() {
    rsync -WavP --human-readable --progress $1 $2
}

# get gzipped size
gz() {
    echo "orig size    (bytes): "
    cat "$1" | wc -c
    echo "gzipped size (bytes): "
    gzip -c "$1" | wc -c
}

# direct it all to /dev/null
nullify() {
    "$@" >/dev/null 2>&1
}

# print out arguments for zsh
args() {
    ink -c blue '$#'
    print -l $#
    ink -c blue '$*'
    print -l $*
    ink -c blue '$@'
    print -l $@
}

# man zshbuiltins
manzsh() {
  man zshbuiltins | less -XF -p "^ *$@"
}

# man a specific option
manopt() {
  local program="$1"
  shift
  man $program | less -XF -p "^ *$@"
}

# UTF-8-encode a string of Unicode symbols
escape() {
    printf "\\\x%s" $(print "$@" | xxd -p -c1 -u);
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo ""; # newline
    fi;
}

# decode \x{ABCD}-style Unicode escape sequences
unidecode() {
    perl -e "binmode(STDOUT, ':utf8'); print \"$@\"";
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo ""; # newline
    fi;
}

# get a character’s Unicode code point
codepoint() {
    perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))";
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo ""; # newline
    fi;
}

# Wwatch and print out fs changes. Defaults to current directory
watchfs() {
    watchargs=$*
    if [[ -z $watchargs ]]; then
        watchargs='.'
    fi

    sudo watchman-wait -m 0 $watchargs
}

# print opened connections, filtered by known applications.
lsofopen() {
    # 2BUA8C4S2 = 1password
    local ignore=(Google Dropbox Slack Mail 2BUA8C4S2)
    lsof -nPi TCP | grep -v "^${(j:\|:)ignore}"
}

# scan incoming traffic.
sniff() {
    local device='en0'
    local port=80

    case "$#" in
        1) device="$1";;
        2) device="$1"
           port="$2";;
        *) ;;
    esac

    sudo ngrep -d ${device} -t '^(GET|POST) ' "tcp and port ${port}"
}

# create a data URL from a file
dataurl() {
    local mimeType=`file -b --mime-type "$1"`

    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(base64 -w 0 "$1")"
}

# reads a link until it can't anymore.
readtrail () {
    local the_path="$1"
    [[ -L $the_path ]] || return

    # If there's no link we're at the top
    if [[ -z $the_link ]]; then
        echo $the_path
    fi

    local the_link=${the_path:A}
    if [[ "$the_path" != "$the_link" ]]; then
        echo $the_link
        readtrail $the_link
    fi
}