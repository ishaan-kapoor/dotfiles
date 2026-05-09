#!/bin/bash
# Snapshots all tmux panes running claude, saving their session IDs and CWDs.
# Format: tmux_session:window.pane \t window_name \t claude_session_id \t cwd
#
# Session ID matching:
# 1. --resume/-r <uuid> from bwrap cmdline (exact)
# 2. CWD match + jsonl actively written since process started (mod time > proc start)

SAVEDIR="$HOME/.local/share/tmux/resurrect"
if [ "$1" = "--sync-resurrect" ]; then
    TS=$(ls -t "$SAVEDIR"/tmux_resurrect_*.txt 2>/dev/null | head -1 | sed 's/.*tmux_resurrect_//;s/\.txt//')
fi
TS="${TS:-$(date +%Y%m%dT%H%M%S)}"
OUTFILE="${SAVEDIR}/claude_sessions_${TS}.tsv"
LASTLINK="${SAVEDIR}/claude_sessions_last"
TMPFILE="${SAVEDIR}/claude_sessions.tmp"

> "$TMPFILE"

# Build index: for each jsonl, extract CWD and file modification time
# Format: cwd \t session_id \t mod_epoch
JSONL_INDEX=$(mktemp)
for f in "$HOME"/.claude/projects/*/*.jsonl; do
    [ -f "$f" ] || continue
    echo "$f" | grep -q "subagents" && continue
    sid=$(basename "$f" .jsonl)
    cwd=$(grep -m1 -o '"cwd":"[^"]*"' "$f" 2>/dev/null | cut -d'"' -f4)
    [ -z "$cwd" ] && continue
    mod=$(stat -c '%Y' "$f" 2>/dev/null)
    printf '%s\t%s\t%s\n' "$cwd" "$sid" "$mod"
done > "$JSONL_INDEX" 2>/dev/null

# Track claimed session IDs to prevent double-matching
declare -A CLAIMED

tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}	#{window_name}	#{pane_current_path}	#{pane_pid}' | while IFS=$'\t' read -r pane_ref window_name pane_cwd pane_pid; do
    bwrap_pid=$(pgrep -P "$pane_pid" bwrap 2>/dev/null | head -1)
    [ -z "$bwrap_pid" ] && continue

    bwrap_args=$(cat /proc/"$bwrap_pid"/cmdline 2>/dev/null | tr '\0' '\n')

    # Method 1: --resume/-r <uuid>
    session_id=$(echo "$bwrap_args" | grep -A1 -E '^(--resume|-r)$' | tail -1 | grep -E '^[0-9a-f]{8}-')

    if [ -n "$session_id" ]; then
        cwd=$(grep "$session_id" "$JSONL_INDEX" | head -1 | cut -f1)
        [ -z "$cwd" ] && cwd="$pane_cwd"
        printf '%s\t%s\t%s\t%s\n' "$pane_ref" "$window_name" "$session_id" "$cwd" >> "$TMPFILE"
        CLAIMED["$session_id"]=1
        continue
    fi

    # Method 2: find jsonl with matching CWD, modified after process started,
    # pick the most recently modified one (most likely to be the active session)
    claude_pid=$(pgrep -P "$bwrap_pid" -x claude 2>/dev/null | head -1)
    [ -z "$claude_pid" ] && continue
    proc_start=$(stat -c '%Y' /proc/"$claude_pid" 2>/dev/null)
    [ -z "$proc_start" ] && continue

    best_sid=""
    best_mod=0
    while IFS=$'\t' read -r j_cwd j_sid j_mod; do
        [ "$j_cwd" != "$pane_cwd" ] && continue
        [ -n "${CLAIMED[$j_sid]}" ] && continue
        # jsonl must have been modified after the process started
        [ "$j_mod" -lt "$proc_start" ] && continue
        # Pick the most recently modified match
        if [ "$j_mod" -gt "$best_mod" ]; then
            best_mod=$j_mod
            best_sid=$j_sid
        fi
    done < "$JSONL_INDEX"

    if [ -n "$best_sid" ]; then
        CLAIMED["$best_sid"]=1
        printf '%s\t%s\t%s\t%s\n' "$pane_ref" "$window_name" "$best_sid" "$pane_cwd" >> "$TMPFILE"
    else
        printf '%s\t%s\t%s\t%s\n' "$pane_ref" "$window_name" "UNKNOWN" "$pane_cwd" >> "$TMPFILE"
    fi
done

rm -f "$JSONL_INDEX"

# Don't save empty snapshots
if [ -s "$TMPFILE" ]; then
    mv "$TMPFILE" "$OUTFILE"
    ln -sf "$(basename "$OUTFILE")" "$LASTLINK"

    # Cleanup: sync with resurrect's retention policy
    delete_after=$(tmux show-option -gqv "@resurrect-delete-backup-after" 2>/dev/null)
    delete_after="${delete_after:-30}"
    old_files=($(ls -t "$SAVEDIR"/claude_sessions_*.tsv 2>/dev/null | tail -n +6))
    if [ ${#old_files[@]} -gt 0 ]; then
        find "${old_files[@]}" -type f -mtime "+${delete_after}" -exec rm -f {} \;
    fi
else
    rm -f "$TMPFILE"
fi
