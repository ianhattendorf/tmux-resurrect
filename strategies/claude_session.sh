#!/usr/bin/env bash

# "claude session strategy"
#
# Restores a Claude Code session by resuming the most recent conversation
# in the pane's working directory using 'claude --continue'.
#
# If the original command already includes a session-resuming flag
# (--continue, -c, --resume, -r, --from-pr), it is preserved as-is.
# Otherwise, the command is replaced with 'claude --continue'.

ORIGINAL_COMMAND="$1"
DIRECTORY="$2"

already_resumes_session() {
	[[ "$ORIGINAL_COMMAND" =~ (^|[[:space:]])(--continue|-c|--resume|-r|--from-pr)($|[[:space:]]) ]]
}

main() {
	if already_resumes_session; then
		echo "$ORIGINAL_COMMAND"
	else
		echo "claude --continue"
	fi
}
main
