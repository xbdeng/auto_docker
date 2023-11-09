#!/bin/bash

FROM ubuntu:latest
LABEL authors="xbdeng"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN apt-get -qq update --fix-missing && \
    apt-get -qq install -y wget bzip2 ca-certificates curl git && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/*


RUN mkdir -p ~/miniconda3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
RUN bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
RUN rm -rf ~/miniconda3/miniconda.sh

ENV PATH ~/miniconda3/bin:$PATH

RUN ~/miniconda3/bin/conda config --add channels https://mirrors.sustech.edu.cn/anaconda/pkgs/free/ && \
    ~/miniconda3/bin/conda config --add channels https://mirrors.sustech.edu.cn/anaconda/pkgs/main/ && \
    ~/miniconda3/bin/conda config --set show_channel_urls yes && \
    ~/miniconda3/bin/pip install --upgrade pip --index-url https://mirrors.sustech.edu.cn/pypi/simple && \
    ~/miniconda3/bin/pip config set global.index-url https://mirrors.sustech.edu.cn/pypi/simple


ENTRYPOINT ["top", "-b"]
