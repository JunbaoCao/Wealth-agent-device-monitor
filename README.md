# Wealth device-inspector · 设备监察

English | [中文](README.zh.md) | **[架构白皮书](WHITEPAPER.md)**

**Wealth（威尔思）** 出品的开源**设备监察 agent**：在任意电脑上**一键自查**系统、硬件、语言、编码、时区，自动生成属于那台电脑自己的 `设备档案.md`，防止环境出错。它是你 agent 的**架构底层**——先懂自己的设备，再跑任何智能体。

**License: MIT · Version: v1.3.0（2026-08-14）**

> 📖 想了解整个项目怎么组织、数据怎么流动、怎么扩展？看 **[WHITEPAPER.md（架构白皮书）](WHITEPAPER.md)**。

## In plain words (What this is for)

> **You don't need to be technical.** This tool helps an AI agent (or you) **figure out your own computer first**, before it tries to do anything else. It checks: what system you have, what hardware, what language/encoding, what timezone — and writes it all into a `设备档案.md` file. This prevents the classic problems (garbled text, wrong language, broken code) that happen when an agent doesn't know its machine keyboard。

**One click → you know your computer. That's all.**

---

## What it is

An open-source **device-inspector** for AI agents. Its job is not auditing finances — it is **inspecting the machine environment** so an agent never trips over its own system: wrong encoding, broken locale, missing runtime, garbled text.

**Core idea: the agent knows its machine first, then acts.**

- Inspects system, hardware, CPU, RAM, disk, GPU, NIC, installed software, encoding, timezone, locale.
- Generates a `设备档案.md` specific to that computer.
- Prevents the classic failures: mojibake (乱码), wrong code page (936/GBK vs UTF-8), LF/CRLF mismatch, wrong language/zone.

---

## Features

- ✅ **One-click inspection** — a single script scans everything.
- ✅ **Cross-platform** — Windows (PowerShell) + macOS/Linux (Python).
- ✅ **Auto-generates device-report.md** — tailored to that exact machine.
- ✅ **Background guardian** — silent heartbeat, logs to Obsidian, safe self-healing guidance (never modifies your system without consent).
- ✅ **Skill & tool registration** — `device-inspector` skill + `check_device` tool for any DeepSeek Harness / Cherry Studio session.
- ✅ **RAG-ready** — vectorize reports into a local queryable knowledge base.
- ✅ **Honest & bottom-line** — only inspects and explains; flags unreadable items as "待手动确认".

---

## Repository structure

```
Wealth-device-inspector/
├── README.md              ← This file (English usage guide)
├── README.zh.md           ← Chinese usage guide
├── WHITEPAPER.md          ← Architecture whitepaper (organization, data flow, extension)
├── SKILL.md               ← Reusable generic skill definition (for AI skill discovery)
├── agent/
│   └── SOUL.md            ← Device-inspector persona (generic, no machine-specific data)
├── device-monitor-plugin/ ← Background-guardian plugin (DeepSeek Harness dynamic plugin)
│   ├── plugin.js          ← Plugin source (heartbeat / logging / tool / skill registration)
│   └── package.json       ← Plugin metadata
├── scripts/               ← Device scan scripts (cross-platform)
│   ├── scan-device.ps1    ← Windows PowerShell script
│   └── scan-device.py     ← Python script (Win / Mac / Linux)
├── format/                ← Output format spec
│   ├── 设备档案模板.md      ← Empty template (filled by scan scripts)
│   └── 格式与编码.md        ← Generic format / encoding / timezone spec
└── docs/                  ← Methodology documents
    ├── 通用技能.md         ← Reusable methodology for any machine
    ├── 知识图谱与RAG.md    ← RAG knowledge-base integration framework
    ├── 后台守护与自愈.md    ← Background-guardian & self-healing guide
    └── 文件清单与归属.md    ← Where each file goes (local vs repo)
```

---

## Quick start

### Option 1: Scan with a script (simplest)

**Windows (PowerShell):**
1. Download or clone this repo:
   ```powershell
   git clone https://github.com/JunbaoCao/Wealth-device-inspector.git
   cd Wealth-device-inspector
   ```
2. Run the PowerShell scan script (one click):
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\scan-device.ps1
   ```
3. A file `设备档案.md` appears in the current folder — the full picture of this machine.

**macOS / Linux:**
```bash
git clone https://github.com/JunbaoCao/Wealth-device-inspector.git
cd Wealth-device-inspector
python3 scripts/scan-device.py
```

### Option 2: Use as an agent (advanced)

Put `agent/SOUL.md` into Cherry Studio's `Data\Agents\<GUID>\` or mount it to a DeepSeek Harness agent preset. The device-inspector then becomes an agent that proactively corrects misconceptions and stays honest.

### What each script does

| File | What it does | When to use it |
|------|-------------|----------------|
| `scripts/scan-device.ps1` | PowerShell script: scans system/CPU/RAM/disk/GPU/NIC/software/encoding/timezone, writes `设备档案.md` | Windows users, one-click inspection |
| `scripts/scan-device.py` | Python script: same scan, cross-platform | Mac/Linux, or if you prefer Python |
| `device-monitor-plugin/plugin.js` | DeepSeek Harness dynamic plugin: heartbeat + logs to Obsidian + `check_device` tool + skill registration | When running inside DeepSeek Harness |

### How to install the agent (for developers)

1. Clone this repo, then in a DSH session register the plugin (`device-monitor-plugin/plugin.js`).
2. Or put `agent/SOUL.md` into a Cherry Studio agent folder.
3. The `check_device` tool becomes callable by your agent; the `device-inspector` skill appears in the skill catalog.

---

## The generated report looks like

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

## Community and support

- Feedback / issues: [GitHub Issues](https://github.com/JunbaoCao/Wealth-device-inspector/issues)
- Fork, adapt, and reuse freely under the MIT license.
- Tag your fork with the `dsh-plugin` topic for discoverability.

## License

[MIT](LICENSE)

---

*Crafted by Wealth (威尔思) for anyone to inspect and understand their own computer.*