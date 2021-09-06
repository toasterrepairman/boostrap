# boostrap, a nordic Arch bootstrap

echo "-- boostrap --"
echo "the following script will install a lot of dotfiles you may not want"

sleep 2

echo "exit now if you are not sure of what you are doing"

sleep 5

# system upgrade
sudo pacman -Syu

# installing essentials (lightweight only)
sudo pacman -S fish yay micro feh base-devel

# setting fish to default shell
sudo chsh -s /bin/fish

# installing rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# grabbing Spotify PGP key
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -

# installing bonus programs
yay -S ibus-typing-booster nextcloud-client xclip gthumb wike vlc okteta monero-gui seahorse pinta gfeeds ghidra foliate spotify libgepub nerd-fonts-fira-code fd discord tootle meld obsidian-appimage spicetify-cli spotify gitg obs-studio spicetify-themes-git curlew qalculate-gtk ulauncher polari tilix visual-studio-code-bin betterdiscordctl-git lutris libreoffice-fresh

# beep beep installing Taxi
yay -S python-dulwich
yay -S taxi-git

# rice
yay -S nordic-theme papirus-folders-nordic ttf-ibm-plex inter-font

# python installation
pip install python3-xlib

# battle.net dependencies
sudo pacman -S lib32-gnutls lib32-libldap lib32-libgpg-error lib32-sqlite lib32-libpulse lib32-alsa-plugins

# hacking spotify desu
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

# preparing Steam
yay -S steam-manjaro steam-native
nohup steam-runtime&
cp resources/air.zip ~/.local/share/Steam/skins
unzip ~/.local/share/Steam/skins/air.zip

# bootstrapping GTK theme
mkdir ~/.themes/ && cp resources/Pop-nord-dark.zip ~/.themes/ 
unzip ~/.themes/Pop-nord-dark.zip
gsettings set org.gnome.shell.extensions.user-theme name "Pop-nord-dark"
gsettings set org.gnome.desktop.interface gtk-theme name "Pop-nord-dark"

# setting wallpaper
cp resources/wallpaper.png ~/.themes/
gsettings set org.gnome.desktop.background picture-uri ~/.themes/wallpaper.png

# restoring config
cp -r resources/config/* ~/.config/

# installing discord/kvantum theme to resources/ 
cd resources/ 
git clone https://github.com/orblazer/discord-nordic.git
git clone https://github.com/EliverLara/Nordic.git
cp -r Nordic/kde/kvantum .
betterdiscordctl install
mkdir /.config/BetterDiscord/themes/
cp discord-nordic/nordic.theme.css ~/.config/BetterDiscord/themes/
cd ..

# installing spicetify
spicetify backup apply
spicetify config custom_apps lyrics-plus
spicetify config custom_apps new-releases
spicetify config extensions bookmark.js
spicetify config extensions loopyLoop.js 
spicetify config extensions shuffle+.js
spicetify config color_scheme nord-dark
spicetify apply

# Install uLauncher theme
git clone https://github.com/KiranWells/ulauncher-nord/ \
  ~/.config/ulauncher/user-themes/nord

# installing retroarch/libretro cores
yay -S retroarch retroarch-assets-ozone libretro-beetle-pce libretro-beetle-psx libretro-beetle-supergrafx libretro-blastem libretro-bsnes libretro-citra libretro-desmume libretro-dolphin libretro-gambatte libretro-mgba libretro-mupen64plus-next

# gnome terminal theme
cd resources/ 
git clone https://github.com/arcticicestudio/nord-gnome-terminal.git
cd nord-tilix/
./install.sh
cd ..

# git ident
git config --global user.email "smol@toast.cyou"
git config --global user.name "toast"

# i stay norded // i've seen footage
echo "installation is complete, please reboot to finish the install"