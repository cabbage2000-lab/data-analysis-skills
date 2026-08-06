# Visualization & Report Generation Rules

Load during Phases 4–5 whenever charts are produced; required reading before generating the report in Phase 5.

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
| Cumulative contribution (80/20)? | Pareto (bar + line, dual axis) | Common for retail category and customer-contribution analysis |
| Retention decay over time? | Cohort heatmap | Common in SaaS/internet: rows = cohorts, columns = periods |

Prefer industry-customary charts: drawdown curves (line + area fill) in finance, Pareto in retail, cohort heatmaps in SaaS. If the industry template's "report section emphasis" specifies chart types, follow it.

## ECharts option Generation Rules (Python side)

Build options directly as dicts and inject via `json.dumps` — **do not use pyecharts**. Constraints and defaults:

1. **Pure JSON**: options must not contain functions. Use ECharts string templates for tooltip/label formatters (`'{b}: {c}'`, `'{b}<br/>{a}: {c} ({d}%)'`)
2. **Default interaction for time series**: `"dataZoom": [{"type": "inside"}, {"type": "slider"}]`
3. **Toolbox on every chart**: `"toolbox": {"feature": {"saveAsImage": {}, "dataView": {"readOnly": true}}}`
4. **Tooltip on by default**: `{"trigger": "axis"}` for line/bar, `{"trigger": "item"}` for scatter/pie
5. **Value-axis names carry the unit**: `"yAxis": {"type": "value", "name": "Sales (10k CNY)"}`; when amounts run large, convert the unit in Python before injecting
6. Palette and fonts are covered by the report template's defaults; options need not set color (except special semantic colors — e.g. a red-for-down / green-for-up convention must be set explicitly)

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
