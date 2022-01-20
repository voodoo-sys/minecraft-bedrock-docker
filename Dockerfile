FROM ubuntu:20.04

## dependecies
RUN apt-get update && apt-get install -y --no-install-recommends wget unzip apt-utils libcurl4-openssl-dev ca-certificates curl

## ipv4
EXPOSE 19132/udp

## ipv6
EXPOSE 19133/udp

## download and unpack latest bedrock server
ARG userAgentHeader="User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0"

RUN mkdir -p /srv/minecraft-bedrock && cd /srv/minecraft-bedrock && \
    wget --header="$userAgentHeader" $(curl -H "$userAgentHeader" 'https://www.minecraft.net/en-us/download/server/bedrock' | grep -o -e "https://minecraft.azureedge.net/bin-linux/bedrock-server-.\+.zip") && \
    unzip *.zip && rm -f *.zip && chmod +x bedrock_server

COPY entrypoint.sh /srv/minecraft-bedrock/entrypoint.sh
RUN chmod +x /srv/minecraft-bedrock/entrypoint.sh

VOLUME ["/srv/minecraft-bedrock/worlds"]

CMD ["/srv/minecraft-bedrock/entrypoint.sh"]
