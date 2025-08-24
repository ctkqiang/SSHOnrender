# 使用 Ubuntu 基础镜像
FROM ubuntu:22.04

# 构建过程中避免交互式提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装 OpenSSH 服务端和 sudo
RUN apt-get update && \
    apt-get install -y openssh-server sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 创建 SSH 运行目录
RUN mkdir /var/run/sshd

# 创建一个用户（示例：用户名 "ling"，密码 "supersecret"）
RUN useradd -ms /bin/bash ling && \
    echo "root:ubuntu" | chpasswd && \
    adduser ling sudo

# （可选）允许使用密码登录
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# 暴露 SSH 端口
EXPOSE 22

# 前台运行 SSH 守护进程
CMD ["/usr/sbin/sshd", "-D"]
