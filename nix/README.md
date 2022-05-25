# NixOS

This is a new world. We'll see what happens hopefully this is a better place 
with less demons and more robust/survivable systems. This looks better than 
using Guix at least.

---

## Tips
### Symlinking

We can symlink our config files direcly into the system to retain version 
control when we update our systems. This can be done seamlessly with the 
following commands

```bash
sudo ln -s ~/Documents/Code/Shell/boostrap/nix/nixos/ /etc/
```
