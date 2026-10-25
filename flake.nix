{
  description = "Minecraft Horizon launcher wrapper";
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = import ./default.nix {
        inherit pkgs;
      };
      apps.${system} = {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/horizon-launcher";
        };
        update = {
          type = "app";
          program = "${pkgs.writeShellApplication {
            name = "update-horizon-launcher";
            text = ''
              ${pkgs.nix-update}/bin/nix-update \
                --flake default \
                --version-regex 'launcher@([0-9]+\.[0-9]+\.[0-9]+)' \
                "$@"
            '';
            }}/bin/update-horizon-launcher";
        };
      };
    };
}
