{
  pkgs ? import <nixpkgs> { },
}:
let
  version = "0.2.97";
  launcher = pkgs.stdenv.mkDerivation {
    pname = "horizon-launcher-unwrapped";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/ludovic111/horizon/releases/download/launcher%40${version}/horizon-launcher-linux-x86_64.tar.gz";
      sha256 = "sha256-V7RU/HdCi4pYyF+g44cU12chKz9mQTviFb8dXhysq04=";
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
  # Root-owned ancestors appear as UID 65534 in Bubblewrap's user namespace.
  # Horizon rejects those for control sockets, so expose the runtime directory
  # directly under the user-owned FHS root. Keep its existing desktop sockets.
  extraBwrapArgs = [
    "--perms 0700 --tmpfs /horizon-runtime"
    ''--bind-try "''${XDG_RUNTIME_DIR:-/run/user/$(${pkgs.coreutils}/bin/id -u)}" /horizon-runtime''
  ];
  profile = ''
    export XDG_RUNTIME_DIR=/horizon-runtime
  '';
  runScript = "${launcher}/bin/horizon-launcher";

  passthru = {
    inherit (launcher) src;
  };
}
