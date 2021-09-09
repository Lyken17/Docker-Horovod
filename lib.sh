# /bin/bash
# build esentials 
apt-get update -y && apt upgrade -y
apt-get install -y zip, wget, git, vim, htop, tree, tmux, bash, zsh
apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        cmake \
        gcc \
        g++ \
        llvm \
        clang \
        llvm \
        git \
        curl \
        vim \
        wget \
        ca-certificates
