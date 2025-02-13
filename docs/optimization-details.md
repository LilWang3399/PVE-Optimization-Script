# 優化技術細節

## CPU 相關優化
1. **調速器模式**
   - 強制使用 `performance` 模式
   - 禁用 Intel P-state (舊款 CPU)

2. **NUMA 設定**
   ```bash
   kernel.numa_balancing=0
