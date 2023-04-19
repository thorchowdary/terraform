#!/bin/bash 
sudo su -
cd /opt
curl -s https://api.github.com/repos/Lusitaniae/apache_exporter/releases/latest|grep browser_download_url|grep linux-amd64|cut -d '"' -f 4|wget -qi -
tar -xvzf apache_exporter-0.13.3.linux-amd64.tar.gz
rm -rf apache_exporter-0.13.3.linux-amd64.tar.gz
cd apache_exporter-0.13.3.linux-amd64/
nohup ./apache_exporter &
cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz
tar -xvzf node_exporter-1.4.0.linux-amd64.tar.gz
cd node_exporter-1.4.0.linux-amd64
nohup ./node_exporter &