#!/bin/bash

PROJECT_DIR="/var/cardsServer/frontend"
BUILD_DIR="dist"
SERVER_USER="root"
SERVER_IP="fitjourneyhome.com"
REMOTE_DIR="/var/www/html"

cd "$PROJECT_DIR" || { echo "Project directory not found!"; exit 1; }

echo "Building the project..."
npm run build || { echo "Build failed!"; exit 1; }

echo "Copying files to server..."
sshpass -p "$DEPLOY_PASSWORD" scp -o PreferredAuthentications=password -o PubkeyAuthentication=no -v -r "$BUILD_DIR"/* "$SERVER_USER@$SERVER_IP:$REMOTE_DIR" || { echo "File transfer failed!"; exit 1; }


echo "Deployment successful!"
