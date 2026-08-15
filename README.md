# 🕵️ 监察师 · 通用设备监察模板

> **一个可以复制到任何电脑、在本地检查自己机器的智能体技能包。**
> 克隆下来 → 运行扫描 → 生成"我的设备档案" → 配合后台守护与 RAG 使用。

---

## 这是什么

监察师是一套**泛式（通用）设备监察方案**。它不绑定某台特定电脑，而是提供一整套方法、脚本和框架，让任何人（包括不懂命令的普通人）在**自己的电脑上**一键查清自己的设备。

**核心思想：工具是通用的，数据是动态生成的。**

- **通用部分（本仓库）**：方法、脚本、格式、后台守护插件、技能定义——复制到哪台电脑都能用。
- **动态部分（运行后生成）**：每台电脑执行扫描脚本后，自动生成**属于那台电脑自己的设备档案.md**。

---

## 快速开始（普通用户）

### 方式一：直接用脚本扫描（最简单）
在电脑上打开 PowerShell 或终端，运行：</think>It looks like my response was cut off mid-generation. Let me continue by creating the actual template files in the `E:\dsh-workspace\监察师-template` folder. Let me build the template content and commit it.

Let me create the template files.

<｜DSML｜tool_calls>
<｜DSML｜invoke name="write">
<｜DSML｜parameter name="content" string="true"># 🕵️ 监察师 · 通用设备监察模板

> **一个可以复制到任何电脑、在本地检查自己机器的智能体技能包。**
> 克隆下来 → 运行扫描 → 生成"我的设备档案" → 配合后台守护与 RAG 使用。

---

## 这是什么

监察师是一套**泛式（通用）设备监察方案**。它不绑定某台特定电脑，而是提供一整套方法、脚本和框架，让任何人（包括不懂命令的普通人）在**自己的电脑上**一键查清自己的设备。

**核心思想：工具是通用的，数据是动态生成的。**

- **通用部分（本仓库）**：方法、脚本、格式、后台守护插件、技能定义——复制到哪台电脑都能用。
- **动态部分（运行后生成）**：每台电脑执行扫描脚本后，自动生成**属于那台电脑自己的设备档案.md**。

---

## 快速开始（普通用户）

### 方式一：直接用脚本扫描（最简单）
在电脑上打开 PowerShell（Windows）或终端（Mac/Linux），运行：

**Windows（PowerShell）：**
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\scan-device.ps1
```
**Mac / Linux：**
```bash
python3 scripts/scan-device.py
```

运行后会在当前目录生成 **`设备档案.md`**，里面就是这台电脑的完整信息：系统、CPU、内存、磁盘、GPU、网卡、软件、编码、时区。

### 方式二：作为智能体使用（进阶）
把 `agent/SOUL.md` 放进 Cherry Studio 的 `Data\Agents\<GUID>\`，或挂到 DeepSeek Harness 的 agent 预设，监察师就成为一个会主动纠错、有底线的智能体。

---

## 目录结构

```
监察师-template/
├── README.md                 ← 本文件（使用说明）
├── SKILL.md                  ← 可复用的通用技能定义（供AI技能目录发现）
├── agent/
│   └── SOUL.md               ← 监察师人设（通用版，不含任何具体机器数据）
├── device-monitor-plugin/    ← 后台守护插件（DeepSeek Harness 动态插件）
│   ├── plugin.js             ← 插件源码（心跳/日志/工具/技能注册）
│   └── package.json          ← 插件元数据
├── scripts/                  ← 设备扫描脚本（跨平台）
│   ├── scan-device.ps1       ← Windows PowerShell 脚本
│   └── scan-device.py        ← Python 脚本（Win/Mac/Linux 通用）
├── format/                   ← 落地格式规范
│   ├── 设备档案模板.md        ← 空模板（扫描脚本填这个）
│   └── 格式与编码.md          ← 通用格式/编码/时区规范
└── docs/                     ← 方法论文档
    ├── 通用技能.md            ← 换电脑照着做的方法论
    ├── 知识图谱与RAG.md       ← RAG 知识库接入框架
    └── 后台守护与自愈.md      ← 后台静默守护与自愈说明
```

---

## 模板内容清单（已全部就位）

| 文件 | 作用 |
|------|------|
| `SKILL.md` | 技能定义，让任何AI会话能发现"监察师"技能 |
| `agent/SOUL.md` | 监察师人设（有底线+苏格拉底纠错+普通人友好） |
| `device-monitor-plugin/plugin.js` | 后台守护插件（心跳、日志到Obsidian、设备检查工具） |
| `scripts/scan-device.ps1` | Windows 一键扫描脚本，生成设备档案 |
| `scripts/scan-device.py` | 跨平台 Python 扫描脚本 |
| `format/设备档案模板.md` | 设备档案空模板 |
| `format/格式与编码.md` | 编码/换行/时区通用规范 |
| `docs/通用技能.md` | 换电脑照做的方法论 |
| `docs/知识图谱与RAG.md` | 知识库/RAG 接入框架 |
| `docs/后台守护与自愈.md` | 后台静默守护与自愈说明 |

---

## 我该怎么用（三步）

1. **克隆或下载本仓库**到你的电脑。
2. **运行扫描脚本**（`scan-device.ps1` 或 `scan-device.py`）→ 生成你的 `设备档案.md`。
3. **把档案放进 Obsidian**，配合监察师人设和后台守护使用；要查资料就接 RAG（见 docs）。

---

*本模板由监察师智能体制作，供任何人免费复用。有问题可让监察师基于你的实际设备数据回答。*