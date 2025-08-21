#!/bin/bash

read -p "Project Name: " project_name
read -p "Author: " author
read -p "License: " license

# Replace in all files recursively
find . -type f -exec sed -i "s/{{PROJECT_NAME}}/$project_name/g" {} +
find . -type f -exec sed -i "s/{{AUTHOR}}/$author/g" {} +
find . -type f -exec sed -i "s/{{LICENSE}}/$license/g" {} +

echo "All placeholders replaced in all files!"