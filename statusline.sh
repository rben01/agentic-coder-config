#!/usr/bin/env bash

input=$(cat)

# MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
CLAUDE_VERSION=$(echo "$input" | jq -r '.version')
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed')

FG_NORMAL=$(printf "\e[0m")
FG_RED=$(printf "\e[0;31m")
FG_GREEN=$(printf "\e[0;32m")
FG_YELLOW=$(printf "\e[0;33m")
FG_BLUE=$(printf "\e[0;34m")
FG_MAGENTA=$(printf "\e[0;35m")
FG_CYAN=$(printf "\e[0;36m")

DIVIDER="${FG_NORMAL} | "

output=''

output+="${FG_BLUE}$(basename "$CURRENT_DIR")"

if git rev-parse --git-dir >/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        output+="${DIVIDER}"
        # color clean and dirty git repo differently
        if [ -z "$(git status --porcelain)" ]; then
            color="$FG_CYAN"
        else
            color="$FG_MAGENTA"
        fi
        output+="${color}${BRANCH}"
    fi
fi

output+="${DIVIDER}${FG_YELLOW}v${CLAUDE_VERSION}"
output+="${FG_NORMAL} (${FG_GREEN}+${LINES_ADDED}${FG_NORMAL}|${FG_RED}-${LINES_REMOVED}${FG_NORMAL})"
echo "$output"
