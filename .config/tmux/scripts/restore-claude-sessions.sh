#!/bin/bash
# Restores claude sessions from the last snapshot.
# Shows saved sessions and lets you pick which to restore.
# Targets panes by their ref from the TSV. If the exact pane does not exist,
# creates a new window.
#
# Usage:
#   restore-claude-sessions             # interactive picker
#   restore-claude-sessions --all       # restore everything
#   restore-claude-sessions <session>   # restore a specific saved tmux session

INFILE="$HOME/.local/share/tmux/resurrect/claude_sessions_last"

if [ ! -f "$INFILE" ] || [ ! -s "$INFILE" ]; then
    echo "No snapshot found at $INFILE"
    exit 1
fi

MY_PANE=$(tmux display-message -p '#{pane_id}' 2>/dev/null)

SESSIONS=$(cut -f1 "$INFILE" | cut -d: -f1 | sort -u)

if [ "$1" = "--all" ]; then
    SELECTED="$SESSIONS"
elif [ -n "$1" ]; then
    SELECTED="$1"
else
    echo "Saved tmux sessions with claude:"
    echo ""
    i=1
    declare -A SESSION_MAP
    for sess in $SESSIONS; do
        count=$(grep -c "^${sess}:" "$INFILE")
        windows=$(grep "^${sess}:" "$INFILE" | cut -f2 | tr '\n' ', ' | sed 's/,$//')
        echo "  $i) $sess ($count panes: $windows)"
        SESSION_MAP[$i]="$sess"
        i=$((i + 1))
    done
    echo ""
    echo "  a) all"
    echo "  q) quit"
    echo ""
    read -p "Restore which? " choice

    if [ "$choice" = "q" ]; then
        exit 0
    elif [ "$choice" = "a" ]; then
        SELECTED="$SESSIONS"
    elif [ -n "${SESSION_MAP[$choice]}" ]; then
        SELECTED="${SESSION_MAP[$choice]}"
    else
        echo "Invalid choice"
        exit 1
    fi
fi

COUNT=0
SKIPPED=0

for restore_session in $SELECTED; do
    while IFS=$'\t' read -r pane_ref window_name session_id cwd; do
        pane_session="${pane_ref%%:*}"
        [ "$pane_session" != "$restore_session" ] && continue
        [ -z "$session_id" ] && continue
        if [ "$session_id" = "UNKNOWN" ]; then
            SKIPPED=$((SKIPPED + 1))
            continue
        fi
        [ -z "$cwd" ] && cwd="$HOME"

        # Check if the exact pane ref exists
        target_pane=$(tmux display-message -t "$pane_ref" -p '#{pane_id}' 2>/dev/null)

        if [ -z "$target_pane" ]; then
            # Pane does not exist. Try to find any idle shell pane in the session
            # with matching window name, or create a new window.
            if tmux has-session -t "$restore_session" 2>/dev/null; then
                target_pane=$(tmux new-window -a -t "${restore_session}:{end}" -n "$window_name" -c "$cwd" -P -F '#{pane_id}')
            else
                tmux new-session -d -s "$restore_session" -n "$window_name" -c "$cwd"
                target_pane=$(tmux display-message -t "${restore_session}:1" -p '#{pane_id}' 2>/dev/null)
            fi
        fi

        # Defer if this is the pane we are running from
        if [ "$target_pane" = "$MY_PANE" ]; then
            SELF_CMD="cd ${cwd} && ai --resume ${session_id}"
            continue
        fi

        # Skip if pane already has claude running
        pane_cmd=$(tmux display-message -t "$target_pane" -p '#{pane_current_command}' 2>/dev/null)
        if [ "$pane_cmd" = "bwrap" ]; then
            echo "Skipping ${window_name} -- claude already running" >&2
            SKIPPED=$((SKIPPED + 1))
            continue
        fi

        # Lock the window name so auto-rename doesn't change it
        tmux set-option -t "$target_pane" automatic-rename off 2>/dev/null
        tmux send-keys -t "$target_pane" "cd ${cwd} && ai --resume ${session_id}" Enter
        COUNT=$((COUNT + 1))
    done < "$INFILE"
done

if [ "$COUNT" -eq 0 ] && [ "$SKIPPED" -eq 0 ]; then
    echo "No sessions to restore"
    exit 1
fi

echo "Restored $COUNT panes"
[ "$SKIPPED" -gt 0 ] && echo "Skipped $SKIPPED panes"

if [ -n "$SELF_CMD" ]; then
    echo ""
    echo "Run this in the current pane:"
    echo "  $SELF_CMD"
fi
