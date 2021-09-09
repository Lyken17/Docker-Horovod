# /bin/bash 

ver=4.1
version=4.1.1

# apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
#         build-essential \
#         cmake \
#         g++-4.8 \
#         git \
#         curl \
#         vim \
#         wget \
#         ca-certificates \
#         ibverbs-providers
        

# compile and install 
mkdir /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://www.open-mpi.org/software/ompi/v$ver/downloads/openmpi-$version.tar.gz && \
    tar zxf openmpi-$version.tar.gz && \
    cd openmpi-$version && \
    ./configure --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi
