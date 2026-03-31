#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STRATEGY="$CURRENT_DIR/../strategies/codex_session.sh"

fail_count=0

assert_output() {
	local description="$1"
	local original_command="$2"
	local directory="$3"
	local expected="$4"
	local actual
	actual="$("$STRATEGY" "$original_command" "$directory")"
	if [ "$actual" != "$expected" ]; then
		echo "FAIL: $description"
		echo "  expected: $expected"
		echo "  actual:   $actual"
		fail_count=$((fail_count + 1))
	else
		echo "PASS: $description"
	fi
}

main() {
	local tmpdir
	tmpdir="$(mktemp -d)"

	# bare invocation should add resume --last
	assert_output "bare codex" \
		"codex" "$tmpdir" \
		"codex resume --last"

	# flags without session resumption should add resume --last
	assert_output "codex with --model flag" \
		"codex -m o3" "$tmpdir" \
		"codex resume --last"

	# resume subcommand should pass through
	assert_output "codex resume" \
		"codex resume" "$tmpdir" \
		"codex resume"

	# resume --last should pass through
	assert_output "codex resume --last" \
		"codex resume --last" "$tmpdir" \
		"codex resume --last"

	# resume with session ID should pass through
	assert_output "codex resume with session ID" \
		"codex resume abc123" "$tmpdir" \
		"codex resume abc123"

	# fork subcommand should pass through
	assert_output "codex fork" \
		"codex fork" "$tmpdir" \
		"codex fork"

	# fork --last should pass through
	assert_output "codex fork --last" \
		"codex fork --last" "$tmpdir" \
		"codex fork --last"

	# fork with session ID should pass through
	assert_output "codex fork with session ID" \
		"codex fork abc123" "$tmpdir" \
		"codex fork abc123"

	# other subcommands should get resume --last
	assert_output "codex exec should not pass through" \
		"codex exec echo hello" "$tmpdir" \
		"codex resume --last"

	rmdir "$tmpdir"

	echo ""
	if [ "$fail_count" -gt 0 ]; then
		echo "$fail_count test(s) failed"
		exit 1
	else
		echo "All tests passed"
		exit 0
	fi
}
main
