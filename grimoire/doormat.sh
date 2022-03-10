# doormat
# a place to wipe your bootstrap

# removes creds
echo "clearing SSH credentials..."
rm ~/.ssh/*

# delete all homebrew packages
echo "removing all brew packages..."
brew remove $(brew list --formulae) $(brew list --cask) 

# clean config directory
echo "deleting config directory..."
rm -r ~/.config/*

# remove all modified directories
echo "clearing personal directories..."
echo "---"
echo "this command will delete a lot of files from ~/Documents/ and other spots"
echo "some of these files may contain personal data or uncommit changes"

# confirm deletion via interactive block
read -p "continue (y/n)?" choice
case "$choice" in 
  y|Y ) rm -rf ~/Documents/* ~/Downloads/* ~/Music/* ~/Pictures/*;;
  n|N ) echo "skipping this step...";;
  * ) echo "invalid, skipping this step...";;
esac