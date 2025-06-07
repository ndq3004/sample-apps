microk8s helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
microk8s helm repo update

microk8s helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace
microk8s kubectl get svc -n ingress-nginx