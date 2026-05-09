#!/bin/bash
src="$(tmux display-message -p '#{session_name}:#{window_index}')"
tmux new-session -d -s "$1" \
  && tmux switch-client -t "$1" \
  && tmux move-window -s "$src" -t "$1:" \
  && tmux kill-window -t "$1:1"
