#!/bin/bash
# usage logtrig.sh file pattern command
# watch "file" and run "command" when file contains "pattern"


if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <log_file> <pattern> <command>"
    exit 1
fi

LOG_FILE="$1"
PATTERN="$2"
COMMAND="$3"

tail -F "$LOG_FILE" | while read -r line; do
    echo "$line" | grep -iq "$PATTERN"
    if [ $? -eq 0 ]; then
        eval "$COMMAND"
        exit
    fi
done
