# data-analysis-skill: Turn data files into analysis reports that tell a story

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![language](https://img.shields.io/badge/language-Chinese%20first-green)
![status](https://img.shields.io/badge/status-v0.17-blue)
![host](https://img.shields.io/badge/host-Claude%20Code%20%7C%20Codex%20%7C%20WorkBuddy-grey)

[简体中文](README.md) | **English**

This is an **Agent Skill** for data analysis — one package installs into [Claude Code](https://claude.com/claude-code), the [Codex CLI](https://developers.openai.com/codex/cli), WorkBuddy and other coding agents, instead of being tied to any single one. Hand it a data file (CSV / Excel / JSON / TSV), say "analyze this", and it works like a data analyst who knows your industry: it first confirms the business context with you, then cleans and analyzes the data, and finally delivers a **single-file interactive HTML report** — not isolated charts and numbers, but a data story with insights and conclusions you can take straight into a meeting.

**See it first**: open [`examples/sample_report.html`](examples/sample_report.html) in your browser — a real generated SaaS business review (36 months of subscription data; test data, not a real customer's). Internet access required, since chart libraries load from CDN.

---

## Supported hosts

| Host | User-level install path | How far it's verified |
|------|-------------------------|-----------------------|
| **Claude Code** | `~/.claude/skills/data-analysis-skill` | Primary host; the full T1–T14 eval suite passes |
| **Codex CLI** | `~/.codex/skills/data-analysis-skill` | Adapted: task list via `update_plan`, the confirmation gate degrades to numbered plain-text choices; interactive end-to-end and `codex exec` smoke tests passed |
| **WorkBuddy** | `~/.workbuddy/skills/data-analysis-skill` | Adapted: install path verified on a real machine and covered by the sync script; interactive behavior is smoke-tested by hand per the [cross-host acceptance checklist](docs/跨宿主验收清单.md) (honest note: not yet fully filled in) |
| Other structurally identical tools | that tool's own skills directory | Anything that reads `SKILL.md` + frontmatter + subdirectory resources can load it; not individually tested |

What stays **invariant** across hosts: the five-phase workflow, the Phase 1 confirmation gate, the statistical discipline, and the six-section report structure. What changes is only the **interaction surface**: if the host has a structured-questioning tool it is used (e.g. AskUserQuestion); if not, the questions degrade to numbered plain text and it waits for your reply. If the host has a task-list tool it is used (TodoWrite / update_plan); if not, the phase checklist is printed as plain text. **The gate itself never degrades — only its presentation does.**

## What it can do for you

- "Here's our Q2 order data — give me an analysis report" → a complete narrative report organized from a retail perspective: GMV, average order value, repeat purchases, returns — every chart comes with an interpretation, conclusions first
- "Check whether variant B in my A/B test is actually better" → a rigorous statistical answer (p-value, confidence interval, assumption checks) without forcing you through the full report pipeline
- "Analyze my account's posts from the past three months" → interpreted through a content-creator lens: engagement rate, completion rate, follower growth efficiency
- "Do a business review of this budget execution sheet" → analyzed from an FP&A perspective: revenue, gross margin, expense ratios, budget attainment

## Installation

Pick any one of the three routes below. **Open a new session afterwards** — sessions already running won't see the new skill.

### Route A: paste the block below to your agent (no commands to type)

**Install into Claude Code** 👇

```text
Please install the data-analysis-skill for me:

1. Clone https://github.com/cabbage2000-lab/data-analysis-skill into a temp directory
2. Make sure ~/.claude/skills/ exists (create it if not), then copy the repo's
   skills/data-analysis-skill directory into it
   - Copy that one directory itself; do not nest the whole skills/ dir inside
   - Overwrite a same-named directory — that's how updating works
   - Do not touch any other skill in that directory, and never wipe the directory
   - assets/ industries/ references/ evals/ must come along; missing any of them breaks links
3. Delete the temp directory
4. Tell me where it landed
```

**Install into Codex** 👇

```text
Please install the data-analysis-skill for me:

1. Clone https://github.com/cabbage2000-lab/data-analysis-skill into a temp directory
2. Make sure ~/.codex/skills/ exists (create it if not), then copy the repo's
   skills/data-analysis-skill directory into it
   - Copy that one directory itself; do not nest the whole skills/ dir inside
   - Overwrite a same-named directory — that's how updating works
   - Do not touch any other skill in that directory, and never wipe the directory
   - assets/ industries/ references/ evals/ must come along; missing any of them breaks links
3. Delete the temp directory
4. Tell me where it landed
```

**Install into WorkBuddy** 👇

```text
Please install the data-analysis-skill for me:

1. Clone https://github.com/cabbage2000-lab/data-analysis-skill into a temp directory
2. Make sure ~/.workbuddy/skills/ exists (create it if not), then copy the repo's
   skills/data-analysis-skill directory into it
   - Copy that one directory itself, don't nest the whole skills/ dir inside —
     WorkBuddy names skills after the directory hierarchy, so an extra level turns
     the skill name into skills:data-analysis-skill
   - Overwrite a same-named directory — that's how updating works
   - Do not touch any other skill in that directory, and never wipe the directory
   - assets/ industries/ references/ evals/ must come along; missing any of them breaks links
3. Delete the temp directory
4. Tell me where it landed
```

In WorkBuddy you can also check the "Skills" panel to confirm it showed up.

### Route B: one-command plugin install (Claude Code / Codex)

This repository is itself a plugin marketplace; the upside is one-command updates.

Claude Code — run these in a session:

```text
/plugin marketplace add cabbage2000-lab/data-analysis-skill
/plugin install data-analysis-skill@data-analysis-marketplace
```

Update with `/plugin update data-analysis-skill`.

Codex — run these in a terminal:

```bash
codex plugin marketplace add cabbage2000-lab/data-analysis-skill
codex plugin add data-analysis-skill@data-analysis-marketplace
```

WorkBuddy uses the Route A prompt (this repo does not yet ship a field-tested WorkBuddy plugin manifest).

Routes A and B install the same skill — **don't do both**, or you end up with two copies. The plugin form only changes how the host displays it; the analysis behavior is identical.

### Route C: clone the repo + run the sync script (for anyone modifying the skill)

```bash
git clone https://github.com/cabbage2000-lab/data-analysis-skill.git
cd data-analysis-skill

# One command installs into every host detected on this machine:
#   Claude Code always; Codex only when ~/.codex/ exists; WorkBuddy only when ~/.workbuddy/ exists
bash sync-to-user.sh
```

If your skills directories live elsewhere, name them via env vars (this is also how you install into a project-level directory):

```bash
DATA_ANALYSIS_CLAUDE_SKILL=/your/path/data-analysis-skill bash sync-to-user.sh
DATA_ANALYSIS_CODEX_SKILL=/your/path/data-analysis-skill bash sync-to-user.sh
DATA_ANALYSIS_WORKBUDDY_SKILL=/your/path/data-analysis-skill bash sync-to-user.sh
```

To upgrade later, `git pull` and run the same command again.

> **The three hosts do not read each other's skill directories** — neither Codex nor WorkBuddy reads `~/.claude/skills/`, and Claude Code does not read `~/.codex/skills/`. Using several hosts means installing into each. The symptom of installing in the wrong place is "the skill simply never appears, with no error at all".
>
> **Only want it in one project?** Replace the user-level path with the project-level directory in that project's root: `.claude/skills/` for Claude Code, `.codex/skills/` for Codex, and **`.codebuddy/skills/` for WorkBuddy** — note it is *not* `.workbuddy/`: the user-level directory is `~/.workbuddy/`, but the project-level one keeps the underlying CodeBuddy-kernel name `.codebuddy/`. Get that asymmetry wrong and the skill never shows up.

## How to use it

1. **Provide data, state your need.** In your agent, point to your data file and say what you want:

   ```
   Analyze this sales data for me: retail_orders.csv — I need a report
   ```

   You don't need to remember the skill's name — plain language matches it; naming `data-analysis-skill` explicitly works just as well.

2. **Answer a few multiple-choice questions.** Before analyzing, it confirms your industry, analysis goal, and report audience (click-to-pick on hosts with a structured-questioning tool, numbered plain-text choices elsewhere). Don't skip this — it determines what the report analyzes and who it speaks to: an executive summary for your boss, or a detailed diagnosis for the ops team.

3. **Get the report.** It walks through data understanding → cleaning → metric computation → analysis → report generation, and delivers an HTML file you open in a browser.

> **Just have a quick question?** Things like "compute the correlation between these two columns" or "is group B's conversion significantly higher" won't be dragged through the full pipeline — it computes and answers directly, with the same statistical rigor.

## What the report looks like

- **A single HTML file**: double-click to open, interactive charts (zoom, tooltips), ready to share with colleagues (they need internet access to open it too)
- **A fixed six-section structure, conclusions first**: Key findings (3–5) → Background & goals → Data overview → Deep-dive analysis (sectioned by industry themes) → Conclusions & recommendations → Appendix: data processing notes
- **Every chart comes with an interpretation**: what the chart shows and what it implies — it doesn't just dump charts on you
- **Traceable processing**: how missing values were handled, whether outliers were dropped — every decision is recorded in the appendix
- **Report language follows your prompt language**: ask in English, get an English report

## Supported industries and methods

| Industry | Typical scenarios | What the report focuses on |
|----------|-------------------|----------------------------|
| Retail / e-commerce | Marketplaces, online stores, offline/omnichannel retail | GMV, average order value, repeat purchase rate, return rate, category mix |
| Internet / SaaS | Subscription software, internet products, membership services | MRR/ARR, retention, churn, net revenue retention |
| Content creators | Account operations on Xiaohongshu (RED), Douyin, Bilibili, WeChat official accounts, etc. | Engagement rate, completion rate, net follower growth, follower conversion efficiency |
| Corporate finance / FP&A | P&L, expenses, budget, cash flow analysis | Revenue growth, gross margin, expense ratios, budget attainment |
| Funds | Fund product performance and operations data | NAV returns, max drawdown, subscriptions/redemptions, holder structure |
| Real estate | Property developer sales and market data | Sales & absorption, cash collection, market volume-price trends |
| Construction | Construction/contracting company operations | Project output & progress, labor/material/machinery costs, contract intake & collections |
| Education & training | Training institutions, online education platforms | Enrollment & renewals, attendance & completion, channel acquisition & CAC |
| Everything else | When none of the above fits, it falls back to a general lens | Scale, trends, composition, distributions — without force-fitting another industry's KPIs |

When the task calls for specialized methods — A/B testing, time-series forecasting, causal inference, machine learning — it loads the corresponding method module on demand; you don't have to ask. Multi-dataset inputs (multi-sheet Excel, several files at once, multi-structure JSON) get every source enumerated and the relation strategy confirmed with you first — **it never silently reads only the first sheet**.

## Why you can trust the conclusions

The skill works under professional discipline — it would rather say less than make things up:

- **No fabricated industry benchmarks.** Unless you provide benchmark data or explicitly authorize a web search, it only compares within your own data — it never quotes an industry average "from memory."
- **Correlation ≠ causation.** Without causal-method validation it won't claim "A drove B," and it proactively calls out potential confounders.
- **No forced conclusions from small samples.** When the sample is too small, it tells you plainly that confidence is limited — even if "the boss needs an answer today."
- **Bad data gets a diagnosis first.** If data quality is too poor, it tells you what's missing and how to fix it, instead of fabricating a polished-looking analysis.

## What it doesn't do

- No live dashboards / dashboard apps (the deliverable is a static single-file report)
- No web scraping — it won't fetch data for you
- No direct database connections — export your data to CSV / Excel files first

## FAQ

**Installed it, but nothing happens?**
Check three things: (1) it went into the skills directory of **the host you're actually using** (the three don't read each other's); (2) you copied the `data-analysis-skill` directory itself, not a `skills/` wrapper around it; (3) you opened a **new session** afterwards. In WorkBuddy, the "Skills" panel shows whether it's there.

**The report opens blank / charts don't render?**
Chart libraries load from CDN, so opening the report requires internet access. The CDNs are chosen to be reachable from mainland China.

**Want a PDF or static images instead?**
Just say so ("give me static charts" / "export to PDF") and it switches to a static-chart approach; the report itself also has an "Export PDF" button in its top-right corner.

**Do I need to set up Python or install packages myself?**
Analysis runs locally inside your agent using Python. If dependencies like pandas are missing, it tries to install them automatically, with fallbacks if installation fails — generally nothing for you to worry about.

**It asks about my industry and goals — can I skip that?**
The confirmation step before a full report is deliberate: data that looks like retail data doesn't mean you want a retail reading of it. Ten seconds of choices make the report fit much better. Quick single questions skip this step entirely.

## Repository layout

```
skills/data-analysis-skill/      # the deliverable itself (this is what gets installed)
  SKILL.md                       #   core layer: five-phase workflow, gate, statistical discipline
  assets/report_template.html    #   single-file HTML report template (header comment = data contract)
  industries/                    #   9 industry templates (loaded on demand)
  references/                    #   6 method modules (loaded on demand)
  evals/evals.json               #   eval scenario definitions (T1–T14)
examples/sample_report.html      # sample output: what a report looks like
.claude-plugin/ .codex-plugin/ .agents/   # plugin marketplace manifests (Route B)
sync-to-user.sh                  # three-host sync script (Route C)
docs/                            # versioning plan, cross-host acceptance checklist
CHANGELOG.md                     # release notes
```

The requirements document and the dev workspace (test data, validators, per-iteration eval runs) stay local and are not published — what ships is the skill itself plus what you need to install it.

## License

Released under the [MIT License](LICENSE) © 2026 cabbage2000-lab.
