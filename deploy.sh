#!/bin/bash

# Load .env file
export $(grep -v '^#' .env | xargs)


# Navigate to your project directory
cd ../active-income

# Pull the latest code
#git pull origin main
git pull https://${GITHUB_TOKEN}@github.com/nabilHaouam/active-income.git main
#git fetch --all
#git reset --hard origin/main


# Install new dependencies
npm install

# Restart the PM2 process
pm2 restart main-server

