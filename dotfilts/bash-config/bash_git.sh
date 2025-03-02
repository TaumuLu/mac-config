alias gbr='git branch -r --sort=-committerdate --format "%(creatordate:relative);%(committerdate:short);%(committername);%(refname:lstrip=-2)" | grep -v ";HEAD$" | column -s ";" -t'

alias gdr='git diff @{1}..'
alias gdc='git diff --cached'

alias gc1='git clone --depth=1'

alias gdl='f() { \
  git filter-branch --force --index-filter \
    "git rm --cached --ignore-unmatch $1" \
    --prune-empty --tag-name-filter cat -- --all
}; f'

grp() {
  local cmd='git remote prune origin'
  echo $cmd
  eval $cmd
}

gbp() {
  # # 获取所有本地分支
  # local_branches=$(git branch | sed 's/*//')

  # # 获取所有远程分支
  # remote_branches=$(git branch -r | sed 's/origin\///')

  # echo $local_branches
  # echo $remote_branches

  # # 遍历所有本地分支
  # for branch in $local_branches; do
  #   # 检查本地分支是否在远程分支列表中
  #   if ! echo "$remote_branches" | grep -q "$branch"; then
  #     # 删除本地分支
  #     # git branch -d "$branch"
  #   fi
  # done
}

parseGitUrl() {
  # 检查当前目录是否为 git 仓库
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    return 1
  fi

  # 检查是否有远程仓库配置
  local url=$(git remote get-url origin 2>/dev/null)
  if [ -z "$url" ]; then
    return 1
  fi

  local type=""
  local domain=""
  local firstPath=""

  if [[ $url == git* ]]; then
    # Handle SSH format (git@github.com:owner/repo.git)
    domain=${url#*@}           # Remove 'git@'
    firstPath=${domain#*:}     # Get everything after ':'
    firstPath=${firstPath%%/*} # Get first path component
    domain=${domain%:*}        # Remove everything after ':'
    type="ssh"
  elif [[ $url == http* ]]; then
    # Handle HTTPS format (https://github.com/owner/repo.git)
    domain=${url##*//}         # Remove 'http(s)://'
    firstPath=${domain#*/}     # Get everything after first '/'
    firstPath=${firstPath%%/*} # Get first path component
    domain=${domain%%/*}       # Remove everything after '/'
    type="http"
  fi

  echo "$type"
  echo "$domain"
  echo "$firstPath"
}

# 从配置文件中读取用户信息
userBashConfig="$CLOUD_CONFIG_DIR/Bash/.bash_config"
if [ -f $userBashConfig ]; then
  source $userBashConfig

  local ogit=$(which git)

  gcu() {
    result=($(parseGitUrl))
    local type=${result[1]}
    local domain=${result[2]}
    local firstPath=${result[3]}

    local user=""
    local email=""

    userInfo=${GIT_USER_MAP["$firstPath"]}
    if [[ -n $userInfo ]]; then
      IFS=' ' read -A list <<<$userInfo
      if [[ ${#list[@]} -eq 2 ]]; then
        user=${list[1]}
        email=${list[2]}
      else
        user=${firstPath}
        email=${GIT_USER_MAP["$user"]}
      fi
    elif [[ -n $domain ]]; then
      user=${GIT_DOMAIN_USER["$domain"]}
      email=${GIT_USER_MAP["$user"]}
    fi

    if [[ -n $user && -n $email ]]; then
      # eval "git cu $userInfo"
      # IFS=' ' read -A list <<< $userInfo
      git config --replace-all user.name "${user}"
      git config --replace-all user.email "${email}"
    fi

    echo -e -n "user: "
    printGreen $(git config user.name)
    echo -e -n "email: "
    printGreen $(git config user.email)
  }

  gitClone() {
    local folder=""
    for value in "$@"; do
      if [[ $value == git* || $value == http* ]]; then
        folder=${value##*/}
        folder=${folder%\.*}
      elif ! [[ $value == -* ]]; then
        folder=$value
      fi
    done

    $ogit clone "$@"
    local absPath=$(readlink -f $folder)

    if [[ -n $absPath ]]; then
      cd "$absPath"
      gcu
      cd ../
    fi
  }

  # 重写 git 命令
  function git {
    if [[ "$1" == "clone" && "$@" != *"--help"* ]]; then
      shift 1
      gitClone "$@"
    else
      command git "$@"
    fi
  }
fi
