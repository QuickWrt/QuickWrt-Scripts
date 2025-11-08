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

### 开始风格化 ###
start_styling() {
    # 第一步：环境检测
    echo -e "${BOLD}${BLUE_COLOR}■ ■ ■ ■ ■ ■ ■ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □${RESET}"
    echo -e "${BOLD}${CYAN_COLOR}✨ 系统环境全面检测 ${YELLOW_COLOR}»» ${MAGENTA_COLOR}步骤 [1/3]${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}■ ■ ■ ■ ■ ■ ■ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □${RESET}"
    echo ""

    # 更新软件源
    echo -e "${CYAN_COLOR}📦 更新软件源...${RESET}"
    if opkg update; then
        echo -e "${GREEN_COLOR}✅ 软件源更新成功${RESET}"
    else
        echo -e "${RED_COLOR}❌ 软件源更新失败${RESET}"
        exit 1
    fi

    # 检测网络工具
    echo -e "${CYAN_COLOR}🌐 检测网络工具...${RESET}"
    if command -v curl &> /dev/null || command -v wget &> /dev/null; then
        if command -v curl &> /dev/null; then
            echo -e "${GREEN_COLOR}✅ curl 已安装${RESET}"
        else
            echo -e "${GREEN_COLOR}✅ wget 已安装${RESET}"
        fi
    else
        echo -e "${YELLOW_COLOR}📥 安装网络工具...${RESET}"
        if opkg install curl || opkg install wget; then
            echo -e "${GREEN_COLOR}✅ 网络工具安装成功${RESET}"
        else
            echo -e "${RED_COLOR}❌ 网络工具安装失败${RESET}"
            exit 1
        fi
    fi

    # 检测解压缩工具
    echo -e "${CYAN_COLOR}📁 检测解压缩工具...${RESET}"
    if command -v unzip &> /dev/null; then
        echo -e "${GREEN_COLOR}✅ unzip 已安装${RESET}"
    else
        echo -e "${YELLOW_COLOR}📥 安装unzip...${RESET}"
        if opkg install unzip; then
            echo -e "${GREEN_COLOR}✅ unzip 安装成功${RESET}"
        else
            echo -e "${RED_COLOR}❌ unzip 安装失败${RESET}"
            exit 1
        fi
    fi

    # 检测现有插件
    echo -e "${CYAN_COLOR}🔌 检测现有插件...${RESET}"
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
    
    local found_plugins=()
    for plugin in "${plugins[@]}"; do
        if opkg list-installed | grep -q "^$plugin"; then
            found_plugins+=("$plugin")
        fi
    done
    
    if [ ${#found_plugins[@]} -gt 0 ]; then
        echo -e "${YELLOW_COLOR}🗑️  发现已安装插件，将在下一步移除:${RESET}"
        for plugin in "${found_plugins[@]}"; do
            echo -e "  ${YELLOW_COLOR}• $plugin${RESET}"
        done
    else
        echo -e "${GREEN_COLOR}✅ 未发现相关插件${RESET}"
    fi

    echo -e "${GREEN_COLOR}🎉 环境检测完成${RESET}"
    echo ""

    # 第二步：下载依赖文件
    echo -e "${BOLD}${BLUE_COLOR}■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □${RESET}"
    echo -e "${BOLD}${CYAN_COLOR}📥 下载依赖文件 ${YELLOW_COLOR}»» ${MAGENTA_COLOR}步骤 [2/2]${RESET}"
    echo -e "${BOLD}${BLUE_COLOR}■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □${RESET}"
    echo ""

    local download_url="https://github.com/QuickWrt/QuickWrt-Scripts/releases/download/$arch/$arch-openwrt-24.10.zip"
    local zip_file="$arch-openwrt-24.10.zip"
    local extract_dir="QuickWrt"
    
    echo -e "${CYAN_COLOR}🏗️  系统架构: ${YELLOW_COLOR}$arch${RESET}"
    echo -e "${CYAN_COLOR}📦 下载文件: ${YELLOW_COLOR}$zip_file${RESET}"
    echo -e "${CYAN_COLOR}📁 解压目录: ${YELLOW_COLOR}$extract_dir${RESET}"
    echo -e "${CYAN_COLOR}🔗 下载地址: ${YELLOW_COLOR}$download_url${RESET}"
    echo ""
    
    # 清理旧文件
    echo -e "${CYAN_COLOR}🧹 清理旧文件...${RESET}"
    rm -rf "$zip_file" "$extract_dir"
    echo -e "${GREEN_COLOR}✅ 清理完成${RESET}"
    
    # 下载文件
    echo -e "${CYAN_COLOR}📥 下载依赖包...${RESET}"
    if command -v curl &> /dev/null; then
        if curl -L -o "$zip_file" "$download_url"; then
            echo -e "${GREEN_COLOR}✅ 下载成功 (使用curl)${RESET}"
        else
            echo -e "${RED_COLOR}❌ 下载失败${RESET}"
            exit 1
        fi
    elif command -v wget &> /dev/null; then
        if wget -O "$zip_file" "$download_url"; then
            echo -e "${GREEN_COLOR}✅ 下载成功 (使用wget)${RESET}"
        else
            echo -e "${RED_COLOR}❌ 下载失败${RESET}"
            exit 1
        fi
    else
        echo -e "${RED_COLOR}❌ 未找到可用的下载工具${RESET}"
        exit 1
    fi
    
    # 创建解压目录
    echo -e "${CYAN_COLOR}📁 创建解压目录...${RESET}"
    mkdir -p "$extract_dir"
    echo -e "${GREEN_COLOR}✅ 目录创建完成${RESET}"
    
    # 解压缩文件
    echo -e "${CYAN_COLOR}📦 解压缩文件...${RESET}"
    if unzip -q "$zip_file" -d "$extract_dir"; then
        echo -e "${GREEN_COLOR}✅ 解压缩成功${RESET}"
    else
        echo -e "${RED_COLOR}❌ 解压缩失败${RESET}"
        exit 1
    fi
    
    # 移除压缩包
    echo -e "${CYAN_COLOR}🗑️  移除压缩包...${RESET}"
    rm -f "$zip_file"
    echo -e "${GREEN_COLOR}✅ 压缩包已移除${RESET}"
    
    # 安装所有ipk文件
    echo -e "${CYAN_COLOR}🔧 安装插件文件...${RESET}"
    if [ -d "$extract_dir" ]; then
        cd "$extract_dir"
        local ipk_files=(*.ipk)
        if [ ${#ipk_files[@]} -gt 0 ]; then
            for ipk_file in "${ipk_files[@]}"; do
                if [ -f "$ipk_file" ]; then
                    echo -e "${YELLOW_COLOR}📦 安装: $ipk_file${RESET}"
                    if opkg install "$ipk_file"; then
                        echo -e "${GREEN_COLOR}✅ 安装成功: $ipk_file${RESET}"
                    else
                        echo -e "${RED_COLOR}❌ 安装失败: $ipk_file${RESET}"
                    fi
                fi
            done
        else
            echo -e "${RED_COLOR}❌ 未找到ipk文件${RESET}"
            exit 1
        fi
        cd ..
    else
        echo -e "${RED_COLOR}❌ 解压目录不存在${RESET}"
        exit 1
    fi
    
    echo -e "${GREEN_COLOR}🎉 依赖文件安装完成${RESET}"
    echo ""
}

# 主函数
main() {
    show_banner
    start_styling
}

main "$@"
