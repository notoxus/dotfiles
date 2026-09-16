{ config, pkgs, inputs, ... }:
let
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
#   imports = [
#       inputs.noctalia.homeModules.default
#   ];
   home.username = "juo";
   home.homeDirectory = "/home/juo";
   home.sessionPath = [
      "$HOME/.local/bin"
      "$HOME/bin"
   ];
   home.stateVersion = "26.05";

   programs.zsh = {
      enable = true;
      enableCompletion = true;
      defaultKeymap = "emacs";

      autosuggestion = {
         enable = true;
         highlight = "fg=#6c7086";
         strategy = [ "history" "completion" ];
      };
      syntaxHighlighting.enable = true;
      history = {
         size = 50000;
         save = 50000;
         append = true;
         extended = true;
         expireDuplicatesFirst = true;
         findNoDups = true;
         ignoreAllDups = true;
         ignoreSpace = true;
         share = false;
      };
      shellAliases = {
         ll = "ls -lah";
         gs = "git status";
         bentopdf =
  "docker run -d --rm --name bentopdf -p 127.0.0.1:3000:8080 ghcr.io/alam00000/bentopdf-simple:latest";
         tree = "eza --tree --icons";
      };
   };
   programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
   };
#   programs.noctalia = {
#      enable = true;
#      systemd.enable = true;
#   };
   programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
         "--height=40%"
         "--layout=reverse"
         "--border"
         "--info=inline"
      ];
   };
   programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
   };

   programs.yazi = {
      enable = true;
      enableZshIntegration = true;
   };
   programs.starship = {
     enable = true;
     enableZshIntegration = true;

     settings = {
       add_newline = false;
       command_timeout = 3000;

       character = {
         success_symbol = "[❯](bold #9ece6a)";
         error_symbol = "[❯](bold #f7768e)";
         vimcmd_symbol = "[❮](bold #7aa2f7)";
       };

      directory = {
        style = "bold #7aa2f7";
        truncation_length = 4;
        truncate_to_repo = true;
        read_only = " 󰌾";
      };

      git_branch = {
        symbol = " ";
        style = "bold #bb9af7";
      };

      git_status.style = "bold #e0af68";

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration](bold #ff9e64) ";
      };

      status = {
        disabled = true;
        format = "[$symbol$status](bold #f7768e) ";
      };

      line_break.disabled = false;
     };
   };
   programs.vscodium = {
      enable = true;

      profiles.default.extensions = with pkgs.vscode-extensions; [
         bbenoist.nix          # Nix language support
         arrterian.nix-env-selector
         dracula-theme.theme-dracula
         vscodevim.vim
         yzhang.markdown-all-in-one
     ];
   };

   gtk = {
      enable = true;
      font = {
         name = "JetBrainsMono Nerd Font";
         size = 11;
      };
   };
   home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;

      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 28;
   };
   home.packages = with pkgs; [
      tmux
      nautilus
      codex
      rnote
      gaphor
      unstable.rustdesk-flutter
   ];
   xdg = {
      enable = true;

      mimeApps = {
         enable = true;

         defaultApplications = {
           "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
         };
      };
   };
   programs.home-manager.enable = true;
}
