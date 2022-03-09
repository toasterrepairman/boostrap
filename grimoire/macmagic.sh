# use non-insane mouse scaling
Command Defaults write GlobalPreferences com.apple.mouse.scaling -1

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# set git identity
git config --global user.email "smol@toast.cyou"
git config --global user.name "toast"

# install stuff *with* homebrew
brew install slack iterm2 chrome 1password sloth monitorcontrol coteditor \
glance onegoal mysensors

# TODO
# reverse scrolling // 

# TO INSTALL
# docker-desktop