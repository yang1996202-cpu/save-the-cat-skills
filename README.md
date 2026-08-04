# 救猫咪故事创作 · 跨平台母子 skill 套件

把《救猫咪》故事方法论外化成 **母编排器 + 6 个单一职责子 skill**。同一套方法、同一个故事核心，在 **Claude Code / OpenAI Codex / 腾讯 WorkBuddy** 三个 AI 上通用——三者都以 `SKILL.md` 为 skill 核心指令文件（agentskills.io 跨平台标准）。

## 它解决什么

"写好一个故事"被拆成母 + 子。母 `save-the-cat` 守住故事主线并路由，子各自只交付一种产物。点子前提不成立就停在点子阶段；主干没想清楚就不填十五拍；诊断发现上游问题不先润色台词。

范围只到故事创作与改稿：`点子 → 故事核心 → 整体结构 → 场景规划 → 场景正文 → 诊断与重写`。分镜、视频生成提示词是故事确认后的后续生产，不进本套件。

## 母子结构

| | skill | 入口 | 职责 |
|---|---|---|---|
| 母 | `save-the-cat` | `/save-the-cat` | 守住主线，识别阶段，调用子 skill，管理交接与回退 |
| 子 | `stc-idea-check` | `/stc-idea-check` | 模糊点子 → 故事核心卡 |
| 子 | `stc-beatsheet` | `/stc-beatsheet` | 故事核心 → 三个世界 + BS2 十五拍 |
| 子 | `stc-scene-cards` | `/stc-scene-cards` | 节拍 → 可逐场写作的场景卡 |
| 子 | `stc-scene-write` | `/stc-scene-write` | 场景卡 → 场景正文 |
| 子 | `stc-diagnose` | `/stc-diagnose` | 已有文本 → 证据化改稿单 |
| 子 | `stc-first-aid` | `/stc-first-aid` | 创作者卡住 → 一剂急救 |

母编排器不亲自写产物，调用对应子 skill 执行；每个子 skill 也能独立调用。`stc-idea-check` 为兼容旧调用保留原名，实际工作是"点子发展"，不是给点子打分。

## 三平台通用

| 平台 | skills 目录 | 备注 |
|---|---|---|
| Claude Code | `~/.claude/skills/<skill>/` | 认 SKILL.md |
| OpenAI Codex | `~/.codex/skills/<skill>/` | 额外读 `agents/openai.yaml`（UI 调用配置） |
| 腾讯 WorkBuddy | `~/.workbuddy/skills/<skill>/` | 认 SKILL.md |

三平台都只扫一层 `skills/<name>/SKILL.md`，不递归——所以母和每个子都要各自装到 skills 目录下。

## 安装

7 个 skill（母 `save-the-cat` + 6 子 `stc-*`）放到目标平台 skills 目录。推荐 symlink（源单一，改一处三平台同步）：

```bash
SRC=/path/to/save-the-cat          # 本仓库根目录
bash -c '
for plat in "$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.workbuddy/skills"; do
  mkdir -p "$plat"
  ln -sfn "'"$SRC"'" "$plat/save-the-cat"
  for s in stc-idea-check stc-beatsheet stc-scene-cards stc-scene-write stc-diagnose stc-first-aid; do
    ln -sfn "'"$SRC"'/$s" "$plat/$s"
  done
done
'
```

> 用 `bash -c` 是因为 zsh 不做词分割，直接 `for s in $LIST` 只会循环一次。新 skill 可能要重启会话/app 才加载。

拷贝安装（分发给别人）：把整个仓库拷到对方机器，再跑上面的脚本（`SRC` 指向解压后的根）。

## 使用

- **从零创作或改稿**：`/save-the-cat`（母带你走完整流程，每阶段可确认）
- **只要某一步**：直接 `/stc-beatsheet`、`/stc-diagnose` 等

两种常用入口：

> 用 save-the-cat 把这个方向发展成完整故事，每个阶段让我确认。
>
> 用 save-the-cat 强势改这个故事——先找根本问题，再直接重写，别只给建议。

## 目录结构

```text
save-the-cat/
├── SKILL.md                 ← 母编排器
├── agents/openai.yaml       ← 母的 Codex 调用配置
├── README.md
├── references/              ← 跨阶段共享契约
│   ├── story-creation-contract.md   主干五问、原始吗、主角赢的正当性
│   └── source-ledger.md             方法来源与归属
├── scripts/verify-source.sh ← 核对原始划线文件哈希
├── evaluations/             ← 触发与质量评测用例
├── stc-idea-check/          ← 子：点子发展
├── stc-beatsheet/           ← 子：节拍结构
├── stc-scene-cards/         ← 子：场景卡
├── stc-scene-write/         ← 子：场景写作
├── stc-diagnose/            ← 子：诊断
└── stc-first-aid/           ← 子：急救
```

每个子 skill：`SKILL.md`（三平台通用）+ `agents/openai.yaml`（Codex）+ 可选 `references/`（本阶段深度参考）。

## 方法论核心（简，详细见 references）

- **跟着谁**：最值得跟随、面对最大冲突、最长情感旅程的主角。
- **原始吗**：表面目标剥到生存、饥饿、性、保护所爱之人、死亡恐惧等基本本能。
- **变化**：清楚开始与结束状态，结尾用行动兑现。
- **结构**：三个世界（转变机器）+ BS2 十五拍安排变化。
- **场景**：每场一个主要冲突、一次首尾转变。
- **主角赢的正当性**：被主角击败的人要"该被击败"（主动越界）；不能踩着无辜好人赢还被故事奖励。

跨阶段不能漂移的创作主线与交接格式，全在 `references/story-creation-contract.md`，本 README 只点题，不复制。

## 来源与保护

主要资料是《救猫咪》三部曲的划线摘录（非全书全文）。原始文件不进本仓库、不可修改。

- `references/source-ledger.md`：方法行号、唯一主责、官方补充与整理者延伸。
- `references/story-creation-contract.md`：跨阶段共同创作主线。
- `scripts/verify-source.sh /path/to/救猫咪三部曲.md`：核对哈希、行数、字节数防漂移。

方法标记：`[摘录]`（本地可核查）/ `[官方补充]`（补自官方材料）/ `[整理者延伸]`（为 AI 工作流加，不冒充原法则）。

## 已作废的实验

`evaluations/runs/2026-07-30-superhero-blind*` 是六轮同题实验，**不是有效盲测或好故事样例**：原始点子前提没先证明成立，轮次间又改 skill 再用同一题（针对考题调参），中间版本未逐轮提交。衍生出的特殊能力、救援设备、专业权限、精确时间核验等已从运行时删除。这些文件只作失败档案，不指导通用创作。下一轮验证应冻结 skill 版本、用真实故事。
