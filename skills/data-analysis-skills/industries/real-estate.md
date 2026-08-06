# Real Estate Industry Analysis Template

Scope: property developers (marketing / investment strategy / operations), agencies, and market researchers analyzing real-estate sales and market data — project sales & absorption, cash collection, market volume-price. Identification signals: fields such as purchase commitment / contract signing / online filing (认购/签约/网签), units (套数), floor area (面积), absorption rate (去化率), cash collection (回款), average/total price (均价/总价), building / unit type / listing (楼栋/户型/房源), sales office / walk-ins / intent deposits (案场/来访/认筹), city/submarket transaction volume-price (城市/板块成交量价), sellable inventory / months of inventory (可售库存/去化周期), or developer/project/homebuying descriptions. Routing: the developer's own P&L/expense/budget analysis → corporate-finance.md; brokerage business (listings & leads, showings, commissions) and rental operations (occupancy, rent, NOI) → general.md for now; when hard to tell, confirm with the user.

## KPI System (KPI Dictionary & Definitions)

| KPI | Definition | Points to confirm |
|------|------|------|
| Contracted amount / units / area | Aggregate by contract-signing date | **Purchase commitment (认购) ≠ contract signing (签约) ≠ online filing (网签) ≠ cash collection (回款)** — the four definitions differ widely; confirm which one the data uses first. Commitment-based data carries cancellation risk — conclusions must note it |
| Absorption rate | Cumulative units (or area) absorbed / total sellable units (or area) | Whether the denominator is **the current launch batch or the whole sellable project** changes results a lot — declare it; when unit- and area-based views coexist, report each |
| Average selling price (ASP) | Contracted amount / contracted area | **ASP movement ≠ unit-price movement** — it may be a mix shift (product type / building / unit-type composition); decompose the mix before concluding |
| Collection rate | Cumulative cash collected / cumulative contracted amount | **Requires collection data**; current-period collections include lagged collections from prior signings — declare the window definition |
| Months of inventory | Current sellable inventory / average monthly absorption over the last N months | **Requires inventory data**; declare the averaging window (sensitive to seasonality and launch cadence) |
| Walk-in-to-commitment conversion | Committing groups / walk-in groups | **Requires sales-office walk-in data**; distinguish organic walk-ins from channel-referred visits |
| Market volume & price | Transacted units/area, average transaction price, YoY/MoM | **Requires market data**; MoM is distorted by seasonal factors such as Chinese New Year — lead with YoY; citywide ASP is also mix-affected |
| Supply-demand ratio | Approved-for-sale area / transacted area | **Requires supply data**; skip if missing |

Metrics with missing fields: skip them and state in the report "the data does not include X, so Y was not computed" — never fabricate. Project-vs-market comparisons must align periods and definitions first.

## Typical Analysis Themes

1. **Sales & absorption panorama**: contracted amount/units trajectory + absorption progress + ASP trend; **a signing surge must be split into launch cadence vs demand change** — peaks created by batched online filings or concentrated launches do not signal warming demand
2. **Volume-price mix decomposition**: sales velocity and price differences across product types / buildings / unit types / area bands (Pareto: which unit types carry the velocity); decompose ASP movement into mix change vs unit-price change
3. **Collection vs signing gap** (requires collection data): signing and collection trajectories with the collection-rate trend; when the gap widens, flag cash-collection pacing for attention — phrase cautiously
4. **Sales-office conversion funnel** (requires walk-in data): stage conversion from walk-in → intent deposit → commitment → signing; channel-source comparison (organic vs channel-referred)
5. **Market conditions & months of inventory** (requires market data): market volume-price trends, inventory and months-of-inventory shifts; project absorption set against the market over the same period

## Narrative Language

Absorption (去化), sales velocity (流速), launch (推盘/推售), sellable value (可售货值), contract signing (签约), online filing (网签), cash collection (回款), sales office (案场), intent deposit (认筹). Audience tiers: developer executives (sellable-value and collection oriented, conclusions first); marketing line (walk-in conversion, channel and pricing detail); research / investment strategy (volume-price and months of inventory, definition detail). Phrasing discipline: "absorption accelerated after the price cut", not "the price cut drove absorption"; "transactions rebounded after the policy came out", not "the policy stimulated transactions" (policy attribution is real estate's classic causal-language trap); **never quote from memory any months-of-inventory health threshold (e.g. "under 12 months is healthy") or city/competitor rankings** — enforce benchmark discipline strictly (user-provided, or authorized search with cited sources); commitment-based conclusions must note cancellation risk.

## Report Section Emphasis

Deep-dive priority: sales & absorption panorama (always) → volume-price mix decomposition (always) → collection vs signing gap (requires data) → sales-office funnel (requires data) → market conditions (requires data). Go-to charts: contracted-amount bars + absorption-rate line on dual axes, ASP trend line, product/unit-type mix stacked bars or Pareto, sales-office funnel chart, market volume-price dual-axis lines. All within ECharts 5.4.3 pure-JSON capability.
