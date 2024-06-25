#!/bin/bash
###############################################################################
# Global Define colors using ANSI escape sequences
###############################################################################

COLOR_RED='\033[0;31m'      # Red
COLOR_YELLOW='\033[0;33m'   # Yellow
COLOR_BLUE='\033[0;34m'     # Blue
COLOR_GREEN='\033[0;32m'    # Green
COLOR_RESET='\033[0m'       # Reset color


logger() {
    local log_level=$1
    local message=$2
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Define log file path (change this to your desired log file path)
    local log_file="/var/log/my_script.log"

    # Check if log file exists, create it if it doesn't
    if [ ! -f "$log_file" ]; then
        touch "$log_file" || { printf "Error: Could not create log file %s\n" "$log_file"; return 1; }
    fi

    # Determine color based on log level
    case "$log_level" in
        "INFO")
            local log_color=$COLOR_GREEN
            ;;
        "WARN")
            local log_color=$COLOR_YELLOW
            ;;
        "ERROR")
            local log_color=$COLOR_RED
            ;;
        "DEBUG")
            local log_color=$COLOR_BLUE
            ;;
        *)
            local log_color=$COLOR_RESET  # Default color
            ;;
    esac

    # Output to log file with timestamp and log level
    printf "[%s] [%s] - %s\n" "$timestamp" "$log_level" "$message" >> "$log_file"

    # Output to standard output with color, timestamp, and log level
    printf "[%s] [%b%s%b] - %s\n" "$timestamp" "$log_color" "$log_level" "$COLOR_RESET" "$message"
}

# Function to check if the user's response is "yes"
answer_is_yes() {
    # Returns true (0) if the user's response is "yes", false (1) otherwise
    [[ "$REPLY" =~ ^[Yy]$ ]] && return 0 || return 1
}

# Function to ask a simple question
ask() {
    # Prints a question and reads the user's response
    print_question "$1"
    read -r
}

# Function to ask for confirmation (yes/no)
ask_for_confirmation() {
    # Asks for confirmation with a yes/no prompt and reads the user's response
    print_question "$1 (y/n) "
    read -r -n 1
    printf "\n"
}

# Function to ask for sudo permissions
ask_for_sudo() {
    # Asks for and caches sudo credentials to prevent repetitive password prompts
    sudo -v &> /dev/null

    # Refreshes sudo timestamp until the script is finished
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &
}

# Function to check if a command exists
cmd_exists() {
    # Checks if a command is available in the system
    command -v "$1" &> /dev/null
}

# Function to kill all background subprocesses
kill_all_subprocesses() {
    # Kills all background processes spawned by the script
    local i=""
    for i in $(jobs -p); do
        kill "$i"
        wait "$i" &> /dev/null
    done
}

# Function to execute a command with additional features
execute() {
    # Executes a command, shows a spinner, and prints the result
    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"
    local exitCode=0
    local cmdsPID=""

    # Sets a trap to kill all subprocesses on script exit
    set_trap "EXIT" "kill_all_subprocesses"

    # Executes the command in the background
    eval "$CMDS" &> /dev/null 2> "$TMP_FILE" &

    cmdsPID=$!

    # Shows a spinner while the command is running
    show_spinner "$cmdsPID" "$CMDS" "$MSG"

    # Waits for the command to finish and gets its exit code
    wait "$cmdsPID" &> /dev/null
    exitCode=$?

    # Prints the result and any error output
    print_result $exitCode "$MSG"
    if [ $exitCode -ne 0 ]; then
        print_error_stream < "$TMP_FILE"
    fi

    # Cleans up temporary files
    rm -rf "$TMP_FILE"
    return $exitCode
}

# Function to get the user's response
get_answer() {
    # Returns the user's response
    printf "%s" "$REPLY"
}

# Function to determine the operating system
get_os() {
    # Determines the operating system and returns its identifier
    local os=""
    local kernelName="$(uname -s)"

    case "$kernelName" in
        Darwin)
            os="macos"
            ;;
        Linux)
            os="linux"
            ;;
        *)
            os="$kernelName"
            ;;
    esac
    printf "%s" "$os"
}

# Function to get the version of the operating system
get_os_version() {
    # Gets the version of the operating system
    local os="$(get_os)"
    local version=""

    case "$os" in
        macos)
            version="$(sw_vers -productVersion)"
            ;;
        linux)
            version="$(lsb_release -d | cut -f2 | cut -d' ' -f2)"
            ;;
    esac
    printf "%s" "$version"
}

# Function to check if the current directory is a Git repository
is_git_repository() {
    # Checks if the current directory is a Git repository
    git rev-parse &> /dev/null
}

# Function to check if the version is supported
is_supported_version() {
    # Checks if a version is supported based on a comparison
    declare -a v1=(${1//./ })
    declare -a v2=(${2//./ })
    local i=""

    for (( i=${#v1[@]}; i<${#v2[@]}; i++ )); do
        v1[i]=0
    done

    for (( i=0; i<${#v1[@]}; i++ )); do
        if [[ -z ${v2[i]} ]]; then
            v2[i]=0
        fi

        if (( 10#${v1[i]} < 10#${v2[i]} )); then
            return 1
        elif (( 10#${v1[i]} > 10#${v2[i]} )); then
            return 0
        fi
    done
}

# Function to create a directory
mkd() {
    # Creates a directory if it does not exist, prints an error if a file with the same name exists
    if [ -n "$1" ]; then
        if [ -e "$1" ]; then
            if [ ! -d "$1" ]; then
                print_error "$1 - a file with the same name already exists!"
            else
                print_success "$1"
            fi
        else
            execute "mkdir -p $1" "$1"
        fi
    fi
}

# Function to print an error message
print_error() {
    # Prints an error message in red
    print_in_red "   [✖] $1 $2\n"
}

# Function to print an error stream
print_error_stream() {
    # Prints an error stream line by line
    while read -r line; do
        print_error "↳ ERROR: $line"
    done
}

# Function to print in color
print_in_color() {
    # Prints text in the specified color
    printf "%b" "$(tput setaf "$2" 2> /dev/null)" "$1" "$(tput sgr0 2> /dev/null)"
}

# Function to print in green
print_in_green() {
    # Prints text in green
    print_in_color "$1" 2
}

# Function to print in purple
print_in_purple() {
    # Prints text in purple
    print_in_color "$1" 5
}

# Function to print in red
print_in_red() {
    # Prints text in red
    print_in_color "$1" 1
}

# Function to print in yellow
print_in_yellow() {
    # Prints text in yellow
    print_in_color "$1" 3
}

# Function to print a question
print_question() {
    # Prints a question in yellow
    print_in_yellow "   [?] $1"
}

# Function to print the result of a command
print_result() {
    # Prints the success or failure of a command
    if [ "$1" -eq 0 ]; then
        logger "INFO" "$2"
    else
        logger "ERROR" "$2"
    fi

    return "$1"
}

# Function to print success message
print_success() {
    # Prints a success message in green
    logger "INFO" "[✔] $1\n"
}

# Function to print warning message
print_warning() {
    # Prints a warning message in yellow
    logger "WARN" "[!] $1\n"
}

# Function to set a trap for signals
set_trap() {
    # Sets a trap for the specified signal to execute a command
    trap -p "$1" | grep "$2" &> /dev/null || trap '$2' "$1"
}

# Function to skip questions based on command-line options
skip_questions() {
    # Skips questions based on command-line options
    while :; do
        case $1 in
            -y|--yes)
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done

    return 1
}

# Function to show a spinner while a command is running
show_spinner() {
    # Shows a spinner while a command is running
    local -r FRAMES='/-\|'
    local -r NUMBER_OF_FRAMES=${#FRAMES}
    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"
    local i=0
    local frameText=""

    if [ "$TRAVIS" != "true" ]; then
        printf "\n\n\n"
        tput cuu 3
        tput sc
    fi

    while kill -0 "$PID" &>/dev/null; do
        frameText="   [${FRAMES:i++%NUMBER_OF_FRAMES:1}] $MSG"

        if [ "$TRAVIS" != "true" ]; then
            printf "%s\n" "$frameText"
        else
            printf "%s" "$frameText"
        fi

        sleep 0.2

        if [ "$TRAVIS" != "true" ]; then
            tput rc
        else
            printf "\r"
        fi
    done
}

# macOS-specific utilities

# Function to clean up Homebrew installations
brew_cleanup() {
    # Cleans up Homebrew installations by removing older versions of formulas
    execute "brew cleanup" "Homebrew (cleanup)"
    execute "brew cask cleanup" "Homebrew (cask cleanup)"
}

# Function to install a Homebrew formula
brew_install() {
    # Installs or upgrades a Homebrew formula
    declare -r CMD="$4"
    declare -r CMD_ARGUMENTS="$5"
    declare -r FORMULA="$2"
    declare -r FORMULA_READABLE_NAME="$1"
    declare -r TAP_VALUE="$3"

    # Checks if Homebrew is installed
    if ! cmd_exists "brew"; then
        logger "ERROR" "$FORMULA_READABLE_NAME ('Homebrew' is not installed)"
        return 1
    fi

    # If a tap is specified, ensures it is tapped
    if [ -n "$TAP_VALUE" ]; then
        if ! brew_tap "$TAP_VALUE"; then
            logger "ERROR" "$FORMULA_READABLE_NAME ('brew tap $TAP_VALUE' failed)"
            return 1
        fi
    fi

    # Installs or upgrades the formula
    # shellcheck disable=SC2086
    if brew $CMD list "$FORMULA" &> /dev/null; then
        logger "INFO"  "$FORMULA_READABLE_NAME"
    else
        execute "brew $CMD install $FORMULA $CMD_ARGUMENTS" "$FORMULA_READABLE_NAME"
    fi
}

# Function to get the Homebrew prefix
brew_prefix() {
    # Gets the Homebrew installation prefix
    local path=""
    if path="$(brew --prefix 2> /dev/null)"; then
        printf "%s" "$path"
        return 0
    else
        print_error "Homebrew (get prefix)"
        return 1
    fi
}

# Function to tap a Homebrew repository
brew_tap() {
    # Taps a Homebrew repository
    brew tap "$1" &> /dev/null
}

# Function to update Homebrew
brew_update() {
    # Updates Homebrew
    execute "brew update" "Homebrew (update)"
}

# Function to upgrade Homebrew packages
brew_upgrade() {
    # Upgrades Homebrew packages
    execute "brew upgrade" "Homebrew (upgrade)"
}

get_homebrew_git_config_file_path() {

    local path=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if path="$(brew --repository 2> /dev/null)/.git/config"; then
        printf "%s" "$path"
        return 0
    else
        print_error "Homebrew (get config file path)"
        return 1
    fi

}

install_homebrew() {

    if ! cmd_exists "brew"; then
        printf "\n" | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &> /dev/null
        #  └─ simulate the ENTER keypress
    fi

    print_result $? "Homebrew"

}

opt_out_of_analytics() {

    local path=""

    path="$(get_homebrew_git_config_file_path)" || return 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Opt-out of Homebrew's analytics.
    # https://github.com/Homebrew/brew/blob/0c95c60511cc4d85d28f66b58d51d85f8186d941/share/doc/homebrew/Analytics.md#opting-out

    if [ "$(git config --file="$path" --get homebrew.analyticsdisabled)" != "true" ]; then
        git config --file="$path" --replace-all homebrew.analyticsdisabled true &> /dev/null
    fi

    print_result $? "Homebrew (opt-out of analytics)"

}

backupA() {
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      mv "$target" "$target.backup"
      echo "-----> Moved your old $target config file to $target.backup"
    fi
  fi
}

backup() {
    USER_HOME=${1-${HOME}}
    backup_dir=${2:-backup_files}

    if [ ! -d "$backup_dir" ]; then
        mkdir -p "$backup_dir"
        logger "INFO" "Created backup directory: $backup_dir"
    fi

    # Use a pattern to include hidden files and directories
    shopt -s dotglob
    for target in "$USER_HOME"/* "$USER_HOME"/.[!.]*; do
        if [ -e "$target" ]; then
            if [ ! -L "$target" ]; then
                relative_path="${target#$USER_HOME/}"
                target_backup_dir="$backup_dir/$(dirname "$relative_path")"

                mkdir -p "$target_backup_dir"
                mv "$target" "$target_backup_dir/"
                logger "INFO" "Moved $target to $target_backup_dir"
            fi
        fi
    done
    shopt -u dotglob
}


clone_dotfiles_repo() {
    REPO_URL=$1
    TARGET_DIR="${HOME}/"${2:-.dotfiles}""

    # Check if the repository URL is provided
    if [ -z "$REPO_URL" ]; then
        echo "Usage: clone_dotfiles_repo <repository_url>"
        return 1
    fi

    # Create the target directory if it doesn't exist
    if [ ! -d "$TARGET_DIR" ]; then
        mkdir -p "$TARGET_DIR"
    fi

    # Clone the repository into the target directory
    git clone "$REPO_URL" "$TARGET_DIR"
}
