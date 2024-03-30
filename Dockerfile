#!/bin/bash

# 使用最新版本的 Ubuntu 作为基础镜像
FROM ubuntu:20.04

# 设置作者信息
LABEL authors="xbdeng"

# 设置环境变量
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# 更新软件包并安装常用工具
RUN apt-get update && \
    apt-get install -y wget bzip2 ca-certificates curl git vim systemctl openssh-server openssh-client

# 更换 Ubuntu 软件源镜像
RUN sed -i "s@http://.*archive.ubuntu.com@https://mirrors.sustech.edu.cn@g" /etc/apt/sources.list && \
    sed -i "s@http://.*security.ubuntu.com@https://mirrors.sustech.edu.cn@g" /etc/apt/sources.list 

# 下载并安装 Miniconda
RUN mkdir -p ~/miniconda3 && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh && \
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 && \
    rm -rf ~/miniconda3/miniconda.sh

# 将 Miniconda 的 bin 目录添加到 PATH 环境变量中
ENV PATH /root/miniconda3/bin:$PATH

# 配置 Anaconda 和 pip 的镜像源为南方科技大学镜像
RUN ~/miniconda3/bin/conda config --add channels https://mirrors.sustech.edu.cn/anaconda/pkgs/free/ && \
    ~/miniconda3/bin/conda config --add channels https://mirrors.sustech.edu.cn/anaconda/pkgs/main/ && \
    ~/miniconda3/bin/conda config --set show_channel_urls yes && \
    ~/miniconda3/bin/pip install --upgrade pip --index-url https://mirrors.sustech.edu.cn/pypi/simple && \
    ~/miniconda3/bin/pip config set global.index-url https://mirrors.sustech.edu.cn/pypi/simple

# 在 SSH 配置文件中允许密码登录
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 开放端口
EXPOSE 22
 
# 创建一个空白的 authorized_keys 文件, 设置权限
RUN mkdir -p /root/.ssh && \
    touch /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

# 启动 SSH 服务
CMD ["/usr/sbin/sshd", "-D"]
