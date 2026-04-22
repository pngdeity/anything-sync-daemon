# Stage 1 Modernization Plan: Professionalism, Linguistics, and Hygiene

## Objective
Elevate the project's professional image and maintainability by standardizing English usage, removing technical debt (defunct distros), and establishing automated quality gates.

---

## Part 1: Comprehensive English Language Review
**Goal**: Ensure all user-facing documentation and internal developer comments adhere to proper English language usage and technical writing standards.

### Tasks
1. **Linguistic Audit**: Review all source-code comments, documentation (`README.md`, `INSTALL`, `USAGE.md`), and any English prose in the repository's files.
2. **Standardize and Fix**: Identify any deviations from proper English usage (grammar, spelling, syntax) and implement fixes. This includes but is not limited to:
    - Standardizing on Technical American English (e.g., `disk` instead of `disc`).
    - Standardizing suffixes (e.g., `synced` instead of `sync'ed`).
    - Fixing run-on sentences and ensuring clear technical directives.
    - Correcting technical typos (e.g., `preformed` -> `performed`, `incase` -> `in case`).
3. **Specific Refinements**:
    - `README.md`: Hyphenate "user-defined" when used as an adjective. Ensure "sync back" has an object ("sync them back").
    - `INSTALL`: Change "Setup the via a make" to "Set up via make". Change "file-system" to "filesystem".
    - `USAGE.md`: Fix "Since the sync targets is relocated" to "Since the sync targets are relocated".

---

## Part 2: Tone and Professionalism
**Goal**: Remove emotional language and non-technical colloquialisms from source comments.

### Tasks
1. **Comment Audit**: Search for and replace unprofessional language in `common/anything-sync-daemon.in`.
    - Replace `# fuck it` with `# Fallback if no distro string is found`.
    - Replace `# fuck up the sync process` with `# cause the sync process to fail`.
    - Replace `# to whet your appetite` in config files with `# Example configuration:`.

---

## Part 3: Pruning Obsolete References
**Goal**: Remove documentation for defunct or ancient systems that no longer add value.

### Tasks
1. **Defunct Distros**:
    - Remove the "CHAKRA" section and its broken link from the `INSTALL` file.
    - Remove specific references to Ubuntu 15.04 in script comments; refer to them generically as "legacy distributions" if necessary.
2. **Obsolete Init Systems**:
    - Deprecate Upstart mentions in the `README.md` and `INSTALL` files in favor of Systemd.

---

## Part 4: Documentation Modernization
**Goal**: Establish a modern, editable "Source of Truth" for documentation.

### Tasks
1. **Markdown First**: Transition `doc/asd.1` (troff) to `USAGE.md` (Markdown) as the primary editing source.
2. **README Update**: Point contributors to `USAGE.md` for manual updates.

---

## Part 5: Automation and Persistence
**Goal**: Ensure these issues are never reintroduced by automating the "Professionalism" check.

### Automation Strategy
1. **Linter Integration**: Add a GitHub Action workflow utilizing `typos-cli` to automatically flag (and optionally fix) technical misspellings in Pull Requests.
2. **Markdown Linting**: Implement `markdownlint` to enforce consistent formatting and grammar in `.md` files.

### Why issues won't be reintroduced:
- **CI Enforcement**: Once `typos` and `markdownlint` are active in CI, a PR containing "disc" or "incase" will fail the build automatically.
- **Maintainer Guardrails**: The automation reduces the cognitive load on maintainers, as they don't have to manually spot "synced" vs "sync'ed"; the machine does it for them.
- **Cultural Baseline**: Cleaning the existing codebase sets a clear standard for new contributors; code with profanity in a clean repository stands out as an obvious violation.

---

## Execution Instructions for AI Agents
1. **Branch**: Always work on a feature branch (e.g., `fix/modernize-stage1`).
2. **Surgical Edits**: Use targeted string replacements.
3. **Verification**: Run `grep` after changes to ensure no instances of "disc" or profanity remain.
4. **Build**: Run `make doc` to ensure the Markdown-to-Manpage pipeline reflects the new linguistic standards.
