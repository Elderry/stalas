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
alias ls='ls -G' #[macOS]
alias echo='echo -e' #[Linux]
alias docker='"/mnt/c/Program Files/Docker/Docker/resources/bin/docker.exe"' #[Linux]
# Currently this doesn't work becase of an encoding issue: https://github.com/docker/compose/issues/2775
# alias docker-compose='"/mnt/c/Program Files/Docker/Docker/resources/bin/docker-compose.exe"' #[Linux]
alias vc='"/mnt/c/Program Files (x86)/Microsoft VS Code/Code.exe"' #[Linux]
alias vc='open /Applications/"Visual Studio Code".app' #[macOS]

# Home Folders
export REAL_HOME=/mnt/c/Users/Ruiyang #[Linux]
export REAL_HOME=~ #[macOS]
export TS=$REAL_HOME/Projects/Tradeshift
export BWTS=$REAL_HOME/Projects/BWTS/

# Posh-Git
# Color reference: https://help.ubuntu.com/community/CustomizingBashPrompt
RESET='\e[0m'
GREEN_REVERT='\e[1;7;32m'
BLUE_REVERT='\e[1;7;34m'
MAGNETA_REVERT='\e[7;35m'
GREEN_MAGNETA_BACK='\e[1;32;45m'
BLUE='\e[1;34m'
REVERT='\e[7m'
MAGNETA='\e[35m'
source $REAL_HOME/Projects/Personal/posh-git-sh/git-prompt.sh
path="${BLUE_REVERT} \w ${RESET}${BLUE}"
user="${GREEN_REVERT} \u@\h ${RESET}${GREEN_MAGNETA_BACK}"
host="${RESET}${MAGNETA_REVERT}$ ${RESET}${MAGNETA}${RESET}"
PROMPT_COMMAND='__posh_git_ps1 "" "${path}\n${user}${host}"'

# Java
JAVA_HOME=$(/usr/libexec/java_home -v 1.8) #[macOS]
