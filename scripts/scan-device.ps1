# 监察师 · 设备扫描脚本（Windows PowerShell）
# 用途：一键扫描本机，生成"设备档案.md"。
# 用法：powershell -ExecutionPolicy Bypass -File .\scripts\scan-device.ps1
# 输出：在当前目录生成 设备档案.md

$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== 监察师 · 设备扫描开始 ==="
$ErrorActionPreference = 'SilentlyContinue'

# 基本系统信息
$hostname = $env:COMPUTERNAME
$osCaption = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ProductName
$osBuild = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').CurrentBuild
$osDisplay = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion
$osArch = $env:PROCESSOR_ARCHITECTURE

# CPU
$cpu = (Get-ItemProperty 'HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0').ProcessorNameString
$cpuMhz = (Get-ItemProperty 'HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0').'~MHz'
$cpuThreads = $env:NUMBER_OF_PROCESSORS

# 内存
$mem = $null
try { $cs = Get-CimInstance Win32_ComputerSystem; $mem = [math]::Round($cs.TotalPhysicalMemory/1GB,1) } catch { $mem = "需管理员权限" }

# 磁盘
$disks = @()
try { $drives = [System.IO.DriveInfo]::GetDrives(); foreach($d in $drives){ if($d.IsReady){ $disks += ("{0} 总{1}GB 剩{2}GB" -f $d.Name, [math]::Round($d.TotalSize/1GB,1), [math]::Round($d.TotalFreeSpace/1GB,1)) } } } catch { $disks = "无" }

# GPU
$gpu = $null
$gpuClass = Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}'
foreach($x in $gpuClass){ $v = Get-ItemProperty $x.PSPath; if($v.'DriverDesc'){ $gpu = $v.'DriverDesc'; break } }
if(-not $gpu){ $gpu = "未识别" }

# 网卡
$nics = @()
$nicClass = Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}'
foreach($x in $nicClass){ $v = Get-ItemProperty $x.PSPath; if($v.'DriverDesc' -and $v.'DriverDesc' -notmatch 'Miniport'){ $nics += $v.'DriverDesc' } }

# 语言/时区/编码
$culture = (Get-Culture).Name
$timezone = (Get-TimeZone).Id
$codePage = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage').ACP
$consoleEnc = [Console]::OutputEncoding.WebName

# 软件（去重）
$soft = @()
$regPaths = @('HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*')
foreach($p in $regPaths){ $items = Get-ItemProperty $p; foreach($i in $items){ if($i.DisplayName){ $soft += ("{0} {1}" -f $i.DisplayName, $i.DisplayVersion) } } }
$soft = $soft | Sort-Object -Unique

# 生成 Markdown
$md = @"
---
tags:
  - 监察师
  - 设备档案
  - 自动生成
created: $((Get-Date -Format 'yyyy-MM-dd'))
---

# 设备档案（本机自动生成）

> 由监察师扫描脚本自动生成，记录本机系统/硬件/软件/编码/时区信息。

## 系统
| 项目 | 值 |
|------|-----|
| 计算机名 | $hostname |
| 系统 | $osCaption ($osDisplay, Build $osBuild) |
| 架构 | $osArch |
| 用户 | $env:USERNAME |

## 处理器 CPU
| 项目 | 值 |
|------|-----|
| 型号 | $cpu |
| 主频 | $cpuMhz MHz |
| 线程 | $cpuThreads |

## 内存 / 磁盘
| 项目 | 值 |
|------|-----|
| 内存 | $mem GB |
| 磁盘 | $($disks -join '; ') |

## 显卡 / 网卡
| 项目 | 值 |
|------|-----|
| 显卡 | $gpu |
| 网卡 | $($nics -join '; ') |

## 语言 / 时区 / 编码
| 项目 | 值 |
|------|-----|
| 系统语言 | $culture |
| 时区 | $timezone |
| 代码页 | $codePage |
| 控制台编码 | $consoleEnc |

## 已装软件（部分）
$($soft -join "`n")
"@

$outFile = Join-Path (Get-Location) '设备档案.md'
$md | Out-File -FilePath $outFile -Encoding UTF8
Write-Host "✅ 已生成：$outFile"
Write-Host "将本文件纳入 Obsidian 监察师文件夹即可使用。"