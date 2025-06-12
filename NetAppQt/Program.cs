using Confluent.Kafka;
using OpenTelemetry.Logs;


var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenTelemetry()
    .WithLogging(logs =>
    {
        logs.AddOtlpExporter(options =>
        {
            options.Endpoint = new Uri("http://localhost:4317"); // or use 4318 for HTTP
        });
    });

var app = builder.Build();

var logger = app.Services.GetRequiredService<ILogger<Program>>();

logger.LogInformation("helllo");
logger.LogDebug("helllo");

app.MapGet("/", () => "Hello World!");
app.MapGet("/test", () => "Hello World! 123");
app.MapGet("/pub", async () =>
{
    var producer = new KafkaProducer();
    await producer.ProduceAsync("Hello from .NET to kafka-business!");

    return "published";
});

app.MapGet("/sub", () =>
{   

    var config = new ConsumerConfig
    {
        BootstrapServers = "localhost:9092",
        GroupId = "dotnet-consumer",
        AutoOffsetReset = AutoOffsetReset.Earliest
    };

    using var consumer = new ConsumerBuilder<Ignore, string>(config).Build();
    consumer.Subscribe("business-topic");

    Console.WriteLine("Listening...");
    while (true)
    {
        var cr = consumer.Consume();
        Console.WriteLine($"📩 Received: {cr.Message.Value}");
    }
});

app.Run();
