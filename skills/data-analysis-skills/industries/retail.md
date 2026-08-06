# Retail / E-commerce Analysis Template

Scope: e-commerce platforms, online shops, offline retail, omnichannel retail. Identification signals: fields or descriptions such as orders, SKU, GMV, shopping cart, store, category.

## KPI System (KPI Dictionary & Definitions)

| KPI | Definition | Points to confirm |
|------|------|------|
| GMV | Σ(quantity × unit price × (1 − discount)) | Whether returns/cancellations are excluded (default: include returns and disclose the return amount separately) |
| AOV (客单价) | GMV / order count | Distinguish per-order vs per-customer definitions |
| Repeat purchase rate | Customers with ≥2 purchases in the period / customers with any purchase | Confirm the measurement window (90 days / annual) |
| Return rate | Returned orders / total orders | Report both by order count and by amount |
| Conversion rate | Purchasing visitors / total visitors | **Requires traffic data**; cannot be derived from order data alone — skip and explain if missing |
| Inventory turnover | COGS / average inventory | **Requires inventory and cost data**; skip if missing |
| SKU sell-through (动销率) | SKUs with sales / SKUs listed | Requires the full set of listed SKUs |

Metrics with missing fields: skip them and state in the report "the data does not include X, so Y was not computed" — never fabricate.

## Typical Analysis Themes

1. **Sales trend & seasonality**: monthly/weekly GMV trajectory; identify and annotate mega-promotion peaks (618 / Double 11 / Double 12); promotion dependence (share of GMV from promotion months)
2. **Category/SKU structure**: Pareto analysis (concentration of category contribution); positioning differences between high-revenue-low-order and high-order-low-revenue categories
3. **Customer value segmentation (RFM)**: three-way segmentation by recency/frequency/monetary; report each segment's headcount share and contribution, with per-segment operating recommendations
4. **Promotion & discount effects**: discount depth × AOV/volume relationships (mind correlation ≠ causation — promotion months usually coincide with mega-promotion traffic)
5. **Channel & regional comparison**: GMV/AOV/return-rate differences across channels; regional market performance

## Narrative Language

GMV, AOV (客单价), SKU, sell-through (动销), mega-promotions (大促), repeat purchase (复购), per-unit price (件单价), units per transaction (连带率), sales per square meter (坪效, offline). For executives, speak plainly ("the best-selling category"); for analysts, keep the definition details. Attribute growth cautiously: "promotion months account for 24% of GMV", not "promotions drove 24% of revenue".

## Report Section Emphasis

Deep-dive priority: sales trend (always) → category structure (always) → channel comparison → RFM/repeat purchase (requires customer IDs) → promotion effects. Go-to charts: Pareto chart (categories), calendar heatmap or annotated line (mega-promotions), RFM segment matrix table.
