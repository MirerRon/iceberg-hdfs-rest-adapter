FROM ubuntu:22.04

USER 0

RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y upgrade

# Install Java
RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y --allow-downgrades install openjdk-17-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Install Kerberos
RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y --allow-downgrades install krb5-user

#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# Modifications were made by Ron Mirer

# Set up the user and group
RUN  set -xeu && \
     groupadd iceberg --gid 1000 && \
     useradd iceberg --uid 1000 --gid 1000 --create-home && \
     apt-get update && \
     apt-get install -y --no-install-recommends curl && \
     rm -rf /var/lib/apt/lists/*

# Working directory for the application
WORKDIR /usr/lib/iceberg-rest

# Copy the JAR dependencies
COPY --chown=iceberg:iceberg build/jars/* /usr/lib/iceberg-rest/

# Default in-memory catalog - should be overriden
ENV CATALOG_CATALOG__IMPL=org.apache.iceberg.jdbc.JdbcCatalog
ENV CATALOG_URI=jdbc:sqlite::memory:
ENV CATALOG_JDBC_USER=user
ENV CATALOG_JDBC_PASSWORD=password
ENV REST_PORT=8181

# Healthcheck for the iceberg rest service
HEALTHCHECK --retries=10 --interval=1s \
  CMD curl --fail http://localhost:$REST_PORT/v1/config || exit 1

EXPOSE $REST_PORT
USER iceberg:iceberg
ENV LANG=en_US.UTF-8
CMD ["java", "-cp", "${HADOOP_CONF_DIR}:/usr/lib/iceberg-rest/*", "org.apache.iceberg.rest.RESTCatalogServer"]
