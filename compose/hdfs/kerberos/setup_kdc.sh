#!/bin/bash

mkdir -p /var/log/kerberos
kdb5_util -P masterkey -r EXAMPLE.COM create -s

/usr/sbin/kadmin.local -q "addprinc -randkey hdfs/namenode.example.com"
/usr/sbin/kadmin.local -q "addprinc -randkey HTTP/namenode.example.com"
/usr/sbin/kadmin.local -q "addprinc -randkey hdfs/dn001.example.com"
/usr/sbin/kadmin.local -q "addprinc -randkey HTTP/dn001.example.com"
/usr/sbin/kadmin.local -q "addprinc -randkey hdfs/rest_catalog.example.com"
/usr/sbin/kadmin.local -q "addprinc -randkey HTTP/rest_catalog.example.com"

rm -rf /opt/hadoop_security_files/hdfs.keytab

/usr/sbin/kadmin.local -q "ktadd -k /opt/hadoop_security_files/hdfs.keytab hdfs/namenode.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /opt/hadoop_security_files/hdfs.keytab HTTP/namenode.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /opt/hadoop_security_files/hdfs.keytab hdfs/dn001.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /opt/hadoop_security_files/hdfs.keytab HTTP/dn001.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /opt/hadoop_security_files/hdfs.keytab hdfs/rest_catalog.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /opt/hadoop_security_files/hdfs.keytab HTTP/rest_catalog.example.com"

useradd hdfs
chown hdfs /opt/hadoop_security_files/hdfs.keytab

keytool -genkey -alias namenode.example.com -keyalg rsa -keysize 1024 -dname "CN=namenode.example.com" -keypass changeme -keystore /opt/hadoop_security_files/hdfs.jks -storepass changeme
keytool -genkey -alias dn001.example.com -keyalg rsa -keysize 1024 -dname "CN=dn001.example.com" -keypass changeme -keystore /opt/hadoop_security_files/hdfs.jks -storepass changeme

krb5kdc -n
