{
  description = "Minecraft Horizon launcher wrapper";
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
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
      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/horizon-launcher";
      };
    };
}
