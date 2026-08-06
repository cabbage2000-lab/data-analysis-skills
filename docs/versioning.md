# 版本号规划

> 适用于 `data-analysis-skill` 项目，从 v0.15 起正式执行。

## 版本模型

采用 **语义化版本（SemVer）**，结合 skill 项目特殊性调整：

```
MAJOR.MINOR.PATCH
  │     │     │
  │     │     └─ 模板修复、文案调整、eval 补充、Bug 修复（向前兼容）
  │     └─────── 新增行业模版、新增方法模块、模板数据契约扩展（向前兼容）
  └───────────── 五阶段流程变更、模板数据契约破坏性变更、SKILL.md 核心纪律重写
```

### Skill 项目的版本语义

与库/应用不同，skill 的「破坏性变更」主要影响两方面：

1. **已生成报告的渲染**：模板数据契约删除/重命名字段 → 旧数据无法正确渲染
2. **调用方行为**：五阶段流程增删阶段、门禁规则结构性变动 → 依赖旧流程的 eval/集成需重写

新增行业模版/方法模块不影响任何现有行为，因此只升 MINOR。

## 版本 bump 规则速查

| 变更类型 | 版本 bump | 示例 |
|----------|-----------|------|
| 新增行业模版 `industries/*.md` | MINOR | v1.0 → v1.1 |
| 新增方法模块 `references/*.md` | MINOR | v1.0 → v1.1 |
| **新增宿主支持**（安装路径 + 条款中立化 + 分发形态） | MINOR | v0.16.1 → v0.17（先例：v0.9 Codex 适配） |
| 模板数据契约**新增**字段（旧数据仍可渲染） | MINOR | v1.0 → v1.1 |
| 模板数据契约**删除/重命名**字段 | MAJOR | v1.0 → v2.0 |
| 五阶段流程增加/删除阶段 | MAJOR | v1.0 → v2.0 |
| SKILL.md 门禁规则增加（收紧） | PATCH | v1.0.0 → v1.0.1 |
| 模板 CSS/排版微调 | PATCH | v1.0.0 → v1.0.1 |
| CDN 版本升级（如 ECharts 5.4.3→5.5.0） | PATCH | v1.0.0 → v1.0.1 |
| 修复 eval 断言或测试数据 | PATCH | v1.0.0 → v1.0.1 |
| 文档/README/CLAUDE.md 更新 | 不单独升版 | 随最近一次代码变更一起发 |

## 当前阶段：v0.x → v1.0 过渡

v0.x 阶段允许破坏性变更（MINOR 即可含不兼容调整）。以下条件全部满足后发布 v1.0.0：

| 里程碑 | 说明 | 状态 |
|--------|------|------|
| 核心流程冻结 | 五阶段流程 + 门禁规则不再有结构性变动 | ⬜ 待确认 |
| 模板契约冻结 | `report_template.html` 头部数据契约承诺向后兼容 | ⬜ 待确认 |
| 首批模版齐全 | 首批规划的行业模版全部交付（含 stock、finance） | ⬜ 进行中 |
| Evals 全绿 | T1–T14 全部 with_skill 通过，且一轮 iteration 无新增失败 | T1–T7 ✅ iteration-1；T8–T12 ⬜ 待 iteration-5；T13–T14 ✅ iteration-6 |
| 文档同步 | README / CLAUDE.md / 需求文档三者对齐，无滞后描述 | ✅ v0.17 对齐一轮（README 中英双版 + CLAUDE.md + 需求文档 §1/§9 + 本文件） |
| 跨宿主验收 | 三宿主门禁/纪律/报告结构一致性核对表全项回填 | ⬜ WorkBuddy 待跑（`docs/跨宿主验收清单.md`） |

v1.0.0 发布后，MINOR 升级承诺不破坏已有报告渲染。

## 路线图

```
v0.15 (2026-06-12)
 │  9 行业模版 · 5 方法模块 · Grid.js 表格双模式
 │
 ▼
v0.16 (2026-06-14)
 │  多数据集输入支持（Excel 多 sheet / CSV 多文件 / JSON 多结构）
 │  + references/data-sources.md + JSON/TSV 基础覆盖 + T8–T12
 │  里程碑：Phase 1 增加多源识别子步骤（非新增阶段，五阶段主线未变）
 │
 ▼
v0.16.1 (2026-06-15)
 │  方法模块端到端 eval 补全：T13（时序预测）/ T14（ML 泄漏与不平衡）
 │  + time-series.md 补定阶依据 + 样本外回测两节（P1-1）
 │  首次启用 PATCH 三段号（eval 补充 + 方法模块纪律收紧，无新模块/契约/流程变更）
 │  判别力诚实记录：T13 方法层判别力弱（baseline 自发做回测），价值在报告规范+保证性
 │
 ▼
v0.17 (2026-08-06, 当前)
 │  三宿主通用化：新增 WorkBuddy（Claude Code / Codex CLI / WorkBuddy）
 │  + SKILL.md 宿主条款中立化（门禁不降级，只降级呈现）
 │  + 插件市场分发形态（.claude-plugin / .codex-plugin / .agents）
 │  + README 中文优先（README.md 中文 / README.en.md 英文）
 │  + docs/跨宿主验收清单.md（WorkBuddy 冒烟待回填）
 │  五阶段流程 / 统计纪律 / 模板契约均未动
 │
 ▼
v0.18
 │  stock.md 交付 (#11) + 方法模块增强（时序分解 / 异常检测）
 │  里程碑：若此版五阶段流程无变动 → 标记「流程冻结」
 │
 ▼
v0.19
 │  finance.md 交付 (#2) + 餐饮模版（如确认需求）
 │  里程碑：模板数据契约扩展到此版冻结，后续只做兼容性扩展
 │
 ▼
v0.20
 │  Beta 预发布版：全量 eval 重跑 + 文档对齐审计 + 外部用户试用
 │  最后一个 0.x，允许标注「已知限制」
 │
 ▼
v1.0.0
 │  正式发布 · 首个 GitHub Release + 完整发布说明
 │  承诺：MINOR 升级不破坏已有报告渲染
 │
 ▼
v1.1.0   新增行业模版（如政府/公共事业）+ 社区模版 PR 流程
v1.2.0   方法模块：NLP 情感分析 + 更多高级分析
v1.3.0   导出格式扩展（Markdown / PDF）
v2.0.0   （远期）交互式探索阶段、多报告批量生成等架构级变更
```

## Git Tag 与 GitHub Release 策略

- 每个 **MINOR 及以上**版本创建 GitHub Release
- PATCH 版本不单独发 Release（重要 hotfix 除外）
- `CHANGELOG.md` 记录所有变更，Release notes 从中提取摘要
- `[Unreleased]` 段作为下一版的 staging area

```bash
# 发布流程
git tag -a v1.0.0 -m "v1.0.0: 首个正式发布版"
git push origin v1.0.0

gh release create v1.0.0 \
  --title "v1.0.0 — 正式发布" \
  --generate-notes
```

## CHANGELOG 维护规范

- 每个版本段按类型分组：`feat` / `fix` / `docs` / `refactor`
- 版本号与需求文档版本对齐（需求文档内版本号为准）
- 日期使用 ISO 格式（YYYY-MM-DD）
- `[Unreleased]` 下的条目在发版时移入具体版本段
