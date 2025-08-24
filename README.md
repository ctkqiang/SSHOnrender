# 使用 Ubuntu + OpenSSH 的 Docker 镜像

这个仓库包含一个 `Dockerfile`，用于构建一个基于 **Ubuntu 22.04** 的镜像，并在其中启用 **OpenSSH** 服务，以便你可以通过 SSH 登录到容器中。

---

## 功能特点

* 基于 `ubuntu:22.04`
* 自动安装并配置 **OpenSSH Server**
* 创建用户 `root`（默认密码：`password`）
* 开放 SSH 端口 **22**，支持密码登录
* 支持在本地使用 SSH 直接连接

---

## 使用步骤

### 1. 克隆仓库

```bash
git clone https://github.com/ctkqiang/SSHOnrender.git
cd <your-repo-name>
```

### 2. 构建镜像

```bash
docker build -t ubuntu-ssh .
```

### 3. 启动容器

```bash
docker run -d -p 2222:22 ubuntu-ssh
```

* 这里把容器的 22 端口映射到本机的 2222 端口。

### 4. 使用 SSH 连接

```bash
ssh -p 2222 root@localhost
```

输入密码：

```
password
```

登录成功后，你就进入了容器内的 Ubuntu 系统，可以像远程服务器一样使用。

---

## 常见问题

### ❓如何修改用户名或密码？

在 `Dockerfile` 中找到以下部分：

```dockerfile
RUN useradd -ms /bin/bash root && \
    echo "root:password" | chpasswd && \
    adduser root sudo
```

修改 `root` 和 `password` 为你自己的用户名和密码。

### ❓如何使用 SSH 公钥登录而不是密码？

1. 在本机生成密钥（如果还没有）：

   ```bash
   ssh-keygen -t rsa -b 4096
   ```

   公钥通常存放在 `~/.ssh/id_rsa.pub`

2. 修改 `Dockerfile`，在构建时把公钥写入容器内：

   ```dockerfile
   RUN mkdir -p /home/root/.ssh && \
       echo "<你的公钥内容>" > /home/root/.ssh/authorized_keys && \
       chown -R root:root /home/root/.ssh && \
       chmod 600 /home/root/.ssh/authorized_keys
   ```

3. 重新构建镜像并运行，之后即可使用免密登录：

   ```bash
   ssh -p 2222 root@localhost
   ```

---

## 部署到 Render（可选）

如果你希望把它跑在 Render 上：

1. 新建一个 Web Service，选择 **Docker** 部署方式。
2. 确保 `Dockerfile` 在仓库根目录。
3. Render 默认使用 HTTP，你需要映射一个端口（如 10022）来暴露 SSH。
4. 连接方式：

   ```bash
   ssh -p 10022 root@<your-service>.onrender.com
   ```

---

## ⚠️ 安全提示

* 不要在生产环境中使用弱密码（如 `password`）。
* 推荐使用 **SSH 公钥认证** 替代密码。
* 如果部署到公网，务必配置防火墙或安全组限制访问。
