# Proxmox VE Optimization Script

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

針對 Proxmox VE 伺服器的系統優化腳本，包含核心參數調校、硬體效能優化與虛擬化相關設定。

## 📦 功能特色

- 自動檢測 SSD/NVME 儲存設備
- CPU 效能模式設定
- 內存管理優化 (HugePages/Swappiness)
- NUMA 架構支援強化
- 自動備份系統配置文件

## 🚀 快速開始

**系統需求**：
- Proxmox VE 7.x/8.x
- Root 權限
- Bash 5.0+

```bash
# 下載腳本
git clone https://github.com/LilWang3399/PVE-Optimization-Script.git
cd PVE-Optimization-Script

# 授予執行權限
chmod +x scripts/pve-optimizer.sh

# 執行腳本 (需 root 權限)
sudo ./scripts/pve-optimizer.sh
```

## ⚙️ 主要優化項目

| 類別        | 優化項目                          | 預設值              |
|-------------|----------------------------------|--------------------|
| **CPU**     | 調速器模式設定                   | performance        |
| **Memory**  | HugePages 大小                   | 物理記憶體 75%     |
|             | Swappiness 值                   | 10                 |
| **Storage** | I/O 調度器 (SSD/NVME)           | deadline           |
| **Network** | 擁塞控制算法                     | BBR                |
|             | TCP 緩衝區大小                   | 16MB               |
| **Virtual** | NUMA 平衡                       | 禁用               |

## ⚠️ 注意事項

1. 執行前務必：
   - [ ] 備份重要數據
   - [ ] 閱讀 [優化細節文件](docs/optimization-details.md)
   - [ ] 確認硬體相容性

2. 主要配置文件備份位置：
   ```
   /etc/sysctl.conf.bak
   /etc/fstab.bak
   /etc/default/grub.bak
   ```
