# TP-LINK WR842N V3 LEDE 中文打印服务器固件

基于 OpenWrt 21.02 源码定制的 TP-LINK WR842N V3 路由器固件，集成中文打印服务功能。

## 功能特性

- **打印服务**: CUPS 2.4.2 中文打印服务
- **预装驱动**: HP LaserJet 1020/1020plus/1007/1008/1108 打印机驱动
- **USB支持**: USB打印机支持，VirtualHere虚拟USB
- **网络打印**: 网络打印机支持，远程打印功能
- **管理功能**: 定时重启，一键切换无线AP模式
- **中文界面**: 全中文Web管理界面
- **自动编译**: GitHub Actions一键云编译

## 默认配置

- **LAN IP**: 192.168.10.1
- **Web登录**: admin / thdn12345678
- **Wi-Fi SSID**: THDN-dayin
- **Wi-Fi密码**: thdn12345678
- **主机名**: THDN-PrintServer

## 编译环境

- **操作系统**: Ubuntu 22.04 LTS
- **OpenWrt版本**: 21.02.7
- **目标芯片**: ar71xx/generic
- **闪存容量**: 16MB

## 快速开始

### 本地编译

```bash
# 克隆项目
git clone https://github.com/your-repo/tplink-842n-v3-printserver.git
cd tplink-842n-v3-printserver

# 安装依赖
sudo apt update
sudo apt install -y build-essential ccache ecj fastjar file g++ gawk \
gettext git java-propose-classpath libelf-dev libncurses5-dev \
libncursesw5-dev libssl-dev python python2.7-dev python3 unzip wget \
python3-distutils python3-setuptools python3-dev rsync subversion \
swig time xsltproc zlib1g-dev

# 下载源码
./scripts/download-sources.sh

# 配置编译
make menuconfig

# 开始编译
make -j$(nproc)
```

### GitHub Actions自动编译

1. Fork本项目到你的GitHub仓库
2. 进入Actions页面，手动触发编译工作流
3. 编译完成后，在Release页面下载固件

## 固件文件

编译完成后会生成两个文件：
- `openwrt-ar71xx-generic-tl-wr842n-v3-squashfs-sysupgrade.bin` - 用于在线升级
- `openwrt-ar71xx-generic-tl-wr842n-v3-squashfs-factory.bin` - 用于首次刷机

## 刷机说明

1. **首次刷机**: 使用factory.bin文件，通过路由器Web界面或TFTP刷入
2. **在线升级**: 使用sysupgrade.bin文件，通过OpenWrt Web界面升级
3. **注意事项**: 刷机有风险，请确保电源稳定，谨慎操作

## 项目结构

```
.
├── .github/
│   └── workflows/
│       └── build.yml          # GitHub Actions编译脚本
├── configs/
│   ├── .config               # OpenWrt配置文件
│   └── cups-config/          # CUPS打印服务配置
├── files/
│   ├── etc/
│   │   ├── config/           # 默认配置文件
│   │   ├── cups/             # CUPS配置
│   │   └── rc.local          # 启动脚本
│   └── www/
│       └── luci-static/      # 中文界面资源
├── patches/
│   └── *.patch              # 补丁文件
├── scripts/
│   ├── download-sources.sh   # 源码下载脚本
│   ├── setup-environment.sh  # 环境配置脚本
│   └── build.sh             # 编译脚本
└── README.md
```

## 技术支持

如有问题，请在GitHub Issues中提交，我们会尽快回复。

## 许可证

本项目基于OpenWrt开源协议发布，详见LICENSE文件。
