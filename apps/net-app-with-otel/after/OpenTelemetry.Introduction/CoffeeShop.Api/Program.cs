using CoffeeShop.Api;
using Microsoft.EntityFrameworkCore;
using OpenTelemetry.Logs;
using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using Web.Api.Database;

var builder = WebApplication.CreateBuilder(args);

builder.Logging.ClearProviders();
builder.Logging.AddConsole();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<CoffeeShopDbContext>(options => options.UseInMemoryDatabase("CoffeeShop"));

// builder.Services.AddOpenTelemetry()
//     .ConfigureResource(resource => resource.AddService(DiagnosticsConfig.ServiceName))
//     .WithMetrics(metrics =>
//     {
//         metrics
//             .AddAspNetCoreInstrumentation()
//             .AddHttpClientInstrumentation();

//         metrics.AddMeter(DiagnosticsConfig.Meter.Name);

//         metrics.AddOtlpExporter();
//     })
//     .WithTracing(tracing =>
//     {
//         tracing
//             .AddAspNetCoreInstrumentation()
//             .AddHttpClientInstrumentation()
//             .AddEntityFrameworkCoreInstrumentation();

//         tracing.AddOtlpExporter();
//     });

builder.Logging.AddOpenTelemetry(options =>
{
    options.IncludeScopes = true;
    options.ParseStateValues = true;
    options.IncludeFormattedMessage = true;
    // Export logs to OTLP endpoint (OpenTelemetry Collector)
    options.SetResourceBuilder(
        OpenTelemetry.Resources.ResourceBuilder.CreateDefault()
            .AddService("MyDotNetApp"));
    options.AddOtlpExporter(otlpOptions =>
    {
        otlpOptions.Endpoint = new Uri("http://localhost:4317"); // Collector endpoint
    });
    
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapGet("/", (ILogger<Program> logger) =>
{
    logger.LogInformation("Received request to the root endpoint");
    logger.LogDebug("sjldjlkfjsdlfkjlkdsjfkl");
    return "Welcome to the Coffee Shop API!" + Environment.GetEnvironmentVariable("OTEL_EXPORTER_OTLP_ENDPOINT");
});

app.MapPost("coffee", (CoffeeType coffeeType, CoffeeShopDbContext dbContext, ILogger<Program> logger) =>
{
    if (!Enum.IsDefined(coffeeType))
    {
        logger.LogWarning("Invalid {CoffeeType}", coffeeType);

        return Results.BadRequest();
    }

    var entry = dbContext.Sales.Add(new Sale
    {
        CoffeeType = coffeeType,
        CreatedOnUtc = DateTime.UtcNow
    });
    dbContext.SaveChanges();

    DiagnosticsConfig.SalesCounter.Add(
        1,
        new KeyValuePair<string, object?>("sales.coffee.type", coffeeType),
        new KeyValuePair<string, object?>("sales.id", entry.Entity.Id),
        new KeyValuePair<string, object?>("sales.date", entry.Entity.CreatedOnUtc.Date.ToShortDateString()));

    logger.LogInformation("Successfully create {@Sale}", entry.Entity);

    return Results.Ok(entry.Entity.Id);
});

// app.UseHttpsRedirection();

app.Run();
