using Confluent.Kafka;
using System;
using System.Threading.Tasks;

public class KafkaProducer
{
    private readonly string _bootstrapServers = "localhost:9092";
    private readonly string _topic = "business-topic";

    public async Task ProduceAsync(string message)
    {
        var config = new ProducerConfig
        {
            BootstrapServers = _bootstrapServers
        };

        using var producer = new ProducerBuilder<Null, string>(config).Build();

        try
        {
            var result = await producer.ProduceAsync(_topic, new Message<Null, string> { Value = message });
            Console.WriteLine($"✅ Delivered to: {result.TopicPartitionOffset}");
        }
        catch (ProduceException<Null, string> e)
        {
            Console.WriteLine($"❌ Delivery failed: {e.Error.Reason}");
        }
    }
}
