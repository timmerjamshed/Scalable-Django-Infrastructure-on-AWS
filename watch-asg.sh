#!/usr/bin/env bash
# Live view of the Auto Scaling Group instances (refreshes every 5 seconds).
# Requires the AWS CLI to be installed and configured (aws configure).
# Usage: ./scripts/watch-asg.sh [asg-name]

set -euo pipefail

ASG_NAME="${1:-devops-asg}"

command -v aws >/dev/null 2>&1 || {
  echo "AWS CLI not found. Install and configure it first."
  exit 1
}

watch -n 5 "aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names ${ASG_NAME} \
  --query 'AutoScalingGroups[0].Instances[*].[InstanceId,LifecycleState,HealthStatus]' \
  --output table"
