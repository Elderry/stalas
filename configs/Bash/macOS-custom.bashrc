
### Custom configuration for macOS ###

# For GnuPG and Pinentry's password prompt.
# Reference: https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY=$(tty)

# AutoJump
if [[ -f /usr/local/etc/profile.d/autojump.sh ]]; then
    . /usr/local/etc/profile.d/autojump.sh
fi
