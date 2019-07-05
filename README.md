# OPENVPN

    $> export CIPHER="AES-256-CBC"
    $> docker-compose run --rm openvpn ovpn_genconfig -N -d -u udp://VPN.SERVERNAME.COM:PORT -2 -C $CIPHER -n <pihole_ip> -n 8.8.8.8 -n 1.1.1.1
    $> docker-compose run --rm openvpn ovpn_initpki
    $> sudo chown -R $(whoami): ./config/openvpn
    $> docker-compose up -d openvpn

    $> export CLIENTNAME="your_client_name"
    $> docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass

    $> docker-compose run --rm openvpn ovpn_otp_user $CLIENTNAME
    $> google-authenticator --time-based --disallow-reuse --force --rate-limit=3 --rate-time=30 --window-size=3 -l "${1}@${OVPN_CN}" -s /etc/openvpn/otp/${1}.google_authenticator

    $> docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

# Certificates

    $ make name=certs
    Country Name (2 letter code) [AU]: FR
    State or Province Name (full name) [Some-State]:
    Locality Name (eg, city) []:
    Organization Name (eg, company) [Internet Widgits Pty Ltd]:
    Organizational Unit Name (eg, section) []:
    Common Name (e.g. server FQDN or YOUR name) []: mydomain.com or ip
    Email Address []:
    Please enter the following 'extra' attributes to be sent with your certificate request
    A challenge password []:  !!NO PASSWORD!!
    An optional company name []:

# Sftp

    $> echo -n "your-password" | docker run -i --rm atmoz/makepasswd --crypt-md5 --clearfrom=-

# Nginx server names issue

    Visit https://superuser.com/questions/1093419/alias-for-ips-in-the-home-lan-network
# Start

    $> docker-compose up -d
