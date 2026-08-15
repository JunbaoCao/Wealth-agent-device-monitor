#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
监察师 · 设备扫描脚本（跨平台 Python 版）
用途：扫描本机，生成"设备档案.md"（Windows / macOS / Linux 通用）。
用法：python3 scripts/scan-device.py
输出：在当前目录生成 设备档案.md
"""
import datetime, json, os, platform, socket, subprocess, sys

def run(cmd):
    try:
        r = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=30)
        return r.stdout.strip()
    except Exception:
        return ""

def main():
    print("=== 监察师 · 设备扫描开始 ===")
    info = {}
    info['hostname'] = socket.gethostname()
    info['os'] = platform.platform()
    info['system'] = platform.system()
    info['machine'] = platform.machine()
    info['processor'] = platform.processor() or run("wmic cpu get name /value") or "未知"

    # 内存
    info['ram_gb'] = "需手动确认"
    try:
        if sys.platform == 'win32':
            out = run("wmic computersystem get totalphysicalmemory /value")
            import re
            m = re.search(r'(\d+)', out)
            if m: info['ram_gb'] = round(int(m.group(1))/(1024**3), 1)
        elif sys.platform.startswith('linux'):
            out = run("free -b | awk '/Mem:/{print $2}'")
            if out: info['ram_gb'] = round(int(out)/(1024**3), 1)
        elif sys.platform == 'darwin':
            out = run("sysctl hw.memsize | awk '{print $2}'")
            if out: info['ram_gb'] = round(int(out)/(1024**3), 1)
    except Exception:
        pass

    # 磁盘
    disks = []
    try:
        if sys.platform == 'win32':
            out = run("wmic logicaldisk get caption,size,freespace /format:csv")
            for line in out.splitlines():
                parts = [p.strip() for p in line.split(',')]
                if len(parts) >= 4 and parts[2].isdigit():
                    total = round(int(parts[2])/(1024**3), 1)
                    free = round(int(parts[3])/(1024**3), 1)
                    disks.append(f"{parts[1]} 总{total}GB 剩{free}GB")
        else:
            out = run("df -h | awk 'NR>1{print $1\" 总\"$2\" 剩\"$4}'")
            if out: disks = out.splitlines()
    except Exception:
        pass

    # 语言/时区/编码
    try:
        import locale
        info['locale'] = locale.getdefaultlocale()[0] or 'unknown'
    except Exception:
        info['locale'] = os.environ.get('LANG', 'unknown')
    info['timezone'] = datetime.datetime.now().astimezone().tzinfo.tzname(None)
    info['encoding'] = 'UTF-8'

    # 生成 Markdown
    today = datetime.date.today().isoformat()
    md = f"""---
tags:
  - 监察师
  - 设备档案
  - 自动生成
created: {today}
---

# 设备档案（本机自动生成）

> 由监察师扫描脚本自动生成，记录本机系统/硬件/软件/编码/时区信息。

## 系统
| 项目 | 值 |
|------|-----|
| 主机名 | {info['hostname']}
| 系统 | {info['os']}
| 架构 | {info['machine']}

## 处理器 CPU
| 项目 | 值 |
|------|-----|
| 型号 | {info['processor']}

## 内存 / 磁盘
| 项目 | 值 |
|------|-----|
| 内存 | {info['ram_gb']} GB
| 磁盘 | {('; '.join(disks)) if disks else '无'}

## 语言 / 时区 / 编码
| 项目 | 值 |
|------|-----|
| 系统语言 | {info['locale']}
| 时区 | {info['timezone']}
| 编码 | {info['encoding']}

---
*本档案由 监察师 扫描脚本自动生成。*
"""
    out = os.path.join(os.getcwd(), '设备档案.md')
    with open(out, 'w', encoding='utf-8') as f:
        f.write(md)
    print(f"✅ 已生成：{out}")
    print("将本文件纳入 Obsidian 监察师文件夹即可使用。")

if __name__ == '__main__':
    main()