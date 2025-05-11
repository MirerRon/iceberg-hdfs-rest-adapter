# iceberg-hdfs-rest-adapter
A simple JDBC catalog with a REST Adapter that exposes Iceberg on HDFS.

## Compile
To use the REST Adapter class with HDFS we have to compile it with the hadoop dependencies.
1. Add the following to the [libs.versions.toml](https://github.com/apache/iceberg/blob/main/gradle/libs.versions.toml) file:
   ```java
   .
   .
   .
    hadoop3-hdfs = { module = "org.apache.hadoop:hadoop-hdfs", version.ref = "hadoop3" }
    hadoop3-hdfs-client = { module = "org.apache.hadoop:hadoop-hdfs-client", version.ref = "hadoop3" } <---
    hadoop3-mapreduce-client-core = { module = "org.apache.hadoop:hadoop-mapreduce-client-core", version.ref = "hadoop3" }
   .
   .
   .
   ```
2. Add the dependecies to the `:open-api` section in the [build.gradle](https://github.com/apache/iceberg/blob/main/build.gradle#L948) file:
   ```java
   .
   .
   .
    implementation libs.hadoop3.common <----
    implementation libs.hadoop3.hdfs.client <----
    testFixturesImplementation(libs.hadoop3.common) {
   .
   .
   .
   ```
3. Build the JAR:
   ```java
   ./gradlew.sh :iceberg-open-api:shadowJar
   ```

## Image
To build the Image you can recompile the `iceberg-rest-adapter.jar` by following the guide above or just use the current version:
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
