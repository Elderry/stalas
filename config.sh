#!/bin/sh

DARK_RED='\e[31m'
DARK_GREEN='\e[32m'
DARK_BLUE='\e[34m'
RESET='\e[0m'
echo "\n${DARK_BLUE}--------------- Elderry's Config Files ---------------\n"

function Write-Split() {
    total=50
    length=$((${#1} + ${#2} + ${#3}))
    left=$(($total - $length))
    hyphen = $(($left / 2))
    for i in {1..$hyphen}; do echo -n '-'; done
    echo " ${DARK_GREEN}${1}[${DARK_RED}${2}]${DARK_GREEN}${3} ${DARK_BLUE}"
    for i in {1..$(($hyphen + $left % 2))}; do echo -n '-'; done
    echo '\n'
}

function Config() {
    echo '\n'
    Write-Split 'Going to config ' $1 '.'
    $2
    Write-Split 'Config of ' $1 ' finished.'
}

Config 'Bash'               'Config - Bash.sh'
Config 'Vim'                'Config - Vim.sh'
Config 'Visual Studio Code' 'Config - Visual Studio Code.sh'

echo "\n--------------- Elderry's Config Files ---------------${RESET}\n"
