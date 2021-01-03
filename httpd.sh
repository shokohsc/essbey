#!/bin/sh

PORT=${1:-8080}
NS=$(netstat -taupen 2>/dev/null | grep ":$PORT ")
test -n "$NS" && echo "Port $PORT is already taken" && exit 1
set -e

for IP in $(ifconfig | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1) ; do
    echo -e "Listening at $IP:$PORT"
done

echo -e "\n"
FIFO="/tmp/httpd$PORT"
rm -f $FIFO
mkfifo $FIFO
trap ctrl_c INT

function ctrl_c() {
    rm -f $FIFO && echo -e "\nServer shut down.\n" && exit
}

while true; do (
  read line < $FIFO;
  line=$(echo "$line" | tr -d '[\r\n]')
  >&2 echo $line
  if echo "$line" | grep -qE '^GET /' # if line starts with "GET /"
  then
    export REQUEST=""
    REQUEST=$(echo "$line" | cut -d ' ' -f2) # extract the request
    HTTP_200="HTTP/1.1 200 OK"
    HTTP_404="HTTP/1.1 404 Not Found"
    HTTP_DATE="Date: $(LC_TIME=en_US date -u)"
    HTTP_LOCATION="Location:"
    HTTP_CONTENT_TYPE="Content-Type: text/plain"
    HTTP_CONNECTION="Connection: close"
    HTTP_CONTENT_LENGTH="Content-Length:"
    HTTP_CACHE_CONTROL="Cache-Control: max-age=300, public"
    HTTP_SERVER="Server: netcat-openbsd-1.130-r1"
    # call a script here
    # Note: REQUEST is exported, so the script can parse it (to answer 200/403/404 status code + content)
    if echo $REQUEST | grep -qE '^/ovpn/'; then
        ovpn_param=${REQUEST#"/ovpn/"};
        if test -f "/app/${ovpn_param}.ovpn"; then
          ovpn_profile=$(cat /app/${ovpn_param}.ovpn | sed 's/remote\ .*/&\n&\%/' | sed 's/\ udp\%$/\ tcp/' | sed 's/\ tcp\%$/\ udp/');
          printf "%s\n%s %s\n%s\n%s %s\n%s\n%s\n%s\n%s\n\n" \
            "$HTTP_200" \
            "$HTTP_LOCATION" \
            $REQUEST \
            "$HTTP_CONTENT_TYPE" \
            "$HTTP_CONTENT_LENGTH" \
            $(echo "${ovpn_profile}" | wc -m) \
            "$HTTP_CACHE_CONTROL" \
            "$HTTP_CONNECTION" \
            "$HTTP_DATE" \
            "$HTTP_SERVER"
          echo "${ovpn_profile}"
        else
          printf "%s\n%s %s\n%s\n%s\n%s\n%s\n%s\n\n" \
            "$HTTP_404" \
            "$HTTP_LOCATION" \
            $REQUEST \
            "$HTTP_CONTENT_TYPE" \
            "$HTTP_CACHE_CONTROL" \
            "$HTTP_CONNECTION" \
            "$HTTP_DATE" \
            "$HTTP_SERVER"
          echo "Profile $ovpn_param not found!"
        fi
    # elif echo $REQUEST | grep -qE '^/date'; then
    #     date
    # elif echo $REQUEST | grep -qE '^/net'; then
    #     ifconfig
    else
        printf "%s\n%s %s\n%s\n%s\n%s\n%s\n%s\n\n" \
          "$HTTP_404" \
          "$HTTP_LOCATION" \
          $REQUEST \
          "$HTTP_CONTENT_TYPE" \
          "$HTTP_CACHE_CONTROL" \
          "$HTTP_CONNECTION" \
          "$HTTP_DATE" \
          "$HTTP_SERVER"
        echo "Resource $REQUEST not found!"
    fi
  fi
) | nc -lkp $PORT > $FIFO; done;
