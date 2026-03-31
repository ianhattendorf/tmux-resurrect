# Restoring Claude Code sessions

Claude Code sessions are restored automatically. By default, `claude` is on the
restore list and uses the `session` strategy, which resumes the most recent
conversation via `claude --continue`.

No configuration is required.

### Customizing the strategy

The default strategy can be changed in `.tmux.conf`:

    set -g @resurrect-strategy-claude 'session'

Setting it to an empty string disables the strategy and restores the original
command as-is.
