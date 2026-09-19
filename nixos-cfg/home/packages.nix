{ pkgs, inputs, ... }:

let
  unstable =
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with pkgs; [
    tmux
    nautilus
    codex
    rnote
    gaphor
    unstable.rustdesk-flutter
    eclipses.eclipse-java
    obs-studio
    mpv
    gh
    file
    imagemagick
    libreoffice
    ripgrep
  ];
}
