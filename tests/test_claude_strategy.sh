#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STRATEGY="$CURRENT_DIR/../strategies/claude_session.sh"

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

	# bare invocation should add --continue
	assert_output "bare claude" \
		"claude" "$tmpdir" \
		"claude --continue"

	# flags without session resumption should add --continue
	assert_output "claude with --model flag" \
		"claude --model opus" "$tmpdir" \
		"claude --continue"

	# --continue should pass through
	assert_output "claude --continue" \
		"claude --continue" "$tmpdir" \
		"claude --continue"

	# -c should pass through
	assert_output "claude -c" \
		"claude -c" "$tmpdir" \
		"claude -c"

	# --resume should pass through
	assert_output "claude --resume" \
		"claude --resume" "$tmpdir" \
		"claude --resume"

	# --resume with session ID should pass through
	assert_output "claude --resume with session ID" \
		"claude --resume abc123" "$tmpdir" \
		"claude --resume abc123"

	# -r should pass through
	assert_output "claude -r" \
		"claude -r" "$tmpdir" \
		"claude -r"

	# -r with session ID should pass through
	assert_output "claude -r with session ID" \
		"claude -r abc123" "$tmpdir" \
		"claude -r abc123"

	# --from-pr should pass through
	assert_output "claude --from-pr" \
		"claude --from-pr 42" "$tmpdir" \
		"claude --from-pr 42"

	# --continue with other flags should pass through
	assert_output "claude --continue with other flags" \
		"claude --continue --model opus" "$tmpdir" \
		"claude --continue --model opus"

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
