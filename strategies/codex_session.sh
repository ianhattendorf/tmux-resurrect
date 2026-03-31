#!/usr/bin/env bash

# "codex session strategy"
#
# Restores a Codex session by resuming the most recent conversation
# using 'codex resume --last'.
#
# If the original command already includes a session-resuming subcommand
# (resume, fork), it is preserved as-is.
# Otherwise, the command is replaced with 'codex resume --last'.

ORIGINAL_COMMAND="$1"
DIRECTORY="$2"

already_resumes_session() {
	[[ "$ORIGINAL_COMMAND" =~ ^codex[[:space:]]+(resume|fork)($|[[:space:]]) ]]
}

main() {
	if already_resumes_session; then
		echo "$ORIGINAL_COMMAND"
	else
		echo "codex resume --last"
	fi
}
main
