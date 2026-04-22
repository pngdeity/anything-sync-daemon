#!/usr/bin/env bash

#
# Anything-sync-daemon ShellCheck Wrapper
#

set -euo pipefail

# Ensure we are in the project root
cd "$(dirname "$0")/.."

# Check if shellcheck is installed
if ! command -v shellcheck &>/dev/null; then
  echo "Error: shellcheck is not installed." >&2
  echo "Install it with 'sudo apt install shellcheck' or equivalent." >&2
  exit 1
fi

echo "Running ShellCheck on anything-sync-daemon..."
shellcheck -x common/anything-sync-daemon.in
