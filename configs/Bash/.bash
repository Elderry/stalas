# Java
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# Maven
export MAVEN_OPTS="-Djavax.net.ssl.keyStore=/Users/ruiyang/Onedrive/Collections/AppBackup/Tradeshift/lry@cn.tradeshift.com.pfx \
    -Djavax.net.ssl.keyStoreType=pkcs12 \
    -Djavax.net.ssl.keyStorePassword=<key store password>"

# Terminal # [macOS]
export CLICOLOR=1 # [macOS]

# Colors
# Reference: https://help.ubuntu.com/community/CustomizingBashPrompt
RESET='\[\e[0m\]'
GREEN_MAGNETA='\[\e[92;105m\]'
BLUE_WHITE='\[\e[94;107m\]'
MAGNETA_WHITE='\[\e[95;107m\]'
WHITE_BLUE='\[\e[97;104m\]'
WHITE_GREEN='\[\e[97;102m\]'
WHITE_MAGNETA='\[\e[97;105m\]'
path="${WHITE_BLUE} \w ${BLUE_WHITE}"
user="${WHITE_GREEN} \u@\h ${GREEN_MAGNETA}"
host="${WHITE_MAGNETA} $ ${MAGNETA_WHITE}"
export PS1="${path}\n${user}${host}${RESET} "

# For GnuPG and Pinentry's password prompt.
# Reference: https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY=$(tty)

# AutoJump
if [[ -f /usr/local/etc/profile.d/autojump.sh ]]; then
    . /usr/local/etc/profile.d/autojump.sh
fi
if [[ -f /usr/share/autojump/autojump.sh ]]; then
    . /usr/share/autojump/autojump.sh
fi

# Git
if [[ -f /usr/local/etc/bash_completion ]]; then
    . /usr/local/etc/bash_completion
fi

# Visual Studio Code [macOS]
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin" # [macOS]

# enable more support of ls
alias ls='ls --color=auto'
alias la='ls -A'

# SSH [Linux]
eval `ssh-agent` # [Linux]
