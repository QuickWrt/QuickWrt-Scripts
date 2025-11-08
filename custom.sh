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
export arch=$(echo "$(. /etc/openwrt_release ; echo $DISTRIB_ARCH)")

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
    echo -e "${CYAN_COLOR}🏗️  系统架构: ${BOLD}${YELLOW_COLOR}$arch${RESET}"
    echo -e "${CYAN_COLOR}🐧  设备型号: ${BOLD}${YELLOW_COLOR}$(cat /tmp/sysinfo/board_name 2>/dev/null || echo "Unknown")${RESET}"
    echo -e "${CYAN_COLOR}💾  可用空间: ${BOLD}${YELLOW_COLOR}$(df -h / | awk 'NR==2 {print $4}')${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e ""
}

# 检查并移除插件
remove_plugins() {
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e "${BOLD}${CYAN_COLOR}🔍 检查并移除旧插件...${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    
    local plugins=(
        "luci-app-argon-config"
        "luci-app-quickstart" 
        "luci-app-store"
        "luci-lib-taskd"
        "luci-lib-xterm"
        "luci-theme-argon"
        "quickstart"
        "taskd"
    )
    
    for plugin in "${plugins[@]}"; do
        if opkg list-installed | grep -q "^$plugin "; then
            echo -e "${YELLOW_COLOR}🗑️  正在移除: $plugin${RESET}"
            opkg remove --force-removal-of-dependent-packages "$plugin" >/dev/null 2>&1 || true
            echo -e "${GREEN_COLOR}✅ 已移除: $plugin${RESET}"
        else
            echo -e "${CYAN_COLOR}ℹ️  未安装: $plugin${RESET}"
        fi
    done
    
    echo -e "${BOLD}${GREEN_COLOR}✅ 插件检查完成${RESET}"
    echo ""
}

# 下载并添加密钥
add_key() {
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e "${BOLD}${CYAN_COLOR}🔑 下载并添加软件源密钥...${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    
    local key_url="https://opkg.kejizero.xyz/key-build.pub"
    local key_file="/tmp/key-build.pub"
    
    echo -e "${YELLOW_COLOR}📥 下载密钥: $key_url${RESET}"
    if wget -q --timeout=30 --tries=3 -O "$key_file" "$key_url"; then
        echo -e "${GREEN_COLOR}✅ 密钥下载成功${RESET}"
        echo -e "${YELLOW_COLOR}🔐 添加密钥到opkg...${RESET}"
        opkg-key add "$key_file" >/dev/null 2>&1
        echo -e "${GREEN_COLOR}✅ 密钥添加成功${RESET}"
        rm -f "$key_file"
    else
        echo -e "${RED_COLOR}❌ 密钥下载失败，跳过此步骤${RESET}"
        return 1
    fi
    
    echo ""
}

# 添加软件源
add_feeds() {
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e "${BOLD}${CYAN_COLOR}📦 添加软件源...${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    
    local feed_url="https://opkg.cooluc.com/openwrt-24.10/$arch"
    local feed_line="src/gz openwrt_extras $feed_url"
    local feeds_file="/etc/opkg/customfeeds.conf"
    
    # 检查是否已存在该源
    if grep -q "^$feed_line" "$feeds_file" 2>/dev/null; then
        echo -e "${CYAN_COLOR}ℹ️  软件源已存在，跳过添加${RESET}"
    else
        echo -e "${YELLOW_COLOR}➕ 添加软件源: $feed_url${RESET}"
        echo "$feed_line" >> "$feeds_file"
        echo -e "${GREEN_COLOR}✅ 软件源添加成功${RESET}"
    fi
    
    echo ""
}

# 更新软件包列表
update_opkg() {
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e "${BOLD}${CYAN_COLOR}🔄 更新软件包列表...${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    
    echo -e "${YELLOW_COLOR}🔄 执行 opkg update...${RESET}"
    if opkg update >/dev/null 2>&1; then
        echo -e "${GREEN_COLOR}✅ 软件包列表更新成功${RESET}"
    else
        echo -e "${RED_COLOR}❌ 软件包列表更新失败${RESET}"
        return 1
    fi
    
    echo ""
}

# 安装 quickstart
install_quickstart() {
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e "${BOLD}${CYAN_COLOR}📥 安装 luci-app-quickstart...${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    
    echo -e "${YELLOW_COLOR}📦 安装 luci-app-quickstart${RESET}"
    if opkg install luci-i18n-quickstart-zh-cn luci-theme-argon luci-app-argon-config-zh-cn>/dev/null 2>&1; then
        echo -e "${GREEN_COLOR}✅ luci-app-quickstart 安装成功${RESET}"
    else
        echo -e "${RED_COLOR}❌ luci-app-quickstart 安装失败${RESET}"
        return 1
    fi
    
    echo ""
}

# 完成提示
show_completion() {
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e "${BOLD}${GREEN_COLOR}🎉 iStoreOS 风格化完成!${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e ""
    echo -e "${BOLD}${YELLOW_COLOR}📋 完成摘要:${RESET}"
    echo -e "${CYAN_COLOR}✅ 已移除旧插件${RESET}"
    echo -e "${CYAN_COLOR}✅ 已添加软件源密钥${RESET}"
    echo -e "${CYAN_COLOR}✅ 已配置软件源${RESET}"
    echo -e "${CYAN_COLOR}✅ 已更新软件包列表${RESET}"
    echo -e "${CYAN_COLOR}✅ 已安装 luci-app-quickstart${RESET}"
    echo -e ""
    echo -e "${BOLD}${MAGENTA_COLOR}💡 建议操作:${RESET}"
    echo -e "${YELLOW_COLOR}🔁 重启系统以使所有更改生效${RESET}"
    echo -e "${YELLOW_COLOR}🌐 访问 Web 界面查看新的主题和功能${RESET}"
    echo -e ""
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
    echo -e "${CYAN_COLOR}⏰ 完成时间: ${BOLD}${YELLOW_COLOR}$(date '+%Y-%m-%d %H:%M:%S')${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}=================================================================${RESET}"
}

### 开始风格化 ###
start_styling() {
    remove_plugins
    add_key
    add_feeds
    update_opkg
    install_quickstart
    show_completion
}

# 主函数
main() {
    show_banner
    
    # 确认是否继续
    echo -e "${BOLD}${YELLOW_COLOR}⚠️  此脚本将修改系统配置，是否继续? [y/N]${RESET}"
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY])
            echo -e "${GREEN_COLOR}🚀 开始执行风格化...${RESET}"
            echo ""
            start_styling
            ;;
        *)
            echo -e "${RED_COLOR}❌ 用户取消操作${RESET}"
            exit 1
            ;;
    esac
}

main "$@"
