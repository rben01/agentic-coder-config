#!/usr/bin/env bash

input=$(cat)

MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
CLAUDE_VERSION=$(echo "$input" | jq -r '.version')
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed')
CONTEXT_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
CONTEXT_USED_TOK=$(echo "$input" | jq -r '
  (.context_window.current_usage.input_tokens // 0)
  + (.context_window.current_usage.cache_creation_input_tokens // 0)
  + (.context_window.current_usage.cache_read_input_tokens // 0)')

FG_NORMAL=$(printf "\e[0m")
FG_RED=$(printf "\e[0;31m")
FG_GREEN=$(printf "\e[0;32m")
FG_YELLOW=$(printf "\e[0;33m")
FG_BLUE=$(printf "\e[0;34m")
FG_MAGENTA=$(printf "\e[0;35m")
FG_CYAN=$(printf "\e[0;36m")
FG_WHITE=$(printf "\e[0;97m")

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
        if [ ${#BRANCH} -gt 24 ]; then
            BRANCH="${BRANCH:0:24}…"
        fi
        output+="${color}${BRANCH}"
    fi
fi

output+="${DIVIDER}${FG_YELLOW}${MODEL_DISPLAY}"

# Format token count as "Xk"
if [ "$CONTEXT_USED_TOK" -ge 1000 ] 2>/dev/null; then
    CTX_DISPLAY="$((CONTEXT_USED_TOK / 1000))k"
else
    CTX_DISPLAY="${CONTEXT_USED_TOK}"
fi

# Color context info based on percentage
if [ "$CONTEXT_PCT" -gt 75 ]; then
    CTX_COLOR="$FG_RED"
elif [ "$CONTEXT_PCT" -gt 50 ]; then
    CTX_COLOR="$FG_YELLOW"
else
    CTX_COLOR="$FG_WHITE"
fi

output+=" ${FG_NORMAL}[${CTX_COLOR}${CTX_DISPLAY}${FG_NORMAL}=${CTX_COLOR}${CONTEXT_PCT}%${FG_NORMAL}]"
output+="${FG_NORMAL} (${FG_GREEN}+${LINES_ADDED}${FG_NORMAL}|${FG_RED}-${LINES_REMOVED}${FG_NORMAL})${DIVIDER}${FG_YELLOW}v${CLAUDE_VERSION}${FG_NORMAL}"
echo "$output"
