docker pull shokohsc/mkcert && \
docker run -ti --rm \
 -e domain=$DOMAIN_CERT \
 --name mkcert \
 -v $(pwd):/root/.local/share/mkcert \
 shokohsc/mkcert
