#!/usr/bin/env bash

system=$(uname -s)
if [ $system = Linux ]; then
    filename=.bashrc
elif [ $system = Darwin ]; then
    system=macOS
    filename=.bash_profile
fi

sed -e "s/\s*#\[$system\]//" -e '/#\[[a-zA-Z]*\]/ d' <"$(dirname ${BASH_SOURCE[0]})/../Settings/Bash.bashrc" >~/$filename
