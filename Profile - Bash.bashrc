# Add some color for ls in wsl
export LS_COLORS='ow=34' #[Linux]
ls() { command ls --color -A -I NTUSER.\* -I ntuser.\* "$@"; } #[Linux]

# If not running interactively, skip belowing commands
# Reference: https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html
case $- in
    *i*) ;;
      *) return;;
esac

# Bash History
export HISTSIZE=1000
export HISTFILESIZE=2000

# Aliases
alias docker='"/mnt/c/Program Files/Docker/Docker/resources/bin/docker.exe"' #[Linux]
# Currently this doesn't work becase of an encoding issue: https://github.com/docker/compose/issues/2775
alias docker-compose='"/mnt/c/Program Files/Docker/Docker/resources/bin/docker-compose.exe"' #[Linux]
alias echo='echo -e'
alias ls='ls -G' #[macOS]
alias vc='"/mnt/c/Program Files (x86)/Microsoft VS Code/Code.exe"' #[Linux]
alias vc='open /Applications/"Visual Studio Code".app' #[macOS]

# Home Folders
export REAL_HOME=/mnt/c/Users/Ruiyang #[Linux]
export REAL_HOME=~ #[macOS]
export TS=$REAL_HOME/Projects/Tradeshift
export BWTS=$REAL_HOME/Projects/BWTS/

# Posh-Git
# Color reference: https://help.ubuntu.com/community/CustomizingBashPrompt
RESET='\[\e[0m\]'
GREEN_MAGNETA='\[\e[92;105m\]'
BLUE_WHITE='\[\e[94;107m\]'
MAGNETA_WHITE='\[\e[95;107m\]'
WHITE_BLUE='\[\e[97;104m\]'
WHITE_GREEN='\[\e[97;102m\]'
WHITE_MAGNETA='\[\e[97;105m\]'
source $REAL_HOME/Projects/Personal/posh-git-sh/git-prompt.sh
path="${WHITE_BLUE} \w ${BLUE_WHITE}"
user="${WHITE_GREEN} \u@\h ${GREEN_MAGNETA}"
host="${WHITE_MAGNETA}$ ${MAGNETA_WHITE}${RESET}"
PROMPT_COMMAND='__posh_git_ps1 "" "${path}\n${user}${host}"'

# Java
JAVA_HOME=$(/usr/libexec/java_home -v 1.8) #[macOS]
