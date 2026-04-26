function prependToPATH_fn {
    # Prepend to path without duplicating entries
    case ":$PATH:" in
        *":$1:"*) :;; # already there
        *) PATH="$1:$PATH";;
    esac
}

function appendToPATH_fn {
    # Append to path without duplicating entries
    case ":$PATH:" in
        *":$1:"*) :;; # already there
        *) PATH="$PATH:$1";;
    esac
}

# function reload () {
#     exec "${SHELL}" "$@"
# }

function yy() {
    # https://yazi-rs.github.io/docs/quick-start#shell-wrapper
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    	builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

function extract () {
    # Easily extract archives
    if [ -f $1 ] ; then
        case $1 in
        *.tar.bz2)   tar xjvf $1    ;;
        *.tar.gz)    tar xzvf $1    ;;
        *.tar.xz)    tar xvf $1    ;;
        *.bz2)       bzip2 -d $1    ;;
        *.rar)       unrar $1    ;;
        *.gz)        gunzip $1    ;;
        *.tar)       tar xf $1    ;;
        *.tbz2)      tar xjf $1    ;;
        *.tgz)       tar xzf $1    ;;
        *.zip)       unzip $1     ;;
        *.Z)         uncompress $1    ;;
        *.7z)        7z x $1    ;;
        # *.ace)       unace x $1    ;;
        *)           echo "'$1' cannot be extracted via extract()"   ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

