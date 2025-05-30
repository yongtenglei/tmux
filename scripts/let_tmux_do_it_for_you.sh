#!/bin/bash

SESSION="ragflow_workspace"

if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  # Open Source
  tmux new-session -d -s "$SESSION" -n "open-server"
  tmux send-keys -t "$SESSION:open-server" "cd ~/workspace/ragflow" C-m
  tmux send-keys -t "$SESSION:open-server" "docker compose -f docker/docker-compose-base.yml up -d" C-m
  tmux send-keys -t "$SESSION:open-server" "source .venv/bin/activate; \
                                          export PYTHONPATH=$(pwd); \
                                          bash docker/launch_backend_service.sh" C-m

  tmux new-window -t "$SESSION" -n "open-web"
  tmux send-keys -t "$SESSION:open-web" "cd ~/workspace/ragflow/web" C-m

  # Enterprise
  tmux new-window -t "$SESSION" -n "close-server"
  tmux send-keys -t "$SESSION:close-server" "cd ~/workspace/close/ragflow" C-m

  tmux new-window -t "$SESSION" -n "close-web"
  tmux send-keys -t "$SESSION:close-web" "cd ~/workspace/close/ragflow/web" C-m
fi

tmux attach-session -t "$SESSION"
