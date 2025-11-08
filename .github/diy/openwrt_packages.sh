#!/bin/bash
function git_sparse_clone() {
branch="$1" rurl="$2" localdir="$3" && shift 3
git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
cd $localdir
git sparse-checkout init --cone
git sparse-checkout set $@
mv -n $@ ../
cd ..
rm -rf $localdir
}

function mvdir() {
mv -n `find $1/* -maxdepth 0 -type d` ./
rm -rf $1
}

mkdir -p applications
cd applications
git clone --depth 1 -b main https://github.com/linkease/istore && mv -n istore/luci/* ./ && rm -rf istore
git clone --depth 1 -b openwrt-24.10 https://github.com/QuickWrt/luci-theme-argon openwrt-argon && mv -n openwrt-argon/{luci-app-argon-config,luci-theme-argon} ./ && rm -rf openwrt-argon
git clone --depth 1 -b master https://github.com/linkease/nas-packages && mv -n nas-packages/network/services/quickstart ./ && rm -rf nas-packages
git clone --depth 1 -b main https://github.com/linkease/nas-packages-luci nas-luci && mv -n nas-luci/luci/luci-app-quickstart ./ && rm -rf nas-luci

sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile

rm -rf ./*/.git ./*/.gitattributes ./*/.svn ./*/.github ./*/.gitignore
#find . -type f -name Makefile -exec sed -i 's/PKG_BUILD_FLAGS:=no-mips16/PKG_USE_MIPS16:=0/g' {} +
exit 0
