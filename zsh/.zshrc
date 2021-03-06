(( $PROFILING )) && zmodload zsh/zprof

if [[ $OSTYPE =~ darwin && -x /usr/libexec/path_helper ]]; then
	if [[ ! -f "$TMPPREFIX"/path-helper.sh ]]; then
		/usr/libexec/path_helper -s > "$TMPPREFIX"/path-helper.sh
	fi
	source  "$TMPPREFIX"/path-helper.sh
fi

# See man zshoptions or http://zsh.sourceforge.net/Doc/Release/Options.html
setopt \
	MULTIOS AUTO_CD \
	INTERACTIVE_COMMENTS MAGIC_EQUAL_SUBST SHORT_LOOPS \
	EXTENDED_HISTORY SHARE_HISTORY HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_IGNORE_DUPS \
	KSH_OPTION_PRINT

# Autoload needed functions
autoload -Uz add-zsh-hook compinit zmv

# Reset key bindings
bindkey -e

# ZSH Variables
HISTFILE="$XDG_DATA_HOME/zsh/history" HISTSIZE=100000 SAVEHIST=100000

## Custom Packages

# Autoload files
autoload -Uz "$ZDOTDIR"/autoload/*(-.N:t)
fpath+=("$ZDOTDIR"/autoload)
path=("$ZDOTDIR"/bin $path)

for plugin_file ("$ZDOTDIR"/*.plugin.zsh) source "$plugin_file"
unset plugin_file

## Packages
if [[ ! -f "$TMPPREFIX/antibody-plugins.sh" ]] {
	ink -c green -- '- Generating Antibody Bundle -'

	{
		# Packaged
		local antibody_plugins=(
			zsh-users/zsh-completions
			psprint/history-search-multi-word
			zsh-users/zsh-autosuggestions
			zdharma/fast-syntax-highlighting
			zsh-users/zsh-history-substring-search
		)

		antibody init
		echo ${(F)antibody_plugins} | antibody bundle
	} | > "$TMPPREFIX/antibody-plugins.sh"
}
source "$TMPPREFIX/antibody-plugins.sh"

(( $+gopath )) && path+=(${^gopath}/bin)
(( $+CARGO_HOME )) && path+=("$CARGO_HOME"/bin)
(( $+COMPOSER_HOME )) && path+=("$COMPOSER_HOME"/vendor/bin)
(( $+ANDROID_SDK_ROOT )) && path+=("$ANDROID_SDK_ROOT"/platform-tools)

bindkey '^[[A' history-substring-search-up          # [UpArrow] - Sourced after syntax-highlighting
bindkey '^[[B' history-substring-search-down        # [DownArrow]

bindkey '^[[1;5C' forward-word                      # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                     # [Ctrl-LeftArrow] - move backward one word

bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line

bindkey "${terminfo[kdch1]}" delete-char          # [Delete] - Delete

bindkey '\ew' kill-region                           # [Esc-w] - Kill from the cursor to the mark

## Local
path=("$ZDOTDIR"/local/bin $path)
[[ -f "$ZDOTDIR"/.zlocalrc ]] && source "$ZDOTDIR"/.zlocalrc

compinit -C

(( $PROFILING )) && zprof
