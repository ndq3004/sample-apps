### This yaml file will deploy kafka clusters for logs and business
### Also deploy Otel instance for logging collector
### Dotnet app just need to aware of otel

### Create topic through container:
```
docker exec -it <kafka-business-container-id> \
  kafka-topics --bootstrap-server kafka-business:9092 \
  --create --topic business-topic --partitions 1 --replication-factor 1
```