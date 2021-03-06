export PAGER='bat -p'
export BAT_PAGER='less -FXR'
export EDITOR='nvim'
export VISUAL='subl'

# Defaults
: ${LANG:='en_US.UTF-8'}

{
	setopt LOCAL_OPTIONS EXTENDED_GLOB
	autoload -Uz zrecompile

	zrecompile -qp -- \
		"$ZDOTDIR"/.zcompdump -- \
		"$ZDOTDIR"/autoload/prompt_pure_setup

	zrecompile -qp "$ZDOTDIR"/autoload.zwc "$ZDOTDIR"/autoload/^(_*|prompt_*_setup|*.*)(-.N)

	rm -f "$ZDOTDIR"/**/*.zwc.old(N)
}&!
