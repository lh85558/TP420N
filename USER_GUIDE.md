# TP-LINK WR842N V3 中文打印服务器使用指南

## 快速开始

### 1. 刷机步骤

#### 首次刷机（使用factory.bin）
1. 下载 `openwrt-ar71xx-generic-tl-wr842n-v3-squashfs-factory.bin`
2. 连接路由器LAN口，设置电脑IP为192.168.1.2
3. 访问192.168.1.1，进入原厂管理界面
4. 选择固件升级，上传factory.bin文件
5. 等待刷机完成（约3-5分钟）

#### 在线升级（使用sysupgrade.bin）
1. 访问192.168.10.1，登录管理界面
2. 进入系统 → 备份/升级
3. 上传sysupgrade.bin文件进行升级

### 2. 默认配置

- **管理地址**: http://192.168.10.1
- **用户名**: admin
- **密码**: thdn12345678
- **WiFi名称**: THDN-dayin
- **WiFi密码**: thdn12345678

### 3. 打印服务配置

#### 连接USB打印机
1. 将USB打印机连接到路由器的USB口
2. 访问 http://192.168.10.1:631 进入CUPS管理界面
3. 点击"管理打印机" → "添加打印机"
4. 选择检测到的USB打印机
5. 选择对应的驱动程序（HP LaserJet系列已预装）

#### 使用命令行配置
```bash
# 查看已连接的打印机
lsusb

# 设置HP打印机
setup-printers setup

# 查看打印机状态
setup-printers status
```

### 4. 网络打印机配置

#### 添加网络打印机
```bash
# 添加网络打印机（替换IP和名称）
setup-printers network 192.168.10.100 "网络打印机1"
```

#### 启用远程打印
```bash
# 启用远程打印功能
setup-printers remote
```

### 5. 模式切换

#### 路由器模式（默认）
- LAN口：192.168.10.1
- WAN口：自动获取IP
- 提供DHCP服务

#### AP模式
- 所有端口桥接
- 自动从上级路由器获取IP
- 关闭DHCP服务

#### 切换命令
```bash
# 切换模式
ap-mode-toggle toggle

# 查看当前模式
ap-mode-toggle status
```

### 6. 远程访问

#### 通过VirtualHere
1. 安装VirtualHere客户端
2. 连接到路由器IP:7575
3. 远程使用USB设备

#### 通过CUPS
1. 访问 http://路由器IP:631
2. 使用Web界面管理打印机

### 7. 定时重启

默认配置：每周日凌晨3:30自动重启

#### 修改重启时间
```bash
# 编辑定时重启配置
uci set autoreboot.@autoreboot[0].week='0'    # 0=周日,1=周一...
uci set autoreboot.@autoreboot[0].hour='3'   # 3点
uci set autoreboot.@autoreboot[0].minute='30' # 30分
uci commit autoreboot
/etc/init.d/autoreboot restart
```

### 8. 常见问题

#### 无法访问管理界面
1. 检查电脑IP是否设置为自动获取
2. 尝试访问192.168.10.1
3. 如仍无法访问，长按复位键恢复出厂设置

#### 打印机无法识别
1. 检查USB连接是否牢固
2. 确认打印机已开机
3. 使用 `lsusb` 命令查看是否检测到设备
4. 检查CUPS服务是否运行：`/etc/init.d/cupsd status`

#### WiFi连接问题
1. 确认WiFi密码正确（thdn12345678）
2. 检查无线是否被禁用
3. 尝试重启无线：`wifi down && wifi up`

#### 存储空间不足
1. 16MB闪存空间有限，避免安装额外软件包
2. 定期清理日志文件
3. 使用外部存储（如USB设备）扩展空间

### 9. 高级配置

#### 修改LAN IP地址
```bash
uci set network.lan.ipaddr='192.168.1.1'
uci commit network
/etc/init.d/network restart
```

#### 修改WiFi设置
```bash
uci set wireless.@wifi-iface[0].ssid='新WiFi名称'
uci set wireless.@wifi-iface[0].key='新WiFi密码'
uci commit wireless
wifi reload
```

#### 备份配置
```bash
# 备份当前配置
sysupgrade -b /tmp/backup.tar.gz

# 恢复配置
sysupgrade -r /tmp/backup.tar.gz
```

### 10. 技术支持

- **项目主页**: [GitHub仓库地址]
- **问题反馈**: 在GitHub Issues中提交
- **技术文档**: 查看项目Wiki

### 11. 安全建议

1. **修改默认密码**: 首次使用后立即修改管理密码
2. **关闭远程管理**: 如不需要，关闭WAN口管理访问
3. **定期更新**: 关注项目更新，及时升级固件
4. **防火墙配置**: 根据需求配置防火墙规则

### 12. 性能优化

1. **内存管理**: 16MB内存较小，避免同时运行多个服务
2. **日志轮转**: 配置日志自动清理
3. **缓存优化**: 合理配置DNS缓存和连接跟踪
4. **无线优化**: 选择干扰较少的信道

---

**注意**: 刷机有风险，请谨慎操作。建议在熟悉OpenWrt的用户指导下进行高级配置。
