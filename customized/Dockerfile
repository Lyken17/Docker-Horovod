FROM nvidia/cuda:10.0-devel-ubuntu18.04

# TensorFlow version is tightly coupled to CUDA and cuDNN so it should be selected carefully
ENV TENSORFLOW_VERSION=1.14.0
ENV PYTORCH_VERSION=1.1.0
ENV TORCHVISION_VERSION=0.3.0
ENV CUDNN_VERSION=7.6.0.64-1+cuda10.0
ENV NCCL_VERSION=2.4.7-1+cuda10.0
ENV MXNET_VERSION=1.5.0

# Python 2.7 or 3.6 is supported by Ubuntu Bionic out of the box
ARG python=2.7
ENV PYTHON_VERSION=${python}

# Set default shell to /bin/bash
SHELL ["/bin/bash", "-cu"]

RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        cmake \
        g++-4.8 \
        git \
        curl \
        vim \
        wget \
        ca-certificates \
        libcudnn7=${CUDNN_VERSION} \
        libnccl2=${NCCL_VERSION} \
        libnccl-dev=${NCCL_VERSION} \
        libjpeg-dev \
        libpng-dev \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        librdmacm1 \
        libibverbs1 \
        ibverbs-providers


# Install Open MPI
RUN mkdir /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-4.0.0.tar.gz && \
    tar zxf openmpi-4.0.0.tar.gz && \
    cd openmpi-4.0.0 && \
    ./configure --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi

# Install miniconda 3
ENV MV=3
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda${MV}-latest-Linux-x86_64.sh && \
     chmod +x Miniconda${MV}-latest-Linux-x86_64.sh && \
     ./Miniconda${MV}-latest-Linux-x86_64.sh -b -p /opt/conda && \
     rm Miniconda${MV}-latest-Linux-x86_64.sh


RUN  ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
     echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

ENV  PATH="/opt/conda/bin:$PATH"
ENV  CMAKE_PREFIX_PATH="/opt/conda"
RUN  conda update -y conda
RUN  conda create -n py35 python=3.5

# RUN  ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
#      echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
RUN  echo "conda activate py35" >> ~/.bashrc

ENV  PATH="/opt/conda/envs/py35/bin:$PATH"
ENV  CMAKE_PREFIX_PATH="/opt/conda/envs/py35:$CMAKE_PREFIX_PATH"

RUN pip install --upgrade pip

# Install TensorFlow, Keras, PyTorch and MXNet
ENV TENSORFLOW_VERSION=1.12.0
ENV PYTORCH_VERSION=1.1.0
ENV TORCHVISION_VERSION=0.2.2.post3
ENV MXNET_VERSION=1.4.1

RUN pip install future typing
RUN pip install numpy \
        tensorflow-gpu==${TENSORFLOW_VERSION} \
        keras \
        h5py
RUN pip install https://download.pytorch.org/whl/cu100/torch-${PYTORCH_VERSION}-$(python -c "import wheel.pep425tags as w; print('-'.join(w.get_supported()[0]))").whl \
        https://download.pytorch.org/whl/cu100/torchvision-${TORCHVISION_VERSION}-$(python -c "import wheel.pep425tags as w; print('-'.join(w.get_supported()[0]))").whl
RUN pip install mxnet-cu100==${MXNET_VERSION}

# Install Horovod, temporarily using CUDA stubs
RUN ldconfig /usr/local/cuda/targets/x86_64-linux/lib/stubs && \
    HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITH_MXNET=1 \
         pip install --no-cache-dir horovod && \
    ldconfig

# Install OpenSSH for MPI to communicate between containers
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

# Download examples
RUN apt-get install -y --no-install-recommends subversion && \
    svn checkout https://github.com/horovod/horovod/trunk/examples && \
    rm -rf /examples/.svn

WORKDIR "/examples"

# install common packages
RUN pip install tensorboardX tqdm
RUN pip install --upgrade git+https://github.com/tensorpack/tensorpack.git
RUN apt install -y libzmq3-dev
# RUN pip install --upgrade git+https://github.com/tensorpack/zmq_ops.git
RUN git clone https://github.com/tensorpack/zmq_ops && \
	cd zmq_ops && \
	pip install .
