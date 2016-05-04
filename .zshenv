export DOTFILES=$HOME/.dotfiles
export DOTFILES_CACHE_DIR=$HOME/.cache
export HOMEBREW_PREFIX=/usr/local
export HOMEBREW_CASK_OPTS="--appdir=/Applications" # Install all casks to /Applications
export HOMEBREW_BREWFILE=$DOTFILES/apps/Brewfile
export HOMEBREW_NO_ANALYTICS=1
export GHQ_ROOT=$HOME/dev/src
export GOPATH=$HOME/dev/go
export COMPOSER_HOME=$HOME/.composer

[[ -f "$HOME/.localrc" ]] && source $HOME/.localrc
