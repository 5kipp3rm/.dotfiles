#! /usr/bin/env bash
# Global SDOTSH path : Simple dot shell with prompt

if [ -z "${SDOTSH_PATH-}" ]; then 
    SDSH_PATH="${HOME}/.dotfiles"
    export SDOTSH_PATH
fi

#################################
#   Simple Dotfile Shall (SDOTSH)   #
#################################

# Check the Bash version.
if [ -z "${BASH_VERSION-}" ]; then
  printf 'sdotsh: This is not a Bash session. Bash 4.3 or higher is required by sdotsh.\n' >&2
  return 1 2>/dev/null
elif [ -z "${BASH_VERSINFO-}" ] || ((BASH_VERSINFO[0] < 4 || BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 3)); then
  printf 'sdotsh: This is Bash %s. Bash 4.3 or higher is required by sdotsh.\n' "$BASH_VERSION" >&2
  return 1 2>/dev/null
fi

# Do not set up prompts when it is not an interactive session.
if [[ $- != *i* ]] && ! return 0 2>/dev/null; then
  printf 'sbp: This is not an interactive session of Bash.\n' >&2
  exit 1
fi

# shellcheck source=src/interact.bash
source "${SDOTSH_PATH}/lib/interactive.cli.bash"
# shellcheck source=src/debug.bash
source "${SDOTSH_PATH}/lib/debug.bash"

if [[ -w "/run/user/${UID}" ]]; then
  SBP_TMP=$(mktemp -d --tmpdir="/run/user/${UID}") && trap 'command rm -rf "$SBP_TMP"' EXIT
else
  SBP_TMP=$(mktemp -d) && trap 'command rm -rf "$SBP_TMP"' EXIT
fi

