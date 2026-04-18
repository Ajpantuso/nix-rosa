# Contributing

Thanks for contributing.

## Development Setup

1. Install Nix.
2. (Optional) Enable direnv and run `direnv allow`.
3. Validate the flake:

   ```bash
   nix flake check
   ```

4. Build and test:

   ```bash
   ./scripts/test-package.sh
   ```

## Change Guidelines

- Keep changes focused and minimal.
- Update `README.md` when behavior or usage changes.
- Include tests or validation for your changes.

## Sign-off

This repository uses DCO sign-off. Add `Signed-off-by` to commits.

```text
Signed-off-by: Your Name <you@example.com>
```
