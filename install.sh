#!/bin/sh

set -e

check_dependency() {
  cmd=$1
  if ! command -v $cmd >/dev/null 2>&1 ; then
    echo "$cmd could not be found"
    echo "Please install $cmd"
    exit 1
  fi
}

check_dependency openssl
check_dependency ssh-keygen
check_dependency docker
check_dependency docker-compose

echo "Step 1/5 : Generating SECRET_KEY_BASE"
secret_key_base=$(openssl rand -hex 64)
echo "Writing SECRET_KEY_BASE to .env"
sed -i "s/SECRET_KEY_BASE=.*$/SECRET_KEY_BASE=${secret_key_base}/" .env
echo "OK\n"

echo "Step 2/5 : Generating JWT_RS256_PRIVATE_KEY"
ssh-keygen -t rsa -m PEM -N "" -f jwtRS256.key
jwt_rs256_private_key=$(sed -z 's/\n/\\\\n/g' jwtRS256.key)
echo "Writing JWT_RS256_PRIVATE_KEY to .env"
sed -i "s|JWT_RS256_PRIVATE_KEY=.*$|JWT_RS256_PRIVATE_KEY=${jwt_rs256_private_key}|" .env
echo "OK\n"

echo "Step 3/5 : Generating JWT_RS256_PUBLIC_KEY"
openssl rsa -in jwtRS256.key -pubout -outform PEM -out jwtRS256.key.pub
jwt_rs256_public_key=$(sed -z 's/\n/\\\\n/g' jwtRS256.key.pub)
echo "Writing JWT_RS256_PUBLIC_KEY to .env"
sed -i "s|JWT_RS256_PUBLIC_KEY=.*$|JWT_RS256_PUBLIC_KEY=${jwt_rs256_public_key}|" .env
echo "OK\n"

echo "Step 4/5 : Generating POSTGRES_PASSWORD"
postgres_password=$(openssl rand -base64 24)
sed -i "s|POSTGRES_PASSWORD=.*$|POSTGRES_PASSWORD=${postgres_password}|" .env
echo "OK\n"

echo "Step 5/5 : Cleaning up"
rm jwtRS256.key jwtRS256.key.pub
echo "OK\n"
