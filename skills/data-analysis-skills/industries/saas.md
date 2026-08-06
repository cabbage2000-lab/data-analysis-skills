# Internet / SaaS Analysis Template

Scope: subscription software, internet products, membership services. Identification signals: fields or descriptions such as MRR, ARR, subscription, retention, DAU, trial, churn.

## KPI System (KPI Dictionary & Definitions)

| KPI | Definition | Points to confirm |
|------|------|------|
| MRR / ARR | End-of-period monthly recurring revenue; ARR = MRR × 12 | Whether one-off revenue is included (it should be excluded) |
| Net New MRR | New + expansion − contraction − churned MRR | Whether all four components are present; if not, disclose using the available ones |
| MRR churn rate | MRR churned in the month / MRR at month start | Distinguish revenue-based vs customer-count-based definitions |
| Net dollar retention (NDR) | (MRR at month start + expansion − contraction − churn) / MRR at month start | >100% means net negative churn — call it out prominently |
| Trial conversion rate | Conversions to paid / trials | Confirm the conversion window (14/30 days) |
| LTV / CAC | LTV ≈ ARPA × gross margin / customer churn rate | Requires acquisition-cost data; if missing, report the LTV side only |
| DAU/MAU stickiness | Daily actives / monthly actives | Confirm the definition of "active" |
| Quick Ratio | (New + expansion) / (churn + contraction) | <2 growth under pressure; >4 healthy |

## Typical Analysis Themes

1. **Growth engine decomposition**: evolution of the MRR waterfall (new/expansion/contraction/churn) over time; whether growth is driven by new customers or by expansion
2. **Retention & churn (cohorts)**: retention curves or heatmaps by signup/first-purchase month; churn-rate trend and inflection-point detection
3. **Funnel conversion**: stage-by-stage conversion trends from trial to paid; decompose changes in conversion rate vs changes in acquisition volume
4. **Revenue quality**: NDR and Quick Ratio trends; MRR concentration (dependence on large accounts)
5. **Engagement & usage**: DAU/MAU stickiness, feature-usage distribution (requires behavioral data)

## Narrative Language

MRR, ARR, churn, NDR, cohort, funnel, ARPA, net negative churn, Rule of 40 (growth rate + profit margin). Quantify any slowdown statement: "average monthly MRR growth fell from 8% to 2% over the past 6 months". When churn rises, lead the warning with the revenue-based view (its direct impact on revenue).

## Report Section Emphasis

Deep-dive priority: growth engine decomposition (always) → retention/churn (always) → funnel conversion → revenue quality. Go-to charts: MRR waterfall or stacked bars (component evolution), cohort heatmap (retention), funnel chart (conversion), dual-axis lines (growth rate vs churn rate). For founder/executive audiences: conclusions first, with the trend inflection as the #1 key finding.
