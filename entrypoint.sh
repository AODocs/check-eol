#!/bin/bash

printf "check EOL in: $1\n"

BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_CYAN='\033[1;36m'
NC='\033[0m'

rErrors=()
rInfos=()

files=$(git ls-files --eol $1)


# echo "$files"

while IFS= read -r line; do

    file_name=$(echo $line |awk '{ print $NF }')
    attribute=$(echo $line |awk 'match($0, / attr\/(text|-text) /) { print substr( $0, RSTART+6, RLENGTH-7 )}')
    working_tree=$(echo $line |awk 'match($0, / w\/(lf|crlf|mixed|none) /) { print substr( $0, RSTART+3, RLENGTH-4 )}')
    expected=$(echo $line |awk 'match($0, / eol=(lf|crlf|mixed|none) /) { print substr( $0, RSTART+5, RLENGTH-6 )}')

    # echo "$file_name -- ##$attribute##"
    if [[ "$attribute" == "text" ]]
    then
        if [[ -z "$expected" ]]
        then        
            msg=$( printf "${BOLD_YELLOW}No EOL rule defined for %s${NC}\n" $file_name)
            rInfos+=("$msg")
        else
            if [[ "$working_tree" != "$expected"  && "$working_tree" != "none" ]]
            then             
                msg=$( printf "Found file ${BOLD_RED}%s${NC} with ${BOLD_CYAN}%s${NC} endings but expected ${BOLD_YELLOW}%s.${NC}\n" $file_name $working_tree $expected)
                rErrors+=("$msg")
            fi
        fi
    fi
    
    
done <<< "$files"


for value in "${rInfos[@]}"
do
    echo $value
done

if [ "${#rErrors[@]}" -eq 0 ]
then
    printf "${BOLD_GREEN}No files with EOL errors found.${NC}\n"
    exit 0
else
    for value in "${rErrors[@]}"
    do
        echo $value
    done
    printf "${BOLD_YELLOW} %s files with EOL warnings found.${NC}\n" ${#rInfos[@]}
    printf "${BOLD_RED} %s files with EOL errors found.${NC}\n" ${#rErrors[@]}
    exit ${#rErrors[@]}
fi
