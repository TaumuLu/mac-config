# 检查代理状态
checkProxyStatus() {
  local port=$1
  if lsof -i TCP:"$port" -s TCP:LISTEN &>/dev/null; then
    return 0
  fi
  return 1
}

# 设置代理环境变量
# all_proxy: 小写版本，被大多数 Unix 工具和命令行应用程序使用
# ALL_PROXY: 大写版本，是一些特定应用程序的后备选项，当 all_proxy 未设置时会使用它
# 同时设置两者以确保最大兼容性
setProxyEnv() {
  local port=$1
  export all_proxy="socks5://127.0.0.1:$port" # 设置小写版本，常用于 curl, wget 等工具
  export http_proxy="http://127.0.0.1:$port"
  export https_proxy="http://127.0.0.1:$port"
  printGreen "Proxy environment variables set for port $port"
}

# 清除代理环境变量
unsetProxyEnv() {
  unset all_proxy
  unset http_proxy
  unset https_proxy
  printGreen "Proxy environment variables cleared"
}

onProxy() {
  local ssh_host=$1
  local port=$2
  local setProxy=$3

  # 参数验证
  if [ -z "$ssh_host" ] || [ -z "$port" ]; then
    printRed "Usage: onProxy <ssh_host> <port> [setProxy]"
    return 1
  fi

  # 检查端口是否已经被占用
  if checkProxyStatus "$port"; then
    printYellow "SOCKS proxy on port $port is already running"
    [ "$setProxy" = true ] && setProxyEnv "$port"
    return 0
  fi

  # 启动代理
  if ssh -D "$port" -f -N "$ssh_host" 2>/dev/null; then
    printGreen "SOCKS proxy started on port $port for host $ssh_host"
    [ "$setProxy" = true ] && setProxyEnv "$port"
  else
    printRed "Failed to start SOCKS proxy for host $ssh_host"
    return 1
  fi
}

offProxy() {
  local port=$1

  if [ -z "$port" ]; then
    printRed "Usage: offProxy <port>"
    return 1
  fi

  local pid

  # 获取进程ID
  pid=$(lsof -i TCP:"$port" -s TCP:LISTEN -t 2>/dev/null)

  if [ -z "$pid" ]; then
    printYellow "No SOCKS proxy running on port $port"
    return 0
  fi

  if kill "$pid" 2>/dev/null; then
    printGreen "SOCKS proxy on port $port has been stopped"
    unsetProxyEnv
  else
    printRed "Failed to stop SOCKS proxy on port $port"
    return 1
  fi
}

onProxyInDir() {
  local target_dir=$1
  local ssh_host=$2
  local port=$3

  # 参数验证
  if [ -z "$target_dir" ] || [ -z "$ssh_host" ] || [ -z "$port" ]; then
    printRed "Usage: onProxyInDir <target_dir> <ssh_host> <port>"
    return 1
  fi

  # 规范化路径
  local current_dir=$(realpath "$PWD")
  local target_abs_dir=$(realpath "$(eval echo "$target_dir")")

  # 路径匹配检查
  if [[ "${current_dir}/" == "${target_abs_dir%/}/"* ]]; then
    onProxy "$ssh_host" "$port"
    printGreen "Proxy enabled in directory: $target_abs_dir"
  fi
}

# 显示代理状态
showProxyStatus() {
  if [ -n "$all_proxy" ] || [ -n "$ALL_PROXY" ]; then
    printGreen "Current proxy settings:"
    [ -n "$all_proxy" ] && echo "all_proxy=$all_proxy"
    [ -n "$ALL_PROXY" ] && echo "ALL_PROXY=$ALL_PROXY"
  else
    printYellow "No proxy environment variables set"
  fi
}
