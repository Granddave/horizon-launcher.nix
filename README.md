# Horizon launcher nix package

Nix flake for the [Horizon launcher](https://github.com/ludovic111/horizon).

Run with

```sh
nix run github:Granddave/horizon-launcher.nix
```

The launcher runs inside an FHS environment so downloaded games use a matching
Nix-provided loader and runtime libraries on both NixOS and other Linux systems.
This requires Bubblewrap to be able to create user namespaces; host security
policy may need to allow this, particularly on Ubuntu.

On non-NixOS systems with Intel Vulkan graphics, run through nixGL:

```sh
nix run --impure github:nix-community/nixGL#nixVulkanIntel -- nix run github:Granddave/horizon-launcher.nix
```

To test a local checkout, replace the final `nix run github:Granddave/horizon-launcher.nix`
with `nix run`.

Update package with

```sh
nix run .#update
```

## License

Licensed under MIT.
