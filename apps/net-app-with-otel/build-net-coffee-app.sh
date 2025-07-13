cd /home/vboxuser/Desktop/sample-apps/apps/net-app-with-otel/after/OpenTelemetry.Introduction/CoffeeShop.Api
dotnet build
cd /home/vboxuser/Desktop/sample-apps/apps/net-app-with-otel
docker build -t net-cof-app -f Dockerfile .
docker tag net-cof-app quannguyen3004/net-cof-app:dev
docker images
