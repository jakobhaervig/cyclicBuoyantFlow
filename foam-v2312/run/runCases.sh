#!/bin/bash

# Function to execute the Allrun script for a case
run_case() {
    case_dir=$1
    echo "Running case: $case_dir"
    
    cd "$case_dir"
    
    if [ -x ./Allrun ]; then
        ./Allrun
        echo "Finished running Allrun for: $case_dir"
    else
        echo "Allrun script not found or not executable in $case_dir"
    fi
    
    cd ..
}

# Export the function so that parallel can access it
export -f run_case

# Find directories that match the pattern 'verticalChannel_????' and run in parallel
find . -maxdepth 1 -type d -name 'verticalChannel_????' | parallel run_case {}