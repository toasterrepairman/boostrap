#!/bin/bash
############################################################
# Functions                                                     #
############################################################
Help()
{
  # Display Help
  echo "Bootstrapping script for various Linux systems."
  echo "(may end with undesirable/insecure results)"
  echo
  echo "Syntax: scriptTemplate [-g|h|v|V]"
  echo "options:"
  echo "g     Print the GPL license notification."
  echo "h     Print this Help."
  echo "v     Verbose mode."
  echo "V     Print software version and exit."
  echo
}

Ricing()
{
  # bootstrapping GTK theme
  mkdir ~/.themes/ && cp resources/Pop-nord-dark.zip ~/.themes/ 
  unzip ~/.themes/Pop-nord-dark.zip
  gsettings set org.gnome.shell.extensions.user-theme name "Pop-nord-dark"
  gsettings set org.gnome.desktop.interface gtk-theme name "Pop-nord-dark"

  # setting wallpaper
  cp resources/wallpaper.png ~/.themes/
  gsettings set org.gnome.desktop.background picture-uri ~/.themes/wallpaper.png

  # gnome terminal theme
  cd resources/ 
  git clone https://github.com/arcticicestudio/nord-gnome-terminal.git
  cd nord-tilix/
  ./install.sh
  cd ..
}

Arch()
{
  # system upgrade
  sudo pacman -Syu

  # installing essentials (lightweight only)
  sudo pacman -S fish yay micro feh base-devel

  # setting fish to default shell
  sudo chsh -s /bin/fish

  # installing rust
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

  # installing bonus programs
  yay -S ibus-typing-booster lsp-plugins easyeffects syncthing libdbusmenu-glib \
  xclip gthumb wike keeweb-desktop-bin vlc okteta monero-gui seahorse pinta gfeeds \
  ghidra foliate spotify libgepub nerd-fonts-fira-code fd discord tootle meld \
  obsidian-appimage spicetify-cli spotify gitg obs-studio spicetify-themes-git curlew \
  qalculate-gtk polari tilix visual-studio-code-bin betterdiscordctl-git lutris \
  libreoffice-fresh chromium blanket bottom auto-cpufreq ventoy hunspell-en_us github-cli \
  curtail gimagereader-gtk tesseract-data-eng evolution transmission-gtk evince \
  geeqie gwenview

  # beep beep installing Taxi
  yay -S python-dulwich
  yay -S taxi-git

  # install virtual machine stuffs
  sudo pacman -Syu qemu libvirt virt-manager

  # rice
  yay -S nordic-theme papirus-folders-nordic ttf-ibm-plex inter-font

  # battle.net dependencies
  sudo pacman -S lib32-gnutls lib32-libldap lib32-libgpg-error lib32-sqlite \
  lib32-libpulse lib32-alsa-plugins

  # installing retroarch/libretro cores
  yay -S retroarch retroarch-assets-ozone libretro-beetle-pce libretro-beetle-psx \
  libretro-beetle-supergrafx libretro-blastem libretro-bsnes libretro-citra \
  libretro-desmume libretro-dolphin libretro-gambatte libretro-mgba \
  libretro-mupen64plus-next

  # syncthing setup
  systemctl enable syncthing@toast.service
  systemctl start syncthing@toast.service

  # git ident
  git config --global user.email "smol@toast.cyou"
  git config --global user.name "toast"
}

BootstrapNixOS()
{
  su
    rm -r /etc/nixos/;
    ln -s nix/nixos/ /etc/;
    cat /etc/nixos/configuration.nix
    
    echo "";
    echo "This config will be committed in 5 seconds...";
    sleep 5

    nixos-rebuild switch --upgrade-all

    exit;
}

NixOS()
{
  echo "The following script will lobotomize your NixOS install and potentially"
  echo "leave your system in a non-secure state."
  read -p "Do you want to proceed? (y/n) " yn
  case $yn in 
    y ) BootstrapNixOS;;
    n ) echo "exiting...";
      exit;;
    * ) echo "invalid response";
      exit 1;;
  esac

  echo "The following script will lobotomize your NixOS install and potentially"
  echo "leave your system in a non-secure state."
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

set -euo pipefail

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hran:" option; do
  case $option in
    h) # Prints help 
      Help
      exit;; 
    r) # Installs Ricing 
      Help
      exit;;
    a) # Bootstraps Arch system
      Name=$OPTARG;;
    n) # Bootstraps NixOS system
      Name=$OPTARG;;
    \?) # Invalid option
      echo "Error: Invalid option"
      exit;;
  esac
done
