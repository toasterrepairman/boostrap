# regenerates pixbuf cache
# surprisingly common issue in GTK, hopefully this gets figured out at some point

sudo update-mime-database /usr/share/mime
sudo /usr/lib/arm-linux-gnueabihf/gdk-pixbuf/gdk-pixbuf-query-loaders --update-cache