#!/bin/bash
# bash file with all functions for the autocommiter.
# Source settings to get the settings and setting methods
source "$(dirname "$0")/settings.sh"

# Displays menu. Will be called at launch, after scripts and if the user types in menu
disp_menu() {
    echo "--------------------------"
    echo "What would you like to do?"
    echo "$run_key: Run the committing script."
    echo "$settings_key: View or edit settings."
    echo "$exit_key: Exit the program."
    echo "$help_us_key: Interested in helping with development?"
    echo "$guide_key: See a guide for this page."
}
# add_each iterates through each file to be added. 
add_each() {
    files=()

    while IFS= read -r file; do 
        files+=("$file")
    done < <(git status --porcelain | awk '{print $NF}')

    for file in "${files[@]}"; do
        while true; do 
            echo "Would you like to add $file to be committed?"
            echo "1: Yes, please add this."
            echo "2: No, don't."
            echo "3: You can add all the rest."
            echo "4: I changed my mind, I don't want to commit."
            
            read wants_to_add 

            if [ "$wants_to_add" == "1" ]; then
                echo "Adding $file"
                git add "$file"
                break
            elif [ "$wants_to_add" == "2" ]; then
                echo "Alright, moving on."
                break
            elif [ "$wants_to_add" == "3" ]; then
                echo "Okay, adding them all."
                $add_command
                return 
            elif [ "$wants_to_add" == "4" ]; then
                echo "Aborting code."
                exit 1
            fi
        done
    done
    echo "All done adding items!"
    echo "-------------------------"
}
# get_commit_message() commits the code in script.sh
get_commit_message() {
    # Checks for a valid commit message
    while true; do
        echo "Enter your commit message here."
        read -e commit_message
        if [ -n "$commit_message" ]; then
            break
        else 
            echo "Please give me a commit message."
        fi
    done
    # return $commit_message
}
# Pushes the code in script.sh
push_code() {
    if git push; then 
        # Check if push was successful 
        echo "Pushed successfully"
        echo "You are all done committing! Have a nice day."
    else
        echo "Push has failed, check your error message here:"
        # Get error message 
        output=$(git push 2>&1)
        status=$?

        if [ $status -ne 0 ]; then
            # Display it.
            echo "Push failed:"
            echo "$output"
            # And then abort code using exit 1
            exit 1
        fi
    fi

}
# function to_lower takes input and puts it into lowercase. Used to configure settings in menus.
to_lower() {
    local input="$1"
    echo "${input,,}"
}

# Function that runs when launched
launch_program() {
    if [ "$show_menu_on_start" == "true" ]; then
        disp_menu
    fi
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
            sleep 3
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
        elif [ "$user_option" == "$guide_key" ]; then
            echo "This is an auto-committer that commits your code for you!"
            echo "You can edit settings in the settings menu, commit to a repo, ask to help with development, or..."
            echo "If you don't like us, you can exit the code. If you really feel like it :_(."
            echo "Follow the given prompts to navigate the auto-committer."
            sleep 3
            disp_menu
        fi
    done
}
commit() {
    echo "Please enter the exact path to the folder that you want to push to from here."
    echo "e.g. ../project1/src"
    echo "Any mistakes will cause errors, so be careful."
    sleep 2
    echo "Type in your directory here:"
    read directory

    cd "$directory" || { echo "Invalid directory."; exit 1; }

    sleep 3
    # Confirm the user wants to commit here.
    echo "Ready to commit?"
    echo "1: Yes, go ahead."
    echo "2: No, I'm not done yet."
    # Does the user want to proceed? This variable shows.
    read committing

    if [ "$committing" == "1" ]; then
        sleep 2
        # Asks user if they would like through each change
        echo "Would you like to iterate through all changes to add them? (1)"
        echo "Or would you like to just add them all using '$add_command' (2)"
        read to_iterate
        if [ "$to_iterate" == "1" ]; then
            echo "Okay, iterating through each change"
            add_each
        else 
            echo "Okay, adding everything."
            if $add_command; then
                echo "Added successfully; Testing only" # FIXME: delete this line once testing is over
            fi
        fi
        get_commit_message

        # Now commit the code using the commit message found using get_commit_message

        echo "Committing the code with commit message $commit_message."
        git commit -m "$commit_message"
        echo "-------------------------"
        # Confirm the user wants to push.
        if [ "$auto_push" == "true" ]; then
            push_code
        else 
            echo "About to push code, Are you sure you want to do this?"

            echo "1: Sure, go ahead"
            echo "2: Wait, no don't! I need to change something."
            
            read go_push
            
            if [ "$go_push" == "1" ]; then
                # pushes code
                push_code
                # echo "You are all done committing! Have a nice day."
            elif [ "$go_push" == "2" ]; then
                # Runs only if the user is not ready to push
                echo "Aborting code. Please push your code when ready."
                exit 1
            fi
        fi
    fi
}
# quick_commit is called in faster_script.sh
quick_commit() {
    echo "Please type in the directory to your project from here."
    read dir
    cd "$dir" || { echo "Invalid directory"; exit 1; }
    # Now push the code.
    git add .
    # Gets the commit message and saves it to commit_message.
    get_commit_message 
    git commit -m "$commit_message"
    push_code # pushes code.
}