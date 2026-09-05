#!/bin/bash

# Imports for functions.
source "$(dirname "$0")/lib.sh"

# A script to automatically push code. Made by AadilPaul
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
    echo "Or would you like to just add them all using 'git add .' (2)"
    read to_iterate
    if [ "$to_iterate" == "1" ]; then
        echo "Okay, iterating through each change"
        add_each
    else 
        echo "Okay, adding everything."
        git add .
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
        # pushes code
        push_code
        # echo "You are all done committing! Have a nice day."
    elif [ "$go_push" == "2" ]; then
        # Runs only if the user is not ready to push
        echo "Aborting code. Please push your code when ready."
        exit 1
    fi
fi     