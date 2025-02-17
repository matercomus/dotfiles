#!/bin/bash

# Function to calculate days between two dates
days_between_dates() {
    local date1=$1
    local date2=$2
    
    # Convert dates to seconds since epoch
    local d1=$(date -d "$date1" +%s)
    local d2=$(date -d "$date2" +%s)
    
    # Calculate difference in days
    local diff=$(( (d2 - d1) / 86400 ))
    echo "${diff#-}"  # Absolute value
}

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <date1> <date2>"
    echo "Example: $0 2024-01-01 2024-02-06"
    exit 1
fi

# Get arguments
date1=$1
date2=$2

days=$(days_between_dates "$date1" "$date2")
echo "Number of days between $date1 and $date2: $days"
