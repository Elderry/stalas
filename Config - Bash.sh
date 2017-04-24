#!bin/sh

system=$(uname -s)
if [ $system = Linux ]; then
    filename=.bashrc
    extendRegexr=-r
elif [ $system = Darwin ]; then
    system=macOS
    filename=.bash_profile
    extendRegexr=-E
fi

sed $extendRegexr -e "s/\s+#\[$system\]//" -e '/#\[\w+\]/ d' <'Profile - Bash.bashrc' >~/$filename
