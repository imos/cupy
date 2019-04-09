FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    python-dev python-pip python-wheel python-setuptools \
    python3-dev python3-pip python3-wheel python3-setuptools \
    wget git g++ make cmake libblas3 libblas-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN pip3 install \
    'cython>=0.28.0' 'ideep4py<2.1' 'pytest==4.1.1' 'pytest-xdist==1.26.1' \
    mock setuptools typing \
    typing_extensions filelock numpy>=1.9.0 protobuf>=3.0.0 six>=1.9.0

RUN pip install \
    'cython>=0.28.0' 'ideep4py<2.1' 'pytest==4.1.1' 'pytest-xdist==1.26.1' \
    mock setuptools typing \
    typing_extensions filelock numpy>=1.9.0 protobuf>=3.0.0 six>=1.9.0

# Newer versions of more-itertools no longer support python2.
RUN pip install 'more-itertools<=5.0.0'

RUN mkdir -p /tmp/xpytest && cd /tmp/xpytest && \
    wget 'https://github.com/imos/xpytest/releases/download/v0.1.3/xpytest-linux.gz' && \
    gunzip xpytest-linux.gz && \
    chmod +x xpytest-linux && \
    mv xpytest-linux /usr/local/bin/xpytest && \
    rm -rf /tmp/xpytest

RUN git clone https://github.com/cupy/cupy.git /tmp/cupy && \
    cd /tmp/cupy && \
    python3 -m pip install . && \
    python -m pip install . && \
    rm -rf /tmp/cupy
