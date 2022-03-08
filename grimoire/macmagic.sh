# use non-insane mouse scaling
Command Defaults write GlobalPreferences com.apple.mouse.scaling -1

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install stuff *with* homebrew
brew install slack iterm2 chromium

# perform evil incantation to get Docker working
brew install --cask docker

# check to see if evil spell worked
echo "This will check if Docker has been installed properly"
sleep 5
docker info

# TODO
# reverse scrolling // 

# TO INSTALL
