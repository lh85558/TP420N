# TP-LINK WR842N V3 快速构建指南

## 一键构建（推荐）

### 使用GitHub Actions（最简单）
1. Fork本项目到你的GitHub仓库
2. 进入Actions页面
3. 点击"Build TP-LINK WR842N V3 PrintServer Firmware"
4. 点击"Run workflow"开始构建
5. 构建完成后在Release页面下载固件

### 本地快速构建

```bash
# 1. 克隆项目
git clone https://github.com/your-repo/tplink-842n-v3-printserver.git
cd tplink-842n-v3-printserver

# 2. 一键构建
bash scripts/build.sh

# 3. 构建完成后，固件在firmware/目录
ls -la firmware/
```

## 详细构建步骤

### 环境准备（Ubuntu 22.04）

```bash
# 安装构建依赖
sudo apt update
sudo apt install -y build-essential ccache ecj fastjar file g++ gawk \
gettext git java-propose-classpath libelf-dev libncurses5-dev \
libncursesw5-dev libssl-dev python python2.7-dev python3 unzip wget \
python3-distutils python3-setuptools python3-dev rsync subversion \
swig time xsltproc zlib1g-dev
```

### 下载源码

```bash
# 下载OpenWrt源码
bash scripts/download-sources.sh
```

### 配置环境

```bash
# 复制项目配置
bash scripts/setup-environment.sh
```

### 开始构建

```bash
# 进入OpenWrt目录
cd ~/openwrt

# 可选：自定义配置
make menuconfig

# 开始构建（使用所有CPU核心）
make -j$(nproc)

# 或者使用项目构建脚本
cd /path/to/project
bash scripts/build.sh
```

## 构建时间预估

- **GitHub Actions**: 30-45分钟
- **本地构建**: 
  - 首次构建：2-3小时
  - 后续构建：30-60分钟

## 构建输出

构建完成后，固件文件位于：
```
~/openwrt/bin/targets/ar71xx/generic/
├── openwrt-ar71xx-generic-tl-wr842n-v3-squashfs-factory.bin  # 首次刷机
└── openwrt-ar71xx-generic-tl-wr842n-v3-squashfs-sysupgrade.bin # 在线升级
```

## 故障排除

### 构建失败
1. 检查磁盘空间（至少需要10GB）
2. 检查网络连接（需要下载源码包）
3. 清理后重试：`make clean && make -j$(nproc)`

### 缺少依赖
```bash
# 重新安装依赖
sudo apt install -f
bash scripts/setup-environment.sh
```

### 配置错误
```bash
# 重置配置
cd ~/openwrt
cp /path/to/project/configs/.config ./
make defconfig
```

## 验证构建

```bash
# 检查固件文件
file firmware/*.bin

# 检查文件大小（应该在8-12MB之间）
ls -lh firmware/*.bin

# 计算校验和
cd firmware
md5sum *.bin
sha256sum *.bin
```

## 快速测试

### 本地测试
```bash
# 使用QEMU测试（可选）
qemu-system-mips -M malta -kernel firmware/*.bin
```

### 刷机测试
1. 备份原厂固件
2. 使用factory.bin进行首次刷机
3. 访问192.168.10.1确认正常工作

## 发布流程

### 创建Release
```bash
# 创建标签
git tag v1.0.0

# 推送标签
git push origin v1.0.0

# GitHub Actions会自动创建Release
```

### 发布内容
- factory.bin（首次刷机用）
- sysupgrade.bin（在线升级用）
- checksums.md5（MD5校验和）
- checksums.sha256（SHA256校验和）
- 更新日志

## 注意事项

1. **安全第一**: 刷机有风险，请谨慎操作
2. **备份重要**: 刷机前备份原厂固件和重要数据
3. **电源稳定**: 刷机过程中保持电源稳定
4. **网络环境**: 构建需要稳定的网络连接
5. **系统资源**: 建议至少有4GB内存和20GB磁盘空间

## 获取帮助

- 查看构建日志：`tail -f build.log`
- 访问项目Issues页面
- 查看OpenWrt官方文档
- 加入相关技术交流群组

---

**提示**: 首次构建建议从GitHub Actions开始，熟悉流程后再进行本地构建。
