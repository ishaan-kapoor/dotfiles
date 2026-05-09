#!/bin/bash
# Manage tmux restore points: pick, archive, or list.
#
# Usage:
#   tmux-pick-restore-point              # fzf picker to select restore point
#   tmux-pick-restore-point --list       # list all restore points
#   tmux-pick-restore-point --archive    # fzf picker to archive a restore point
#   tmux-pick-restore-point --archives   # list archived restore points

SAVEDIR="$HOME/.local/share/tmux/resurrect"
ARCHIVEDIR="$SAVEDIR/archives"

list_saves() {
    local saves=$(ls -t "$SAVEDIR"/tmux_resurrect_*.txt 2>/dev/null)
    [ -z "$saves" ] && echo "No restore points found" && return 1

    for f in $saves; do
        ts=$(basename "$f" .txt | sed 's/tmux_resurrect_//')
        display_ts=$(echo "$ts" | sed 's/T/ /;s/\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)$/\1:\2:\3/')
        sessions=$(grep '^pane' "$f" | cut -f2 | sort -u | wc -l)
        windows=$(grep '^pane' "$f" | cut -f2,3 | sort -u | wc -l)

        claude_file="$SAVEDIR/claude_sessions_${ts}.tsv"
        if [ -f "$claude_file" ]; then
            claude_count=$(wc -l < "$claude_file")
            claude_info="${claude_count} claude"
        else
            claude_info="no claude save"
        fi

        echo "${display_ts}  |  ${sessions} sess, ${windows} win  |  ${claude_info}  |  ${ts}"
    done
}

pick_restore() {
    local preview="$HOME/.config/tmux/scripts/preview-restore-point.sh {}"
    local selected=$(list_saves | fzf --no-sort --header="Pick a restore point" --preview="$preview" --preview-window=right:50%)
    [ -z "$selected" ] && echo "Cancelled" && return 0

    local ts=$(echo "$selected" | awk -F'|' '{print $NF}' | tr -d ' ')

    local resurrect_file="tmux_resurrect_${ts}.txt"
    if [ -f "$SAVEDIR/$resurrect_file" ]; then
        ln -sf "$resurrect_file" "$SAVEDIR/last"
        echo "Resurrect: -> $resurrect_file"
    else
        echo "Warning: $resurrect_file not found"
    fi

    local claude_file="claude_sessions_${ts}.tsv"
    if [ -f "$SAVEDIR/$claude_file" ]; then
        ln -sf "$claude_file" "$SAVEDIR/claude_sessions_last"
        echo "Claude:    -> $claude_file"
    else
        echo "Warning: no matching claude save for $ts"
    fi

    echo ""
    echo "Now run:  prefix Ctrl-r  then  restore-claude-sessions"
}

archive_save() {
    local preview="$HOME/.config/tmux/scripts/preview-restore-point.sh {}"
    local selected=$(list_saves | fzf --no-sort --header="Pick a restore point to archive" --preview="$preview" --preview-window=right:50%)
    [ -z "$selected" ] && echo "Cancelled" && return 0

    local ts=$(echo "$selected" | awk -F'|' '{print $NF}' | tr -d ' ')

    read -p "Archive name: " name
    [ -z "$name" ] && echo "Cancelled" && return 0

    mkdir -p "$ARCHIVEDIR"
    local dest="$ARCHIVEDIR/${name}"
    mkdir -p "$dest"

    cp "$SAVEDIR/tmux_resurrect_${ts}.txt" "$dest/" 2>/dev/null
    cp "$SAVEDIR/claude_sessions_${ts}.tsv" "$dest/" 2>/dev/null

    echo "Archived to $dest/"
    ls "$dest/"
}

list_archives() {
    if [ ! -d "$ARCHIVEDIR" ] || [ -z "$(ls -A "$ARCHIVEDIR" 2>/dev/null)" ]; then
        echo "No archives"
        return
    fi

    for d in "$ARCHIVEDIR"/*/; do
        name=$(basename "$d")
        resurrect=$(ls "$d"/tmux_resurrect_*.txt 2>/dev/null | head -1)
        if [ -n "$resurrect" ]; then
            ts=$(basename "$resurrect" .txt | sed 's/tmux_resurrect_//')
            display_ts=$(echo "$ts" | sed 's/T/ /;s/\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)$/\1:\2:\3/')
            has_claude=$(ls "$d"/claude_sessions_*.tsv 2>/dev/null | wc -l)
            echo "$name  |  saved at ${display_ts}  |  claude: ${has_claude}"
        fi
    done
}

case "${1:-}" in
    --list)     list_saves | sed 's/  |  [^ ]*$//' ;;
    --archive)  archive_save ;;
    --archives) list_archives ;;
    *)          pick_restore ;;
esac
