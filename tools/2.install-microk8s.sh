#!/bin/bash

set -e

echo "🔧 Installing MicroK8s..."
sudo snap install microk8s --classic

echo "👤 Adding user '$USER' to 'microk8s' group..."
sudo usermod -aG microk8s $USER

# Optional: Fix ~/.kube permissions
sudo chown -f -R $USER ~/.kube || true

echo "⏳ Waiting for MicroK8s to be ready..."
microk8s status --wait-ready

echo "⚙️ Enabling core add-ons: dns, helm3, ingress, storage..."
microk8s enable dns helm3 ingress storage

# Configure MetalLB range (edit to match your network)
METALLB_RANGE="192.168.1.240-192.168.1.250"
echo "🌐 Enabling MetalLB with IP range $METALLB_RANGE..."
microk8s enable metallb:$METALLB_RANGE

echo "📈 Enabling monitoring and UI add-ons: prometheus, dashboard, registry..."
microk8s enable prometheus
microk8s enable dashboard
microk8s enable registry

# Export kubeconfig
echo "📝 Exporting kubeconfig to ~/.kube/config..."
mkdir -p ~/.kube
microk8s config > ~/.kube/config

echo ""
echo "✅ MicroK8s installation complete!"
echo "➡️ Please restart your session or run 'newgrp microk8s' to apply group changes."
echo "📊 Access the Kubernetes dashboard by running:"
echo "    microk8s dashboard-proxy"

