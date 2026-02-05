# Spec 14: Cloud Infrastructure - AWS/GCP, VMs & Storage

## Overview

**Spec ID:** DuskSpendr-INFRA-014  
**Domain:** Cloud Engineering  
**Priority:** P0 (Infrastructure)  
**Estimated Effort:** 4 sprints  

This specification covers cloud infrastructure for DuskSpendr, including compute resources, storage solutions, and Infrastructure as Code patterns for AWS and GCP.

---

## Objectives

1. **Cost Optimization** - Efficient resource utilization
2. **High Availability** - Multi-AZ deployment
3. **Scalability** - Auto-scaling based on demand
4. **Security** - IAM, encryption, compliance
5. **Automation** - Full Infrastructure as Code

---

## Cloud Architecture (AWS Primary)

```
┌──────────────────────────────────────────────────────────────────────────┐
│                           AWS Account (Production)                        │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ┌─────────────────────────────────────────────────────────────────┐     │
│  │                    VPC: DuskSpendr-prod (10.0.0.0/16)          │     │
│  │                                                                  │     │
│  │  ┌──────────────────────┐    ┌──────────────────────┐          │     │
│  │  │   AZ: ap-south-1a    │    │   AZ: ap-south-1b    │          │     │
│  │  │                      │    │                      │          │     │
│  │  │ ┌──────────────────┐ │    │ ┌──────────────────┐ │          │     │
│  │  │ │ Public Subnet    │ │    │ │ Public Subnet    │ │          │     │
│  │  │ │ 10.0.1.0/24      │ │    │ │ 10.0.2.0/24      │ │          │     │
│  │  │ │ ┌──────────────┐ │ │    │ │ ┌──────────────┐ │ │          │     │
│  │  │ │ │  NAT Gateway │ │ │    │ │ │  NAT Gateway │ │ │          │     │
│  │  │ │ └──────────────┘ │ │    │ │ └──────────────┘ │ │          │     │
│  │  │ └──────────────────┘ │    │ └──────────────────┘ │          │     │
│  │  │                      │    │                      │          │     │
│  │  │ ┌──────────────────┐ │    │ ┌──────────────────┐ │          │     │
│  │  │ │ Private Subnet   │ │    │ │ Private Subnet   │ │          │     │
│  │  │ │ 10.0.10.0/24     │ │    │ │ 10.0.20.0/24     │ │          │     │
│  │  │ │ ┌──────────────┐ │ │    │ │ ┌──────────────┐ │ │          │     │
│  │  │ │ │  ECS Tasks   │ │ │    │ │ │  ECS Tasks   │ │ │          │     │
│  │  │ │ │  (Fargate)   │ │ │    │ │ │  (Fargate)   │ │ │          │     │
│  │  │ │ └──────────────┘ │ │    │ │ └──────────────┘ │ │          │     │
│  │  │ └──────────────────┘ │    │ └──────────────────┘ │          │     │
│  │  │                      │    │                      │          │     │
│  │  │ ┌──────────────────┐ │    │ ┌──────────────────┐ │          │     │
│  │  │ │ Database Subnet  │ │    │ │ Database Subnet  │ │          │     │
│  │  │ │ 10.0.100.0/24    │ │    │ │ 10.0.200.0/24    │ │          │     │
│  │  │ │ ┌──────────────┐ │ │    │ │ ┌──────────────┐ │ │          │     │
│  │  │ │ │  RDS Primary │ │ │    │ │ │  RDS Standby │ │ │          │     │
│  │  │ │ └──────────────┘ │ │    │ │ └──────────────┘ │ │          │     │
│  │  │ └──────────────────┘ │    │ └──────────────────┘ │          │     │
│  │  └──────────────────────┘    └──────────────────────┘          │     │
│  │                                                                  │     │
│  └─────────────────────────────────────────────────────────────────┘     │
│                                                                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐          │
│  │   S3 Buckets    │  │  ElastiCache    │  │   Secrets Mgr   │          │
│  │   (Storage)     │  │   (Redis)       │  │   (Secrets)     │          │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘          │
│                                                                           │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Compute Resources

### ECS Fargate Configuration

```hcl
# terraform/ecs.tf

resource "aws_ecs_cluster" "main" {
  name = "DuskSpendr-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs_exec.name
      }
    }
  }
}

resource "aws_ecs_task_definition" "api" {
  family                   = "DuskSpendr-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = "api"
      image = "${aws_ecr_repository.api.repository_url}:latest"
      
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      
      environment = [
        { name = "NODE_ENV", value = "production" },
        { name = "PORT", value = "3000" }
      ]
      
      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = aws_secretsmanager_secret.db_url.arn
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.api.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "api"
        }
      }
      
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}

resource "aws_ecs_service" "api" {
  name            = "DuskSpendr-api"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 3
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.api.id]
    assign_public_ip = false
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "api"
    container_port   = 3000
  }
  
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
}
```

### Auto Scaling

```hcl
# terraform/autoscaling.tf

resource "aws_appautoscaling_target" "api" {
  max_capacity       = 20
  min_capacity       = 3
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "api_cpu" {
  name               = "api-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.api.resource_id
  scalable_dimension = aws_appautoscaling_target.api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.api.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "api_memory" {
  name               = "api-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.api.resource_id
  scalable_dimension = aws_appautoscaling_target.api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.api.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80.0
  }
}
```

---

## Storage Solutions

### S3 Buckets

```hcl
# terraform/s3.tf

# Encrypted backups bucket
resource "aws_s3_bucket" "backups" {
  bucket = "DuskSpendr-backups-${var.environment}"
}

resource "aws_s3_bucket_versioning" "backups" {
  bucket = aws_s3_bucket.backups.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backups" {
  bucket = aws_s3_bucket.backups.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.backups.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backups" {
  bucket = aws_s3_bucket.backups.id

  rule {
    id     = "auto-backup-cleanup"
    status = "Enabled"

    filter {
      prefix = "auto-backups/"
    }

    expiration {
      days = 30
    }

    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
  
  rule {
    id     = "archive-old-backups"
    status = "Enabled"

    filter {
      prefix = "manual-backups/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "backups" {
  bucket = aws_s3_bucket.backups.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

### RDS PostgreSQL

```hcl
# terraform/rds.tf

resource "aws_db_instance" "main" {
  identifier = "DuskSpendr-db"
  
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.t3.medium"
  allocated_storage    = 100
  max_allocated_storage = 500
  storage_type         = "gp3"
  storage_encrypted    = true
  kms_key_id          = aws_kms_key.rds.arn
  
  db_name  = "DuskSpendr"
  username = var.db_username
  password = var.db_password
  port     = 5432
  
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "DuskSpendr-final-snapshot"
  
  tags = {
    Name = "DuskSpendr-primary"
  }
}

# Read replica
resource "aws_db_instance" "replica" {
  identifier = "DuskSpendr-db-replica"
  
  replicate_source_db = aws_db_instance.main.identifier
  instance_class      = "db.t3.medium"
  
  storage_encrypted = true
  kms_key_id       = aws_kms_key.rds.arn
  
  vpc_security_group_ids = [aws_security_group.db.id]
  
  performance_insights_enabled = true
  
  tags = {
    Name = "DuskSpendr-replica"
  }
}
```

### ElastiCache Redis

```hcl
# terraform/elasticache.tf

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "DuskSpendr-redis"
  description          = "Redis cluster for DuskSpendr"
  
  node_type            = "cache.t3.medium"
  num_cache_clusters   = 2
  port                 = 6379
  
  engine               = "redis"
  engine_version       = "7.0"
  parameter_group_name = aws_elasticache_parameter_group.redis.name
  
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.redis.id]
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = var.redis_auth_token
  
  automatic_failover_enabled = true
  multi_az_enabled          = true
  
  snapshot_retention_limit = 7
  snapshot_window         = "05:00-06:00"
  
  tags = {
    Name = "DuskSpendr-redis"
  }
}
```

---

## IAM Configuration

```hcl
# terraform/iam.tf

# ECS Task Role
resource "aws_iam_role" "ecs_task" {
  name = "DuskSpendr-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_task" {
  name = "DuskSpendr-ecs-task-policy"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.backups.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:DuskSpendr/*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = aws_kms_key.main.arn
      }
    ]
  })
}
```

---

## Cost Optimization

### Resource Sizing

| Resource | Size | Estimated Monthly Cost |
|----------|------|------------------------|
| ECS Fargate (3 tasks) | 0.5 vCPU, 1GB | $45 |
| RDS PostgreSQL | db.t3.medium | $85 |
| RDS Read Replica | db.t3.medium | $85 |
| ElastiCache Redis | cache.t3.medium | $50 |
| NAT Gateway | 2 AZs | $90 |
| S3 Storage | 100GB | $3 |
| CloudWatch | Standard | $15 |
| **Total** | | **~$373/month** |

### Cost Saving Strategies

1. **Reserved Instances** - 1-year commitment for 30% savings
2. **Spot Instances** - For non-critical batch jobs
3. **S3 Intelligent Tiering** - Auto-optimize storage costs
4. **Right-sizing** - Regular review of resource utilization

---

## Implementation Tickets

| Ticket ID | Title | Priority | Points |
|-----------|-------|----------|--------|
| SS-280 | Set up AWS VPC with multi-AZ subnets | P0 | 8 |
| SS-281 | Configure ECS Fargate cluster | P0 | 8 |
| SS-282 | Set up RDS PostgreSQL with replica | P0 | 8 |
| SS-283 | Configure ElastiCache Redis | P0 | 5 |
| SS-284 | Create S3 buckets with encryption | P0 | 5 |
| SS-285 | Set up IAM roles and policies | P0 | 8 |
| SS-286 | Configure auto-scaling policies | P0 | 5 |
| SS-287 | Create Terraform modules | P0 | 13 |
| SS-288 | Set up ALB with SSL | P0 | 5 |
| SS-289 | Configure CloudWatch alarms | P1 | 5 |
| SS-290 | Set up cost monitoring | P1 | 3 |

---

## Verification Plan

### Automated Tests
1. Terraform plan validation
2. Infrastructure tests with Terratest
3. Security scanning with Checkov
4. Cost estimation with Infracost

### Manual Verification
1. Multi-AZ failover testing
2. Auto-scaling trigger tests
3. Backup/restore validation
4. Performance benchmarks

---

*Last Updated: 2026-02-04*  
*Version: 1.0*
