docker run -d --rm \
 -e domain=$DOMAIN_CERT \
 --name mkcert \
 -v $(pwd):/root/.local/share/mkcert \
 vishnunair/docker-mkcert
