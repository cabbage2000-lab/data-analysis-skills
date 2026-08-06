# Fund Industry Analysis Template

Scope: fund companies (product/research/marketing), distribution channels, and investors analyzing fund product data — NAV performance, AUM & subscription/redemption, holder structure. Identification signals: fields such as NAV / unit NAV / cumulative NAV (净值/单位净值/累计净值), returns, drawdown, units (份额), subscription/redemption (申购/赎回), AUM (管理规模), holders (持有人), fund code/fund name, Sharpe, or descriptions from fund companies / research teams / retail fund investors. Routing: the company's own P&L/budget analysis → corporate-finance.md; non-fund portfolio holdings / strategy backtests / credit data → general.md for now (a finance/quant finance.md is pending); when hard to tell, confirm with the user.

## KPI System (KPI Dictionary & Definitions)

| KPI | Definition | Points to confirm |
|------|------|------|
| Period return | (Ending NAV − beginning NAV) / beginning NAV | **Prefer cumulative/adjusted NAV** — unit NAV is marked down at dividend ex-dates and understates returns; confirm dividend treatment |
| Annualized return | (1 + period return)^(365 / days in period) − 1 | Do not annualize periods under 6 months (short-period annualization amplifies volatility); annualized figures must state the underlying period |
| Max drawdown | max(1 − NAV / running historical peak) | Annotate the drawdown's start/end dates and whether it has recovered |
| Annualized volatility | Std dev of daily returns × √244 | Declare the convention: trading days √244 vs calendar days √365 |
| Sharpe ratio | (Annualized return − risk-free rate) / annualized volatility | **The risk-free-rate assumption must be stated explicitly** (e.g. 2%), never left implicit |
| Calmar ratio | Annualized return / max drawdown | Do not compute when drawdown is 0 or near 0 |
| Net subscription | Subscribed units − redeemed units | **Requires subscription/redemption data**; skip if missing |
| AUM change | Ending AUM − beginning AUM, split into NAV contribution vs flow contribution | **Requires AUM data**; AUM growth ≠ subscription inflow (it may just be NAV appreciation) |
| Holder structure | Institutional/retail share, average units per holder | **Requires holder data**; skip if missing |

Metrics with missing fields: skip them and state in the report "the data does not include X, so Y was not computed" — never fabricate. Multi-fund comparisons must align periods first — funds with different inception dates cannot be compared on cumulative returns directly.

## Typical Analysis Themes

1. **Performance & risk panorama**: normalized return curve + drawdown curve + core metrics table (return/volatility/drawdown/Sharpe); examine performance separately in market up and down phases — never conclude from a single cumulative number
2. **Multi-fund / peer comparison**: side-by-side under identical period definitions; risk-return scatter (x volatility, y annualized return) to locate "lower volatility at the same return, higher return at the same volatility"; highest return ≠ best risk-adjusted
3. **AUM & flow behavior** (requires AUM/flow data): AUM trajectory and net subscriptions; the temporal relation between flows and performance — "subscriptions surge after NAV highs, redemptions surge after deep drawdowns" is the classic chase-and-flee pattern; phrase cautiously (correlation, not causation)
4. **Rolling metrics & performance persistence**: rolling annualized return/volatility/Sharpe to test whether performance depends on a single phase
5. **Holder structure** (requires holder data): shifts in the institutional/retail mix, concentration and redemption pressure

## Narrative Language

NAV (净值), drawdown (回撤), annualized (年化), Sharpe (夏普), volatility (波动), subscription/redemption (申赎), retained AUM (保有规模), risk-adjusted return (风险调整后收益). Audience tiers: fund-company executives (AUM- and ranking-oriented, conclusions first); research teams (keep risk-adjusted returns and definition details); retail investors (plain language, risk warnings up front). Phrasing discipline: attach "past performance does not predict future results" to any performance conclusion; "NAV gains were accompanied by larger net subscriptions", not "performance attracted inflows" (causal discipline); **never quote peer averages or benchmark-index values (e.g. CSI 300 / 沪深300) from memory** — funds are the highest-risk scenario for fabricated benchmarks; enforce benchmark discipline strictly (user-provided, or authorized search with cited sources).

## Report Section Emphasis

Deep-dive priority: performance & risk panorama (always) → multi-fund comparison (always when multiple funds) → AUM & flows (requires data) → rolling persistence → holder structure (requires data). Go-to charts: normalized NAV lines (multi-fund comparison, base = 1), drawdown area chart (filled downward from the 0 axis), risk-return scatter, AUM bars + signed net-subscription bars, rolling-metric lines. All within ECharts 5.4.3 pure-JSON capability.
