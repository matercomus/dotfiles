#!/bin/bash
#
# This script launches the development env in tmux on the remote host

mount-vu-hedgeiot.sh mka299
# SSH into the remote host and start a tmux session
ssh -o ForwardAgent=yes -o ProxyJump=mka299@ssh.data.vu.nl mka299@130.37.53.67 -t 'tmux new-session -s dev "bash"'

