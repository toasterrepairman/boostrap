# boostrap, a nordic Arch bootstrap

echo "-- boostrap --"
echo "the following script will install a lot of dotfiles you may not want"

sleep 2

echo "exit now if you are not sure of what you are doing"

sleep 5

# system upgrade
sudo pacman -Syu

# installing essentials (lightweight only)
sudo pacman -S fish yay micro

# setting fish to default shell
sudo chsh -S /bin/fish

# installing bonus programs
sudo yay -S curlew kdenlive qalculate spotify glade ghostwriter discord albert

# bootstrapping GTK theme
mkdir ~/.themes/ && cp resouces/Pop-nord-dark.zip ~/.themes/ 
gsettings set org.gnome.shell.extensions.user-theme "Pop-nord-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Pop-nord-dark"

# restoring config
cp -r resources/config/* ~/.config/

# i stay norded // i've seen footage