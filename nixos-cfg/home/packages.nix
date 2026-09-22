{ pkgs, inputs, ... }:

let
   system = pkgs.stdenv.hostPlatform.system;
   unstable = import inputs.nixpkgs {
    inherit system;

    config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "cisco-packet-tracer"
        "CiscoPacketTracer_901_Ubuntu_64bit.deb"
      ];
  };  
in
{
  home.packages = with pkgs; [
    # CLI / terminal
    tmux
    neovim
    fastfetch
    eza
    lazygit
    bat
    delta
    dust
    btop
    ripgrep
    gh
    file
    imagemagick

    # Development
    jdk21

    # Desktop App
    nautilus
    codex
    rnote
    gaphor
    unstable.rustdesk-flutter
    obs-studio
    mpv
    ardour
    libreoffice
    zotero
    unstable.cisco-packet-tracer_9
  ];
}
