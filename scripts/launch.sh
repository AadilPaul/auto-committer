#!/bin/bash
# A script to automatically push code. Made by AadilPaul
source "$(dirname "$0")/lib.sh"
source "$(dirname "$0")/settings.sh"
# Activate a venv.
# .venv\Scripts\activate
get_user_name() {
    user_name=$(get "user_name")
    if [ -z "$user_name" ]; then
        echo "Please tell me your name"
        read name
        set "user_name" "$name"
        user_name=$(get "user_name")
    fi
}
echo "Hello, $user_name"
echo "Welcome to the auto-committer!"
launch_program