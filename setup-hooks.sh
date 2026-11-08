#!/usr/bin/env bash

if [[ -t 1 ]]; then clear; fi

set -e

red() { printf "\033[0;31m%s\033[0m\n" "$1"; }
green() { printf "\033[0;32m%s\033[0m\n" "$1"; }

error() {
	red "ERROR: $1"
	exit 1
}

echo
printf "Configuring git hooks... "

# validate repo and hooks dir
cd "$(git rev-parse --show-toplevel)" >/dev/null 2>&1 || error "Not inside git repo"
cd "hooks" >/dev/null 2>&1 || error "Dir not found \"hooks\""

# configure hooks
git config core.hooksPath hooks
chmod +x pre-commit 2>/dev/null || error "Failed to set execute permissions"
green "OK"
echo
