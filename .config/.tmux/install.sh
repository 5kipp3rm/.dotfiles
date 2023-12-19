#!/usr/bin/env bash

set -e
set -u
set -o pipefail

dotfiles_path="$HOME/.dotfiles/.config"

function is_app_installed() {
  type "$1" &>/dev/null
}

function error_exit {
    echo "Error: $1" >&2
    exit 1
}

function safe_rename {
    local source="$1"
    local destination="$2"
    
    if [ -e "$source" ]; then
        mv "$source" "$destination" || error_exit "Failed to rename $source to $destination."
    fi
}

function create_link {
    local source="$1"
    local destination="$2"
    
    safe_rename "${destination}" "${destination}.bak"

    ln -s "$source" "$destination" || error_exit "Failed to create symbolic link from $source to $destination."
    echo "Created link: $destination"
}

REPODIR="$(cd "$(dirname "$0")"; pwd -P)"
cd "$REPODIR";

if ! is_app_installed tmux; then
  printf "WARNING: \"tmux\" command is not found. \
Install it first\n"
  exit 1
fi

if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
  printf "WARNING: Cannot found TPM (Tmux Plugin Manager) \
   at default location: \$HOME/.tmux/plugins/tpm.\n"
  git clone --quiet https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -e "$HOME/.tmux.conf" ]; then
  printf "Found existing .tmux.conf in your \$HOME directory. Will create a backup at $HOME/.tmux.conf.bak\n"
fi

cp -f "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak" 2>/dev/null || true
# Create a symbolic link for .tmux directory
create_link "$dotfiles_path/.tmux" "$HOME/.tmux"
# Create a symbolic link for .tmux.conf file
create_link "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"

# Install TPM plugins.
# TPM requires running tmux server, as soon as `tmux start-server` does not work
# create dump __noop session in detached mode, and kill it when plugins are installed
printf "Install TPM plugins\n"
tmux new -d -s __noop >/dev/null 2>&1 || true 
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.tmux/plugins"
"$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
tmux kill-session -t __noop >/dev/null 2>&1 || true

printf "OK: Completed\n"