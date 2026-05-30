sudo tee /etc/cron.weekly/k3s-crictl-prune > /dev/null <<'EOF'
#!/bin/bash
set -e
/usr/local/bin/k3s crictl rmi --prune
EOF
sudo chmod +x /etc/cron.weekly/k3s-crictl-prune