FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu18.04

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    python3.7-dev python3-pip python3-wheel python3-setuptools \
    wget git g++ make cmake libblas3 libblas-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# NOTE: protobuf version is fixed because of deprecation warning in 3.7.0:
# https://github.com/protocolbuffers/protobuf/issues/5865
RUN python3.7 -m pip install \
    'cython>=0.28.0' 'ideep4py<2.1' \
    'pytest==4.1.1' 'pytest-xdist==1.26.1' mock setuptools typing \
    typing_extensions filelock 'numpy>=1.9.0' 'protobuf==3.6.1' 'six>=1.9.0'

RUN mkdir -p /tmp/xpytest && cd /tmp/xpytest && \
    wget 'https://github.com/imos/xpytest/releases/download/v0.1.3/xpytest-linux.gz' && \
    gunzip xpytest-linux.gz && \
    chmod +x xpytest-linux && \
    mv xpytest-linux /usr/local/bin/xpytest && \
    rm -rf /tmp/xpytest

COPY . /cupy
RUN cd /cupy && python3.7 -m pip install .
