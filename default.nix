{
  pkgs ? import <nixpkgs> { },
}:
pkgs.stdenv.mkDerivation {
  pname = "horizon-launcher";
  version = "0.2.6";

  src = ./horizon-launcher;
  dontUnpack = true;

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
    cp $src $out/bin/horizon-launcher
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
