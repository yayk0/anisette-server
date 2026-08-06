# AltStore 兼容性边界

本项目优先目标是 SideStore。

上游 `Dadoum/anisette-v3-server` README 说明它支持 SideStore 当前使用的 Anisette V1 和 Anisette V3 协议，也可用于 AltServer-Linux。这意味着服务端接口层面具备一定 AltStore/AltServer-Linux 兼容基础。

但需要注意：

- AltStore iOS 客户端不一定暴露自定义 Anisette Server 设置。
- 官方 AltServer 桌面端的 Anisette 获取逻辑可能随版本变化。
- AltServer-Linux、第三方脚本或自动化工作流对自定义 Anisette 地址的支持方式各不相同。
- 即使 `/` 或 `/v3/client_info` 能响应，也不等于完整登录、刷新、签名流程已经通过。

建议验证顺序：

1. 确认容器健康检查通过。
2. 用浏览器访问 `http://<服务器IP>:6969/v3/client_info`。
3. 如果工具使用 Anisette V1，访问 `http://<服务器IP>:6969/` 检查是否返回 Anisette header JSON。
4. 在目标 AltStore/AltServer-Linux 工具中配置自定义地址。
5. 用真实 Apple ID 登录、刷新 App、重签 App 做完整验证。

PR 和 README 中只声称接口基础兼容，不声称所有 AltStore 官方客户端版本都开箱即用。
