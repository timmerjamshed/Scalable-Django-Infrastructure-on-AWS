#!/usr/bin/env bash
# Apache Bench load test against the ALB.
# Usage: ./scripts/load-test.sh <ALB_DNS_NAME> [requests] [concurrency]
# Example: ./scripts/load-test.sh devops-alb-123456.us-east-1.elb.amazonaws.com 200000 200
#
# Run it from a separate EC2 instance in the same region if you can:
# ab is single threaded and a laptop can become the bottleneck at high concurrency.

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <ALB_DNS_NAME> [requests=200000] [concurrency=200]"
  exit 1
fi

ALB_DNS="$1"
REQUESTS="${2:-200000}"
CONCURRENCY="${3:-200}"

command -v ab >/dev/null 2>&1 || {
  echo "Apache Bench not found. Install it with: sudo apt install apache2-utils -y"
  exit 1
}

# Raise the open-file limit for high concurrency (ignored if not permitted)
ulimit -n 100000 2>/dev/null || true

echo "Target:       http://${ALB_DNS}/"
echo "Requests:     ${REQUESTS}"
echo "Concurrency:  ${CONCURRENCY}"
echo "Leave this running and watch scaling in another terminal."
echo

ab -n "${REQUESTS}" -c "${CONCURRENCY}" "http://${ALB_DNS}/"
