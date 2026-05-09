#!/bin/bash
src="$(tmux display-message -p '#{session_name}:#{window_index}')"
tmux switch-client -t "$1" \
  && tmux move-window -s "$src" -t "$1:"
