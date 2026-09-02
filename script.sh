#!/bin/bash

# A script to automatically push code. Made by AadilPaul
# We define our functions here:

add_each() {
    # Iterates through each file to be added. Will be called in the "$is_commited" == "1"
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
                git add *
                return 
            elif [ "$wants_to_add" == "4" ]; then
                echo "Aborting code."
                exit 1
            fi
        done
    done
}
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
    # return 0
}

push_code() {
    if git push; then 
        # Check if push was successful 
        echo "Pushed successfully"
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

# Start the code, this is the first thing the user sees.

# Enter the directory of the folder to push to 
echo "Please enter the exact path to the folder that you want to push to from here."
echo "e.g. ../project1/src"
echo "Any mistakes will cause errors, so be careful."
echo "Type in your directory here:"
read directory

cd "$directory" || exit 1

# Confirm the user wants to commit here.
echo "Ready to commit?"

echo "1: Yes, go ahead."
echo "2: No, I'm not done yet."
# Does the user want to proceed? This variable shows.
read committing

if [ "$committing" == "1" ]; then

    # Asks user if they would like through each change
    echo "Would you like to iterate through all changes to add them? (1)"
    echo "Or would you like to just add them all using 'git add *' (2)"
    read to_iterate
    if [ "$to_iterate" == "1" ]; then
        
        echo "Okay, iterating through each change"
        add_each

    else 

        echo "Okay, adding everything."
        git add *

    fi
    get_commit_message

    # Now commit the code using the commit message found using get_commit_message

    echo "Committing the code with commit message $commit_message."
    git commit -m "$commit_message"

    # Confirm the user wants to push.

    echo "About to push code, Are you sure you want to do this?"

    echo "1: Sure, go ahead"
    echo "2: Wait, no don't! I need to change something."
    
    read go_push
    
    if [ "$go_push" == "1" ]; then

        #pushes code, will probably add branch support
        push_code
        echo "You are all done committing! Have a nice day."

    elif [ "$go_push" == "2" ]; then

        # Runs only if the user is not ready to push
        echo "Aborting code. Please push your code when ready."
        exit 1

    fi
    
fi

    