#!/bin/bash
# Remove duplicate resurrect save pairs.
# Keeps the oldest of each group of identical consecutive saves.
# Compares file content byte-for-byte (resurrect + claude saves independently).

SAVEDIR="$HOME/.local/share/tmux/resurrect"
DRY_RUN=true
[ "$1" = "--apply" ] && DRY_RUN=false

removed=0
prev_resurrect=""
prev_claude=""

for f in $(ls -t "$SAVEDIR"/tmux_resurrect_*.txt 2>/dev/null | tac); do
    ts=$(basename "$f" .txt | sed 's/tmux_resurrect_//')
    claude_file="$SAVEDIR/claude_sessions_${ts}.tsv"

    if [ -n "$prev_resurrect" ]; then
        resurrect_same=false
        claude_same=false

        cmp -s "$f" "$prev_resurrect" && resurrect_same=true

        if [ -f "$claude_file" ] && [ -f "$prev_claude" ]; then
            cmp -s "$claude_file" "$prev_claude" && claude_same=true
        elif [ ! -f "$claude_file" ] && [ ! -f "$prev_claude" ]; then
            claude_same=true
        fi

        if $resurrect_same && $claude_same; then
            if $DRY_RUN; then
                echo "Would remove: $ts (same as previous)"
            else
                rm -f "$f" "$claude_file"
                echo "Removed: $ts"
            fi
            removed=$((removed + 1))
            continue
        fi
    fi

    prev_resurrect="$f"
    prev_claude="$claude_file"
done

echo ""
if $DRY_RUN; then
    echo "$removed duplicates found (dry run, use --apply to remove)"
else
    echo "$removed duplicates removed"
fi
