#!/bin/sh

sed -Ee 's|\s+//\[macOS\]||'              \
     -e '/\/\/\[Windows\]/ d'             \
    <'Settings - Visual Studio Code.json' \
    >"~/$HOME/Library/'Application Support'/Code/User/settings.json"
