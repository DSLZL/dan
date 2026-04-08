#!/usr/bin/env bash
set -e

CONFIG_FILE="/app/dan-runtime/config/web_config.json"

# 如果环境变量存在且不为空，则使用 jq 更新配置文件
if [ -n "${PORT:-}" ]; then
    jq --argjson p "$PORT" '.port = $p' "$CONFIG_FILE" > tmp.json && mv tmp.json "$CONFIG_FILE"
fi
if [ -n "${THREADS:-}" ]; then
    jq --argjson t "$THREADS" '.manual_default_threads = $t' "$CONFIG_FILE" > tmp.json && mv tmp.json "$CONFIG_FILE"
fi
if [ -n "${WEB_TOKEN:-}" ]; then
    jq --arg wt "$WEB_TOKEN" '.web_token = $wt' "$CONFIG_FILE" > tmp.json && mv tmp.json "$CONFIG_FILE"
fi
if [ -n "${CLIENT_API_TOKEN:-}" ]; then
    jq --arg cat "$CLIENT_API_TOKEN" '.client_api_token = $cat' "$CONFIG_FILE" > tmp.json && mv tmp.json "$CONFIG_FILE"
fi
if [ -n "${CPA_BASE_URL:-}" ]; then
    jq --arg url "$CPA_BASE_URL" '.cpa_base_url = $url' "$CONFIG_FILE" > tmp.json && mv tmp.json "$CONFIG_FILE"
fi
if [ -n "${CPA_TOKEN:-}" ]; then
    jq --arg tk "$CPA_TOKEN" '.cpa_token = $tk' "$CONFIG_FILE" > tmp.json && mv tmp.json "$CONFIG_FILE"
fi
if [ -n "${MAIL_API_URL:-}" ]; then
    jq --arg url "$MAIL_API_URL" '.mail_api_url = $url' "$CONFIG_FILE" > tmp.json && mv tmp.json "$CONFIG_FILE"
fi
if [ -n "${MAIL_API_KEY:-}" ]; then
    jq --arg key "$MAIL_API_KEY" '.mail_api_key = $key' "$CONFIG_FILE" > tmp.json && mv tmp.json "$CONFIG_FILE"
fi
if [ -n "${DEFAULT_PROXY:-}" ]; then
    jq --arg pr "$DEFAULT_PROXY" '.default_proxy = $pr | .use_registration_proxy = true' "$CONFIG_FILE" > tmp.json && mv tmp.json "$CONFIG_FILE"
fi

echo "Configuration updated. Starting dan-web..."
# 切换到工作目录并前台启动二进制文件
# 注意：必须使用 exec，这样二进制进程才能替代 bash 成为 PID 1，接收 docker stop 的信号
cd /app/dan-runtime
exec ./dan-web
