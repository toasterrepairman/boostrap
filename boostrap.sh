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

# bootstrap shell theme
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# setting wallpaper
feh --bg-fill $(pwd)/resources/wallpaper.png

# installing bonus programs
yay -S curlew ghostwriter qalculate-gtk albert polari tilix visual-studio-code-bin

# bootstrapping GTK theme
mkdir ~/.themes/ && cp resouces/Pop-nord-dark.zip ~/.themes/ 
gsettings set org.gnome.shell.extensions.user-theme name "Pop-nord-dark"
gsettings set org.gnome.desktop.interface gtk-theme name "Pop-nord-dark"

# restoring config
cp -r resources/config/* ~/.config/

# installing rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# i stay norded // i've seen footage
echo "installation is complete, please reboot to finish the install"
