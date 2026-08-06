---
name: data-analysis-skills
description: Use when the user provides data files (CSV/Excel/JSON/TSV) or tabular data and wants analysis, insights, or a report — e.g. 分析数据、做数据报告、数据洞察, sales/operations/business data review, EDA, A/B test evaluation, forecasting, or an interactive HTML data report. Not for building dashboard apps, web scraping, or live database connections.
---

# data-analysis-skills: Industry-Aware Data Analysis & Narrative Reporting

## Overview

Turn raw data into industry-aware data stories that speak for themselves — the deliverable is not isolated charts and numbers, but an analysis report with insights, conclusions, and the power to drive business decisions.

```
One analysis = five-phase workflow (the main line)
             × one industry template industries/ (what to analyze, who to speak to)
             × method modules references/ loaded on demand (how to analyze)
             → data JSON injected into assets/report_template.html → single-file HTML report
```

Supported inputs: CSV, Excel (.xlsx/.xls), JSON, TSV. A single input may carry **multiple datasets** — an Excel file with several sheets, two or more files handed over at once, or a JSON whose top level is a dict with multiple array keys; handle these via the Phase 1 multi-source intake (see `references/data-sources.md`). Analysis runs on Python (pandas etc.; if a dependency is missing, try pip install first, and fall back per the degradation table on failure).

## First: Task Triage

| What the user is asking for | Path |
|------|------|
| Open-ended analysis, wants a report/insights ("analyze this data", "give me a report") | **Full five-phase workflow** (including the Phase 1 gate), see below |
| A single statistical question ("test whether B is significant", "compute the correlation between these two columns") | **Lightweight path**: run that computation directly and reply with the result + caveats; do not impose industry confirmation or the full report workflow |

Triage rule: the user names a specific statistical computation and does not ask for overall insights/a report → lightweight path. When in doubt, run the full workflow. **Statistical discipline applies equally to both paths.**

## The Five-Phase Workflow

At kickoff, immediately use the host's task-list tool (TodoWrite in Claude Code, update_plan in Codex, the equivalent plan/todo tool in other hosts) to create one todo per phase, advancing and updating status phase by phase. **If the host offers no such tool, list the five phases as a plain-text checklist up front and restate progress as you go** — phase tracking is never dropped just because the tool is missing. Phases 2–5 run straight through without interrupting the user with further questions; print a one-line progress note at the start of each phase.

### Phase 1: Data Intake & Understanding [the only mandatory gate]

1. Read the data and report a profile: row/column counts, field types, missingness, time range, distributions of key unique values
2. **Industry identification**: infer the industry from field names, data characteristics, and the user's description, and self-assess confidence
3. **Multi-source intake (when the input carries >1 dataset)**: an Excel file with several sheets, two or more files handed over at once, or a JSON whose top level is a dict with multiple array keys each count as multiple datasets. **Enumerate every source** (all sheet names / all files / all top-level keys), surface the full list to the user, and load `references/data-sources.md` for the read patterns and relation matrix. **Never silently read only the first sheet / the named file / collapse JSON keys** — that produces a report the user cannot tell is incomplete
4. **User confirmation (mandatory gate)**: ask via structured multiple-choice questions — use the host's structured-questioning tool when it has one (e.g. AskUserQuestion in Claude Code); when the host has none, the tool is unavailable, or the user declines it, ask as numbered multiple-choice questions in plain text and **wait for the user's reply before continuing**. Only the presentation degrades — the gate itself never does. Bundle into the first round:
   - Industry confirmation (high confidence → a single confirm option; low confidence or anonymized fields → offer 3–4 industry options, **never guess on your own**)
   - Analysis goal (when the user hasn't made clear what they want to see)
   - Report audience (executives = conclusion-led, light on jargon / analysts = keep the technical detail)
   - Data-definition ambiguities (when field meanings, units, or reporting periods are unclear)
   - **Multi-source relation strategy** (when step 3 applies): fusion (join/concat into one table) vs per-source independent analysis, plus the join keys
5. Question budget: at most 3 rounds, at most 3 multiple-choice questions per round; aim to fit all questions for the whole workflow into a single round in this phase

**When you may skip the questions and go straight to Phase 2**: industry, analysis goal, and audience can all be read directly from the user's input (e.g. "I'm the founder, this is 36 months of operating data for our SaaS — look at growth and retention"). As long as the industry has not been confirmed by the user, you must ask — **data that looks like retail ≠ the user confirming a retail reading**.

**Why this gate cannot be skipped**: skipping confirmation means you have decided the analysis agenda, industry narrative, and audience style on the user's behalf. In baseline tests the model skipped the questions on the grounds that "delivering a full EDA first is the professional default; asking back would block the user" — and produced a neutral analysis the user may never have wanted. One round of multiple-choice costs the user tens of seconds; a report pointed in the wrong direction wastes the entire analysis. None of these excuses hold:

| Excuse for skipping | Reality |
|------|------|
| "Deliver value first; asking back blocks the user" | One round of multiple-choice ≪ one report pointed the wrong way. The gate is a hard requirement |
| "Field semantics are clear, no confirmation needed" | Clear fields ≠ confirmed industry + clear goal. You don't set the agenda for the user |
| "EDA doesn't depend on business semantics, just do it first" | EDA without industry and goal is a neutral pile of numbers — the opposite of this skill's core positioning |
| "If the user catches an issue they can just tell me" | Confirmation must come first; correcting course after the report ships is the most expensive path |

Once confirmation lands, pick the industry template: a matching template exists (see table below) → load it; industry identifiable but no template → `industries/general.md` + inject industry terminology into the narrative; unidentifiable / user rejected the guess without naming one → `industries/general.md`, keep the narrative industry-neutral.

### Phase 2: Data Cleaning

- Missing values: choose drop/impute/flag based on the missing ratio and the nature of the field
- Outliers: detect with IQR and Z-score; assess business plausibility before treating them (**anomalous ≠ wrong** — e.g. a big-promotion peak)
- Deduplicate and standardize formats (dates, encodings, units)
- **Traceability (mandatory)**: record every key cleaning decision and write it into the report appendix "Data Processing Notes"
- **Terminating gate**: if data quality is too poor to support analysis (key fields largely missing / data is all garbage) → produce a data-quality diagnostic report (problems + repair suggestions), terminate the workflow, and do not force an analysis

### Phase 3: Data Transformation

- Compute derived metrics **using the industry template's KPI definitions first**; if a template metric's required fields are missing → skip the metric and say so in the report — never fabricate it
- Pivot, aggregate, and reshape long/wide as the analysis themes require
- Transformation logic also goes into "Data Processing Notes"

### Phase 4: Data Analysis

- Run EDA by default: distributions, anomalies, correlations
- **Organize the analysis agenda around the industry template's "typical analysis themes"**, going deep theme by theme
- Load method modules as the task requires (see the "On-Demand Loading" table)
- Follow statistical discipline throughout (see below)

### Phase 5: Data Report

1. **Required reading: `references/visualization.md`** — select chart types and generate ECharts options per its rules
2. Organize the analysis results into the data JSON (six-section content + chart options + narrative text) and inject it into `assets/report_template.html` (data contract in the template's header comment), producing a **single-file HTML**
3. The six-section structure is fixed by the template: Key Findings (3–5 items, conclusions first) → Background & Objectives → Data Overview → Deep-Dive Analysis (sectioned by industry themes) → Conclusions & Recommendations → Appendix: Data Processing Notes
4. Every chart answers one explicit question; the `insight` field is required (what this shows, what it means for the decision)
5. Narrative terminology and style follow the industry template and the confirmed audience
6. **Report language follows the user**: a Chinese request gets a Chinese report; an English request with English data gets an English report

**Do not hand-write your own HTML or stitch a report from matplotlib static images** — in baseline tests the model improvised a base64 static-image report: no interactivity, arbitrary structure, in breach of the delivery spec. The template already has interaction polished (ECharts zoom/hover/toolbox), pinned CDN versions, and Chinese fonts; you only inject data. matplotlib is for in-process exploration only, or when the user explicitly asks for static images/PDF.

## Statistical Discipline (globally mandatory, applies equally to both paths)

1. Statistical tests must report p-values and confidence intervals, and check their assumptions
2. Phrase correlation findings cautiously and proactively name confounders visible in the data; without causal-method validation, never use "boosted/caused/drove" language (see the phrasing table in `references/causal-inference.md`)
3. When the sample is too small, state the statistical-power limitation explicitly — **do not force a verdict because the user is pressing ("the boss needs the answer today")**
4. **Industry-benchmark discipline**: benchmark comparisons appear in exactly two cases — (a) the user supplied benchmark data; (b) the user **explicitly authorized** web search and results are cited with sources. With neither: do internal comparisons only, and note in the reply "for industry benchmarking, please provide benchmark data or authorize me to search the web (results would be directional reference only)". **Never quote industry averages from memory; never search the web without authorization** — in baseline tests the model searched and cited external data on its own; even with sources attributed, this violates the authorization requirement: whether to search, and which sources to lean on, is the user's call
5. **No silent multi-source loss**: when the input carries multiple datasets (multi-sheet Excel / multiple files / multi-key JSON), enumerate every source, surface the full list to the user, and confirm the relation strategy — **never silently read only the first sheet / the named file / collapse JSON keys** (see `references/data-sources.md`). This extends the template's "no silent truncation" rule from the output layer to the input layer

## On-Demand Loading

| File | When to load |
|------|------|
| `industries/retail.md` | Confirmed retail / e-commerce |
| `industries/saas.md` | Confirmed internet / SaaS / subscription business |
| `industries/self-media.md` | Confirmed self-media / content-creator account operations |
| `industries/corporate-finance.md` | Confirmed corporate finance / FP&A (P&L, expenses, budget, cash-flow analysis) |
| `industries/fund.md` | Confirmed fund industry (fund NAV performance, AUM & subscription/redemption, holder analysis) |
| `industries/real-estate.md` | Confirmed real estate (project sales & absorption, cash collection, market volume-price trends) |
| `industries/construction.md` | Confirmed construction (project output & progress, labor/material/machinery costs, contract intake & collections) |
| `industries/education.md` | Confirmed education & training (enrollment & renewals, attendance & completion, channel acquisition) |
| `industries/general.md` | Industry unidentified / uncovered / user rejected the guess (fallback) |
| `references/data-sources.md` | The input carries multiple datasets — multi-sheet Excel, multiple files, or multi-key JSON |
| `references/visualization.md` | Phases 4–5 whenever charts are produced (required in Phase 5) |
| `references/ab-testing.md` | User mentions experiments, control groups, A/B tests |
| `references/causal-inference.md` | User asks "did X cause Y" or wants causal conclusions |
| `references/time-series.md` | Data has a time dimension and trends/forecasts are needed |
| `references/machine-learning.md` | Modeling, classification, clustering, or prediction tasks |

Industry templates are a thin layer: they change analysis focus and narrative style only — they never replace the five-phase workflow or statistical discipline.

## Degradation Paths

| Situation | Behavior |
|------|------|
| Data quality too poor | Diagnostic report + repair suggestions, terminate (see Phase 2) |
| Sample too small for statistical testing | Descriptive analysis + statistical-power caveat |
| Goal still unclear after 3 rounds of questions | Produce a standard EDA report from data characteristics, declaring assumptions upfront |
| Environment cannot interact (any non-interactive mode, e.g. `codex exec` / `claude -p`) | Treat as "goal still unclear after 3 rounds": standard EDA report + general industry fallback + assumptions declared upfront |
| Host lacks a task-list tool or a structured-questioning tool | Degrade the presentation only — plain-text phase checklist / numbered plain-text multiple-choice, then wait for the reply. The Phase 1 gate and the five-phase workflow stay intact |
| Low confidence in industry identification | Offer 3–4 industry options; don't guess |
| Industry identifiable but no template | general.md + industry terminology injected into the narrative |
| User rejects the identification without naming an industry | general.md, industry-neutral narrative |
| Data doesn't meet causal-inference prerequisites | Correlation conclusions only + the data conditions that would be needed |
| Too few time-series points | No forecasting; trend description only, with the reason stated |
| No usable industry benchmark | Internal comparisons only; never fabricate external benchmarks |
| Chart data volume too large | Aggregate/sample before injecting into HTML; note the granularity in the appendix (rules in visualization.md) |
| Python dependency missing | Notify and attempt pip install; on failure degrade (without statsmodels do trend description only; without scikit-learn skip modeling and say so) |
| Multi-source relation key missing / cannot fuse | Analyze each source independently; state this and explain why fusion isn't possible |
| Multi-source schemas/structures incompatible | Surface the conflict to the user; degrade to single-source or request clarification |

## Red Flags — stop the moment you catch these thoughts

- "The data is clear enough, no need to ask about industry" → back to the Phase 1 gate
- "Let me just run an analysis and show the user first" → back to the Phase 1 gate
- "The industry average is roughly X%, common knowledge" → violates benchmark discipline, delete it
- "Let me quickly search for industry benchmarks" → no search without authorization; ask first
- "The sample is small but the trend is obvious, the conclusion should be fine" → report the power limitation
- "With correlation this strong, 'boosted' isn't an overreach" → check the phrasing table
- "I'd structure the report better myself" → use the template's six sections
- "matplotlib charts embedded in HTML are just as good" → use ECharts + the template
- "The first sheet is enough, let me just read it" / "I'll process the file the user named" → multi-source silent-loss red line: enumerate every source, surface the list, confirm strategy (Phase 1 step 3 + `references/data-sources.md`)

## Pre-Completion Checklist

- [ ] Industry confirmed by the user (or the right degradation path was taken)
- [ ] Report opens with 3–5 key findings, conclusions first
- [ ] Industry metrics computed per template definitions; metrics with missing fields are explained, not fabricated
- [ ] Every chart answers an explicit question and carries an interpretation
- [ ] Tests report p-values/confidence intervals; no causal language without causal methods
- [ ] No unsourced industry benchmark figures in the report
- [ ] Appendix contains complete "Data Processing Notes"
- [ ] Single-file HTML; ECharts loaded from a pinned-version CDN; interactive when opened with network access
- [ ] Report language matches the user's language; narrative style matches the audience
- [ ] If the input had multiple datasets (sheets/files/JSON keys), all sources were enumerated and the relation strategy confirmed or explained — none silently dropped
