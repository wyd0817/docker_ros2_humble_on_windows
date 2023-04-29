# ------------ ベースイメージファイル
FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

# Add user so we don't need --no-sandbox. 
# RUN addgroup -S chrome \
#     && adduser -S -G chrome chrome \
#     && mkdir -p /home/chrome/Downloads \
#     && { \
#     echo "pcm.default pulse"; \
#     echo "ctl.default pulse"; \
#     } | tee /home/chrome/.asoundrc \
#     && chown -R chrome:chrome /home/chrome
    
# ------------ 環境設定
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV DISPLAY host.docker.internal:0.0
ENV PULSE_SERVER=tcp:host.docker.internal:4713
ENV DEBIAN_FRONTEND=noninteractive

# ------------ タイムゾーンの設定
RUN apt-get update && apt-get install -y tzdata
ENV TZ=Asia/Tokyo 

# ------------ ワークディレクトリの設定
WORKDIR /root

# ------------ Ubuntu上での環境構築
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python3 python3-pip

# windows上でx-serverに接続するために必要なx11-appsのインストール
RUN apt-get install x11-apps -y

# gitのインストール（20.04以降はデフォルトでインストールされていない）
RUN apt-get install git -y

# matplotlibなどでの描画GUIに必要
RUN apt-get install python3-tk -y

# PyTorchのためのライブラリをインストール
RUN pip3 install torch torchvision

# ------------ ROS2のセットアップ
COPY setup.sh /root/
RUN bash ~/setup.sh

# ------------ LLMのセットアップ
RUN pip install wandb datasets tqdm tiktoken transformers deepspeed openai PyYAML accelerate datasets einops evaluate peft protobuf scikit-learn scipy sentencepiece fire mpi4py
RUN pip install bs4 zenhan mecab-python3 pyknp
RUN pip install langchain sentence_transformers faiss-gpu python-dotenv

# ------------ Jupyterのセットアップ
RUN pip install ipykernel jupyter jupyterlab
