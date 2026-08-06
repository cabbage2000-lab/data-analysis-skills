# Corporate Finance / FP&A Analysis Template

Scope: corporate finance teams, FP&A, and business analysis examining the company's own financial data (P&L, expenses, budget, cash flow, receivables/payables). Identification signals: fields such as account/voucher (科目/凭证), budget/actual, revenue/cost/gross profit, selling/G&A/R&D expenses, cash flow, receivables/payables, cost center/business unit/profit center, or descriptions from finance leads/CFO/business analysts. Distinguish from "finance/quant investing" (returns, drawdown, positions, NAV) — that is an investor's view and this template does not apply; when hard to tell, confirm with the user.

## KPI System (KPI Dictionary & Definitions)

| KPI | Definition | Points to confirm |
|------|------|------|
| Revenue growth rate | (Current-period revenue − base-period revenue) / base-period revenue | Confirm YoY vs MoM/QoQ; for seasonal businesses prefer YoY |
| Gross margin | (Revenue − COGS) / revenue | Whether cost includes manufacturing overhead / depreciation allocation; write the definition into the report |
| Operating margin | (Revenue − cost − period expenses) / revenue | When data only reaches the expense level, use this definition and say so — never pass it off as net margin |
| Expense ratio | A given period expense / revenue | Compute separately for the four classes: selling, G&A, R&D, finance |
| Budget execution rate | Actual / budget | **Requires budget data**; for revenue items >100% means over-achievement, for cost/expense items >100% means overrun — never mix the directions |
| Budget variance rate | (Actual − budget) / budget | **Requires budget data**; rank by both absolute variance and variance rate to locate the accounts that matter |
| Operating cash flow / earnings quality | Net operating cash flow vs net profit | **Requires cash-flow data**; skip if missing |
| DSO / DPO | Average receivables (payables) / revenue (cost) × days in period | **Requires receivables/payables balance data**; skip if missing |
| EBITDA | Net profit + interest + income tax + depreciation & amortization | **Requires interest/tax/D&A fields**; skip if missing |

Metrics with missing fields: skip them and state in the report "the data does not include X, so Y was not computed" — never fabricate. P&L (accrual basis) and cash flow are two separate views: with P&L data alone, never infer "cash-flow position" or "collection status".

## Typical Analysis Themes

1. **Profit structure & trend**: step-by-step decomposition from revenue → gross profit → operating profit (waterfall thinking); monthly/quarterly trends with YoY/MoM; seasonality detection (e.g. a Q4 surge), distinguishing "real business seasonality" from "budgeting that ignored seasonality" (when the budget is smooth but actuals have peaks, seasonally high attainment is a budgeting artifact, not a performance signal)
2. **Expense structure & control**: composition and movement of each expense as a share of revenue; the gap between expense growth and revenue growth — expense growth persistently outpacing revenue growth is an early control warning
3. **Budget execution & variance**: compute and rank execution/variance rates to locate overrun accounts; separate one-off variances from persistent ones (only multi-period same-direction overruns are structural — don't over-read single-period swings)
4. **Cash flow & working capital** (requires cash-flow / receivables-payables data): divergence between operating cash flow and net profit (earnings quality); DSO/DPO trends and working-capital occupation
5. **Department / product line / cost center profitability comparison**: side-by-side revenue scale, gross margin, and expense ratio across units; drill into units with deteriorating profitability — separate revenue-side (volume/price) from cost-side (cost-ratio) problems

## Narrative Language

Account / line item (科目), YoY/MoM (同比/环比), attainment rate (达成率), execution rate (执行率), variance (偏差), control (管控), earnings quality (盈利质量), gross profit (毛利), period expenses (期间费用), P&L (损益). For executives (CFO/GM), conclusion-led with little jargon; for financial analysts, keep the definition details. Phrasing discipline: state facts rather than passing judgment — "selling expenses exceeded budget for three consecutive quarters, average variance +12%", not "selling expenses are out of control"; attribute cautiously — "Product line A's gross-margin decline coincided with a rising cost ratio", not "poor cost management eroded profit" (the data cannot see management actions).

## Report Section Emphasis

Deep-dive priority: profit structure & trend (always) → expense structure (always) → budget execution variance (requires budget data) → department/product-line comparison → cash flow (requires data). Go-to charts: waterfall (revenue-to-profit decomposition; implement in ECharts 5.4.3 as stacked bars with a transparent base), grouped bars (budget vs actual), stacked bars/area (expense structure), multi-series lines (gross-margin trends across units).
