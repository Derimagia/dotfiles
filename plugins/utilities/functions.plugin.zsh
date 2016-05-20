# Create a new directory and enter it
take(){
    mkdir "$1" && cd "$1"
}

# z is the new j? I guess?
z() {
    cd $(fasd -d "$1" | fzf-tmux --select-1)
}

f() {
    fasd -f "$1" | fzf-tmux --select-1
}

# All the dig info
digga() {
    dig +nocmd "$1" any +multiline +noall +answer
}

aliases() {
    alias | grep -E ${1-.} | \
        ccat | \
        fzf-tmux
}

escape() {
    print -f "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
}

ip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

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
