{
  pkgs ? import <nixpkgs> { },
}:
let
  version = "0.2.64";
  launcher = pkgs.stdenv.mkDerivation {
    pname = "horizon-launcher-unwrapped";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/ludovic111/horizon/releases/download/launcher%40${version}/horizon-launcher-linux-x86_64.tar.gz";
      sha256 = "sha256-I84jHrE79CA+qZB2tUC5NZbH32cAXlQp7LuqJSRb7mc=";
    };
    sourceRoot = ".";

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

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
  };
in
pkgs.buildFHSEnv {
  pname = "horizon-launcher";
  inherit version;

  targetPkgs = pkgs: with pkgs; [
    alsa-lib
    alsa-plugins
    jdk25
    libX11
    libXcursor
    libXi
    libXrandr
    libxcb
    libxkbcommon
    systemdLibs
    vulkan-loader
    wayland
  ];
  runScript = "${launcher}/bin/horizon-launcher";

  passthru = {
    inherit (launcher) src;
  };
}
