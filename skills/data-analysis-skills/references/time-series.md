# Time-Series Analysis & Forecasting

Load when the data has a time dimension and the user needs trend analysis or forecasting.

## Method Tiers (choose in this order; do not bring in heavier methods)

| Tier | Method | When |
|------|------|------|
| Default | Exponential smoothing (Holt-Winters), ARIMA / SARIMA (statsmodels) | The vast majority of business series; interpretable, stable on small data |
| Optional | Prophet | Pronounced holiday/multi-seasonal effects and prophet is already installed |
| Never | LSTM and other deep learning | Heavy dependencies; no better than classical methods on small data (explicitly excluded by requirements) |

## Pre-Forecast Checks (fail → degrade to trend description)

1. **Number of points**: monthly series < 24 points, weekly < 52 → **no model forecasting**; describe trend and seasonality only, and say why (sample too small to estimate seasonal terms stably)
2. **Gaps & frequency**: is the time index evenly spaced, any missing months? Fill gaps or resample first, and record it in the Data Processing Notes
3. **Structural breaks**: level shifts visible to the eye (product revamp, pandemic) → annotate them in the report; consider modeling only the post-break data
4. **Stationarity**: run an ADF test before ARIMA; difference as needed

## Standard Flow

1. Resample to the analysis granularity (day/week/month) → 2. STL decomposition (trend/seasonal/residual; the decomposition plot goes into the report) → 3. Select the model order with a stated basis (see below) and fit → 4. Residual diagnostics (Ljung-Box) → 5. Out-of-sample backtest before trusting the forecast (see below) → 6. Forecast + **confidence intervals**

Forecasts must carry intervals: "next 3 months forecast X (95% interval [L, U])". A point forecast alone is not acceptable. Forecast horizon must not exceed 1/4 of the history length; beyond that, state the extrapolation risk.

## Model Order Selection

Don't pick (p,d,q) or smoothing parameters by guesswork — an unjustified order is just a hidden assumption the reader can't check:

- ARIMA/SARIMA: read ACF/PACF (cutoff vs tail-off) to seed orders, or grid-search by AIC/BIC; `pmdarima.auto_arima` is fine when installed (fall back to a manual AIC/BIC search if it is missing).
- Record the chosen order and the basis for it in the report, so the choice is auditable rather than magic.

## Out-of-Sample Validation (do this before the final forecast)

A forecast you never backtested can be confidently wrong, and a 95% interval only describes the model's own assumptions, not whether it actually tracks reality. So before producing the final forecast:

- Hold out the last k periods (k ≈ the forecast horizon), or run walk-forward validation: refit on the training span only and report MAPE/MAE on the held-out tail.
- A model that just fits the full sample and extrapolates, with no backtest, is not acceptable — you have no evidence it predicts rather than overfits.
- Compare against a naive baseline (seasonal-naive / last-value). If the model can't beat that, prefer the simpler baseline and say so.

## Exponential Smoothing Example (statsmodels)

```python
from statsmodels.tsa.holtwinters import ExponentialSmoothing
# Monthly data, yearly seasonality; fall back to trend-only when the sample covers < 2 full seasonal cycles
model = ExponentialSmoothing(series, trend="add", seasonal="add", seasonal_periods=12).fit()
forecast = model.forecast(3)
```

## Dependency Degradation

statsmodels missing and pip install fails: skip ARIMA/exponential smoothing; describe the trend with moving averages + YoY/MoM tables instead, and state in the report "why no model forecast was made".
