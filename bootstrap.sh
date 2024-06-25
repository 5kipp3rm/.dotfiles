#!/usr/bin/env bash



###############################################################################
# Global Variables and Remote and local dotsh_utils
###############################################################################
REMOTE_UTILS_URL="https://raw.githubusercontent.com/5kipp3rm/dotfiles/initial/dotsh_utils.sh"
LOCAL_UTILS_FILE="dotsh_utils.sh"
REMOTE_GIT_URL="https://github.com/5kipp3rm/dotfiles.git"
# Ensure that the following actions
# are made relative to this file's path.
cd "$(dirname "${BASH_SOURCE[0]}")"

###############################################################################
# download dotsh_utils
###############################################################################
download_utils() {
    printf "[INFO] Downloading %s from %s...\n" "$LOCAL_UTILS_FILE" "$REMOTE_UTILS_URL"
    curl -s -L -o "$LOCAL_UTILS_FILE" "$REMOTE_UTILS_URL"
    if [ $? -ne 0 ]; then
        printf "[ERROR] Failed to download %s\n" "$LOCAL_UTILS_FILE"
        exit 1
    fi
}

# Check if utils.sh exists locally
if [ ! -f "$LOCAL_UTILS_FILE" ]; then
    printf "%s not found locally.\n" "$LOCAL_UTILS_FILE"
    download_utils
else
    printf "%s found locally.\n" "$LOCAL_UTILS_FILE"
fi

# Source the utils.sh file
. "$LOCAL_UTILS_FILE"
logger "INFO" "Starting script..."
# Proceed with the rest of the script
printf "Proceeding with the rest of the bootstrap script...\n"
current_os=$(get_os)
###############################################################################
# Clone dotsh 
###############################################################################
# Backup function
backup 
# Clone Repository
clone_dotfiles_repo ${REMOTE_GIT_URL} testing123
# Print the result
echo "You are on $current_os."
# symlink create with output
symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then
    echo "-----> Symlinking your new $link"
    ln -s $file $link
  fi
}
# installing tmux application
#### $HOME/.config/.tmux/
# ln -s .dotfiles/.config/.tmux/ .tmux
# ln -s .dotfiles/.config/.tmux/.tmux.conf .tmux.conf
#### $HOME/.config/.shell/

#### $HOME/.config/.ssh/
#### $HOME/.config/.tmux/
#### $HOME/.config/.vim/
#### $HOME/.config/git/

## macOS package installation
if $current_os == "Ubuntu"
then

else
    install_homebrew
    print_in_purple "\n • Installs\n\n"
    print_in_purple "\n   Homebrew Packages\n"
    brew_install "Git" "git"
    brew_install "Bash Completion" "bash-completion"
    brew_install "Yarn" "yarn" "" "" "--without-node"
    brew_install "Mac App Store command line interface" "mas"

    print_in_purple "\n   Homebrew Applications\n"
    brew_install "Dropbox" "dropbox" "caskroom/cask" "cask"
    brew_install "Chrome" "google-chrome" "caskroom/cask" "cask"
    brew_install "Chrome Canary" "google-chrome-canary" "caskroom/cask" "cask"
    brew_install "Slack" "slack" "caskroom/cask" "cask"
    brew_install "Visual Studio Code" "visual-studio-code" "caskroom/cask" "cask"
    brew_install "iTerm2" "iterm2" "caskroom/cask" "cask"
    brew_install "Hyper" "hyper" "caskroom/cask" "cask"
    brew_install "Spotify" "spotify" "caskroom/cask" "cask"
    brew_install "Sketch" "sketch" "caskroom/cask" "cask"
    brew_install "Postman" "postman" "caskroom/cask" "cask"
    brew_install "Firefox" "firefox" "caskroom/cask" "cask"
    brew_install "VLC" "vlc" "caskroom/cask" "cask"
    brew_install "iStat Menus" "istat-menus" "caskroom/cask" "cask"

    print_in_purple "\n   Mac App Store Applications\n"

    execute "mas install 1263070803" "Install Lungo"
    print_in_purple "\n   Cleanup\n\n"
    brew_cleanup

    #!/bin/bash

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install brew cask
brew tap caskroom/cask

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Git
brew install git
brew install hub
brew install git-lfs

# ZSH
brew install zsh

# Python
brew instal python
brew install python3
pip install --upgrade pip setuptools

# Node
brew install node

# Remove outdated versions from the cellar.
brew cleanup
fi
