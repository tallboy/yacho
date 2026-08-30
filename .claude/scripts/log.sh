#!/usr/bin/env bash
# Append a well-formed row to a /log-work decision log (TSV).
# Usage: log.sh <logfile> <phase> <decision> <why> <evidence> <result>
# Example:
#   .claude/scripts/log.sh scratch/decisions/frontmatter-audit.tsv audit \
#     "treated files with no updated: field as stale" \
#     "notebook-sync already flags a missing date the same as an old one" \
#     ".claude/commands/notebook-sync.md" "6 files flagged"
set -euo pipefail

if [ "$#" -ne 6 ]; then
	printf 'usage: log.sh <logfile> <phase> <decision> <why> <evidence> <result>\n' >&2
	exit 1
fi

logfile="$1"
shift

logdir="$(dirname "$logfile")"
if [ -n "$logdir" ] && [ "$logdir" != "." ] && [ ! -d "$logdir" ]; then
	mkdir -p "$logdir"
fi

if [ ! -f "$logfile" ]; then
	printf 'ts\tphase\tdecision\twhy\tevidence\tresult\n' > "$logfile"
fi

ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
# Strip tabs/newlines/CR so cells stay on one line, and prefix any cell
# whose first char a spreadsheet would parse as a formula (=, +, -, @)
# with a single quote. This log is meant to be readable in a spreadsheet,
# so text that came from somewhere else (a PR title, a filename, generated
# output) must not become formula execution when a reviewer opens the file.
clean() {
	local v
	v=$(printf '%s' "$1" | tr '\t\n\r' '   ')
	case "$v" in
		=*|+*|-*|@*) printf "'%s" "$v" ;;
		*) printf '%s' "$v" ;;
	esac
}
printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
	"$ts" "$(clean "$1")" "$(clean "$2")" "$(clean "$3")" "$(clean "$4")" "$(clean "$5")" \
	>> "$logfile"
