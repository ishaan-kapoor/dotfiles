#!/bin/bash
# Preview script for fzf in pick-restore-point.
# Called with the full fzf line; extracts timestamp from last | field.

SAVEDIR="$HOME/.local/share/tmux/resurrect"
ts=$(echo "$1" | awk -F'|' '{print $NF}' | tr -d ' ')

resurrect="$SAVEDIR/tmux_resurrect_${ts}.txt"
claude="$SAVEDIR/claude_sessions_${ts}.tsv"

if [ ! -f "$resurrect" ]; then
    echo "Resurrect file not found"
    exit 0
fi

echo "=== Layout ==="

# Build window name map from window lines
declare -A WNAMES
while IFS=$'\t' read -r _ sess win wname _rest; do
    wname="${wname#:}"
    WNAMES["${sess}:${win}"]="$wname"
done < <(grep '^window' "$resurrect")

# Show panes grouped by window
prev_key=""
grep '^pane' "$resurrect" | while IFS=$'\t' read -r _ sess win _ _ pane _ dir _ cmd _rest; do
    dir="${dir#:}"
    dir=$(echo "$dir" | sed 's|/u/kapooris|~|;s|/codemill/kapooris-r|~/cm|')
    key="${sess}:${win}"
    wname="${WNAMES[$key]}"

    if [ "$key" != "$prev_key" ]; then
        echo ""
        echo "  ${key} [${wname}]"
        prev_key="$key"
    fi
    printf "    pane %s: %s (%s)\n" "$pane" "$cmd" "$dir"
done

# Show claude sessions if available
if [ -f "$claude" ]; then
    echo ""
    echo "=== Claude Sessions ==="
    while IFS=$'\t' read -r ref wname sid cwd; do
        short_cwd=$(echo "$cwd" | sed 's|/u/kapooris|~|;s|/codemill/kapooris-r|~/cm|')
        if [ "$sid" = "UNKNOWN" ]; then
            echo "  $ref [$wname] -- unknown ($short_cwd)"
        else
            echo "  $ref [$wname] -- ${sid:0:8}... ($short_cwd)"
        fi
    done < "$claude"
fi
