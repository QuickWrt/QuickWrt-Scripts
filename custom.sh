#!/bin/bash -e

# 定义全局颜色
export RED_COLOR='\e[1;31m'
export GREEN_COLOR='\e[1;32m'
export YELLOW_COLOR='\e[1;33m'
export BLUE_COLOR='\e[1;34m'
export MAGENTA_COLOR='\e[1;35m'
export CYAN_COLOR='\e[1;36m'
export GOLD_COLOR='\e[1;33m'
export BOLD='\e[1m'
export RESET='\e[0m'

# 当前脚本版本号
version='v1.0.0 (2025.11.08)'

# 各变量默认值
export author="OPPEN321"
export blog="www.kejizero.online"
export mirror="https://github.com/QuickWrt/QuickWrt-Scripts"

# 打印横幅
show_banner() {
    clear
    echo -e ""
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}              iStoreOS 高级风格化系统${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e ""
    echo -e "${BOLD}${BLUE_COLOR}   ██████╗███████╗██████╗  ██████╗ ██╗    ██╗██████╗ ████████╗${RESET}"
    echo -e "${BOLD}${CYAN_COLOR}   ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗██║    ██║██╔══██╗╚══██╔══╝${RESET}"
    echo -e "${BOLD}${CYAN_COLOR}     ███╔╝ █████╗  ██████╔╝██║   ██║██║ █╗ ██║██████╔╝   ██║${RESET}"
    echo -e "${BOLD}${YELLOW_COLOR}    ███╔╝  ██╔══╝  ██╔══██╗██║   ██║██║███╗██║██╔══██╗   ██║${RESET}"
    echo -e "${BOLD}${YELLOW_COLOR}   ███████╗███████╗██║  ██║╚██████╔╝╚███╔███╔╝██║  ██║   ██║${RESET}"
    echo -e "${BOLD}${YELLOW_COLOR}   ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═╝   ╚═╝${RESET}"
    echo -e ""
    echo -e "${BOLD}${YELLOW_COLOR}         Open Source · Tailored · High Performance${RESET}"
    echo -e ""
    echo -e "${BOLD}${MAGENTA_COLOR}           🎨  主题定制 · 视觉美化 · 性能优化${RESET}"
    echo -e ""
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e "${CYAN_COLOR}🛠️  开发者: ${BOLD}${GOLD_COLOR}$author${RESET}"
    echo -e "${CYAN_COLOR}🌐  博客: ${BOLD}${GOLD_COLOR}$blog${RESET}"
    echo -e "${CYAN_COLOR}📦  版本: ${BOLD}${GOLD_COLOR}$version${RESET}"
    echo -e "${CYAN_COLOR}🎯  仓库: ${BOLD}${GOLD_COLOR}$mirror${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e "${CYAN_COLOR}🔧  开始时间: ${BOLD}${YELLOW_COLOR}$(date '+%Y-%m-%d %H:%M:%S')${RESET}"
    echo -e "${CYAN_COLOR}🏗️  系统架构: ${BOLD}${YELLOW_COLOR}$(uname -m)${RESET}"
    echo -e "${CYAN_COLOR}🐧  设备型号: ${BOLD}${YELLOW_COLOR}$(cat /tmp/sysinfo/board_name 2>/dev/null || echo "Unknown")${RESET}"
    echo -e "${CYAN_COLOR}💾  可用空间: ${BOLD}${YELLOW_COLOR}$(df -h / | awk 'NR==2 {print $4}')${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e ""
    echo -e "${BOLD}${MAGENTA_COLOR}🚀 正在启动 iStoreOS 视觉美化系统...${RESET}"
    echo -e ""
}

# 主函数
main() {
    show_banner
}

main "$@"
