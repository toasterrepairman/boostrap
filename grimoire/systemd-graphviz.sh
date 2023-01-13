#!/bin/bash

# Use ps to get a list of running processes
processes=$(ps -eo pid,ppid,comm)

# Create a graphviz file
echo "digraph {" > processes.dot

# Loop through the processes and add edges to the graphviz file
while read -r line; do
  parent_pid=$(echo $line | awk '{print $2}')
  child_pid=$(echo $line | awk '{print $1}')
  process_name=$(echo $line | awk '{print $3}')
  echo "\"$parent_pid\" -> \"$child_pid\" [ label = \"$process_name\"];" >> processes.dot
done <<< "$processes"

echo "}" >> processes.dot

# Use dot to generate a graph image
dot -Tpng -o processes.png processes.dot

# Open the image
xdg-open processes.png
