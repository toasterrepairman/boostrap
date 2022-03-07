sudo pacman -S docker

sudo tee /etc/modules-load.d/loop.conf <<< "loop"
modprobe loop

sudo groupadd docker
sudo usermod -aG docker toast

systemctl start docker.service