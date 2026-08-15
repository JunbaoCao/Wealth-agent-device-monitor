# Wealth device-inspector · 设备监察

English | [中文](README.zh.md)

**Wealth（威尔思）** 出品的开源**设备监察 agent**：在任意电脑上**一键自查**系统、硬件、语言、编码、时区，自动生成属于那台电脑自己的 `设备档案.md`，防止环境出错。它是你 agent 的**架构底层**——先懂自己的设备，再跑任何智能体。

**License: MIT**

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
    └── 后台守护与自愈.md    ← Background-guardian & self-healing guide
```

---

## Quick start

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\scan-device.ps1
```

**macOS / Linux:**
```bash
python3 scripts/scan-device.py
```

This generates `设备档案.md` — the full picture of this machine.

### Use as an agent (advanced)

Put `agent/SOUL.md` into Cherry Studio's `Data\Agents\<GUID>\` or mount to a DeepSeek Harness agent preset.

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