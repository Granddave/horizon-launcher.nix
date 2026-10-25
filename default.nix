{
  pkgs ? import <nixpkgs> { },
}:
let
  version = "0.2.5";
in
pkgs.stdenv.mkDerivation {
  pname = "horizon-launcher";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/ludovic111/horizon/releases/download/launcher%40${version}/horizon-launcher-linux-x86_64.tar.gz";
    sha256 = "sha256-95TaNZimM4E+M/1J1FxPqLSd5FUc+h96GIp1bYDXzoo=";
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
          pkgs.wayland
          pkgs.vulkan-loader
          pkgs.libxcb
          pkgs.libxkbcommon
        ]
      }"
  '';
}
