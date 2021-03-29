# This docker container will run a dedicated Valheim game server.
#
# Dedicated steamcmd docker image from valve:
# https://developer.valvesoftware.com/wiki/SteamCMD#Docker
FROM cm2network/steamcmd:latest

USER steam

WORKDIR /home/steam/steamcmd

# Required ports.  Make sure to enable these when running the container.
EXPOSE 2456/udp
EXPOSE 2457/udp
EXPOSE 2458/udp

# Required server information.  These MUST be set.
# ServerName - (Required) Public server name, may contain spaces may NOT contain special characters
ENV ServerName="ValheimServer"
# WorldName - (Required) Name for the game world.  Must be more than 4 characters, may not contain spaces or special characters.
ENV WorldName="Valheim"
# ServerPass - (Required) Password for users accessing the server.
ENV ServerPass="ValheimPass"
# Public option - (Required) Set server public
ENV Public=0

# Update Steam Manually
COPY --chown=steam:steam ./package/* /home/steam/steamcmd/package/

# Download Valheim server from Steam
RUN /home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/valheimserver +app_update 896660 validate +quit

CMD export SteamAppId=892970 && /home/steam/valheimserver/valheim_server.x86_64 -name "${ServerName}" -port "2456" -nographics -batchmode -world "${WorldName}" -password "${ServerPass}" -public ${Public}
