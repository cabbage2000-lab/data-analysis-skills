# Construction Industry Analysis Template

Scope: construction/contracting companies (general contractors, specialty subcontractors, decoration/municipal/infrastructure contractors) analyzing construction production and operations data — project output & progress, labor/material/machinery costs, contract intake, cash collection. Identification signals: fields such as output value (产值), physical progress (形象进度), work quantities (工程量), labor/materials/machinery (人材机), contract value / new signings / winning bids (合同额/新签/中标), project/section/site (项目/标段/工地), interim measurement (计量), variation orders (签证), settlement (结算), cash collection (回款), receivables, hazards/incidents (隐患/事故), acceptance (验收), or descriptions from contractors / engineering bureaus / project departments. Routing: the company's own P&L/expense/budget analysis (account dimension) → corporate-finance.md, while project-dimension labor/material/machinery costs belong here; developer sales data (commitment/signing/absorption) → real-estate.md; survey & design / cost consulting → general.md for now; when hard to tell, confirm with the user.

## KPI System (KPI Dictionary & Definitions)

| KPI | Definition | Points to confirm |
|------|------|------|
| Completed output value | Aggregate by period | **Output value (产值) ≠ revenue ≠ cash collection** — the three definitions differ widely; confirm which one the data uses first. Self-performed output vs total output including subcontractors must be distinguished and declared |
| Output plan completion rate | Cumulative completed output / planned output | Whether the denominator is **the annual target, total contract value, or milestone plan** changes results a lot — declare it |
| Physical progress variance | Actual progress − planned progress | Different progress-measurement methods (output share / physical quantities / schedule share) can flip the conclusion — declare which is used |
| New contract value | Aggregate by signing date | **Winning a bid (中标) ≠ signing (签约) ≠ taking effect (生效)**; distinguish framework agreements from formal contracts |
| Backlog coverage ratio | Outstanding contract backlog / annualized output | **Requires backlog data**; declare the annualization window |
| Cost structure | Shares of the four cost classes: labor / materials / machinery / subcontracting | **Requires cost data**; budget-vs-actual must be on the same work-quantity basis |
| Cost variance rate | (Actual cost − budgeted cost) / budgeted cost | **Requires budget data**; unbooked quantity changes / variation orders distort the variance — conclusions must note it |
| Collection rate / settlement rate | Cumulative collections / cumulative output (or settled or invoiced amount); cumulative settlements / cumulative output | Denominator definitions differ widely — declare them; retention money lags by nature |
| Safety & quality | Hazard rectification rate, first-pass acceptance rate | **Requires safety/quality data**; skip if missing |

Metrics with missing fields: skip them and state in the report "the data does not include X, so Y was not computed" — never fabricate. Cross-project comparisons must align business types and pricing bases first.

## Typical Analysis Themes

1. **Output & progress panorama**: output trajectory + plan completion rate + physical progress variance; **an output surge must be split into batched recognition vs real construction pace** — peaks from year-end pushes or lagged measurement do not signal higher capacity
2. **Project structure & contribution decomposition**: output and gross-profit contribution by project / business type (building, municipal, infrastructure, decoration) / region (Pareto: which projects carry output and profit); identify schedule-lagging and loss-making projects
3. **Cost structure & variance** (requires cost data): labor/materials/machinery/subcontracting mix and trends; budget-vs-actual variance localization (quantity-variance vs price-variance decomposition)
4. **Contract intake & backlog** (requires business-development data): new-contract trend and mix, bid win rate, backlog coverage ratio
5. **Output-settlement-collection chain** (requires settlement/collection data): the three trajectories and their gaps, receivables aging; when gaps widen, flag contractor-financing pressure (垫资) and cash-collection pacing — phrase cautiously
6. **Safety & quality** (requires safety/quality data): hazard/incident trends, rectification closure rate, first-pass acceptance rate; when safety events overlap with schedule-rush periods, phrase cautiously (correlation, not causation)

## Narrative Language

Output value (产值), cumulative-to-date (开累), physical progress (形象进度), labor/materials/machinery (人材机), general contracting / subcontracting (总包/分包), interim measurement (计量), variation orders (签证), settlement (结算), cash collection (回款), contractor financing (垫资), contract backlog (合同储备), winning bids (中标). Audience tiers: company executives (operations- and cash-flow-oriented, conclusions first); project management line (progress and cost-variance detail); business development (contract intake and settlement/collection detail). Phrasing discipline: "cost variance widened during the period of rising material prices", not "material price increases caused the overrun" (the variance also contains quantity changes and late-booked variation orders); "hazard counts rose during schedule-rush phases", not "schedule rushing caused safety risk" (correlation, not causation); **never quote from memory any industry benchmark such as construction-sector average margins, labor-cost shares, or output-margin rankings** — enforce benchmark discipline strictly (user-provided, or authorized search with cited sources); output-value conclusions must state the definition used (output ≠ revenue ≠ collection).

## Report Section Emphasis

Deep-dive priority: output & progress panorama (always) → project structure & contribution (always) → cost structure variance (requires data) → output-settlement-collection (requires data) → contract intake (requires data) → safety & quality (requires data). Go-to charts: output bars + completion-rate line on dual axes, project-output Pareto, labor/materials/machinery cost stacked bars, output/settlement/collection triple-line chart, new-contract bars, planned-vs-actual progress grouped bars. All within ECharts 5.4.3 pure-JSON capability (no Gantt — the custom series requires functions, violating the pure-JSON constraint).
