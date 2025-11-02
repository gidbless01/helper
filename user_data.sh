#!/bin/bash
# Update system
sudo yum update -y

# Install dependencies
sudo yum install -y wget tar

# Install Prometheus
cd /opt
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.55.1/prometheus-2.55.1.linux-amd64.tar.gz
sudo tar -xzf prometheus-2.55.1.linux-amd64.tar.gz
sudo mv prometheus-2.55.1.linux-amd64 prometheus
sudo useradd --no-create-home --shell /bin/false prometheus
sudo chown -R prometheus:prometheus /opt/prometheus
sudo ln -s /opt/prometheus/prometheus /usr/local/bin/prometheus
sudo ln -s /opt/prometheus/promtool /usr/local/bin/promtool

# Create systemd service for Prometheus
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus --config.file=/opt/prometheus/prometheus.yml --storage.tsdb.path=/opt/prometheus/data
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Install Grafana
sudo yum install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
# Create Prometheus config and data directory
sudo tee /opt/prometheus/prometheus.yml > /dev/null <<EOF
global:
    scrape_interval: 15s

scrape_configs:
    - job_name: 'prometheus'
        static_configs:
            - targets: ['localhost:9090']

    - job_name: 'node_exporter'
        static_configs:
            - targets: ['localhost:9100']
EOF

sudo mkdir -p /opt/prometheus/data
sudo chown -R prometheus:prometheus /opt/prometheus

# Restart Prometheus to pick up config
sudo systemctl restart prometheus
