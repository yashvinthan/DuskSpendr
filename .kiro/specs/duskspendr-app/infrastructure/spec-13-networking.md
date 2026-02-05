# Spec 13: Networking - DNS, Ports, Firewalls & Latency

## Overview

**Spec ID:** DuskSpendr-INFRA-013  
**Domain:** Network Engineering  
**Priority:** P0 (Infrastructure)  
**Estimated Effort:** 2 sprints  

This specification covers network architecture for DuskSpendr, including DNS configuration, port management, firewall rules, and latency optimization for the Indian market.

---

## Objectives

1. **Low Latency** - <100ms API response time within India
2. **High Availability** - DNS failover and redundancy
3. **Security** - Defense in depth with multiple firewall layers
4. **Scalability** - Support for 1M+ concurrent connections
5. **Reliability** - 99.99% DNS availability

---

## Network Architecture

```
                          Internet
                              │
                    ┌─────────▼─────────┐
                    │    CloudFlare     │
                    │   (DNS + CDN)     │
                    │   DDoS Protection │
                    └─────────┬─────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
     ┌────────▼────────┐   ┌──▼──┐   ┌────────▼────────┐
     │  Mumbai DC      │   │ VPN │   │  Bangalore DC   │
     │  (Primary)      │   │     │   │  (Secondary)    │
     └────────┬────────┘   └─────┘   └────────┬────────┘
              │                               │
     ┌────────▼────────┐             ┌────────▼────────┐
     │  Cloud Firewall │             │  Cloud Firewall │
     │  (AWS SG/GCP)   │             │  (AWS SG/GCP)   │
     └────────┬────────┘             └────────┬────────┘
              │                               │
     ┌────────▼────────┐             ┌────────▼────────┐
     │   VPC Network   │◄───────────►│   VPC Network   │
     │  10.0.0.0/16    │   Peering   │  10.1.0.0/16    │
     └─────────────────┘             └─────────────────┘
```

---

## DNS Configuration

### Domain Structure

| Domain | Purpose | Provider |
|--------|---------|----------|
| DuskSpendr.app | Primary domain | CloudFlare |
| api.DuskSpendr.app | API endpoint | CloudFlare |
| cdn.DuskSpendr.app | Static assets | CloudFlare |
| *.DuskSpendr.app | Wildcard | CloudFlare |

### DNS Records

```zone
; Primary Domain
DuskSpendr.app.     A       104.21.xx.xx
DuskSpendr.app.     AAAA    2606:4700::6812
DuskSpendr.app.     MX      10 mx1.DuskSpendr.app.
DuskSpendr.app.     TXT     "v=spf1 include:_spf.google.com ~all"

; API Endpoints (Geo-DNS)
api.DuskSpendr.app.         A       [Mumbai LB IP]
api.DuskSpendr.app.         A       [Bangalore LB IP]

; CDN
cdn.DuskSpendr.app.         CNAME   cdn.cloudflare.com.

; Internal Services
internal.DuskSpendr.app.    A       10.0.1.10
db.DuskSpendr.app.          A       10.0.2.10

; CAA Records (Certificate Authority Authorization)
DuskSpendr.app.     CAA     0 issue "letsencrypt.org"
DuskSpendr.app.     CAA     0 issuewild "letsencrypt.org"
```

### Health Checks

```yaml
# CloudFlare Health Check Configuration
health_checks:
  - name: api-health
    address: api.DuskSpendr.app
    port: 443
    type: HTTPS
    path: /health
    interval: 60
    timeout: 10
    retries: 2
    expected_codes: [200]
    follow_redirects: false
```

---

## Port Configuration

### Inbound Ports

| Port | Service | Source | Protocol |
|------|---------|--------|----------|
| 22 | SSH | VPN only | TCP |
| 80 | HTTP (redirect) | Public | TCP |
| 443 | HTTPS | Public | TCP |
| 3000-3010 | App Servers | Internal | TCP |
| 5432 | PostgreSQL | App servers | TCP |
| 6379 | Redis | App servers | TCP |
| 5672 | RabbitMQ | App servers | TCP |
| 9090 | Prometheus | Monitoring | TCP |
| 3100 | Loki | Monitoring | TCP |

### Outbound Ports

| Port | Service | Destination | Protocol |
|------|---------|-------------|----------|
| 443 | HTTPS APIs | Bank APIs | TCP |
| 443 | FCM | Google | TCP |
| 587 | SMTP | Email provider | TCP |
| 53 | DNS | CloudFlare | UDP/TCP |

---

## Firewall Configuration

### Cloud Security Groups (AWS)

```hcl
# terraform/security_groups.tf

# Web/API Security Group
resource "aws_security_group" "api_sg" {
  name        = "DuskSpendr-api-sg"
  description = "Security group for API servers"
  vpc_id      = aws_vpc.main.id

  # HTTPS from CloudFlare IPs only
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cloudflare_ips
  }

  # HTTP for Let's Encrypt
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH from VPN only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpn_cidr]
  }

  # All outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DuskSpendr-api-sg"
  }
}

# Database Security Group
resource "aws_security_group" "db_sg" {
  name        = "DuskSpendr-db-sg"
  description = "Security group for database servers"
  vpc_id      = aws_vpc.main.id

  # PostgreSQL from API servers only
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.api_sg.id]
  }

  # No outbound (databases don't need internet)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
}
```

### UFW Rules (OS Level)

```bash
#!/bin/bash
# firewall-setup.sh

# Reset UFW
ufw --force reset

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (from specific IPs)
ufw allow from 10.0.0.0/8 to any port 22 proto tcp

# Allow HTTP/HTTPS
ufw allow 80/tcp
ufw allow 443/tcp

# Allow internal services (from VPC)
ufw allow from 10.0.0.0/16 to any port 3000:3010 proto tcp
ufw allow from 10.0.0.0/16 to any port 9090 proto tcp

# Enable logging
ufw logging medium

# Enable firewall
ufw --force enable

# Show status
ufw status verbose
```

---

## Latency Optimization

### India-Focused Infrastructure

| Region | Location | Purpose |
|--------|----------|---------|
| ap-south-1 | Mumbai | Primary |
| ap-south-2 | Hyderabad | Secondary |
| Cloud Edge | Multiple | CDN |

### Latency Targets

| User Location | Target Latency | Current |
|---------------|----------------|---------|
| Mumbai | <20ms | - |
| Delhi | <40ms | - |
| Bangalore | <30ms | - |
| Chennai | <35ms | - |
| Kolkata | <50ms | - |

### Optimization Strategies

```yaml
# Network optimizations
optimizations:
  - name: TCP Fast Open
    enable: true
    
  - name: HTTP/2
    enable: true
    
  - name: Connection Pooling
    keepalive: 60s
    max_idle_per_host: 100
    
  - name: Response Compression
    enable: true
    algorithms: [gzip, br]
    min_size: 1024
    
  - name: Edge Caching
    static_assets: 1d
    api_responses: 0  # No caching for API
```

### CloudFlare Configuration

```yaml
# CloudFlare settings for India
cloudflare:
  zone: DuskSpendr.app
  
  ssl:
    mode: full_strict
    min_version: TLSv1.2
    
  performance:
    cache_level: standard
    minify:
      html: true
      css: true
      js: true
    polish: lossless
    mirage: true
    
  security:
    waf: true
    ddos_protection: true
    rate_limiting:
      - url: "/api/*"
        threshold: 100
        period: 60
        
  network:
    websockets: true
    http2: true
    http3: true  # QUIC
    0rtt: true
```

---

## VPN Configuration

### WireGuard Setup

```ini
# /etc/wireguard/wg0.conf

[Interface]
PrivateKey = <server-private-key>
Address = 10.200.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Admin peer
[Peer]
PublicKey = <admin-public-key>
AllowedIPs = 10.200.0.2/32

# DevOps peer
[Peer]
PublicKey = <devops-public-key>
AllowedIPs = 10.200.0.3/32
```

---

## Network Monitoring

### Metrics to Collect

| Metric | Tool | Alert Threshold |
|--------|------|-----------------|
| Latency | Prometheus | >200ms |
| Packet Loss | CloudWatch | >0.1% |
| Bandwidth | Netdata | >80% capacity |
| Connection Count | Prometheus | >10,000 |
| Error Rate | Prometheus | >1% |

### CloudFlare Analytics

```javascript
// CloudFlare Workers for monitoring
addEventListener('fetch', event => {
  const startTime = Date.now();
  
  event.respondWith(
    fetch(event.request).then(response => {
      const duration = Date.now() - startTime;
      
      // Log to analytics
      console.log(JSON.stringify({
        path: new URL(event.request.url).pathname,
        status: response.status,
        duration: duration,
        cf: event.request.cf
      }));
      
      return response;
    })
  );
});
```

---

## Implementation Tickets

| Ticket ID | Title | Priority | Points |
|-----------|-------|----------|--------|
| SS-270 | Configure CloudFlare DNS with geo-routing | P0 | 5 |
| SS-271 | Set up health checks and failover | P0 | 5 |
| SS-272 | Configure cloud security groups | P0 | 5 |
| SS-273 | Set up OS-level firewall rules | P0 | 3 |
| SS-274 | Configure VPN for admin access | P0 | 5 |
| SS-275 | Set up network monitoring | P1 | 5 |
| SS-276 | Configure CloudFlare WAF rules | P0 | 5 |
| SS-277 | Optimize for India latency | P1 | 8 |
| SS-278 | Set up DDoS protection | P0 | 3 |
| SS-279 | Document network architecture | P1 | 3 |

---

## Verification Plan

### Automated Tests
1. DNS resolution tests from multiple regions
2. Port scanning from external IPs
3. Latency tests from major Indian cities
4. Firewall rule verification

### Manual Verification
1. Test VPN connectivity
2. Verify CloudFlare dashboard metrics
3. Perform latency benchmarks
4. Test failover scenarios

---

*Last Updated: 2026-02-04*  
*Version: 1.0*
