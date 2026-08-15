---
name: device-inspector
description: 设备监察技能。让智能体在任意一台电脑上检查自己的系统、硬件、软件、编码、时区，并生成设备档案.md。配合后台守护与 RAG 使用。此技能是泛式模板，不绑定特定机器。
version: 1.1.0
---

# 设备监察技能 (Device Monitor Skill)

## 是什么

一个可复用的泛式技能，让智能体（Agent）能在任何电脑上：

1. 扫描并查清电脑的**系统、硬件（CPU/内存/磁盘/GPU/网卡）、软件、编码、时区、语言区域**。
2. 生成一份**设备档案.md**，记录这台电脑的全部信息。
3. 提供**后台守护**（静默检查、日志、安全修复指引）。
4. 接入 **RAG 知识库**，让 AI 基于设备资料回答。

## 何时使用

- 用户想了解自己的电脑有什么硬件/软件/系统。
- 用户怀疑电脑配置、编码、版本有问题。
- 用户换了新电脑，想快速掌握新机器。
- 需要做环境审计、设备盘点、迁移前摸底。

## 用法（3 步）

### 第1步：扫描设备
在电脑上运行扫描脚本（二选一）：
```powershell
# Windows (PowerShell)
powershell -ExecutionPolicy Bypass -File .\scripts\scan-device.ps1
```
```bash
# Mac/Linux
python3 scripts/scan-device.py
```
输出：在当前目录生成 `设备档案.md`。

### 第2步：盘点可入RAG的数据（按优先级）
扫描本机各盘，按以下优先级判断哪些资料适合入知识库（RAG）：
1. **核心业务数据**（如 wealth 数据资产）→ 最优先
2. **工作方法沉淀**（AI对话记录、skill库、白皮书）→ 第二
3. **专项项目资料**（如乡宁国企审计）→ 第三
4. **环境档案**（设备档案等本地Obsidian）→ 已在本地，随查随用
5. **普通用户目录**（Documents/OneDrive）→ 基本为空，暂不处理

参考格式：`docs/知识图谱与RAG.md` 的"数据清单"部分。

### 第3步：作为智能体
把 `agent/SOUL.md` 放进 Cherry Studio 的 `Data\Agents\<GUID>\`，或挂到 DSH 预设。监察师会主动纠错、有底线、面向普通人。

## 技能边界

- 只能"查"和"讲"，不能擅自改系统设置。
- 需管理员权限/改配置的操作，给命令由用户执行。
- 涉及私密信息，提示用户自行处理，不代劳。

## 关联文件

- `agent/SOUL.md` — 监察师人设
- `scripts/scan-device.ps1` / `scan-device.py` — 扫描脚本
- `format/设备档案模板.md` — 档案模板
- `docs/通用技能.md` — 方法论
- `docs/知识图谱与RAG.md` — RAG 接入 + 数据清单
- `docs/后台守护与自愈.md` — 后台守护
- `device-monitor-plugin/` — 后台守护插件源码