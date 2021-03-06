#build with:
#  docker build -t opennsfw <path> -f <path>\opennsfw.dockerfile
#Run with
#   docker run -v /log/fullpkt:/work/pcap -v /log/nsfw:/work/nsfw
# caffe:cpu is copied from https://raw.githubusercontent.com/BVLC/caffe/master/docker/cpu/Dockerfile
#  ---------- Start caffe:cpu ---------
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-pip \
        python-setuptools \
        python-scipy 

ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT

# FIXME: use ARG instead of ENV once DockerHub supports this
# https://github.com/docker/hub-feedback/issues/460
ENV CLONE_TAG=1.0

RUN git clone -b ${CLONE_TAG} --depth 1 https://github.com/BVLC/caffe.git . && \
    pip install --upgrade pip && \
    hash -r pip && \
    cd python && for req in $(cat requirements.txt) pydot; do pip install $req; done && cd .. && \
    mkdir build && cd build && \
    cmake -DCPU_ONLY=1 .. && \
    make -j"$(nproc)"

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

# ---------- End caffee:cpu -----------

WORKDIR /work

# image extaction setup
RUN apt-get install -y bro && \
    rm -rf /var/lib/apt/lists/*
COPY ./extract-all.bro /work/bro/extract-all.bro
RUN chmod +x /work/bro/extract-all.bro && \
    mkdir /work/images 
    
# Get model 
RUN git clone https://github.com/yahoo/open_nsfw.git opennsfw
COPY classify_nsfw.py /work/opennsfw/classify_nsfw.py
RUN chmod +x /work/opennsfw/*.py

# Copy run script
COPY run_classification.sh /work/

CMD /work/run_classification.sh