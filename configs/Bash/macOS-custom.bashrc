
### Custom configuration for macOS ###

# Aliases
alias ls='ls -G'

# For GnuPG and Pinentry's password prompt.
# Reference: https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY=$(tty)

# AutoJump
if [[ -f /usr/local/etc/profile.d/autojump.sh ]]; then
    . /usr/local/etc/profile.d/autojump.sh
fi

# Add Visual Studio Code (code)
# Reference: https://code.visualstudio.com/docs/setup/mac
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
