# Wealth device-inspector · 设备监察

[English](README.md) | 中文 | **[架构白皮书](WHITEPAPER.md)**

**威尔思（Wealth）** 出品的开源**设备监察 agent**：在任意电脑上**一键自查**系统、硬件、语言、编码、时区，自动生成属于那台电脑自己的 `设备档案.md`，防止环境出错。它是你 agent 的**架构底层**——先懂自己的设备，再跑任何智能体。

**开源协议：MIT · 版本：v1.3.0（2026-08-14）**

> 📖 想了解整个项目怎么组织、数据怎么流动、怎么扩展？看 **[WHITEPAPER.md（架构白皮书）](WHITEPAPER.md)**。

## 用大白话说（这是干嘛的）

> **你不需要懂技术。** 这个工具帮 AI 智能体（或你自己）在**动手做事之前，先搞清自己的电脑**：装的是什么系统、什么硬件、什么语言编码、什么时区——全写进一份 `设备档案.md`。这样就能避免最常见的坑（乱码、语言错、代码跑不起来），因为智能体已经先"认识"了自己的机器。

**一键 → 你就知道你的电脑是什么样。就这个。**

---

## 它是什么

一套开源的**设备监察（device inspector）**agent。它的职责**不是审计财务**——而是**检查机器环境**，让 agent 永远不会被自己的系统绊倒：编码错、区域错、运行时缺、文本乱码。

**核心思想：agent 先了解自己的机器，再行动。**

- 检查系统、硬件、CPU、内存、磁盘、GPU、网卡、已装软件、编码、时区、语言区域。
- 生成**属于那台电脑自己的设备档案.md**。
- 预防经典坑：乱码（mojibake）、代码页错（936/GBK vs UTF-8）、LF/CRLF 不一致、语言时区错。

---

## 功能特性

- ✅ **一键检查** —— 一个脚本扫清一切。
- ✅ **跨平台** —— Windows（PowerShell）+ macOS/Linux（Python）。
- ✅ **自动生成设备档案.md** —— 专属那台机器。
- ✅ **后台守护** —— 静默心跳、写日志到 Obsidian、安全自愈指引（不经你同意绝不改系统）。
- ✅ **技能与工具注册** —— 给任何 DeepSeek Harness / Cherry Studio 会话注册 `device-inspector` 技能和 `check_device` 工具。
- ✅ **RAG-ready** —— 把档案向量化成本地可查询知识库。
- ✅ **有底线、讲真话** —— 只检查和解释，查不到就标注"待手动确认"。

---

## 目录结构

```
Wealth-device-inspector/
├── README.md              ← 本文件（英文使用说明）
├── README.zh.md           ← 中文使用说明
├── WHITEPAPER.md          ← 架构白皮书（项目怎么组织、数据流、如何扩展）
├── SKILL.md               ← 可复用的通用技能定义（供AI技能目录发现）
├── agent/
│   └── SOUL.md            ← 设备监察人设（通用版，不含任何具体机器数据）
├── device-monitor-plugin/ ← 后台守护插件（DeepSeek Harness 动态插件）
│   ├── plugin.js          ← 插件源码（心跳/日志/工具/技能注册）
│   └── package.json       ← 插件元数据
├── scripts/               ← 设备扫描脚本（跨平台）
│   ├── scan-device.ps1    ← Windows PowerShell 脚本
│   └── scan-device.py     ← Python 脚本（Win/Mac/Linux 通用）
├── format/                ← 落地格式规范
│   ├── 设备档案模板.md      ← 空模板（扫描脚本填这个）
│   └── 格式与编码.md        ← 通用格式/编码/时区规范
└── docs/                  ← 方法论文档
    ├── 通用技能.md         ← 换电脑照着做的方法论
    ├── 知识图谱与RAG.md    ← RAG 知识库接入框架
    ├── 后台守护与自愈.md    ← 后台静默守护与自愈说明
    └── 文件清单与归属.md    ← 每个文件该放本地还是仓库
```

---

## 快速开始（普通用户）

### 方式一：直接用脚本扫描（最简单）

**Windows（PowerShell）：**
1. 下载或克隆本仓库：
   ```powershell
   git clone https://github.com/JunbaoCao/Wealth-device-inspector.git
   cd Wealth-device-inspector
   ```
2. 运行 PowerShell 扫描脚本（一键）：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\scan-device.ps1
   ```
3. 当前文件夹出现 `设备档案.md`——这台电脑的完整信息。

**macOS / Linux：**
```bash
git clone https://github.com/JunbaoCao/Wealth-device-inspector.git
cd Wealth-device-inspector
python3 scripts/scan-device.py
```

### 方式二：作为智能体使用（进阶）

把 `agent/SOUL.md` 放进 Cherry Studio 的 `Data\Agents\<GUID>\`，或挂到 DeepSeek Harness 的 agent 预设。设备监察就成为一个会主动纠错、有底线的智能体。

### 每个脚本干什么

| 文件 | 干什么 | 什么时候用 |
|------|--------|-----------|
| `scripts/scan-device.ps1` | PowerShell 脚本：扫描系统/CPU/内存/磁盘/GPU/网卡/软件/编码/时区，写出 `设备档案.md` | Windows 用户，一键检查 |
| `scripts/scan-device.py` | Python 脚本：同样的扫描，跨平台 | Mac/Linux，或想用 Python 时 |
| `device-monitor-plugin/plugin.js` | DeepSeek Harness 动态插件：心跳 + 写日志到 Obsidian + `check_device` 工具 + 技能注册 | 在 DeepSeek Harness 里运行时 |

### 安装 agent（给开发者）

1. 克隆本仓库后，在 DSH 会话里注册插件（`device-monitor-plugin/plugin.js`）。
2. 或把 `agent/SOUL.md` 放进 Cherry Studio 的 agent 文件夹。
3. 你的 agent 就能调用 `check_device` 工具，`device-inspector` 技能会出现在技能目录。

---

## 生成的设备档案长这样

```markdown
# 设备档案（本机自动生成）

## 系统

| 计算机名 | LAPTOP-XXXX |
| 系统 | Windows 11 25H2 (Build 26200) |
| 架构 | x64 |

## 处理器 CPU

| 型号 | AMD Ryzen 5 7520U |
| 主频 | 2795 MHz |

## 内存 / 磁盘

| 内存 | 15.2 GB |
| 磁盘 | C: 205GB; D: 394GB; E: 354GB |

## 语言 / 时区 / 编码

| 系统语言 | zh-CN |
| 时区 | UTC+08:00 (北京) |
| 编码 | UTF-8 |
```

---

## 社区与支持

- 反馈/issues：[GitHub Issues](https://github.com/JunbaoCao/Wealth-device-inspector/issues)
- 在 MIT 许可下自由 fork、改造、复用。
- 给你的 fork 打上 `dsh-plugin` 话题，便于被发现。

## 开源协议

[MIT](LICENSE)

---

*模板由威尔思（Wealth）制作，供任何人检查和了解自己的电脑。*