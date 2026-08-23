# ~/.bashrc

# ------------------------------------------------------------
# Exit early if shell is not interactive
# Prevents unwanted behavior in scripts or non-interactive runs
# ------------------------------------------------------------
case $- in
    *i*) ;;
    *) return ;;
esac

# ------------------------------------------------------------
# Source global definitions if present
# ------------------------------------------------------------
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# ------------------------------------------------------------
# Helper: safely prepend directory to PATH if it exists
# Prevents duplicates and avoids broken entries
# ------------------------------------------------------------
path_prepend () {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

# ------------------------------------------------------------
# User binary directories
# ------------------------------------------------------------
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

# ------------------------------------------------------------
# Java configuration
# ------------------------------------------------------------
JAVA_HOME_DEFAULT="/usr/lib/jvm/java-21-openjdk"

if [ -d "$JAVA_HOME_DEFAULT" ]; then
    export JAVA_HOME="$JAVA_HOME_DEFAULT"
    path_prepend "$JAVA_HOME/bin"
fi

# ------------------------------------------------------------
# Shell behavior
# ------------------------------------------------------------
set -o vi          # vi-style command editing
set -o ignoreeof   # prevent Ctrl+D from exiting shell
bind '"\C-l": clear-screen'   # Ctrl+L clears screen

# ------------------------------------------------------------
# Prompt
# Minimal 2-line prompt:
# current working directory
# ❯ input symbol
# ------------------------------------------------------------
PS1='\n\w\n❯ '

# ------------------------------------------------------------
# Export PATH last (after all modifications)
# ------------------------------------------------------------
export PATH
