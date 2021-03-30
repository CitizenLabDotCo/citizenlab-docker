#!/bin/sh

set -e

echo "Generating SECRET_KEY_BASE"
secret_key_base=$(openssl rand -hex 64)
echo "Writing SECRET_KEY_BASE to .env-back"
sed -i "s/SECRET_KEY_BASE=.*$/SECRET_KEY_BASE=${secret_key_base}/" .env-back
echo "OK\n"

echo "Generating JWT_RS256_PRIVATE_KEY"
ssh-keygen -t rsa -m PEM -N "" -f jwtRS256.key
jwt_rs256_private_key=$(sed -z 's/\n/\\\\n/g' jwtRS256.key)
echo "Writing JWT_RS256_PRIVATE_KEY to .env-back"
sed -i "s|JWT_RS256_PRIVATE_KEY=.*$|JWT_RS256_PRIVATE_KEY=${jwt_rs256_private_key}|" .env-back
echo "OK\n"

echo "Generating JWT_RS256_PUBLIC_KEY"
openssl rsa -in jwtRS256.key -pubout -outform PEM -out jwtRS256.key.pub
jwt_rs256_public_key=$(sed -z 's/\n/\\\\n/g' jwtRS256.key.pub)
echo "Writing JWT_RS256_PUBLIC_KEY to .env-back"
sed -i "s|JWT_RS256_PUBLIC_KEY=.*$|JWT_RS256_PUBLIC_KEY=${jwt_rs256_public_key}|" .env-back
echo "OK\n"

echo "Cleaning up"
rm jwtRS256.key jwtRS256.key.pub
echo "OK"
