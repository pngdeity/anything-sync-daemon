# Stage 3 Modernization Plan: Modern Bash & Lifecycle Orchestration

## Objective
Refactor the core script architecture for high robustness, defensive execution, and modular maintainability using modern Bash 4.0+ features.

---

## Part 1: Defensive Runtime Environment
**Goal**: Implement strict execution standards to catch logic errors at runtime.

### Tasks
1. **Strict Flags**: Enable `set -u` and `set -o pipefail` in the main script.
2. **Environment Sanitization**: Update all variable usage to ensure compliance with `set -u` (e.g., `${VAR:-default_value}`).
3. **Shell Compatibility**: Explicitly require Bash 4.0+ in the shebang and documentation, as associative arrays are a core dependency.

---

## Part 2: Modular Diagnostic Library
**Goal**: Separate boilerplate utility code from primary orchestration logic.

### Tasks
1. **Library Creation**: Create `common/asd-lib.sh`.
2. **Helper Functions**: Implement standardized diagnostic functions:
    - `diag()`: General status reporting to stderr.
    - `ediag()`: Formatted/colored diagnostic output.
    - `croak()`: Terminal error handler with exit status support.
    - `verbosely()`: A wrapper to execute and log command success/failure automatically.
3. **Integration**: Update `anything-sync-daemon.in` to source the library file.

---

## Part 3: Modern Data Structures
**Goal**: Replace fragile indexed arrays with robust associative mapping.

### Tasks
1. **Associative `WHATTOSYNC`**: Implement an associative array named `WHATTOSYNC` as the primary internal data store for targets.
2. **Data Transformation**: Implement logic to ingest the user-provided indexed array from `asd.conf` and transform it into the internal associative structure.
3. **Benefits**: This ensures automatic de-duplication of targets and allows for future path-specific metadata storage.

---

## Part 4: Lifecycle Orchestration
**Goal**: Implement a modular execution flow following industry best practices.

### Tasks
1. **Phased Execution**: Reorganize the script into three distinct functions:
    - `setup_early()`: Initial environment setup, dependency checks, and default variable assignments.
    - `setup_late()`: Configuration loading, array transformation, and path validation.
    - `main()`: Primary orchestration of sync/unsync/preview subcommands.
2. **Modular Loops**: Create a `for_each_dir()` iterator that handles the logic of traversing the `WHATTOSYNC` map, keeping the specific action logic (e.g., the actual `rsync` call) isolated in standalone task functions.

---

## Automation and Persistence Strategy
- **Error Detection**: By using `set -u`, the script will immediately crash with a clear error message if a developer makes a typo in a variable name, preventing silent failures.
- **Architectural Guardrails**: The separation of Concern (`asd-lib.sh` vs `anything-sync-daemon.in`) ensures that utility code does not clutter the primary logic, making the code's intent obvious to future contributors.

---

## Execution Instructions for AI Agents
1. **Source Tracking**: Ensure that `shellcheck` is updated to follow the new sourced library using `-x`.
2. **Backward Compatibility**: Ensure that the transformation of the user's `WHATTOSYNC` array is seamless and does not require users to update their existing `asd.conf`.
3. **Verification**: Validate that colored output and error trapping remain functional and professional.
