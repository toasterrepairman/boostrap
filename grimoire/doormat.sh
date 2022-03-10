# doormat
# a place to wipe your bootstrap

# removes creds
echo "clearing SSH credentials..."
rm ~/.ssh/*

# delete all homebrew packages
echo "removing all brew packages"
brew remove $(brew list --formulae) $(brew list --cask) 

# clean config directory
echo "deleting config directory"
rm -r ~/.config/*