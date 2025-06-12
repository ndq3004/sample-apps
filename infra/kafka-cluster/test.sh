curl localhost:5000
curl localhost:5002

# curl -X POST http://localhost:4318/v1/logs -H "Content-Type: application/json" -d '{}'


curl -X POST http://localhost:4318/v1/logs \
  -H "Content-Type: application/json" \
  -d '{
    "resourceLogs": [
      {
        "resource": {
          "attributes": [
            {
              "key": "service.name",
              "value": {
                "stringValue": "my-service"
              }
            }
          ]
        },
        "scopeLogs": [
          {
            "scope": {
              "name": "my-logger",
              "version": "1.0.0"
            },
            "logRecords": [
              {
                "timeUnixNano": "1719930678000000000",
                "severityText": "INFO",
                "severityNumber": 9,
                "body": {
                  "stringValue": "Test log entry"
                },
                "attributes": [
                  {
                    "key": "env",
                    "value": {
                      "stringValue": "dev"
                    }
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }'
