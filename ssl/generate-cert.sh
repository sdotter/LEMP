#!/bin/bash

mkdir -p ssl
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout ssl/nginx.key -out ssl/nginx.crt \
  -subj "/C=NL/ST=Local/L=Local/O=Dev/CN=localhost"
echo "Self-signed certificate generated in ./ssl/nginx.crt and ./ssl/nginx.key"
