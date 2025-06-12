# Use runtime-only image since app is already built
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy prebuilt app (change path if needed)
COPY ./after/OpenTelemetry.Introduction/CoffeeShop.Api/bin/Debug/net8.0/ ./

# Set environment to HTTP only
ENV ASPNETCORE_URLS=http://+:5000

EXPOSE 5000
ENTRYPOINT ["dotnet", "CoffeeShop.Api.dll"]
