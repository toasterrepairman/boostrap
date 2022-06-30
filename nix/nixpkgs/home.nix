
{ config, pkgs, ... }:

let 
  
in
{
  imports =
  [ # Here we list the modules we want to add to our config:

  ];
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "toast";
  home.homeDirectory = "/home/toast";

  # GTK configuration
  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
  };

  # VS Code Config
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
        # Some example extensions...
        arcticicestudio.nord-visual-studio-code
      ];
    };

    ncspot = {
      enable = true;
      settings = {
        primary = "#5E81AC";
        gapless = true; 
        notify = false;
        initial_screen = "library";
      };
    };

    fish.shellAliases = {
      g = "git";
      "..." = "cd ../..";
      treesaver = "cbonsai -S -t 3";
      weather = "curl wttr.in";
    };
  };

  # Terminal spotify configuration


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
