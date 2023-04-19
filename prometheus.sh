#!/bin/bash
cd /opt
wget https://github.com/prometheus/prometheus/releases/download/v2.39.1/prometheus-2.39.1.linux-amd64.tar.gz
tar -xvzf prometheus-2.39.1.linux-amd64.tar.gz
cd prometheus-2.39.1.linux-amd64/
nohup ./prometheus &