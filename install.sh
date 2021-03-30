#!/bin/sh

secret_key_base=$(openssl rand -hex 64)

ssh-keygen -t rsa -m PEM -N "" -f jwtRS256.key
jwt_rs256_private_key=$(sed -z 's/\n/\\\\n/g' jwtRS256.key)

openssl rsa -in jwtRS256.key -pubout -outform PEM -out jwtRS256.key.pub
jwt_rs256_public_key=$(sed -z 's/\n/\\\\n/g' jwtRS256.key.pub)

rm jwtRS256.key jwtRS256.key.pub

sed -i "s/SECRET_KEY_BASE=/SECRET_KEY_BASE=${secret_key_base}/;s|JWT_RS256_PRIVATE_KEY=|JWT_RS256_PRIVATE_KEY=${jwt_rs256_private_key}|;s|JWT_RS256_PUBLIC_KEY=|JWT_RS256_PUBLIC_KEY=${jwt_rs256_public_key}|" .env-back
