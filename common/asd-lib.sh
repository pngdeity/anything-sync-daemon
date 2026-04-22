#!/bin/bash
# asd-lib.sh — shared diagnostic helpers for anything-sync-daemon
#
# Requires Bash 4.0+
# Source this file in the main script; do not execute directly.

# diag(): General status message to stderr
diag() {
	echo "$*" >&2
}

# ediag(): Formatted error/diagnostic output to stderr (bold red prefix)
ediag() {
	local BLD="\e[01m"
	local RED="\e[01;31m"
	local NRM="\e[00m"
	echo -e "${RED}${BLD}ERROR:${NRM} $*" >&2
}

# croak(): Print an error message and exit
# Usage: croak [exit_code] message...
croak() {
	local exit_code=1
	if [[ "${1:-}" =~ ^[0-9]+$ ]]; then
		exit_code="$1"
		shift
	fi
	ediag "$@"
	exit "$exit_code"
}

# verbosely(): Execute a command and report success or failure to stderr
# Usage: verbosely cmd [args...]
verbosely() {
	if "$@"; then
		diag "OK: $*"
	else
		local rc=$?
		ediag "FAILED (exit ${rc}): $*"
		return "$rc"
	fi
}
