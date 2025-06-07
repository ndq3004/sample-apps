#!/bin/bash
set -e

NAMESPACE="ingress-nginx"

echo "🔧 Creating namespace..."
microk8s kubectl create namespace $NAMESPACE || true

echo "📦 Installing ingress-nginx..."
microk8s helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
microk8s helm repo update

microk8s helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace $NAMESPACE \
  -f values.yaml

echo "✅ ingress-nginx installed!"
