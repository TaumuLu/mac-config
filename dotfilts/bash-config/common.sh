# 定义颜色映射
declare -A colors

colors=(
    ["red"]='\033[0;31m'
    ["green"]='\033[0;32m'
    ["yellow"]='\033[1;33m'
    ["blue"]='\033[0;34m'
)

NC='\033[0m'

printColor() {
    local message=$1
    local colorName=$2
    echo -e "${colors[$colorName]}${message}${NC}"
}

printRed() {
    local message=$1
    printColor "$message" "red"
}

printGreen() {
    local message=$1
    printColor "$message" "green"
}

printYellow() {
    local message=$1
    printColor "$message" "yellow"
}

printBlue() {
    local message=$1
    printColor "$message" "blue"
}
