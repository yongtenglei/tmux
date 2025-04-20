#!/bin/bash

SESSION="work_space"

tmux has-session -t $SESSION 2>/dev/null

if [$? != 0]; then
  # Open source
  tmux new-session -d -s $SESSION -n "open-server"
  tmux send-keys -t $SESSION:open-server "cd ~/workspace/ragflow" C-m
  tmux send-keys -t $SESSION:open-server "docker compose -f docker/docker-compose-base.yml up -d" C-m
  tmux send-keys -t $SESSION:open-server "source .venv/bin/activate; \
                                          export PYTHONPATH=$(pwd); \
                                          bash docker/launch_backend_service.sh" C-m

  tmux new-session -d -s $SESSION -n "open-web"
  tmux send-keys -t $SESSION:open-server "cd ~/workspace/ragflow/web" C-m

  # Enterprise
  tmux new-session -d -s $SESSION -n "close-server"
  tmux send-keys -t $SESSION:open-server "cd ~/workspace/close/ragflow" C-m

  tmux new-session -d -s $SESSION -n "close-web"
  tmux send-keys -t $SESSION:open-server "cd ~/workspace/ragflow/web" C-m
fi

tmux attach-session -t $SESSION
