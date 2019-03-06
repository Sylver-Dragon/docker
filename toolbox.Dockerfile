#build with:
#  docker build -t toolbox:latest <path> -f <path>\toolbox.dockerfile
FROM python:2.7.15-stretch

WORKDIR /work

# jupyter notebook server port
EXPOSE 8888/tcp

# Get DidierStevensSuite
RUN git clone https://github.com/DidierStevens/DidierStevensSuite.git suite
RUN python -m pip install olefile

# install nmap
RUN apt-get update && \
    apt-get install nmap -y

# install WhatWaf
RUN git clone https://github.com/Ekultek/WhatWaf.git whatwaf && \
    python -m pip install requests && \
    python -m pip install bs4

# install WES-NG
RUN git clone https://github.com/bitsadmin/wesng.git wesng && \
    cd /work/wesng && \
    /work/wesng/wes.py --update

# Install jupyter
RUN python -m pip install jupyter

# cleanup
RUN apt-get clean

# start jupyter notebook server
# start container with:
#   docker run -p 8888:8888 -v <path>\ext:/work/ext --rm toolbox
CMD jupyter notebook --no-browser --allow-root --ip=0.0.0.0
