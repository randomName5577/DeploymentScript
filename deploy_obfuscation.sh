#!/bin/bash

# Load .env file
export $(grep -v '^#' .env | xargs)

# Navigate to your project directory
cd ../active-income

# Pull the latest code
git pull https://${GITHUB_TOKEN}@github.com/nabilHaouam/active-income.git main

# Create a new directory for the obfuscated version of the project
mkdir -p ../active-income-obfuscated

# Copy the entire project to the new directory, excluding the .git directory
rsync -a --exclude='.git' ./ ../active-income-obfuscated/

# Navigate to the new directory
cd ../active-income-obfuscated

# Install new dependencies (if any)
npm install

# Use an obfuscation tool to obfuscate the files in the new directory
# 'html-minifier' for HTML, 'clean-css-cli' for CSS, and 'terser' for JavaScript:

# Rename .ejs files to .html
for file in $(find . -type f -name "*.ejs"); do
    mv "$file" "${file%.ejs}.html"
done

# Minify the HTML content
find . -type f -name "*.html" -exec html-minifier {} -o {} \;

# Rename .html files back to .ejs
for file in $(find . -type f -name "*.html"); do
    mv "$file" "${file%.html}.ejs"
done

find . -type f -name "*.css" -exec cleancss {} -o {} \;
find . -type d -name 'node_modules' -prune -o -type f -name "*.js" -exec terser {} -o {} \; 


# Now update your server configuration to serve files from active-income-obfuscated instead of active-income

# Restart the PM2 process
pm2 restart obfuscated-server

