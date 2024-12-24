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

getDomain() {
    local url=`git remote get-url origin`
    local domain=""

    if [[ $url == git* ]]; then
        # Handle SSH format
        domain=${url#*@}        # Remove 'git@'
        domain=${domain%:*}     # Remove everything after ':'
    elif [[ $url == http* ]]; then
        # Handle HTTPS format
        domain=${url##*//}      # Remove 'http(s)://'
        domain=${domain%%/*}    # Remove everything after '/'
    fi

    echo "$domain"
}

# 引入用户自定义配置变量，防止泄露信息
# git 账号信息格式为
# ```
# declare -A GIT_DOMAIN_USER
# GIT_DOMAIN_USER["domain"]="user email"
# GIT_DOMAIN_USER["github.com"]="TaumuLu 972409545@qq.com"
# ```
userBashConfig="$CLOUD_CONFIG_DIR/Bash/.bash_config"
if [ -f $userBashConfig ]; then
  source $userBashConfig

  local ogit=`which git`

  gcu() {
    local domain=`getDomain`

    local userInfo=""
    if [[ -n $domain ]]; then
      userInfo=${GIT_DOMAIN_USER["$domain"]}
    fi

    if [[ -n $userInfo ]]; then
      # eval "git cu $userInfo"
      IFS=' ' read -A list <<< $userInfo
      git config --replace-all user.name "${list[1]}"
      git config --replace-all user.email "${list[2]}"
    fi

    echo -e -n "user: "
    printGreen `git config user.name`
    echo -e -n "email: "
    printGreen `git config user.email`
  }

  local gitClone() {
    local folder=""
    for value in "$@"
    do
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
