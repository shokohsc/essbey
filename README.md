# OPENVPN

    $> export CIPHER="AES-256-CBC"
    $> docker-compose run --rm openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM:PORT -2 -C $CIPHER -n <pihole_ip> -n 8.8.8.8 -n 1.1.1.1 -e 'management 0.0.0.0 5555' -e 'push "redirect-gateway def1 bypass-dhcp"'
    $> docker-compose run --rm openvpn ovpn_initpki
    $> sudo chown -R $(whoami): ./config/openvpn
    $> docker-compose up -d openvpn

    $> export CLIENTNAME="your_client_name"
    $> docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass

    $> docker-compose run --rm openvpn ovpn_otp_user $CLIENTNAME

    $> docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

# Certificates

    $ DOMAIN_CERT=you_domain sh config/traefik/create-website-cert.sh

# Sftp

    $> echo -n "your-password" | docker run -i --rm atmoz/makepasswd --crypt-md5 --clearfrom=-

# Nginx server names issue

    Visit https://superuser.com/questions/1093419/alias-for-ips-in-the-home-lan-network
# Start

    $> docker-compose up -d
