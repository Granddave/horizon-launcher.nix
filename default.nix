{
  pkgs ? import <nixpkgs> { },
}:
let
  version = "0.2.8";
in
pkgs.stdenv.mkDerivation {
  pname = "horizon-launcher";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/ludovic111/horizon/releases/download/launcher%40${version}/horizon-launcher-linux-x86_64.tar.gz";
    sha256 = "sha256-OLWqpwZxobnSz3oxy1WHn83szOJ1PYZ1IqABJHgmV+s=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.makeWrapper
  ];

  buildInputs = with pkgs; [
    libxcb
    libxkbcommon
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 horizon-launcher "$out/bin/horizon-launcher"
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/horizon-launcher" \
      --prefix LD_LIBRARY_PATH : "${
        pkgs.lib.makeLibraryPath [
          pkgs.alsa-lib
          pkgs.libxcb
          pkgs.libxkbcommon
          pkgs.vulkan-loader
          pkgs.wayland
        ]
      }"
  '';
}
