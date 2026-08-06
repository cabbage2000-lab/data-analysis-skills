# A/B Testing & Experiment Analysis

Load when the user mentions experiments, control groups, A/B tests, or version comparisons.

## Pre-Analysis Checks (run in order; report problems before analyzing)

1. **Randomization**: was assignment random? Non-random assignment (self-selection, time-sliced) supports observational comparison only — downgrade the conclusions
2. **SRM check** (Sample Ratio Mismatch): chi-square test of the actual split ratio against the designed ratio; p < 0.01 means the split is broken and results are untrustworthy — report this problem first
3. **Sample size & power**: compute current power before testing (see below); power < 0.5 → state plainly "this experiment most likely cannot detect a real difference"
4. **Metric definitions**: the conversion denominator (impressions/clicks/visits) must be confirmed with the user

## Choosing the Test

| Metric type | Default method | Small sample (any expected cell < 5) |
|------|------|------|
| Conversion rate (binary) | Two-proportion z-test | Fisher's exact test |
| Mean (continuous) | Welch's t-test (no equal-variance assumption) | Mann-Whitney U |
| Counts | Poisson / negative-binomial comparison | Permutation test |

Reports must include: p-value, effect size (absolute difference and relative lift), 95% confidence interval. When the interval spans 0, say explicitly "no difference cannot be ruled out".

## Sample-Size Calculation (when the user asks "how long / how many users")

```python
from scipy import stats
import math

def sample_size_per_group(p_base, mde_abs, alpha=0.05, power=0.8):
    """Per-group sample size for a two-proportion test. p_base: baseline conversion rate; mde_abs: minimum detectable absolute lift."""
    p2 = p_base + mde_abs
    p_bar = (p_base + p2) / 2
    za, zb = stats.norm.ppf(1 - alpha / 2), stats.norm.ppf(power)
    n = ((za * math.sqrt(2 * p_bar * (1 - p_bar)) + zb * math.sqrt(p_base * (1 - p_base) + p2 * (1 - p2))) / mde_abs) ** 2
    return math.ceil(n)
```

## Common Pitfalls (flag proactively in the report)

- **Peeking**: checking significance and stopping before the planned sample size inflates the false-positive rate. If the user's data is a mid-experiment snapshot, flag this risk
- **Multiple comparisons**: when testing several metrics/groups at once, apply Bonferroni or BH correction to the decision metrics, or separate "primary metrics" from "observational metrics"
- **Simpson's paradox**: overall and stratified conclusions can flip; pivot by important dimensions (new vs existing users, platform)
- **Novelty effect**: early-launch lift may decay over time; for short experiments flag the extrapolation risk

## Conclusion Phrasing

- Significant with adequate power: "B significantly outperforms A at α=0.05 (p=…, lift …, 95% CI …)"
- Not significant: "No significant difference detected (p=…); at the current sample size this experiment can only reliably detect lifts of ≥ …" — give the minimum detectable effect, never just "not significant"
- Underpowered: state plainly "the sample size cannot support a reliable conclusion", give the required sample size, and **never declare a winner because the user is pressing**
