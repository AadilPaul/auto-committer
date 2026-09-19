#!/bin/bash
# Script that handles configuring settings 

# Get the script directory
SCRIPT_DIR="$(dirname "$0")"
ENV_FILE="$SCRIPT_DIR/settings.env"
# We can't really go back to the real launch program func, so we use this one and don't export it.
temp_launch_program() {
    disp_menu
    while true; do
        read user_option
        if [ "$user_option" == "$run_key" ]; then
            echo "Would you like to use the faster model? 1: Yes, 2: No"
            read faster
            if [ "$faster" == "1" ]; then
                bash "$(dirname "$0")"/faster_script.sh
            elif [ "$faster" == "2" ]; then
                bash "$(dirname "$0")"/script.sh
            fi
            disp_menu
        elif [ "$user_option" == "$settings_key" ]; then
            # Runs the file that handles settings logic.
            settings_handler
            
        elif [ "$user_option" == "$exit_key" ]; then
            exit 1
        elif [ "$user_option" == "$help_us_key" ]; then
            echo "This is the link to the github repo:"
            echo "https://github.com/AadilPaul/auto-committer"
            echo "You can make a fork & pull request, or request access."
            sleep 3
            disp_menu
        fi
    done
}

greet_user_in_settings() {
    echo "Welcome to settings! What would you like to do?"
}

disp_settings_menu() {
    echo "1: View current settings."
    echo "2: Search for a setting."
    echo "3: Edit a setting."
    echo "$exit_key: Exit the settings menu."
    read user_option
}

# Greets the user when they choose to access settings.
settings_handler() {
    disp_settings_menu
    while true; do
        if [ "$user_option" == "1" ]; then
            print
            disp_settings_menu
        elif [ "$user_option" == "2" ]; then
            echo "What setting would you like to get?"
            read setting_to_get
            get "$setting_to_get"
            disp_settings_menu
        elif [ "$user_option" == "3" ]; then
            echo "What setting would you like to edit?"
            read setting_to_edit
            echo "What would you like to change it to?"
            read val_to_set
            set "$setting_to_edit" "$val_to_set"
            disp_settings_menu
        else 
            # figure out a method to return back to the menu
            temp_launch_program
        fi
    done    
    
}


# Prints current settings
print() {
    echo "Current settings:"
    echo "----------------"
    # Read the .env file, skip comments and empty lines, print key=value
    grep -v '^#' "$ENV_FILE" | grep -v '^$' | while IFS='=' read -r key value; do
        # Remove quotes from value
        value=$(echo "$value" | tr -d '"')
        echo "$key=$value"
    done
    echo "----------------"
}

# Appends new setting to settings.env
add() {
    local key="$1"
    local value="$2"
    
    # Prompts for args, iff none provided.
    if [ -z "$key" ]; then
        echo "Enter setting name:"
        read key
    fi
    if [ -z "$value" ]; then
        echo "Enter setting value:"
        read value
    fi
    
    # Add the setting using the existing set function
    set "$key" "$value"
    echo "Setting added: $key=$value"
}

# Function to get a setting from .env file
get() {
    local key="$1"
    # Remove comments, find the key and extract value
    grep "^${key}=" "$ENV_FILE" 2>/dev/null | cut -d'=' -f2- | tr -d '"'
}

# Function to set a setting in .env file
set() {
    local key="$1"
    local value="$2"
    # Check if key exists, if not append it
    if grep -q "^${key}=" "$ENV_FILE"; then
        # Replace existing key
        sed -i "s/^${key}=.*/${key}=\"${value}\"/" "$ENV_FILE"
    else
        # Append new key
        echo "${key}=\"${value}\"" >> "$ENV_FILE"
    fi
    echo "$key=$value"
}

# Export functions
export -f add
export -f get
export -f set
export -f print
export -f settings_handler
export -f disp_settings_menu

# Init settings (these will be available to sourced scripts)
run_key=$(get "run_script_key")
settings_key=$(get "open_settings_key")
exit_key=$(get "exit_key")
help_us_key=$(get "help_us_key")
greet_user_on_start=$(get "greet_user_on_start")
show_menu_on_start=$(get "show_menu_on_start") 
user_name=$(get "user_name")
add_all_auto=$(get "add_all_auto")
add_command=$(get "add_command")
auto_push=$(get "auto_push")
run_script_command=$(get "run_script_command")
default_dir=$(get "default_dir")
fail_on_conflict=$(get "fail_on_conflict")

# Export variables
export run_key settings_key exit_key help_us_key
export greet_user_on_start show_menu_on_start user_name
export add_all_auto add_command auto_push run_script_command
export default_dir fail_on_conflict


