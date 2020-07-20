docker pull shokohsc/mkcert && \
docker run -d -ti --rm \
 -e domain=$DOMAIN_CERT \
 --name mkcert \
 -v $(pwd):/root/.local/share/mkcert \
 shokohsc/mkcert
