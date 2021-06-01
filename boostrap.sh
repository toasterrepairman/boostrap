# boostrap, a nordic Arch bootstrap

echo "-- boostrap --"
echo "the following script will install a lot of dotfiles you may not want"

sleep 2

echo "exit now if you are not sure of what you are doing"

sleep 5

# setting wallpaper
feh --bg-fill resources/wallpaper.png

# system upgrade
sudo pacman -Syu

# installing essentials (lightweight only)
sudo pacman -S fish yay micro

# setting fish to default shell
sudo chsh -S /bin/fish

# installing bonus programs
yay -S curlew kdenlive qalculate spotify glade ghostwriter discord albert elementary-planner feh polari tilix visual-studio-code-bin

# bootstrapping GTK theme
mkdir ~/.themes/ && cp resouces/Pop-nord-dark.zip ~/.themes/ 
gsettings set org.gnome.shell.extensions.user-theme "Pop-nord-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Pop-nord-dark"

# restoring config
cp -r resources/config/* ~/.config/

# installing rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# i stay norded // i've seen footage
echo "installation is complete, please restart to ensure maximum potency"