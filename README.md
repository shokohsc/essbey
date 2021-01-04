# OPENVPN

    $> export CIPHER="AES-256-CBC"
    $> export OPENVPN_URL="udp://VPN.SERVERNAME.COM:PORT"
    $> export DNS_IP_ADDRESS="PIHOLE_IP_IN_PIHOLE_DOCKER_NETWORK"
    $> docker-compose run --rm openvpn ovpn_genconfig \
        -u $OPENVPN_URL \
        -C $CIPHER \
        -n $DNS_IP_ADDRESS \
        -e 'push "redirect-gateway def1 bypass-dhcp"' \
        -e 'management 0.0.0.0 5555'
    $> docker-compose run --rm openvpn ovpn_initpki
    $> sudo chown -R $(whoami): ./config/openvpn
    $> docker-compose up -d openvpn

    $> export CLIENTNAME="your_client_name"
    $> docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
    $> docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

[link](https://github.com/kylemanna/docker-openvpn/issues/496) if cannot create client file

# Certificates

    $> cd config/traefik/certs
    $> DOMAIN_CERT=your_domain/s sh ../create-website-cert.sh
    $> docker rm -f mkcert

# Sftp

    $> echo -n "your-password" | docker run -i --rm atmoz/makepasswd --crypt-md5 --clearfrom=-

# Nginx server names issue

    Visit https://superuser.com/questions/1093419/alias-for-ips-in-the-home-lan-network
# Start

    $> docker-compose up -d

# Remove old elasticsearch indices
    $> docker run \
    --rm \
    -ti \
    -v "$(pwd)/config/curator/config.yml:/curator/config.yml" \
    -v "$(pwd)/config/curator/action.yml:/curator/action.yml" \
    --network "seedbox_hidden" \
    praseodym/elasticsearch-curator \
    --config \
    config.yml \
    action.yml

my ipv4 -> `dig +short TXT o-o.myaddr.l.google.com @ns3.google.com |sed 's/\"//g'`
what is registered at duckdns.org -> `dig +short mydomain.duckdns.org @1.1.1.1`
