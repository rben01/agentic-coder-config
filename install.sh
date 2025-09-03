#!/usr/bin/env bash

function link() {
	dst="$HOME"/."$1"
	# shellcheck disable=SC2088 # perfectly reasonable use of the tilde
	[ ! -e "$dst" ] && ln -s "$(pwd)"/"$1" "$dst" || echo "~/.$1 already exists, skipping"
}

link claude
link codex
