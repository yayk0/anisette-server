# 上游归属说明

## SideStore 推荐源头

[SideStore/anisette-servers](https://github.com/SideStore/anisette-servers) 是 SideStore 官方推荐 Anisette Server 的列表和模板仓库，不是 Anisette 服务端源码。

该仓库 README 要求推荐服务器应为 Anisette V3，并推荐：

- [SideStore/omnisette-server](https://github.com/SideStore/omnisette-server)
- [Dadoum/anisette-v3-server](https://github.com/Dadoum/anisette-v3-server)

## 本仓库选择

本仓库选择 [Dadoum/anisette-v3-server](https://github.com/Dadoum/anisette-v3-server) 作为上游基础，原因：

- 上游 README 明确说明支持 SideStore 当前使用的 Anisette V1 和 V3 协议。
- `SideStore/omnisette-server` README 表示该实现基本已被 Dadoum 的实现取代。
- Dadoum 上游已有 Docker 运行约定，端口和持久化路径清晰。

当前锁定 commit：

```text
2ef18d7da2abe3a6d070aa478f774538b947aaa2
```

## 许可证边界

本仓库的 Dockerfile、Compose、GitHub Actions、Unraid 模板和文档采用 MIT License。

上游服务端源码归属其原作者。截至创建本封装时，`Dadoum/anisette-v3-server` 仓库未发现显式 LICENSE 文件。构建镜像会拉取并编译该上游源码，因此公开分发镜像前应确认上游授权状态和你自己的风险接受程度。

## 升级上游

升级时修改以下位置的 `UPSTREAM_REF`：

- `Dockerfile`
- `docker-compose.yml`
- `.github/workflows/container.yml`
- `README.md`
- `docs/upstream.md`

升级后至少验证：

- `docker build` 成功。
- 容器启动后健康检查通过。
- `/v3/client_info` 返回 JSON。
- SideStore 真机登录、刷新和签名流程。
