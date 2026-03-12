#!/bin/awk -f

# ai: https://copilot.microsoft.com/chats/JJh6Y2imTHwE2zKH3E2Hp
# prompt: ~~ somethnig like convert bash's arrays to posix shell

# Converts Bash-style arrays to POSIX-style string assignments

{
    # Match lowercase variable names with digits/underscores and array-style assignment
    if (match($0, /^([a-z][a-z0-9_]*)=\(([^)]*)\)$/)) {
        eq_pos = index($0, "=")
        key = substr($0, 1, eq_pos - 1)
        rest = substr($0, eq_pos + 2)
        raw = substr(rest, 1, length(rest) - 1)   # remove closing ")"

        gsub(/^['"]+|['"]+$/, "", raw)            # remove wrapping quotes
        gsub(/[ \t]+/, " ", raw)                  # normalize whitespace

        print key "=\"" raw "\""
    } else {
        print $0
    }
}
