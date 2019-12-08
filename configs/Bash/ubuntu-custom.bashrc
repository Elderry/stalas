
# Below is custom configuration

# Disable colored background for ls in WSL
export LS_COLORS='ow=34'

# Aliases
ls() { command ls --color=auto -I NTUSER.\* -I ntuser.\* "$@"; }
alias config='<stalas path>/config.sh'

# Maven
export MAVEN_OPTS="-Djavax.net.ssl.keyStore=~/OneDrive/Collections/AppBackup/Tradeshift/lry@cn.tradeshift.com.pfx \
    -Djavax.net.ssl.keyStoreType=pkcs12 \
    -Djavax.net.ssl.keyStorePassword=<key store password>"

# Color prompt
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

# AutoJump
# https://github.com/wting/autojump/issues/568
if [[ -f /usr/share/autojump/autojump.bash ]]; then
    . /usr/share/autojump/autojump.bash
fi
