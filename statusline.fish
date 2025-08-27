#!/usr/bin/env fish

set input (cat)

set MODEL_DISPLAY (echo "$input" | jq -r '.model.display_name')
set CURRENT_DIR (echo "$input" | jq -r '.workspace.current_dir')
set CLAUDE_VERSION (echo "$input" | jq -r '.version')
set LINES_ADDED (echo "$input" | jq -r '.cost.total_lines_added')
set LINES_REMOVED (echo "$input" | jq -r '.cost.total_lines_removed')

set DIVIDER ' | '

set FG_NORMAL (printf "\e[0m")
set FG_RED (printf "\e[0;31m")
set FG_GREEN (printf "\e[0;32m")
set FG_YELLOW (printf "\e[0;33m")
set FG_BLUE (printf "\e[0;34m")
set FG_MAGENTA (printf "\e[0;35m")
set FG_CYAN (printf "\e[0;36m")

set output ''

set output "$output$FG_BLUE"(basename "$CURRENT_DIR")

if git rev-parse --git-dir >/dev/null 2>&1
    set BRANCH (git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]
        set output "$output$FG_NORMAL$DIVIDER"
	# color clean and dirty git repo differently
	test -z "$(git status --porcelain)" && set color "$FG_CYAN" || set color "$FG_MAGENTA"
        set output "$output$color$BRANCH"
    end
end

set output "$output$FG_NORMAL$DIVIDER$FG_YELLOW"v"$CLAUDE_VERSION$FG_NORMAL ($FG_GREEN"+"$LINES_ADDED$FG_NORMAL|$FG_RED"-"$LINES_REMOVED$FG_NORMAL)"
echo "$output"

