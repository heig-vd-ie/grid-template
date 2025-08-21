#!/bin/bash

# Ask for project info
read -p "Project Name: " project_name
read -p "Author: " author
read -p "License: " license

# List of files to replace placeholders
files=("README.md" "pyproject.toml")  # add all files you need

# Replace placeholders in each file
for file in "${files[@]}"; do
    if [[ -f $file ]]; then
        sed -i "s/{{PROJECT_NAME}}/$project_name/g" "$file"
        sed -i "s/{{AUTHOR}}/$author/g" "$file"
        sed -i "s/{{LICENSE}}/$license/g" "$file"
        echo "Updated $file"
    fi
done

echo "Project setup complete!"
