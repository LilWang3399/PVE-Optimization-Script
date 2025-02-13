#!/bin/bash
# PVE Optimization Script v1.3
# Repository: https://github.com/yourusername/PVE-Optimization-Script

# 初始化設定
SCRIPT_NAME="PVE Optimizer"
CONFIG_BACKUP_DIR="/var/backups/pve_config"
LOG_FILE="/var/log/pve_optimizer.log"

# 日誌記錄函數
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - $1" | tee -a $LOG_FILE
}

# 檢測硬體函數
detect_hardware() {
    # 檢測 CPU 類型
    if grep -qi 'intel' /proc/cpuinfo; then
        CPU_VENDOR="intel"
    elif grep -qi 'amd' /proc/cpuinfo; then
        CPU_VENDOR="amd"
    fi

    # 檢測儲存設備類型
    STORAGE_TYPE="hdd"
    if lsblk -d -o rota | grep -q '0'; then
        STORAGE_TYPE="ssd"
    fi
}

# 主優化流程
main_optimization() {
    log "=== 開始 PVE 系統優化 ==="
    
    # 建立備份目錄
    mkdir -p $CONFIG_BACKUP_DIR
    
    # 備份配置文件
    log "備份系統配置..."
    cp /etc/sysctl.conf $CONFIG_BACKUP_DIR/sysctl.conf.bak
    cp /etc/fstab $CONFIG_BACKUP_DIR/fstab.bak
    cp /etc/default/grub $CONFIG_BACKUP_DIR/grub.bak
    
    # 核心參數優化
    log "套用核心參數優化..."
    cat >> /etc/sysctl.conf << EOF
# PVE Optimization Start
vm.swappiness=10
vm.dirty_ratio=20
vm.dirty_background_ratio=5
vm.vfs_cache_pressure=100
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.tcp_slow_start_after_idle=0
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
kernel.numa_balancing=0
# PVE Optimization End
EOF

    # 儲存設備優化
    if [ "$STORAGE_TYPE" = "ssd" ]; then
        log "套用 SSD 優化設定..."
        echo "deadline" > /sys/block/sda/queue/scheduler
        cat >> /etc/rc.local << EOF
ionice -c1 -n0 -p \$(pgrep kvm)
ionice -c1 -n0 -p \$(pgrep qemu)
EOF
    fi

    # 套用設定
    log "重新載入系統配置..."
    sysctl -p > /dev/null 2>&1
    update-initramfs -u -k all > /dev/null 2>&1
    
    log "優化完成！建議重新啟動系統。"
}

# 執行主程序
detect_hardware
main_optimization
