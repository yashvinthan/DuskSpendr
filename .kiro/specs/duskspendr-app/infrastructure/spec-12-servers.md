# Spec 12: Servers - Linux, Nginx & Process Management

## Overview

**Spec ID:** DuskSpendr-INFRA-012  
**Domain:** Server Administration  
**Priority:** P0 (Infrastructure)  
**Estimated Effort:** 2 sprints  

This specification covers server infrastructure for DuskSpendr backend services, including Linux server configuration, Nginx reverse proxy setup, and process management for high availability.

---

## Objectives

1. **High Availability** - 99.9% uptime with zero-downtime deployments
2. **Security Hardened** - CIS benchmark compliance
3. **Optimized Performance** - Tuned for API workloads
4. **Observable** - Full logging and monitoring
5. **Automated** - Infrastructure as Code

---

## Server Architecture

```
                        ┌─────────────────┐
                        │   CloudFlare    │
                        │   (CDN/DDoS)    │
                        └────────┬────────┘
                                 │
                        ┌────────▼────────┐
                        │  Load Balancer  │
                        │   (HAProxy)     │
                        └────────┬────────┘
                                 │
           ┌─────────────────────┼─────────────────────┐
           │                     │                     │
   ┌───────▼───────┐    ┌───────▼───────┐    ┌───────▼───────┐
   │    Nginx      │    │    Nginx      │    │    Nginx      │
   │   Server 1    │    │   Server 2    │    │   Server 3    │
   │  (Primary)    │    │  (Secondary)  │    │  (Tertiary)   │
   └───────┬───────┘    └───────┬───────┘    └───────┬───────┘
           │                     │                     │
   ┌───────▼───────┐    ┌───────▼───────┐    ┌───────▼───────┐
   │   App Server  │    │   App Server  │    │   App Server  │
   │   (Node.js)   │    │   (Node.js)   │    │   (Node.js)   │
   └───────────────┘    └───────────────┘    └───────────────┘
```

---

## Linux Server Configuration

### Base OS Requirements

| Component | Specification |
|-----------|---------------|
| OS | Ubuntu 22.04 LTS |
| Kernel | 5.15+ |
| Architecture | x86_64 |
| Min RAM | 4 GB |
| Min CPU | 2 vCPU |
| Min Disk | 50 GB SSD |

### System Hardening

```bash
#!/bin/bash
# server-hardening.sh

# Update system
apt update && apt upgrade -y

# Configure firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw enable

# Disable root login
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Configure fail2ban
apt install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban

# Kernel security parameters
cat >> /etc/sysctl.conf << EOF
# Network security
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0

# Performance tuning
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.core.netdev_max_backlog = 65535
EOF

sysctl -p

# Set up automatic security updates
apt install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```

### User Management

```bash
# Create application user
useradd -m -s /bin/bash DuskSpendr
usermod -aG sudo DuskSpendr

# Set up SSH keys
mkdir -p /home/DuskSpendr/.ssh
chmod 700 /home/DuskSpendr/.ssh
# Add authorized_keys

# Application directories
mkdir -p /opt/DuskSpendr/{app,logs,config}
chown -R DuskSpendr:DuskSpendr /opt/DuskSpendr
```

---

## Nginx Configuration

### Main Configuration

```nginx
# /etc/nginx/nginx.conf

user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 4096;
    use epoll;
    multi_accept on;
}

http {
    # Basic settings
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;

    # MIME types
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # SSL settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 1d;
    ssl_session_tickets off;
    ssl_stapling on;
    ssl_stapling_verify on;

    # Logging
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for" '
                    'rt=$request_time uct="$upstream_connect_time" '
                    'uht="$upstream_header_time" urt="$upstream_response_time"';

    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log warn;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml application/json 
               application/javascript application/xml;

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_conn_zone $binary_remote_addr zone=conn:10m;

    # Upstream servers
    upstream api_servers {
        least_conn;
        server 127.0.0.1:3001 weight=5;
        server 127.0.0.1:3002 weight=5;
        server 127.0.0.1:3003 weight=5 backup;
        keepalive 32;
    }

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

### API Server Configuration

```nginx
# /etc/nginx/sites-available/DuskSpendr-api

server {
    listen 80;
    server_name api.DuskSpendr.app;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.DuskSpendr.app;

    # SSL certificates
    ssl_certificate /etc/letsencrypt/live/api.DuskSpendr.app/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.DuskSpendr.app/privkey.pem;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header Content-Security-Policy "default-src 'self'" always;

    # Request limits
    client_max_body_size 10M;
    client_body_timeout 60s;
    client_header_timeout 60s;

    # Locations
    location / {
        limit_req zone=api burst=20 nodelay;
        limit_conn conn 10;

        proxy_pass http://api_servers;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 60s;
        proxy_connect_timeout 60s;
    }

    # Health check endpoint (no rate limiting)
    location /health {
        proxy_pass http://api_servers;
        proxy_http_version 1.1;
        access_log off;
    }

    # Deny access to sensitive files
    location ~ /\. {
        deny all;
    }
}
```

---

## Process Management

### Systemd Service Configuration

```ini
# /etc/systemd/system/DuskSpendr-api.service

[Unit]
Description=DuskSpendr API Server
Documentation=https://docs.DuskSpendr.app
After=network.target

[Service]
Type=simple
User=DuskSpendr
Group=DuskSpendr
WorkingDirectory=/opt/DuskSpendr/app

# Environment
Environment=NODE_ENV=production
Environment=PORT=3001
EnvironmentFile=/opt/DuskSpendr/config/.env

# Start command
ExecStart=/usr/bin/node /opt/DuskSpendr/app/dist/server.js

# Restart policy
Restart=always
RestartSec=5
StartLimitBurst=5
StartLimitInterval=60

# Resource limits
LimitNOFILE=65535
LimitNPROC=65535

# Security
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/DuskSpendr/logs
PrivateTmp=true

# Logging
StandardOutput=journal
StandardError=journal
SyslogIdentifier=DuskSpendr-api

[Install]
WantedBy=multi-user.target
```

### PM2 Configuration (Alternative)

```javascript
// ecosystem.config.js
module.exports = {
  apps: [
    {
      name: 'DuskSpendr-api-1',
      script: './dist/server.js',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production',
        PORT: 3001
      },
      max_memory_restart: '500M',
      error_file: '/opt/DuskSpendr/logs/pm2-error.log',
      out_file: '/opt/DuskSpendr/logs/pm2-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      merge_logs: true,
      autorestart: true,
      watch: false,
      max_restarts: 10,
      restart_delay: 4000
    },
    {
      name: 'DuskSpendr-api-2',
      script: './dist/server.js',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production',
        PORT: 3002
      },
      max_memory_restart: '500M'
    },
    {
      name: 'DuskSpendr-api-3',
      script: './dist/server.js',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production',
        PORT: 3003
      },
      max_memory_restart: '500M'
    }
  ]
};
```

### Process Management Commands

```bash
# Systemd commands
sudo systemctl start DuskSpendr-api
sudo systemctl stop DuskSpendr-api
sudo systemctl restart DuskSpendr-api
sudo systemctl status DuskSpendr-api
sudo journalctl -u DuskSpendr-api -f

# PM2 commands
pm2 start ecosystem.config.js
pm2 reload DuskSpendr-api-1
pm2 logs DuskSpendr-api-1
pm2 monit
pm2 save
pm2 startup
```

---

## Log Rotation

```bash
# /etc/logrotate.d/DuskSpendr

/opt/DuskSpendr/logs/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 DuskSpendr DuskSpendr
    sharedscripts
    postrotate
        systemctl reload DuskSpendr-api > /dev/null 2>&1 || true
    endscript
}

/var/log/nginx/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        [ -f /var/run/nginx.pid ] && kill -USR1 $(cat /var/run/nginx.pid)
    endscript
}
```

---

## Implementation Tickets

| Ticket ID | Title | Priority | Points |
|-----------|-------|----------|--------|
| SS-260 | Create server provisioning scripts (Ansible/Terraform) | P0 | 8 |
| SS-261 | Configure Linux security hardening | P0 | 5 |
| SS-262 | Set up Nginx reverse proxy | P0 | 5 |
| SS-263 | Configure SSL/TLS certificates (Let's Encrypt) | P0 | 3 |
| SS-264 | Create systemd service configurations | P0 | 5 |
| SS-265 | Set up PM2 for Node.js process management | P1 | 3 |
| SS-266 | Configure log rotation | P1 | 2 |
| SS-267 | Create server monitoring scripts | P1 | 5 |
| SS-268 | Set up automated backups | P0 | 5 |
| SS-269 | Document server runbooks | P1 | 5 |

---

## Verification Plan

### Automated Tests
1. Ansible playbook dry run
2. Nginx configuration test: `nginx -t`
3. Service health checks
4. SSL certificate validation

### Manual Verification
1. SSH access with key-based auth only
2. Firewall rules verification
3. Load balancer failover test
4. Zero-downtime deployment test

---

*Last Updated: 2026-02-04*  
*Version: 1.0*
