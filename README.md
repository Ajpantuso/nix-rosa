# nix-rosa

A Nix flake for the [ROSA CLI](https://github.com/openshift/rosa) (Red Hat OpenShift Service on AWS).

This package automatically tracks new releases of the rosa CLI and updates itself via GitHub Actions.

## Installation

### Quick Run

Try rosa without installing:

```bash
nix run github:ajpantuso/nix-rosa -- version
```

### Install in Current Shell

```bash
nix shell github:ajpantuso/nix-rosa
rosa version
```

### Add to Flake

Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-rosa.url = "github:ajpantuso/nix-rosa";
  };

  outputs = { self, nixpkgs, nix-rosa }: {
    # Use in your configuration
  };
}
```

Then reference `nix-rosa.packages.${system}.rosa` in your configuration.

### Install to User Profile

```bash
nix profile install github:ajpantuso/nix-rosa
```

## Development

### Building Locally

```bash
nix build .#rosa
./result/bin/rosa version
```

### Validate Flake

```bash
nix flake check
```

### Run Tests

```bash
./scripts/test-package.sh
```

## Manual Updates

If you need to update to a new rosa version manually:

1. Compute new hashes for all platforms:
   ```bash
   ./scripts/compute-hashes.sh v1.2.60
   ```

2. Update `flake.nix` with the new version and hashes

3. Test the build:
   ```bash
   ./scripts/test-package.sh
   ```

## Auto-Update Workflow

This repository includes a GitHub Actions workflow that:

- Runs daily at 2 AM UTC
- Checks for new rosa releases
- Computes SHA256 hashes for all supported platforms
- Creates a PR with the updated package
- Can be triggered manually via workflow dispatch

The workflow supports:
- x86_64-linux
- aarch64-linux
- x86_64-darwin
- aarch64-darwin

## License

MIT
