#!/bin/bash

# Use systemd-cgtop to get a list of running systemd processes
processes=$(systemd-cgtop -bn1)

# Create a graphviz file
echo "digraph {" > processes.dot

# Loop through the processes and add edges to the graphviz file
while read -r line; do
  process_name=$(echo $line | awk '{print $1}')
  process_path=$(echo $line | awk '{print $2}')
  echo "\"$process_name\" -> \"$process_path\";" >> processes.dot
done <<< "$processes"

echo "}" >> processes.dot

# Use dot to generate a graph image
dot -Tpng -o processes.png processes.dot

# Open the image
xdg-open processes.png
