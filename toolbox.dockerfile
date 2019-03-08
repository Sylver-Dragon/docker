#build with:
#  docker build -t toolbox:latest <path> -f <path>\toolbox.dockerfile
# start container with:
#   docker run -p 127.0.0.1:8888:8888 -v <path>\ext:/work/ext --rm toolbox
FROM python:2.7.15-stretch

WORKDIR /work

# jupyter notebook server port
EXPOSE 8888/tcp

# Get DidierStevensSuite
RUN git clone https://github.com/DidierStevens/DidierStevensSuite.git suite && \
    chmod +x /work/suite/*.py
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

# Install CyberChef
RUN mkdir /work/cyberchef && \
    curl https://gchq.github.io/CyberChef/cyberchef.htm \
        -o /work/cyberchef/cyberchef.htm \
        -A "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:65.0) Gecko/20100101 Firefox/65.0" \
        -e "https://gchq.github.io/CyberChef/"

# Install jupyter
RUN python -m pip install jupyter

# cleanup
RUN apt-get clean

# start jupyter notebook server
CMD jupyter notebook --no-browser --allow-root --ip=0.0.0.0
