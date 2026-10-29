{
  pkgs ? import <nixpkgs> { },
}:
let
  version = "0.2.26";
in
pkgs.stdenv.mkDerivation {
  pname = "horizon-launcher";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/ludovic111/horizon/releases/download/launcher%40${version}/horizon-launcher-linux-x86_64.tar.gz";
    sha256 = "sha256-7r5kqtX3vZ8IyKxJLJuSHrdjeOry/qKucTLBMLD/R10=";
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
      --set NIX_LD "${pkgs.glibc}/lib/ld-linux-x86-64.so.2" \
      --prefix NIX_LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.glibc ]}" \
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
