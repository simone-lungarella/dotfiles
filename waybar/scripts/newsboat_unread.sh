#!/usr/bin/env bash
# Simple Waybar custom module for Newsboat unread state.
# Usage: newsboat_unread.sh [--icon-only]
# - If --icon-only is passed, shows just an icon when there are unread articles.
# - Otherwise shows icon + count.

set -euo pipefail

ICON=""
ICON_ONLY=false
[[ "${1:-}" == "--icon-only" ]] && ICON_ONLY=true

# Get unread count from newsboat. This command is non-interactive and fast.
# It prints just the number to stdout.
count_raw="$(newsboat -x print-unread 2>/dev/null || echo 0)"
# Normalize: keep only leading integer
count="$(printf '%s\n' "$count_raw" | awk '{print $1}' | sed 's/[^0-9].*$//')"
count="${count:-0}"

# Fallback if not numeric
if ! [[ "$count" =~ ^[0-9]+$ ]]; then
  count=0
fi

if [ "$count" -gt 0 ]; then
  if $ICON_ONLY; then
    text="$ICON"
  else
    text="$ICON $count"
  fi
  printf '{"text":"%s","tooltip":"%s unread in Newsboat","class":"has-unread"}\n' "$text" "$count"
else
  # Empty text + class helps styling; Waybar can hide empty text.
  printf '{"text":"","tooltip":"No unread in Newsboat","class":"no-unread"}\n'
fi
``
