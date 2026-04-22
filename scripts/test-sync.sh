#!/usr/bin/env bash

#
# Anything-sync-daemon Functional Test
# Verifies sync, resync, and unsync logic in a sandboxed environment.
#

set -euo pipefail

# Setup sandbox paths
TEST_ROOT=$(mktemp -d)
trap 'rm -rf "$TEST_ROOT"' EXIT

# Mock environment
export XDG_CONFIG_HOME="$TEST_ROOT/config"
export XDG_RUNTIME_DIR="$TEST_ROOT/runtime"
export DAEMON_FILE="$TEST_ROOT/asd-pid"
export LEGACY_ROOT_LOCK="$TEST_ROOT/legacy-lock"
export LOCKFILE="$TEST_ROOT/asd-lock"
mkdir -p "$XDG_CONFIG_HOME/asd" "$XDG_RUNTIME_DIR"

# Paths to script and config
ASD_BIN="$TEST_ROOT/anything-sync-daemon"
# Ensure the script is built and copy it with its library to an absolute path for reliability
make common/anything-sync-daemon >/dev/null
cp common/anything-sync-daemon "$ASD_BIN"
cp common/asd-lib.sh "$TEST_ROOT/"
chmod +x "$ASD_BIN"

# Create dummy sync targets
TARGET_DIR="$TEST_ROOT/sync_target"
mkdir -p "$TARGET_DIR"
echo "initial data" > "$TARGET_DIR/file.txt"

# Create asd.conf
mkdir -p "$XDG_CONFIG_HOME/asd"
cat <<EOF > "$XDG_CONFIG_HOME/asd/asd.conf"
WHATTOSYNC=("$TARGET_DIR")
VOLATILE="$XDG_RUNTIME_DIR"
USE_BACKUPS="no"
USE_OVERLAYFS="no"
EOF

echo "--- Starting Functional Tests ---"

# 1. Test Sync
echo "Testing 'sync'..."
"$ASD_BIN" sync

if [[ ! -L "$TARGET_DIR" ]]; then
  echo "Error: Target dir should be a symlink after sync."
  exit 1
fi

TMPFS_TARGET=$(readlink -f "$TARGET_DIR")
if [[ "$TMPFS_TARGET" != "$XDG_RUNTIME_DIR"* ]]; then
  echo "Error: Symlink should point to XDG_RUNTIME_DIR. Points to: $TMPFS_TARGET"
  exit 1
fi

if [[ ! -f "$TMPFS_TARGET/file.txt" ]]; then
  echo "Error: File missing in tmpfs."
  exit 1
fi
echo "Sync OK."

# 2. Test Resync (Data flow: tmpfs -> backup)
echo "Testing 'resync'..."
echo "new data" > "$TARGET_DIR/new_file.txt"
"$ASD_BIN" resync

BACKUP_DIR="$TEST_ROOT/.sync_target-backup_asd"
if [[ ! -f "$BACKUP_DIR/new_file.txt" ]]; then
  echo "Error: New file did not sync back to disk backup."
  exit 1
fi
echo "Resync OK."

# 3. Test Unsync
echo "Testing 'unsync'..."
"$ASD_BIN" unsync

if [[ -L "$TARGET_DIR" ]]; then
  echo "Error: Target dir should not be a symlink after unsync."
  exit 1
fi

if [[ ! -f "$TARGET_DIR/new_file.txt" ]]; then
  echo "Error: Data lost after unsync."
  exit 1
fi
echo "Unsync OK."

echo "--- All Functional Tests Passed ---"
