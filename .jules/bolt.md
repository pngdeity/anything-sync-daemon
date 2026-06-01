## 2024-06-25 - Shell subprocess overhead
**Learning:** In bash scripts, repeatedly calling external commands like `tput` inside loops adds significant overhead due to subshell and process spawning.
**Action:** Cache the output of such commands in local variables before the loop to improve performance without sacrificing readability.
