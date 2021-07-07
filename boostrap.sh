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

# bootstrap shell theme
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# grabbing Spotify PGP key
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -

# installing bonus programs
yay -S nextcloud-client inter-font docker visual-studio-code-bin kitematic foliate spotify tumbler twitz libgepub nerd-fonts-fira-code fd discord tootle meld obsidian-appimage spicetify-cli spotify obs-studio spicetify-themes-git curlew ghostwriter qalculate-gtk ulauncher polari tilix visual-studio-code-bin betterdiscordctl-git lutris libreoffice-fresh

# installing SMB support
pamac install nautilus-share manjaro-settings-samba

# hacking spotify desu
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

# download Gnome terminal theme
git clone https://github.com/arcticicestudio/nord-gnome-terminal.git
cd nord-gnome-terminal/src
cd ../..

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
spicetify config color_scheme nord-dark
spicetify apply

# installing retroarch/libretro cores
yay -S retroarch retroarch-assets-ozone libretro-beetle-pce libretro-beetle-psx libretro-beetle-supergrafx libretro-blastem libretro-bsnes libretro-citra libretro-desmume libretro-dolphin libretro-gambatte libretro-mgba libretro-mupen64plus-next

# satanic docker ritual
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart docker

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