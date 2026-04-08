# 固定基础镜像版本，是 Docker 官方推荐的做法【turn5fetch0】
FROM debian:bookworm-slim

# 安装依赖：构建时用 curl；运行时用 jq 来改 JSON 配置
RUN apt-get update && apt-get install -y curl jq ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 这里把远程 install.sh 下载到本地并执行，完成构建阶段（下载 dan-web、生成默认配置）
ARG INSTALL_SH_URL=https://raw.githubusercontent.com/uton88/dan-binary-releases/refs/heads/main/install.sh

RUN set -eux; \
    curl -fsSL "${INSTALL_SH_URL}" -o install.sh && \
    chmod +x install.sh && \
    ./install.sh --install-dir /app/dan-runtime

# 拷贝启动脚本（entrypoint.sh）
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 25666

ENTRYPOINT ["/app/entrypoint.sh"]
