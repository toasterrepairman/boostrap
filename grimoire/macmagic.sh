# use non-insane mouse scaling
Command Defaults write GlobalPreferences com.apple.mouse.scaling -1

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# set git identity
git config --global user.email "smol@toast.cyou"
git config --global user.name "toast"

# install stuff *with* homebrew
brew install slack iterm2 chrome 1password sloth monitorcontrol coteditor \
spotify spicetify

# setting fish to default shell
sudo chsh -s /bin/fish 

# hacking spotify desu
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

# installing spicetify
spicetify backup apply
spicetify config color_scheme nord-dark
spicetify apply

# TODO
# reverse scrolling

# TO INSTALL
# docker-desktop