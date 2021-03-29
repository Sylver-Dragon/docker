#! /bin/bash
export RunningContainer=$(docker container ls | grep -i valheimserver | awk '{ print $1 }')
docker container kill $RunningContainer
cd /docker/valheim/package
rm /docker/valheim/package/*
curl -OL http://media.steampowered.com/client/steam_cmd_linux
for f in $(cat steam_cmd_linux | grep zipvz | sed 's/\t/ /g' | sed 's/^ *//g' | sed 's/ \+/ /g' | cut -d ' ' -f 2 | sed 's/"//g'); do curl -OL http://media.steampowered.com/client/$f; done
cd /docker/valheim
docker image rm sylver-dragon/valheimserver:1.0
docker build -t sylver-dragon/valheimserver:1.0 .
docker run --rm -p 192.168.1.2:2456:2456/udp -p 192.168.1.2:2457:2457/udp -p 192.168.1.2:2458:2458/udp -v /docker/valheim/config:/home/steam/.config/ -e WorldName=MyWorld -e ServerPass=SekretSquirrel -e Public=0 sylver-dragon/valheimserver:1.0
