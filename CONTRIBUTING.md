# Contributing

## Workflow for new iterations

1. Start by updating `TODO.md`:
   - Mark the task as active.
   - Add a one-line intent for what will be changed.
2. At midpoint, update `TODO.md` with:
   - One completed checkpoint.
   - One clear next step.
3. Before marking done:
   - Ensure code and docs are updated together.
   - Run local CI checks and confirm they pass.

## Local CI-ready checks

Run the project parity checks with:

```bash
./scripts/check_local_ci.sh
```

Optional override if Flutter is installed elsewhere:

```bash
FLUTTER_BIN=/path/to/flutter ./scripts/check_local_ci.sh
```

## Commit hygiene

- Keep commits scoped to one logical change.
- Use clear commit messages (`type: summary`).
- Push only after `analyze + test` pass.
