# ------------ Base image file
FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

# ------------ Environment settings
ENV LIBRARY_PATH=/usr/local/cuda/lib64/stubs
ENV DISPLAY=host.docker.internal:0.0
ENV PULSE_SERVER=tcp:host.docker.internal:4713
ENV DEBIAN_FRONTEND=noninteractive

# ------------ Set timezone
RUN apt-get update && \
    apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# ------------ Set working directory
WORKDIR /root

# ------------ Add ROS 2 repository
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    apt-get update && apt-get install -y curl && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# ------------ Build environment on Ubuntu
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    python3 \
    python3-pip \
    x11-apps \
    git \
    python3-tk \
    libopenmpi-dev \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup && \
    rm -rf /var/lib/apt/lists/*

# ------------ Install PyTorch
RUN pip3 install --no-cache-dir torch torchvision

# ------------ ROS2 setup
COPY setup.sh /root/
RUN chmod +x /root/setup.sh && \
    /root/setup.sh

# ------------ LLM setup
RUN pip3 install --no-cache-dir \
    wandb \
    datasets \
    tqdm \
    tiktoken \
    transformers \
    deepspeed \
    openai \
    PyYAML \
    accelerate \
    einops \
    evaluate \
    peft \
    protobuf \
    scikit-learn \
    scipy \
    sentencepiece \
    fire \
    mpi4py \
    bs4 \
    zenhan \
    mecab-python3 \
    pyknp \
    langchain \
    sentence_transformers \
    faiss-gpu \
    python-dotenv

# ------------ Jupyter setup
RUN pip3 install --no-cache-dir \
    ipykernel \
    jupyter \
    jupyterlab

# ------------ CLIP GradCAM Colab setup
RUN pip3 install --no-cache-dir \
    ftfy \
    regex \
    matplotlib \
    opencv-python \
    scikit-image && \
    pip3 install --no-cache-dir git+https://github.com/openai/CLIP.git && \
    pip3 install --no-cache-dir gradio

# ------------ Additional Python packages
RUN pip3 install --no-cache-dir \
    tqdm \
    scipy

# ------------ Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ------------ Verify mpi4py installation
RUN python3 -c "from mpi4py import MPI; print('mpi4py is installed successfully')"
