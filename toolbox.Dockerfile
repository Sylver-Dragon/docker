# Didier Stevens's python tools are based on Python 2
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

# Install jupyter
RUN python -m pip install jupyter

# start jupyter notebook server
# start container with:
#   docker run -p 8888:8888 --rm my/toolbox
CMD jupyter notebook --no-browser --allow-root --ip=0.0.0.0
