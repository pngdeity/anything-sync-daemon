#!/usr/bin/env bash

#
# Anything-sync-daemon Quality Check Wrapper
# Runs ShellCheck (static analysis) and shfmt (formatting check).
#

set -euo pipefail

# Ensure we are in the project root
cd "$(dirname "$0")/.."

rc=0

# Check if shellcheck is installed
if ! command -v shellcheck &>/dev/null; then
	echo "Error: shellcheck is not installed." >&2
	echo "Install it with 'sudo apt install shellcheck' or equivalent." >&2
	exit 1
fi

# Check if shfmt is installed
if ! command -v shfmt &>/dev/null; then
	echo "Error: shfmt is not installed." >&2
	echo "Install it with 'sudo apt install shfmt' or equivalent." >&2
	exit 1
fi

echo "Running ShellCheck on anything-sync-daemon..."
shellcheck -x common/anything-sync-daemon.in || rc=$?

echo "Running shfmt formatting check..."
shfmt -d . || rc=$?

exit "$rc"
