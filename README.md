# Helm

This chart mostly preconfigured (for PoC purpose), like password, token, influxdb2 pv/pvc, etc already has a value. Check it here:
[value.yaml](helm/glances-k8s-stack/values.yaml)

So you can get ideas from it or use it as is

```bash
helm upgrade -i        \
  glances-k8s-stack .  \
  --namespace gks      \
  --create-namespace
```

# Glances client without docker

```bash
pip3 install glances influxdb_client

# Add to .local/bin to PATH
# echo 'export PATH=$PATH:/home/'$USER'/.local/bin' >> .bashrc
# OR

/home/$USER/.local/bin/glances -V
# stdout will be like this:
# Glances v3.2.3.1 with PsUtil v5.8.0
# Log file: /home/system/.local/share/glances/glances.log

# create .config/glances dir
mkdir -p /home/$USER/.config/glances/ || true

# create .config/glances/glances.conf config
tee /home/$USER/.config/glances/glances.conf <<EOF
[influxdb2]
host=influxdb-test.local.net
port=80
protocol=http
org=influxdata
bucket=grafana
token=influxdb2_very_safe_token
EOF

test:
/home/$USER/.local/bin/glances -C /home/$USER/.config/glances/glances.conf --export influxdb2

sudo tee /etc/systemd/system/glances.service <<EOF
[Unit]
Description=Glances
After=network.target influxd.service

[Service]
ExecStart=/home/$USER/.local/bin/glances -C /home/$USER/.config/glances/glances.conf -q --export influxdb2

Restart=on-failure
RemainAfterExit=yes
RestartSec=30s
TimeoutSec=30s
User=$USER

[Install]
WantedBy=multi-user.target
EOF

systemctl enable glances
systemctl start glances
systemctl status glances
```