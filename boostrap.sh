# boostrap, a nordic Arch bootstrap

echo "-- boostrap --"
echo "the following script will install a lot of dotfiles you may not want"

sleep 2

echo "exit now if you are not sure of what you are doing"

sleep 5

sudo pacman -Syu
# system upgrade
sudo pacman -S fish yay micro
# installing essentials (lightweight only)
sudo chsh -S /bin/fish
# setting fish to default shell

sudo yay -S ciano kdenlive qalculate spotify glade ghostwriter discord
# installing bonus programs

# i stay norded // i've seen footage