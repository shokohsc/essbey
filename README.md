#OPENVPN

    $> docker-compose run --rm openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM:PORT -n <pihole_ip> -n 185.187.240.11 -n 8.8.8.8
    $> docker-compose run --rm openvpn ovpn_initpki

    $> sudo chown -R $(whoami): ./config/openvpn

    $> docker-compose up -d openvpn

    $> export CLIENTNAME="your_client_name"
    $> docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
    $> docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

#Certificates

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

# Start

    $> docker-compose up -d
