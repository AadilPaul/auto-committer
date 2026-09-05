#!/bin/bash

# The faster version of script.sh, we import everything from lib.sh.
source "$(dirname "$0")/lib.sh"

# Now push the code.
git add .
get_commit_message # Gets the commit message and saves it to commit_message.
git commit -m "$commit_message"
push_code # pushes code.