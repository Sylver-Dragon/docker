#! /bin/bash
# Check for a new version of Valheim Server
export RunningContainer=$(docker container ls | grep -i valheimserver | awk '{ print $1 }')
export OfficialVersion=$(docker exec -it $RunningContainer /bin/bash -c "./steamcmd.sh +login anonymous +app_info_update 1 +app_info_print 896660 +quit | grep -A10 branches | grep -A2 public | grep buildid | cut -d'\"' -f4")
export RunningVersion=$(docker exec -it 7398d00b81a8 /bin/bash -c "grep buildid /home/steam/valheimserver/steamapps/appmanifest_896660.acf | cut -d'\"' -f4")
if [ "$OfficialVersion" !=  "$RunningVersion" ]
then
  /docker/valheim/updateImage.sh
fi
