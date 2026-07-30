# MacBook Asahi keyd mapping

This repository keeps keyd disabled for desktop hosts. Import
`modules/nixos/hardware/macbook-keyd.nix` only from the MacBook NixOS host.

## Mapping

- Command -> Control
- Right Option -> Korean/English toggle
- Left Option -> unchanged Alt

## Usage

After installing Asahi Linux, add the module to the MacBook host:

```nix
imports = [
  ../../modules/nixos/hardware/macbook-keyd.nix
];
```

Find the internal keyboard id:

```bash
sudo keyd monitor
```

Then replace the temporary wildcard in `macbook-keyd.nix`:

```nix
ids = [ "<macbook-internal-keyboard-id>" ];
```

The wildcard is useful for the first test, but a fixed id prevents MacBook
remaps from applying to external keyboards.
