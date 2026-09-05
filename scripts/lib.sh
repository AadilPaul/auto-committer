#!/bin/bash

# bash file with all functions for the autocommiter.

add_each() {
    # Iterates through each file to be added. Will be called in the "$is_commited" == "1" block in script.sh.
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
                git add . 
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
    # return $commit_message
}

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