#!/usr/bin/env zsh

(( $+commands[grc] )) || exit 34

symlink-files $XDG_CONFIG_HOME/grc/grc.conf /usr/local/etc/
