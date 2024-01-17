#!/bin/bash

openssl genrsa -out /etc/grafana/grafana.key 2048
openssl req -new -key /etc/grafana/grafana.key -out /etc/grafana/grafana.csr -subj "/C=IE/ST=/L=/O=/OU=IT Dept/CN=.com"
openssl x509 -req -days 365 -in /etc/grafana/grafana.csr -signkey /etc/grafana/grafana.key -out /etc/grafana/grafana.crt
chown grafana:grafana /etc/grafana/grafana.crt
chown grafana:grafana /etc/grafana/grafana.key
chmod 400 /etc/grafana/grafana.key /etc/grafana/grafana.crt

sed -e "s#DBHOST#$DBHOST#g" \
    -e "s#ENV#$ENV#g" \
    -e "s#DBNAME#$DBNAME#g" \
    -e "s#DBUSER#$DBUSER#g" \
    -e "s#DBPASSWORD#$DBPASSWORD#g" \
    -e "s#CLIENTID#$CLIENTID#g" \
    -e "s#CLIENTSECRET#$CLIENTSECRET#g" \
    -e "s#TENANT#$TENANT#g" /tmp/grafana.ini >> /etc/grafana/grafana.ini
    
# Start Grafana
exec /run.sh 