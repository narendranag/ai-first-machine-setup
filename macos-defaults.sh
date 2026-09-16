#!/usr/bin/env bash
# macos-defaults.sh — opinionated macOS settings for a new machine. Run by /setup.
#
# Usage: ./macos-defaults.sh [--dry-run]
# Every setting is one line below; delete what you don't want before running.
# Some take effect after logout. Nothing here needs sudo.
set -euo pipefail

dry=0; [ "${1:-}" = "--dry-run" ] && dry=1
run() { if [ "$dry" -eq 1 ]; then echo "$*"; else "$@"; fi; }

# --- Keyboard ------------------------------------------------------------------
run defaults write NSGlobalDomain KeyRepeat -int 2
run defaults write NSGlobalDomain InitialKeyRepeat -int 15
run defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
run defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
run defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
run defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# --- Finder ----------------------------------------------------------------------
run defaults write NSGlobalDomain AppleShowAllExtensions -bool true
run defaults write com.apple.finder AppleShowAllFiles -bool true
run defaults write com.apple.finder ShowPathbar -bool true
run defaults write com.apple.finder ShowStatusBar -bool true
run defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
run defaults write com.apple.finder _FXSortFoldersFirst -bool true
run defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
run defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
run defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
run defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# --- Dock ------------------------------------------------------------------------
run defaults write com.apple.dock autohide -bool true
run defaults write com.apple.dock autohide-delay -float 0
run defaults write com.apple.dock tilesize -int 44
run defaults write com.apple.dock show-recents -bool false
run defaults write com.apple.dock mru-spaces -bool false

# --- Hot corners (bottom-right: Lock Screen) -------------------------------------
run defaults write com.apple.dock wvous-br-corner -int 13
run defaults write com.apple.dock wvous-br-modifier -int 0

# --- Screenshots -----------------------------------------------------------------
run mkdir -p "$HOME/Pictures/Screenshots"
run defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
run defaults write com.apple.screencapture type -string "png"
run defaults write com.apple.screencapture disable-shadow -bool true

# --- Security ------------------------------------------------------------------
run defaults write com.apple.screensaver askForPassword -int 1
run defaults write com.apple.screensaver askForPasswordDelay -int 0

# --- Apply -------------------------------------------------------------------------
if [ "$dry" -eq 0 ]; then
  killall Finder Dock SystemUIServer 2>/dev/null || true
  echo "macos-defaults: applied. Some settings need a logout."
fi
