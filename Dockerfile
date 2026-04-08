FROM debian:bookworm-slim

# 安装依赖：curl用于构建时下载，jq用于运行时动态修改JSON
RUN apt-get update && apt-get install -y curl jq ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 将你的脚本拷贝进来
COPY install.sh .
RUN chmod +x install.sh

# 【构建阶段】执行脚本，仅下载二进制文件和生成默认配置
# 不要加 --systemd 和 --background
RUN ./install.sh --install-dir /app/dan-runtime

# 拷贝我们的启动脚本
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 暴露端口
EXPOSE 25666

# 设置入口
ENTRYPOINT ["/app/entrypoint.sh"]
