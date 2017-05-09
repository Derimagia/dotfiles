# misc paths

PURE_pprompt_SYMBOL=λ

# _pprompt_section <color> <content>
_pprompt_section() {
    local color content
    [[ -n $1 ]] && color="%F{$1}"  || color="%f"
    [[ -n $2 ]] && content="$2"    || content=""

    # Hacky, but pure doesn't have a way to add to the prompt so just alter the username variable.
    prompt_pure_username="%{%B$color%}$content%{%b%f%} $prompt_pure_username"
}

_pprompt_drush() {
    local f="${TMPDIR:-/tmp/}/drush-env-$USER/drush-drupal-site-$$"
    local ENV_COLOR

    if [[ -f $f ]]; then
        DRUSH_SITE=$(< $f)
    else
        DRUSH_SITE="$DRUPAL_SITE"
    fi

    case "$DRUSH_SITE" in
        *.live|*.prod) ENV_COLOR='red' ;;
        *.stage|*.test) ENV_COLOR="yellow" ;;
        *.local|*.dev) ENV_COLOR="green" ;;
        *) ENV_COLOR="blue" ;;
    esac

    [[ -n "$DRUSH_SITE" ]] && _pprompt_section $ENV_COLOR $DRUSH_SITE
}

_pprompt_desk() {
    [[ -n "$DESK_NAME" ]] && _pprompt_section 'cyan' $DESK_NAME
}

node_version="system"
_pprompt_node() {
    (( $+functions[nvm] )) || return

    async_start_worker node_version 2>/dev/null && {
        async_register_callback node_version _detect_node_version_callback
        async_job node_version nvm current

        _detect_node_version_callback() {
            node_version=$3
        }
    }

    [[ $node_version == "system" || $node_version == "node" ]] && return

    _pprompt_section 'green' "⬢  v$node_version"
}

docker_errcode=1
_pprompt_docker() {
    async_start_worker docker_version 2>/dev/null && {
        async_register_callback docker_version _detect_docker_version_callback
        async_job docker_version docker version -f "{{.Server.Version}}"

        _detect_docker_version_callback() {
            docker_errcode=$2
            docker_version=$3
        }
    }

    [[ -f Dockerfile || -f docker-compose.yml || -f docker-compose.yaml ]] || return

    (( $docker_errcode )) || _pprompt_section 'cyan' "🐳  v$docker_version"
}

_pprompt() {
    # Rest $prompt_pure_username
    prompt_pure_username=''

    # show username@host if logged in through SSH
	[[ "$SSH_CONNECTION" != '' ]] && prompt_pure_username='%F{242}%n@%m%f'

	# show username@host if root, with username in white
	[[ $UID -eq 0 ]] && prompt_pure_username='%F{white}%n%f%F{242}@%m%f'

    _pprompt_drush
    _pprompt_desk
    _pprompt_docker
    _pprompt_node
}

add-zsh-hook precmd _pprompt

# bracketed-paste-url-magic is a simplier version of bracketed-paste-magic
autoload -Uz bracketed-paste-url-magic url-quote-magic
zle -N bracketed-paste bracketed-paste-url-magic
zle -N self-insert url-quote-magic
