# Restoring Codex sessions

Codex sessions are restored automatically. By default, `codex` is on the
restore list and uses the `session` strategy, which resumes the most recent
session via `codex resume --last`.

No configuration is required.

### Customizing the strategy

The default strategy can be changed in `.tmux.conf`:

    set -g @resurrect-strategy-codex 'session'

Setting it to an empty string disables the strategy and restores the original
command as-is.
