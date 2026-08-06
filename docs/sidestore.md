# SideStore 配置说明

## 推荐地址格式

局域网内使用：

```text
http://<Unraid 或 Docker 主机 IP>:6969
```

公网或跨网络使用：

```text
https://<你的域名>
```

SideStore 的 Anisette Server URL 通常填写服务根地址，不需要额外添加 `/v3/client_info` 或 `/v3/get_headers`。

## 连通性检查

在手机浏览器或同一网络的电脑上打开：

```text
http://<服务器IP>:6969/v3/client_info
```

能看到 JSON 响应，说明服务端至少已经启动并能响应 Anisette V3 客户端信息接口。

## HTTPS 建议

SideStore 官方推荐 HTTPS，但不是强制要求。局域网自用可以先用 HTTP；如果要公网访问，建议使用 Nginx Proxy Manager、Caddy、Traefik 或其他反向代理提供 HTTPS。

反向代理时保持：

- 后端地址：`http://<容器主机IP>:6969`
- WebSocket/流式请求支持：建议开启
- 请求体大小：保持默认通常即可
- 不要额外改写 `/v3/*` 路径

## 常见问题

### SideStore 无法连接

先确认：

- 容器状态是 healthy。
- 手机和服务器在同一网络，或公网域名能从手机网络访问。
- Unraid 防火墙、路由器端口映射、反向代理规则没有拦截。
- SideStore 中填写的是根地址，例如 `http://192.168.1.10:6969`。

### 更换服务器后需要重新登录

这是正常现象。Anisette 状态和 Apple 登录/签名流程相关，更换服务端或删除持久化目录后，客户端可能需要重新登录或刷新配置。
