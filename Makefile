# Make all
all: init generate dump copy clean

# 1 Create directory
init:
	mkdir certs

# 2 Generate certificate and private key
generate:
	openssl req -x509 -newkey rsa:2048 -keyout certs/key.pem -out certs/cert.pem -days 365 -nodes
	openssl rsa -in certs/key.pem -out certs/key.pem

# 5 Dump
dump:
	openssl x509 -in certs/cert.pem -text -noout
	openssl x509 -in certs/cert.pem -purpose

# 6 Copy
copy:
	cp -R certs config/nginx

# 7 Clean
clean:
	rm -rf ./certs
