# Latest Bedrock server can be found at:
# https://www.minecraft.net/en-us/download/server/bedrock

# Run service (already created) with:
# docker service update --replicas=0 minecraft_minecraft

FROM ubuntu:latest

WORKDIR /home

RUN apt-get update && \
    apt-get install -y wget zip

RUN wget -O bedrock-server.zip https://minecraft.azureedge.net/bin-linux/bedrock-server-1.17.10.04.zip && \
    unzip bedrock-server.zip && \
    chmod +x ./bedrock_server

EXPOSE 19132/udp

CMD LD_LIBRARY_PATH=. ./bedrock_server
