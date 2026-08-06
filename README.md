# anisette-server

面向 Unraid 和 Docker 的自建 Anisette Server 封装。镜像在构建时拉取并编译 [Dadoum/anisette-v3-server](https://github.com/Dadoum/anisette-v3-server)，提供 SideStore 需要的 Anisette V3 接口，同时保留上游已有的 Anisette V1 兼容接口。

> 本仓库不是 SideStore 官方服务器列表仓库，也不是服务端协议的原创实现。SideStore 官方推荐服务器列表位于 [SideStore/anisette-servers](https://github.com/SideStore/anisette-servers)，它只是列表/模板仓库；实际服务端上游选用的是 [Dadoum/anisette-v3-server](https://github.com/Dadoum/anisette-v3-server)。

## 当前上游选择

- SideStore 官方 `anisette-servers` README 要求推荐服务器应为 Anisette V3，并推荐 `SideStore/omnisette-server` 或 `Dadoum/anisette-v3-server`。
- `SideStore/omnisette-server` 自身说明它基本已被 `Dadoum/anisette-v3-server` 取代。
- 因此本仓库选择 `Dadoum/anisette-v3-server` 作为上游基础。
- 当前锁定上游 commit：`2ef18d7da2abe3a6d070aa478f774538b947aaa2`。

## 快速启动

### Docker Compose

```bash
docker compose up -d
```

默认监听：

```text
http://<服务器IP>:6969
```

健康检查地址：

```text
http://<服务器IP>:6969/v3/client_info
```

### 直接运行镜像

```bash
docker run -d \
  --name anisette-server \
  --restart unless-stopped \
  -p 6969:6969 \
  -v anisette-data:/home/Alcoholic/.config/anisette-v3/lib/ \
  ghcr.io/yayk0/anisette-server:latest
```

## 持久化目录

容器内持久化路径：

```text
/home/Alcoholic/.config/anisette-v3/lib/
```

请务必挂载这个目录。删除它会让服务重新生成本地 Anisette/ADI 状态，可能导致客户端重新走登录或配置流程。

## SideStore 配置

1. 在 Unraid 或 Docker 主机上启动容器。
2. 确认手机能访问 `http://<服务器IP>:6969/v3/client_info`。
3. 在 SideStore 中把 Anisette Server URL 设置为：

```text
http://<服务器IP>:6969
```

如果通过公网使用，建议在反向代理上启用 HTTPS，然后填写：

```text
https://<你的域名>
```

更多说明见 [docs/sidestore.md](docs/sidestore.md)。

## AltStore 兼容性边界

本上游服务支持 Anisette V1 和 V3 协议，因此理论上可被部分 AltStore/AltServer-Linux 工作流使用。但 AltStore iOS 客户端和官方 AltServer 桌面端对自定义 Anisette Server 的支持会随版本变化，不保证所有 AltStore 场景都能直接填写并使用自建地址。

更多边界说明见 [docs/altstore.md](docs/altstore.md)。

## Unraid

Unraid Community Applications 模板位于：

```text
templates/unraid/anisette-server.xml
```

手动添加容器时使用这些关键参数：

- Repository: `ghcr.io/yayk0/anisette-server:latest`
- WebUI: `http://[IP]:[PORT:6969]/v3/client_info`
- Port: `6969/tcp`
- Path: `/home/Alcoholic/.config/anisette-v3/lib/` -> `/mnt/user/appdata/anisette-server/lib/`

## 构建

```bash
docker build \
  --build-arg UPSTREAM_REF=2ef18d7da2abe3a6d070aa478f774538b947aaa2 \
  -t anisette-server:local .
```

多架构镜像由 GitHub Actions 构建并发布到 GHCR：

- `linux/amd64`
- `linux/arm64`

PR 中只构建不推送；合入 `main` 或推送 tag 后发布。

## 已验证与仍需验证

已完成：

- SideStore 官方推荐源头核对。
- Dadoum 上游实现的 Docker 构建入口、端口、持久化目录和接口路径核对。
- Dockerfile、Compose、GitHub Actions、Unraid XML 静态检查。
- 本地 Docker 构建和容器健康检查尽量执行。

仍需真机验证：

- SideStore 在目标 iPhone/iPad 上登录、刷新和签名流程。
- 如果用于公网域名，HTTPS 反代、证书、运营商 NAT 和防火墙策略。
- AltStore/AltServer 具体版本是否允许并正确使用自定义 Anisette Server。

## 上游归属与许可证

本仓库维护 Docker/Unraid/GHCR 封装、文档和发布流程，采用 MIT License。

服务端源码归属 [Dadoum/anisette-v3-server](https://github.com/Dadoum/anisette-v3-server)。截至本仓库创建时，上游仓库未发现显式许可证文件；使用、分发或公开部署前请自行确认上游授权状态。详见 [docs/upstream.md](docs/upstream.md)。
