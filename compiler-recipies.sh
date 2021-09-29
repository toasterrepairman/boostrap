# projectpad build hell (best guess)
yay -S luarocks sqlcipher

sudo luarocks install lsqlcipher

git clone https://github.com/emmanueltouzery/projectpad2.git

cd projectpad2/projectpad

cargo build --release