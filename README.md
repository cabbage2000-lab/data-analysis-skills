# data-analysis-skills：把数据文件变成会讲故事的分析报告

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![language](https://img.shields.io/badge/language-简体中文优先-green)
![status](https://img.shields.io/badge/status-v0.18-blue)
![host](https://img.shields.io/badge/host-Claude%20Code%20%7C%20Codex%20%7C%20WorkBuddy-grey)

**简体中文** | [English](README.en.md)

这是一个用于数据分析的 **Agent Skill**——同一套包能装进 [Claude Code](https://claude.com/claude-code)、[Codex CLI](https://developers.openai.com/codex/cli)、WorkBuddy 等多种编程智能体，不绑定单一工具。把数据文件（CSV / Excel / JSON / TSV）丢给它，说一句「帮我分析」，它会像一位懂你行业的数据分析师那样工作：先和你确认业务背景，再完成清洗与分析，最后交付一份**单文件 HTML 交互式报告**——不是孤立的图表和数字，而是有洞察、有结论、能直接拿去汇报的数据故事。

**先看效果**：用浏览器打开 [`examples/sample_report.html`](examples/sample_report.html)——一份真实生成的 SaaS 经营分析报告（36 个月订阅数据，测试数据非真实客户）。需联网，图表库经 CDN 加载。

---

## 支持哪些智能体

| 宿主 | 用户级安装位置 | 验证到什么程度 |
|------|----------------|----------------|
| **Claude Code** | `~/.claude/skills/data-analysis-skills` | 主力宿主，T1–T14 全量 eval 通过 |
| **Codex CLI** | `~/.codex/skills/data-analysis-skills` | 已适配：任务清单走 `update_plan`、门禁提问降级为文本编号选择题；交互式全流程与 `codex exec` 冒烟验收通过 |
| **WorkBuddy** | `~/.workbuddy/skills/data-analysis-skills` | 已适配：安装路径已实测就位，**作者已在 WorkBuddy 实测可加载、可运行**；[跨宿主验收清单](docs/跨宿主验收清单.md)的 S1–S5 逐项核对尚未回填 |
| 其它同构工具 | 该工具自己的 skills 目录 | 只要读 `SKILL.md` + frontmatter + 子目录资源就能加载，未逐一实测 |

跨宿主的**不变量**：五阶段流程、阶段 1 确认门禁、统计纪律、报告六段式结构——这些不因宿主而变。**变的只有交互外观**：宿主有结构化提问工具就用（如 AskUserQuestion），没有就降级成编号文本选择题并等你回复；有任务清单工具就用（TodoWrite / update_plan），没有就打印纯文本阶段清单。**门禁本身从不降级，只有它的呈现方式会降级。**

## 它能帮你做什么

- 「这是我们二季度的订单数据，给我一份分析报告」→ 一份按零售视角组织的完整叙事报告：GMV、客单价、复购、退货，每张图配解读，结论先行
- 「帮我看看 A/B 实验里 B 方案是不是真的更好」→ 直接给出严谨的统计结论（p 值、置信区间、前提检查），不强迫你走完整报告流程
- 「分析下我账号这三个月的笔记数据」→ 按自媒体视角解读互动率、完播、涨粉效率
- 「这份预算执行表帮我做个经营分析」→ 按财务 FP&A 视角分析收入、毛利、费用率、预算达成

## 安装

三种装法任选其一。**装完要新开一个会话**才会加载——已经开着的会话看不到新 skill。

### 方式 A：把下面这段话粘给你的智能体（最省事，不用敲命令）

**装到 Claude Code** 👇

```text
帮我安装 data-analysis-skills 数据分析 skill：

1. 把 https://github.com/cabbage2000-lab/data-analysis-skills 克隆到一个临时目录
2. 确保 ~/.claude/skills/ 存在（没有就创建），把仓库里的
   skills/data-analysis-skills 整个目录复制进去
   - 复制的是这一个目录本身，不要把整个 skills/ 套进去
   - 同名目录直接覆盖，这就是更新
   - 该目录下其他来源的 skill 一个都别动，千万不要清空目录
   - 目录里的 assets/ industries/ references/ evals/ 必须一起带上，缺任何一个都会断链
3. 删掉临时目录
4. 告诉我装到了哪里
```

**装到 Codex** 👇

```text
帮我安装 data-analysis-skills 数据分析 skill：

1. 把 https://github.com/cabbage2000-lab/data-analysis-skills 克隆到一个临时目录
2. 确保 ~/.codex/skills/ 存在（没有就创建），把仓库里的
   skills/data-analysis-skills 整个目录复制进去
   - 复制的是这一个目录本身，不要把整个 skills/ 套进去
   - 同名目录直接覆盖，这就是更新
   - 该目录下其他来源的 skill 一个都别动，千万不要清空目录
   - 目录里的 assets/ industries/ references/ evals/ 必须一起带上，缺任何一个都会断链
3. 删掉临时目录
4. 告诉我装到了哪里
```

**装到 WorkBuddy** 👇

```text
帮我安装 data-analysis-skills 数据分析 skill：

1. 把 https://github.com/cabbage2000-lab/data-analysis-skills 克隆到一个临时目录
2. 确保 ~/.workbuddy/skills/ 存在（没有就创建），把仓库里的
   skills/data-analysis-skills 整个目录复制进去
   - 复制的是这一个目录本身，别把整个 skills/ 目录整体套进去——WorkBuddy 会按
     目录层级给技能命名，多套一层技能名就变成 skills:data-analysis-skills 了
   - 同名目录直接覆盖，这就是更新
   - 该目录下其他来源的 skill 一个都别动，千万不要清空目录
   - 目录里的 assets/ industries/ references/ evals/ 必须一起带上，缺任何一个都会断链
3. 删掉临时目录
4. 告诉我装到了哪里
```

WorkBuddy 还可以在「技能」面板里核对是否装上。

### 方式 B：插件市场一键安装（Claude Code / Codex）

本仓库自身就是插件市场，好处是能用一条命令更新。

Claude Code——在会话里依次执行：

```text
/plugin marketplace add cabbage2000-lab/data-analysis-skills
/plugin install data-analysis-skills@data-analysis-marketplace
```

更新用 `/plugin update data-analysis-skills`。

Codex——在终端里执行：

```bash
codex plugin marketplace add cabbage2000-lab/data-analysis-skills
codex plugin add data-analysis-skills@data-analysis-marketplace
```

WorkBuddy 走方式 A 的提示词路径（本仓库尚未提供经实测的 WorkBuddy 插件清单）。

方式 A 与方式 B 装的是同一套 skill，**别两种都装**——会出现两份、触发时重复。插件形态只改变它在宿主里的显示方式，不改变分析行为。

### 方式 C：克隆仓库 + 同步脚本（想改 skill 的人用这个）

```bash
git clone https://github.com/cabbage2000-lab/data-analysis-skills.git
cd data-analysis-skills

# 一条命令装进本机检测到的每一个宿主：
#   Claude Code 总装；Codex 仅当 ~/.codex/ 存在；WorkBuddy 仅当 ~/.workbuddy/ 存在
bash sync-to-user.sh
```

skills 目录不在默认位置时，用环境变量指定（也可以用它装到项目级目录）：

```bash
DATA_ANALYSIS_CLAUDE_SKILL=/your/path/data-analysis-skills bash sync-to-user.sh
DATA_ANALYSIS_CODEX_SKILL=/your/path/data-analysis-skills bash sync-to-user.sh
DATA_ANALYSIS_WORKBUDDY_SKILL=/your/path/data-analysis-skills bash sync-to-user.sh
```

以后想升级，`git pull` 后再跑一遍同一命令即可。

> **三个宿主的 skills 目录互不读取**——Codex 与 WorkBuddy 都不读 `~/.claude/skills/`，Claude Code 也不读 `~/.codex/skills/`。几个都用就各装一份。装错位置的表现是「skill 完全不出现，且没有任何报错」。
>
> **只想在单个项目里用？** 把用户级路径换成项目根目录下的项目级目录：Claude Code 用 `.claude/skills/`，Codex 用 `.codex/skills/`，**WorkBuddy 用 `.codebuddy/skills/`**——注意不是 `.workbuddy/`：它的用户级目录叫 `~/.workbuddy/`，项目级目录却沿用底层 CodeBuddy 内核的 `.codebuddy/`，这一处不对称写错了 skill 就一个都不出现。

### 方式 D：SkillHub 社区源（不用 clone，一条命令装）

[SkillHub](https://skillhub.cn) 是国内的 skill 社区，本 skill 已上架为 `@user_6733bad6/data-analysis-skills`。它的 CLI 有两个坑，**下面这条命令已经把两个都绕过了，照抄即可**：

```bash
# 装到 Claude Code；换成 ~/.codex/skills 或 ~/.workbuddy/skills 即装到另两个宿主
skillhub install data-analysis-skills --namespace user_6733bad6 --dir ~/.claude/skills \
  && mv ~/.claude/skills/@user_6733bad6/data-analysis-skills ~/.claude/skills/ \
  && rmdir ~/.claude/skills/@user_6733bad6
```

> **`--namespace user_6733bad6` 一个字都不能省。** SkillHub 的 slug 只在各自命名空间内唯一，`data-analysis-skills` 这个名字在别人的命名空间下**也有一个同名 skill**。省掉 `--namespace`，CLI 会走「远程精确匹配」装到那一个上去——落盘目录名一模一样、没有任何报错，你要打开 `SKILL.md` 才会发现装的根本不是这个包。
>
> **后面两行 `mv` + `rmdir` 也不能省。** 带 `--namespace` 安装会多套一层 `@user_6733bad6/` 目录，而宿主只扫 `skills/*/SKILL.md` 这一层，多一层就**一个都发现不了且同样没有报错**。

以后更新：重跑上面这条命令，`install` 那步加 `--force`（否则报 `Target exists`）。

四种方式装的是同一套 skill，**只挑一种**——装多份会在触发时重复。

## 怎么用

1. **给数据，说需求。** 在你的智能体里提供数据文件并表达分析诉求，例如：

   ```
   帮我分析这份销售数据：retail_orders.csv，给我一份报告
   ```

   不用背 skill 名字，说人话就会被匹配到；也可以显式点名 `data-analysis-skills`，两种等价。

2. **回答几个选择题。** 开始分析前它会和你确认行业、分析目标、报告受众（有结构化提问工具的宿主是点选，没有的是编号文本选择题）。别嫌烦——这一步决定报告「分析什么、对谁说话」，是给老板看的经营结论，还是给运营同学看的细节诊断。

3. **拿报告。** 它会依次完成数据理解 → 清洗 → 指标计算 → 分析 → 报告生成，最终交付一个 HTML 文件，用浏览器打开即可。

> **只想问个小问题？** 「帮我算下这两列的相关性」「B 组转化率显著更高吗」这类单点问题不会被强行拉去走完整流程——它会直接计算、直接回答，但统计上同样严谨。

## 你会得到一份什么样的报告

- **单个 HTML 文件**：双击打开、图表可交互（缩放、悬浮提示），可以直接发给同事（对方打开同样需要联网）
- **固定六段式、结论先行**：核心发现（3–5 条）→ 分析背景与目标 → 数据概况 → 深入分析（按行业主题分节）→ 结论与建议 → 附录·数据处理说明
- **每张图配一段解读**：图说明什么、意味着什么，而不是把图扔给你自己看
- **处理过程可追溯**：缺失值怎么处理的、异常值删没删，每个决策都记录在附录里
- **报告语言跟随你的提问语言**：中文提问得到中文报告

## 支持的行业与分析方法

| 行业 | 适用场景 | 报告会关注什么 |
|------|----------|----------------|
| 零售 / 电商 | 电商平台、线上店铺、线下/全渠道零售 | GMV、客单价、复购率、退货率、品类结构 |
| 互联网 / SaaS | 订阅制软件、互联网产品、会员制服务 | MRR/ARR、留存、流失率、净收入留存 |
| 自媒体 / 内容创作 | 小红书、抖音、B站、公众号等账号运营 | 互动率、完播率、粉丝净增、涨粉效率 |
| 企业财务 / FP&A | 损益、费用、预算、现金流分析 | 收入增长、毛利率、费用率、预算达成 |
| 基金 | 基金产品的业绩与运营数据 | 净值收益、最大回撤、规模申赎、持有人结构 |
| 房地产 | 房企项目销售与市场行情数据 | 签约去化、回款、市场量价趋势 |
| 建筑 | 建筑施工企业生产经营数据 | 项目产值进度、人材机成本、合同承接与回款 |
| 教育 / 培训 | 培训机构、在线教育平台 | 招生报名、续费留存、出勤完课、渠道获客 |
| 其他行业 | 以上都不沾边时自动走通用视角 | 规模、趋势、结构、分布，不硬套别的行业指标 |

遇到 A/B 测试、时间序列预测、因果推断、机器学习这类专门方法时，它会按需启用对应的方法模块，不需要你额外指定。多数据集输入（Excel 多 sheet、一次给多个文件、多结构 JSON）会先枚举全部数据源、和你确认关联策略，**绝不静默只读第一个 sheet**。

## 为什么结论值得信

这个 skill 带着「职业操守」工作，宁可少说，不会乱说：

- **不杜撰行业基准**。除非你提供基准数据或明确授权联网检索，否则它只做你数据内部的对比，绝不凭「记忆」报一个行业平均值。
- **相关 ≠ 因果**。没有经过因果方法验证，它不会说「A 带动了 B」，还会主动指出可能的混杂因素。
- **小样本不硬下结论**。样本不够时它会直说结论可信度有限——即使你说「老板今天就要结论」。
- **数据质量太差时先给诊断**。它会告诉你数据缺了什么、问题在哪、怎么补，而不是硬编一份看起来很完整的分析。

## 它不做什么

- 不搭建实时看板 / Dashboard 应用（产出是静态的单文件报告）
- 不做网页爬虫、不替你抓数据
- 不直连数据库——请先把数据导出成 CSV / Excel 等文件

## 常见问题

**装完了但它没反应？**
先确认三件事：① 装的位置是**你正在用的那个宿主**的 skills 目录（三家互不读取）；② 装的是 `data-analysis-skills` 这个目录本身，而不是外面套了一层 `skills/`；③ 装完**新开了一个会话**。WorkBuddy 可以在「技能」面板里直接看有没有。

**报告打开是空白的 / 图表不显示？**
报告的图表库通过 CDN 引入，打开时需要联网。CDN 选用的是国内可达的源。

**想要 PDF 或静态图片版本？**
明确提出即可（如「给我静态图」「导出 PDF」），它会改用静态图方案；报告右上角也有「导出 PDF」按钮。

**需要自己装 Python 环境或依赖包吗？**
分析在你的智能体里本地用 Python 执行，缺少 pandas 等依赖时它会自动尝试安装，安装失败也有降级方案，一般不需要你操心。

**它问我行业和目标，能跳过吗？**
完整报告前的确认是刻意设计的：数据长得像零售数据，不代表你想要零售视角的解读。花十秒选一下，报告会更对味。如果只是问单点小问题，则不会有这一步。

## 仓库结构

```
skills/data-analysis-skills/      # 交付物本体（装到宿主里的就是这个目录）
  SKILL.md                       #   核心层：五阶段流程、门禁、统计纪律
  assets/report_template.html    #   单文件 HTML 报告模板（头部注释是数据契约）
  industries/                    #   行业模版 9 个（按需加载）
  references/                    #   方法模块 6 个（按需加载）
  evals/evals.json               #   评估场景定义（T1–T14）
examples/sample_report.html      # 示例产出：报告长什么样
.claude-plugin/ .codex-plugin/ .agents/   # 插件市场清单（方式 B 用）
sync-to-user.sh                  # 三宿主同步脚本（方式 C 用）
docs/                            # 版本号规划、跨宿主验收清单
CHANGELOG.md                     # 版本变更记录
```

需求文档与开发工作区（测试数据、校验脚本、各轮 eval 记录）留在本地，未随仓库发布——仓库里发布的是 skill 本身与装它所需的东西。

## 许可协议

本项目以 [MIT 协议](LICENSE) 开源 © 2026 cabbage2000-lab。
