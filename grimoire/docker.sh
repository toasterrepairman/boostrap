sudo pacman -S docker

sudo tee /etc/modules-load.d/loop.conf <<< "loop"
modprobe loop

sudo systemctl enable --now snapd.socket

sudo groupadd docker
sudo usermod -aG docker toast
