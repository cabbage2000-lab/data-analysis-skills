# Causal Inference Methods & Phrasing Discipline

Load when the user asks "did X cause/boost/affect Y" or explicitly wants causal conclusions.

## Step 1: What Level of Conclusion Does the Data Support?

| Data shape | Conclusion you may give |
|------|------|
| Cross-sectional observational data | Correlation only + confounder warnings |
| Panel data + intervention event + comparable control group | DID may be attempted |
| Observational data with rich covariates | PSM may be attempted |
| Randomized experiment data | Causal conclusions (hand off to ab-testing.md) |

When method prerequisites are unmet, the fixed response is: **"the current data does not support a causal conclusion" + what data would be needed** (e.g. pre/post data with a control group, a randomized experiment). This is not boilerplate disclaimer — make it specific to the user's scenario.

## Phrasing Table (enforced in reports and replies)

| Forbidden (causal assertion) | Replacement (correlational phrasing) |
|------|------|
| X boosted / caused / drove Y | X is strongly correlated with Y (r=…) |
| Sales rose because we ran ads | Months with higher ad spend also show higher sales, but the same period also had… |
| The effect of X is a z% lift in Y | A 1-unit change in X is associated with a z% change in Y (confounders uncontrolled) |

Correlational conclusions must do all three: (1) give the correlation coefficient and a strength judgment; (2) **proactively list the confounders visible in this data** (name the fields one by one, e.g. promotions, seasonality); (3) state the method or data that would be needed to establish causality.

## Method Quick Reference (use only when prerequisites hold; state assumptions in the report)

### DID (Difference-in-Differences)
- Prerequisites: treatment/control × pre/post panel data; **parallel-trends assumption** (pre-intervention trends of the two groups are parallel — must be verified with a plot that goes into the report)
- Output: DID estimate + standard error; parallel-trends plot

### PSM (Propensity Score Matching)
- Prerequisite: the key covariates driving "treated or not" are all present in the data (unverifiable — state this assumption honestly in the report)
- Flow: logit propensity scores → nearest-neighbor matching → check post-match covariate balance (SMD < 0.1) → compare outcomes
- Balance check fails: report the failure; do not force a conclusion

### Randomized Experiments
- Data comes from random assignment: follow the ab-testing.md test flow; causal phrasing is allowed (still report p-values and intervals)

## Regression Coefficients ≠ Causal Effects

"Controlling for other variables" in multiple regression is not causal identification: omitted variables, reverse causality, and collider bias may all be present. Use "association" phrasing for regression results unless the design satisfies one of the method prerequisites above.
