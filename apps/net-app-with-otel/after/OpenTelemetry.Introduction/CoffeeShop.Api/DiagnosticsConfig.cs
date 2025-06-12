using System.Diagnostics.Metrics;

namespace CoffeeShop.Api;

public static class DiagnosticsConfig
{
    public const string ServiceName = "CoffeeShop";

    public static Meter Meter = new(ServiceName);

    public static Counter<int> SalesCounter = Meter.CreateCounter<int>("sales.count");
}
