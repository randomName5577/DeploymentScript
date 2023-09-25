#!/bin/bash

# Navigate to your project directory
cd ../active-income

# Pull the latest code
git pull origin main

# Install new dependencies
npm install

# Restart the PM2 process
pm2 restart my-app

