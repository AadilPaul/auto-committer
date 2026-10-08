#!/bin/bash
# A script to automatically push code. Made by AadilPaul
source "$(dirname "$0")/lib.sh"
source "$(dirname "$0")/settings.sh"

get_username() {
    user_name=$(menu_get "user_name")

    if [ -z "$user_name" ]; then
        echo "Please tell me your name"
        read -e name
        menu_set "user_name" "$name"
        user_name=$(menu_get "user_name")
    fi

}
if [ "$greet_user_on_start" == "true" ]; then
    if [ -z "$user_name" ]; then
        echo "Your username is blank, would you like to change it? (y/n)"
        read change_username

        if [[ "$change_username" == "y" || "$change_username" == "Y" ]]; then
            get_username
        fi

    else  
        echo -e "\n\rHello, $user_name"
    fi
fi
echo "Welcome to the auto-committer!"
launch_program