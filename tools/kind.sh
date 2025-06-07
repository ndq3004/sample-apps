#!/bin/bash

set -e

echo "Downloading latest Kind binary..."
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64

echo "Making it executable and moving to /usr/local/bin..."
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

echo "Verifying Kind installation..."
kind --version

echo "Kind installed successfully."
