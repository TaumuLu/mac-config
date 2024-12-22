#!/bin/bash

# Color output utilities for shell scripts
# Provides functions for printing colored text to terminal

# ANSI color codes
declare -A colors=(
    ["red"]='\033[0;31m'
    ["green"]='\033[0;32m'
    ["yellow"]='\033[1;33m'
    ["blue"]='\033[0;34m'
)
NC='\033[0m' # No Color

# Print colored text
# Usage: printColor "message" "colorName"
printColor() {
    local message="$1"
    local colorName="$2"
    echo -e "${colors[$colorName]}${message}${NC}"
}

# Convenience functions for common colors
printRed() { printColor "$1" "red"; }
printGreen() { printColor "$1" "green"; }
printYellow() { printColor "$1" "yellow"; }
printBlue() { printColor "$1" "blue"; }
