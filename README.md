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


## 🌟 开源项目赞助计划

### 用捐赠助力发展

感谢您使用本项目！您的支持是开源持续发展的核心动力。  
每一份捐赠都将直接用于：  
✅ 服务器与基础设施维护（魔法城堡的维修费哟~）  
✅ 新功能开发与版本迭代（魔法技能树要升级哒~）  
✅ 文档优化与社区建设（魔法图书馆要扩建呀~）

点滴支持皆能汇聚成海，让我们共同打造更强大的开源工具！  
（小仙子们在向你比心哟~）

---

### 🌐 全球捐赠通道

#### 国内用户

<div align="center" style="margin: 40px 0">

<div align="center">
<table>
<tr>
<td align="center" width="300">
<img src="https://github.com/ctkqiang/ctkqiang/blob/main/assets/IMG_9863.jpg?raw=true" width="200" />
<br />
<strong>🔵 支付宝</strong>（小企鹅在收金币哟~）
</td>
<td align="center" width="300">
<img src="https://github.com/ctkqiang/ctkqiang/blob/main/assets/IMG_9859.JPG?raw=true" width="200" />
<br />
<strong>🟢 微信支付</strong>（小绿龙在收金币哟~）
</td>
</tr>
</table>
</div>
</div>

#### 国际用户

<div align="center" style="margin: 40px 0">
  <a href="https://qr.alipay.com/fkx19369scgxdrkv8mxso92" target="_blank">
    <img src="https://img.shields.io/badge/Alipay-全球支付-00A1E9?style=flat-square&logo=alipay&logoColor=white&labelColor=008CD7">
  </a>
  
  <a href="https://ko-fi.com/F1F5VCZJU" target="_blank">
    <img src="https://img.shields.io/badge/Ko--fi-买杯咖啡-FF5E5B?style=flat-square&logo=ko-fi&logoColor=white">
  </a>
  
  <a href="https://www.paypal.com/paypalme/ctkqiang" target="_blank">
    <img src="https://img.shields.io/badge/PayPal-安全支付-00457C?style=flat-square&logo=paypal&logoColor=white">
  </a>
  
  <a href="https://donate.stripe.com/00gg2nefu6TK1LqeUY" target="_blank">
    <img src="https://img.shields.io/badge/Stripe-企业级支付-626CD9?style=flat-square&logo=stripe&logoColor=white">
  </a>
</div>

---

### 📌 开发者社交图谱

#### 技术交流

<div align="center" style="margin: 20px 0">
  <a href="https://github.com/ctkqiang" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-开源仓库-181717?style=for-the-badge&logo=github">
  </a>
  
  <a href="https://stackoverflow.com/users/10758321/%e9%92%9f%e6%99%ba%e5%bc%ba" target="_blank">
    <img src="https://img.shields.io/badge/Stack_Overflow-技术问答-F58025?style=for-the-badge&logo=stackoverflow">
  </a>
  
  <a href="https://www.linkedin.com/in/ctkqiang/" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-职业网络-0A66C2?style=for-the-badge&logo=linkedin">
  </a>
</div>

#### 社交互动

<div align="center" style="margin: 20px 0">
  <a href="https://www.instagram.com/ctkqiang" target="_blank">
    <img src="https://img.shields.io/badge/Instagram-生活瞬间-E4405F?style=for-the-badge&logo=instagram">
  </a>
  
  <a href="https://twitch.tv/ctkqiang" target="_blank">
    <img src="https://img.shields.io/badge/Twitch-技术直播-9146FF?style=for-the-badge&logo=twitch">
  </a>
  
  <a href="https://github.com/ctkqiang/ctkqiang/blob/main/assets/IMG_9245.JPG?raw=true" target="_blank">
    <img src="https://img.shields.io/badge/微信公众号-钟智强-07C160?style=for-the-badge&logo=wechat">
  </a>
</div>

---

🙌 感谢您成为开源社区的重要一员！  
💬 捐赠后欢迎通过社交平台与我联系，您的名字将出现在项目致谢列表！