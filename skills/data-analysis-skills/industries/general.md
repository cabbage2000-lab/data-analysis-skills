# General Analysis Template (Fallback Base)

Scope: industry unidentified; user rejected the identification without naming an industry; or industry identified but no matching template exists (in that case, inject industry terminology into the narrative on top of this framework).

## KPI System (generic measures computable from the data fields)

| Metric family | Metrics | Definition notes |
|------|------|------|
| Scale | Totals, record counts, mean/median | For monetary metrics, confirm unit and currency |
| Trend | YoY, MoM, moving average | With less than one year of data, do MoM only; state the period baseline |
| Composition | Share of total, Top-N concentration (CR5/CR10) | Merge the tail when there are more than 6 categories |
| Dispersion | Standard deviation, IQR, coefficient of variation | Use the coefficient of variation when comparing across scales |
| Association | Correlation matrix | Report strength only; phrasing follows statistical discipline |

## Typical Analysis Themes (select by the shape of the data)

1. **Overall profile & trend**: how the core quantities move over time, and turning points
2. **Structure & composition**: which categories/groups contribute the bulk of the total (Pareto view)
3. **Dimensional comparison**: how key measures differ across dimensions (region, channel, grouping fields)
4. **Distribution & anomalies**: distribution shapes, outliers, and candidate business interpretations
5. **Association exploration**: correlation structure among numeric fields, suggesting directions for further analysis

## Narrative Language

- Industry-neutral: use generic words such as "records, categories, measures, groups"; **never invent industry context**, and never use unconfirmed industry terminology
- Quote field names exactly as they appear in the user's data; do not rewrite their semantics
- Bind conclusions to the data range: "In the data from 2025-06 to 2026-05…"

## Report Section Emphasis

Organize the deep-dive analysis in the order "trend → structure → comparison → distribution/anomalies → association"; skip themes the data cannot support and say so in the data overview. No industry benchmark is citable here: do internal comparisons only (period-over-period, group-over-group).
