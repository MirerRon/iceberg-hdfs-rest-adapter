# iceberg-hdfs-rest-adapter
A simple JDBC catalog with a REST Adapter that exposes Iceberg on HDFS.

## Build
To build the Image you can recompile the `iceberg-rest-adapter.jar` by following this guide or just use the current version:
```bash
docker build -f build/Dockerfile . -t iceberg-rest-adapter:0.0.1 
```

## Compose
This project contains a compose deployment with the Rest Adapter over postgres and a simple HDFS (with kerberos authentication). To deploy the compose follow the following steps:
1. Create a network named example.com (has to be created externally):
   ```bash
   docker network create example.com
   ```
2. Start the compose:
   ```bash
   cd compose && docker compose up -d
   ```
