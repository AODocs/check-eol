#!/bin/bash

printf "check EOL in: $1\n"

BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_CYAN='\033[1;36m'
NC='\033[0m'

RESULT=0


files=$(git ls-files --eol)


# echo "$files"

while IFS= read -r line; do

    file_name=$(echo $line |awk '{ print $NF }')
    current=$(echo $line |awk 'match($0, / w\/(lf|crlf) /) { print substr( $0, RSTART+3, RLENGTH-4 )}')
    expected=$(echo $line |awk 'match($0, / eol=(lf|crlf) /) { print substr( $0, RSTART+5, RLENGTH-6 )}')

    if [ -z "$expected" ]
    then
        printf "${BOLD_YELLOW}No EOL rule defined for %s${NC}\n" $file_name
    else
        if [ "$current" != "$expected"  ]
        then 
            RESULT=1
            printf "Found file ${BOLD_RED}%s${NC} with ${BOLD_CYAN}%s${NC} endings but expected ${BOLD_YELLOW}%s.${NC}\n" $file_name $current $expected            
        fi
    fi
    
    
done <<< "$files"


if [ "$RESULT" -eq 0 ]
then
    printf "${BOLD_GREEN}No files with EOL errors found.${NC}\n"
    exit 0
else
    exit 1
fi
