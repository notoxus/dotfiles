{ pkgs, inputs, ... }:

let
  unstable =
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
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
  ];
}
