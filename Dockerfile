#!/bin/bash

# 使用最新版本的 Ubuntu 作为基础镜像
FROM ubuntu:latest

# 设置作者信息
LABEL authors="xbdeng"

# 设置环境变量
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# 更换 Ubuntu 软件源镜像
RUN sed -i "s@http://.*archive.ubuntu.com@https://mirrors.sustech.edu.cn@g" /etc/apt/sources.list && \
    sed -i "s@http://.*security.ubuntu.com@https://mirrors.sustech.edu.cn@g" /etc/apt/sources.list


# 更新软件包并安装常用工具
RUN apt-get -qq update --fix-missing && \
    apt-get -qq install -y wget bzip2 ca-certificates curl git vim && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/*

# 下载并安装 Miniconda
RUN mkdir -p ~/miniconda3 && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh && \
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 && \
    rm -rf ~/miniconda3/miniconda.sh

# 将 Miniconda 的 bin 目录添加到 PATH 环境变量中
ENV PATH ~/miniconda3/bin:$PATH

# 配置 Anaconda 和 pip 的镜像源为南方科技大学镜像
RUN ~/miniconda3/bin/conda config --add channels https://mirrors.sustech.edu.cn/anaconda/pkgs/free/ && \
    ~/miniconda3/bin/conda config --add channels https://mirrors.sustech.edu.cn/anaconda/pkgs/main/ && \
    ~/miniconda3/bin/conda config --set show_channel_urls yes && \
    ~/miniconda3/bin/pip install --upgrade pip --index-url https://mirrors.sustech.edu.cn/pypi/simple && \
    ~/miniconda3/bin/pip config set global.index-url https://mirrors.sustech.edu.cn/pypi/simple

# 创建一个空白的 authorized_keys 文件
RUN touch /root/.ssh/authorized_keys

# 设置权限
RUN chmod 600 /root/.ssh/authorized_keys

# 设置容器启动时的默认命令为 top -b
CMD ["top", "-b"]
