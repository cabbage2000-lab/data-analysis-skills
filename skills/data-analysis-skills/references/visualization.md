# Visualization & Report Generation Rules

Load during Phases 4–5 whenever charts are produced; required reading before generating the report in Phase 5.

## Before charting: is it even a chart?

Some "charts" are really a single number or a short list — charting them adds ink, not information. Check this before picking a chart type:

| The data is… | Deliver as | Never as |
|------|------|------|
| One headline value (+ an optional trend remark) | a `stats` tile in Data Overview, or a **bolded number** in the section narrative | a one-bar bar chart |
| A handful of headline numbers | the `stats` tile row (label / value / note) | a grouped bar of 3 lonely values |
| A single ratio against a target or limit | a narrative sentence with both numbers bolded | a 2-slice pie |
| More than ~7 categories that all carry meaning | a table (the `tables` contract), optionally table + a chart of the TOP few | one chart cycling past 8 colors |

## Chart Selection: pick by question, don't pile on charts

Every chart must answer one explicit question. Write the question first, then pick the chart type:

| Question to answer | Preferred chart | ECharts notes |
|------|------|------|
| How does it change over time? | Line | Add `dataZoom` on the time axis; more than 4 series → small multiples or curate down |
| Who is bigger/smaller (category comparison)? | Bar (horizontal for long labels) | Sort by value, not alphabetically |
| Composition / share? | Pie (≤6 categories) / stacked bar (composition over time) | Merge categories beyond 6 into "Other" |
| Relationship between two variables? | Scatter | A trend reference line must be precomputed in Python as an extra series |
| Distribution shape? | Histogram (bar-based) / box plot (between-group comparison) | Box plot series type `boxplot`; precompute the five-number summary in Python |
| Where is the concentration/anomaly (two-way cross)? | Heatmap | Good for hour × weekday, category × region |
| Flows / conversion? | Sankey / funnel | Funnel for a single conversion path, Sankey for multi-branch flows |
| Cumulative contribution (80/20)? | Pareto (bar + line, dual axis) | Common for retail category and customer-contribution analysis; the **sanctioned dual-axis exception** — the line axis is a fixed 0–100% cumulative share, see anti-patterns |
| Retention decay over time? | Cohort heatmap | Common in SaaS/internet: rows = cohorts, columns = periods |

Prefer industry-customary charts: drawdown curves (line + area fill) in finance, Pareto in retail, cohort heatmaps in SaaS. If the industry template's "report section emphasis" specifies chart types, follow it.

## Emphasis: when one series is the story

When the narrative is about ONE series ("digital appliances broke out", "this store vs the market average"), don't hand every series a palette color — that buries the point. Highlight the protagonist, mute the rest:

- Protagonist series: leave it on the palette (slot 1 blue), or the semantic red/blue when the story itself is down/up
- Every background series: de-emphasis gray — `"itemStyle": {"color": "#b5b5b5"}` (visible but receding)
- Direct-label the protagonist only (`endLabel` or a last-point `label`); background series stay unlabeled — the tooltip still carries them
- The chart's `insight` names the protagonist, so chart and narrative point at the same thing

## Chart Anti-patterns — check every chart against this before shipping

If a produced chart matches a row, fix it before it ships:

| ❌ Anti-pattern | Why it misleads | ✅ Do instead |
|------|------|------|
| Dual y-axes: two different measures, two scales on one plot | the two scales' relative alignment is arbitrary — the chart manufactures a correlation the data doesn't claim | two charts stacked, or index both series to a common base (=100 at t0) on **one** axis. **Sanctioned exception: Pareto** — its second axis is a fixed 0–100% cumulative-share scale, not an arbitrary one; keep that exception, and only that one |
| Recoloring after a filter/sort: series colors assigned by current rank | a reader who learned "华东 is blue" in chart 1 is misled by chart 3 | color follows the entity — the same entity keeps the same series position/color across every chart in the report |
| Rainbow / multi-hue ramp for magnitude — **ECharts `visualMap` defaults to one** | hue order is not perceptual order; magnitude needs light→dark | one hue, light→dark. The template injects a blue ramp when `visualMap.inRange` is unset — do not set a multi-hue ramp yourself |
| Categorical palette on ordered categories (funnel stages, age bands, rating tiers) | ordered things shown as unrelated identities — the order disappears | a one-hue ramp, light→dark in category order (set per-item `itemStyle.color` from the template's blue ramp) |
| Pie for near-equal values, or >6 slices | readers can't compare angles precisely | a sorted horizontal bar, or just the numbers; pie only for at-a-glance part-to-whole with ≤6 slices |
| Semantic colors astray: a neutral series wearing red while the chart also talks profit/loss or target/overrun | readers assign good/bad meaning the data doesn't carry | when a chart carries up/down semantics, reserve red `#e3120b` for negative and blue `#006ba6` for positive; reorder or explicitly recolor neutral series away from red |

## ECharts option Generation Rules (Python side)

Build options directly as dicts and inject via `json.dumps` — **do not use pyecharts**. Constraints and defaults:

1. **Pure JSON**: options must not contain functions. Use ECharts string templates for tooltip/label formatters (`'{b}: {c}'`, `'{b}<br/>{a}: {c} ({d}%)'`)
2. **Default interaction for time series**: `"dataZoom": [{"type": "inside"}, {"type": "slider"}]`
3. **Toolbox on every chart**: `"toolbox": {"feature": {"saveAsImage": {}, "dataView": {"readOnly": true}}}`
4. **Tooltip on by default**: `{"trigger": "axis"}` for line/bar, `{"trigger": "item"}` for scatter/pie
5. **Value-axis names carry the unit**: `"yAxis": {"type": "value", "name": "Sales (10k CNY)"}`; when amounts run large, convert the unit in Python before injecting
6. Palette, fonts and mark specs are covered by the report template's defaults (colorblind-validated series palette; 2px lines, 8px markers with a surface ring, 24px bar-width cap, 2px surface gaps between stacked segments / pie slices, 12% area-fill opacity, auto-hidden symbols past 50 points); options need not set color or mark styling (except special semantic colors — e.g. a red-for-down / green-for-up convention must be set explicitly)
7. **Series-count ladder**: 1–3 series read comfortably; 5–6 is the soft cap. Past 6, fold the tail into "Other", split into small multiples (several chart entries), or rethink the chart — **never let the palette cycle past its 8 slots**: a 9th series silently reuses slot 1's color and becomes indistinguishable from it
8. **Label selectively — never a number on every point**: flood-labeling (`label: {show: true}` on a whole series) goes unread and turns the chart into noise. Direct-label only what the narrative is about — the endpoint (`endLabel`), the extreme, the one highlighted series — and let axis ticks + tooltip carry the rest
9. **Legend follows series count**: a single-series chart sets `"legend": {"show": false}` — the chart title already names the series, a one-swatch legend box restates it. With ≥2 series the legend must stay visible (readers must never have to rely on color memory alone)

## Data Volume Control (mandatory)

What gets injected into the HTML is **chart-ready data**, not raw detail:

- A single series over ~1000 points: aggregate first (coarsen granularity: day → week → month) or sample, and record the aggregation granularity in the appendix "Data Processing Notes"
- Scatter over ~2000 points: random-sample and note the sampling ratio
- Tables: detail-level rows are allowed (e.g. SKU-level, per-day records). Hard cap **500 rows per table**: beyond that, truncate to TOP-N in Python before injection (ranked by the measure under analysis) and record the truncation in appendix `processing_notes`. The template never truncates silently
- Goal: keep the single-file HTML small and smooth to open

## Table Modes (static vs interactive)

The template picks the table mode automatically by row count — control it only through how many rows you inject:

- **≤20 rows**: static publication-style table (the default look, consistent with the report's design system)
- **>20 rows**: automatic interactive table (Grid.js — pagination/search/sort). Same `tables` structure; never add fields or markers to opt in/out
- Keep `rows` as display-formatted strings (`"¥1,200,000"`, `"12.4%"`). The template parses numbers for column sorting — do not inject raw unformatted numbers just to make sorting work
- Detail tables: cap 500 rows; truncate to TOP-N before injection and add a `processing_notes` entry (see Data Volume Control)
- Print/PDF caveat: an interactive table prints only the currently visible page (other rows are not in the DOM). If the user explicitly asks for a print/PDF deliverable, prefer ≤20-row summary tables, or note the cutoff in the narrative

## Report Generation Flow (Phase 5)

1. Read `assets/report_template.html` (data contract in the template's header comment)
2. Assemble the report_data dict in Python: six-section content + per-chart `{id, title, question, option, insight}`
3. The `insight` field is required: answer "what this shows and what it means for the decision", in the industry's narrative language
4. `template.replace('__REPORT_DATA_JSON__', json.dumps(report_data, ensure_ascii=False))` to write the single-file HTML
5. Self-check: placeholder replaced, `json.dumps` succeeded (numpy types inside options make it fail — convert to native `int/float/list` first; use `default=str` to track down offenders)

```python
# numpy → native conversion (always run before json.dumps)
def to_native(o):
    import numpy as np
    if isinstance(o, dict):  return {k: to_native(v) for k, v in o.items()}
    if isinstance(o, (list, tuple)): return [to_native(v) for v in o]
    if isinstance(o, np.generic): return o.item()
    return o
```

## Narrative Typography (Phase 5)

The template renders narrative text with two Markdown tiers (authoritative contract in the template's header comment):

| Fields | Supported syntax |
|------|------|
| The four `narrative` fields (`background` / `data_overview` / `sections[]` / `conclusions`) | Block-level: blank line = paragraph break, `### ` subheading, `- ` unordered list, `1. ` ordered list, `**bold**` |
| All other text fields (`headline`/`detail`/`objectives`/`insight`/`quality_summary`/`recommendations`/notes) | `**bold**` and line breaks only |

Discipline — these exist so reports read like editorial writing, not slide bullets:

- **Narrative first, lists second**: prose carries the argument; use a list only for 3+ parallel points. Never convert an entire narrative into bullets
- Paragraphs of 2–4 sentences, separated by blank lines; at most one `### ` block per section narrative (chapter structure belongs in `sections[]`, not inside a narrative)
- No Markdown tables/links/images/code — tabular data goes in the `tables` field
- `**bold**` renders in the accent red: reserve it for key numbers and decision-bearing phrases, not whole sentences
- Ordered items must start the line as `1. ` (Chinese `1、` also works); a 4-digit year like `2025.` is not parsed as a list

## Matplotlib / Seaborn (in-process exploration only, or when the user explicitly asks for static charts)

Chinese text output requires explicit font configuration, otherwise glyphs render garbled:

```python
import matplotlib
matplotlib.rcParams['font.sans-serif'] = ['PingFang SC', 'Hiragino Sans GB', 'Noto Sans CJK SC', 'SimHei', 'Microsoft YaHei']
matplotlib.rcParams['axes.unicode_minus'] = False  # render minus signs correctly
```

Exploration charts never go into the report; Matplotlib output becomes a formal deliverable only when the user asks for PDF/static delivery.
