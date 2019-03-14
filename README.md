# Docker
A repository for useful Docker files.

## toolbox
Contains:
  * Dider Steven's suite (https://blog.didierstevens.com/didier-stevens-suite/)
  * nmap
  * WhatWaf (https://github.com/Ekultek/WhatWaf)
  * WES-NG (https://github.com/bitsadmin/wesng)
  * CyberChef (https://gchq.github.io/CyberChef/)
  
Build with:
  * `docker build -t toolbox:latest d:\docker\toolbox -f d:\docker\toolbox\toolbox.dockerfile`
  
Run with:
  * `docker run -p 127.0.0.1:8888:8888 -v d:\docker\toolbox\ext:/work/ext --rm toolbox`
  
Notes:
  * When run with the volume (`-v`) switch, this binds the container path `/work/ext` to `d:\docker\toolbox\ext`, change the host path as needed.  This allows for saving any files out to the host filesystem by placing them in the "ext" folder.  This is useful for persistance of Jupyter Notebooks, results files, or anything which should survive the reinitialization of the container.  
  * The container exposes a Jupter Notebook Server on port 8888 to the localhost address.  After the container is initialized, it can be accessed with a web browser on `http://127.0.0.1:8888?token=<token>`.  Console output from the `docker run` command will provide the `<token>` needed to access this server.

## opennsfw
This is a dockerfile and supporting files to create a container which will extract all images from a pcap dump and then run those images through a pre-trained Machine Learning system based on the Caffe machine learning framework to identify images which may be inappropriate for a workplace network.  The pre-trained model is from the Yahoo Open_NSFW project (https://github.com/yahoo/open_nsfw), as is much of the dockerfile configuration.  The accompaning scripts are imported into the image the docker build process and are not needed after the build is complete.  
While running, the container assumes a specific pcap naming convention.  Pcap files should be named `fullpkt_yyyyMMddhh.gz` and should be gziped pcap files.  This is set in the `run_classification.sh` script and is based on hourly pcap files and assumes that the previous hour's pcap is to be analyzed.  Pcap files should be in a folder which is bound to the `/work/pcap` folder in the `docker run` command.  
While running, the container expects a folder on the host to be bound to `/work/nsfw`, this is set in the `docker run` command.  Additionally, the host folder must contain two subfolders named `high` and `medium` where images which are classified as having a "high" and "medium" score will be placed respectively.  These locations and the thresholds for "high" and "medium" are in the `classify_nsfw.py` script.  

Build With:
  * `docker build -t opennsfw d:\docker\opennsfw -f d:\docker\opennsfw\opennsfw.dockerfile`
  
 Run with:
   * `docker run -v d:\log\fullpkt:/work/pcap -v d:\log\nsfw:/work/nsfw`
