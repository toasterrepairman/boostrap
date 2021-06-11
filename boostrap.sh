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

# installing bonus programs
yay -S nextcloud-client nerd-fonts-fira-code discord tootle spicetify-cli obs-studio spicetify-themes-git curlew ghostwriter qalculate-gtk albert polari tilix visual-studio-code-bin betterdiscordctl-git lutris libreoffice-fresh

# installing SMB support
pamac install nautilus-share manjaro-settings-samba

# bootstrapping GTK theme
mkdir ~/.themes/ && cp resouces/Pop-nord-dark.zip ~/.themes/ 
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
cp discord-nordic/nordic.theme.css ~/.config/BetterDiscord/themes/
cd ..

# installing spicetify
spicetify config color_scheme nord-dark
spicetify apply

# installing retroarch/libretro cores
yay -S retroarch libretro-beetle-pce libretro-beetle-psx libretro-beetle-supergrafx libretro-blastem libretro-bsnes libretro-citra libretro-desmume libretro-dolphin libretro-gambatte libretro-mgba libretro-mupen64plus-next

# i stay norded // i've seen footage
echo "installation is complete, please reboot to finish the install"