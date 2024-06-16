#!/usr/bin/env bash



###############################################################################
# Remote and local dotsh_utils
###############################################################################
REMOTE_UTILS_URL="https://raw.githubusercontent.com/5kipp3rm/dotfiles/initial/dotsh_utils.sh"
LOCAL_UTILS_FILE="dotsh_utils.sh"

# Ensure that the following actions
# are made relative to this file's path.
cd "$(dirname "${BASH_SOURCE[0]}")"

###############################################################################
# download dotsh_utils
###############################################################################
download_utils() {
    echo "Downloading $LOCAL_UTILS_FILE from $REMOTE_UTILS_URL..."
    curl -L -o "$LOCAL_UTILS_FILE" "$REMOTE_UTILS_URL"
    if [ $? -ne 0 ]; then
        echo "Failed to download $LOCAL_UTILS_FILE"
        exit 1
    fi
}

# Check if utils.sh exists locally
if [ ! -f "$LOCAL_UTILS_FILE" ]; then
    echo "$LOCAL_UTILS_FILE not found locally."
    download_utils
else
    echo "$LOCAL_UTILS_FILE found locally."
fi

# Source the utils.sh file
. "$LOCAL_UTILS_FILE"

# Proceed with the rest of the script
echo "Proceeding with the rest of the bootstrap script..."

exit
current_os=$(get_os)
###############################################################################
# Clone dotsh 
###############################################################################
clone_dotfiles_repo() {
    REPO_URL=$1
    TARGET_DIR="${HOME}/.dotfiles"

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

# Print the result
echo "You are on $current_os."
# Backup function
backup() {
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      mv "$target" "$target.backup"
      echo "-----> Moved your old $target config file to $target.backup"
    fi
  fi
}
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
