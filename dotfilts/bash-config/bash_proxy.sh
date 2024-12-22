onProxy() {
    local ssh_host=$1
    local port=${2:-6001}

    # 检查是否提供了必要参数
    if [ -z "$ssh_host" ]; then
        printRed "Usage: onProxy <ssh_host> [port]"
        return 1
    fi

    # 检查端口是否已经被占用并确认是 SOCKS 代理
    if lsof -i TCP:$port | grep -q "ssh"; then
        printYellow "SOCKS proxy on port $port is already running."

        export all_proxy="socks5://127.0.0.1:$port"
        return 0
    fi

    # 如果端口未被占用，则启动代理
    ssh -D "$port" -f -N "$ssh_host"

    if [ $? -eq 0 ]; then
        printGreen "SOCKS proxy started on port $port for host $ssh_host"
    else
        printRed "Failed to start SOCKS proxy for host $ssh_host"
        return 1
    fi

    # 设置 all_proxy 环境变量
    export all_proxy="socks5://127.0.0.1:$port"
}

offProxy() {
  # pkill -f "ssh -D"

  # 检查传入的端口号，默认使用 6001
  local port=${1:-6001}

  # 检查端口是否被占用
  local pid
  pid=$(lsof -i TCP:$port -s TCP:LISTEN -t)

  if [ -z "$pid" ]; then
      printRed "No SOCKS proxy running on port $port."
      return 0
  fi

  # 停止对应的进程
  kill "$pid"

  if [ $? -eq 0 ]; then
      printGreen "SOCKS proxy on port $port has been stopped."
      unset all_proxy
  else
      printRed "Failed to stop SOCKS proxy on port $port."
      return 1
  fi
}

onProxyInDir() {
    # 获取参数：文件夹、主机地址和端口号
    local target_dir=$1
    local ssh_host=$2
    local port=$3

    # 参数检查
    if [ -z "$target_dir" ] || [ -z "$ssh_host" ]; then
        printRed "Usage: onProxyInDir <target_dir> <ssh_host> <port>"
        return 1
    fi

    # 获取当前目录和目标目录的绝对路径
    local current_dir
    current_dir=$(realpath "$PWD")

    local target_abs_dir
    target_dir=$(eval echo "$target_dir")
    target_abs_dir=$(realpath "$target_dir")

    # 确保目标目录以 `/` 结尾，避免误判
    target_abs_dir="${target_abs_dir%/}/"

    # 判断当前目录是否是目标目录或其子目录
    if [[ "$current_dir/" == "$target_abs_dir"* ]]; then
        onProxy $ssh_host $port
        printGreen "onProxyInDir mark"
    fi
}
