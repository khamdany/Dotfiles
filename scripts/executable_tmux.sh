#!/usr/bin/env fish

set SESSION "myproject"

if tmux has-session -t $SESSION 2>/dev/null
    tmux attach-session -t $SESSION
    exit 0
end

tmux new-session -d -s $SESSION -n webdav
tmux send-keys -t $SESSION:webdav "~/scripts/webdav.sh" Enter

tmux new-window -t $SESSION -n server
tmux send-keys -t $SESSION:server "actual-server" Enter

tmux new-window -t $SESSION -n ngrok
tmux send-keys -t $SESSION:ngrok "ngrok http 5006" Enter

tmux new-window -t $SESSION -n hotspot
tmux send-keys -t $SESSION:hotspot "fish -i" Enter
sleep 1.8                      # adjust if needed (1.2–2.5 usually enough in Termux)
tmux send-keys -t $SESSION:hotspot "hotspot" Enter

tmux select-window -t $SESSION:webdav
tmux attach-session -t $SESSION
