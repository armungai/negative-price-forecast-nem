# How did we get here?

**Why we started with GARCH(1,1)**

The ACF of RRP² showed strong volatility clustering — calm periods cluster together, volatile periods cluster together. This is the primary empirical justification for GARCH. A vanilla GARCH(1,1) was the natural baseline — it captures this clustering using only price history, no external information.

Result: alpha + beta = 0.9999 (near-IGARCH). The model hit the stationarity boundary because extreme SA1 price spikes (up to 37 standard deviations) dominate MLE estimation, making volatility appear permanently persistent. This is documented in the electricity price literature and reflects data properties, not a modelling failure.

---

**Why we moved to GARCH-X**

The EDA showed CURTAILMENT_MW had Spearman -0.63 with RRP — the strongest signal in the dataset — and TOTALDEMAND had +0.59. Both relationships were highly nonlinear (large Pearson vs Spearman divergence). Vanilla GARCH ignores these physical drivers entirely — it only knows that volatility was high, not why.

GARCH-X adds curtailment and demand directly into the variance equation, letting physical market conditions shift the volatility estimate. This is empirically justified — curtailment is a structural cause of negative prices, not just a correlated symptom.

Result: ΔAIC = -224.95 vs baseline. Strong evidence that physical drivers improve the variance model beyond price history alone. Alpha + beta still hitting boundary — the extreme spike problem persists.

---

**Why we tried GJR-GARCH-X**

GJR-GARCH treats negative and positive shocks differently via an indicator variable. The hypothesis was that negative price episodes (renewable oversupply) and positive spikes (supply shortage) are physically different events and should have different effects on future volatility.

Result: gamma = 0.000 — the asymmetry term contributed nothing. Positive and negative shocks drive future volatility equally in SA1. GJR-GARCH-X ΔAIC = -222.94, marginally worse than GARCH-X due to the extra parameter adding no value. GJR was rejected.

---

**Why we moved to NAGARCH-X**

NAGARCH introduces a different type of asymmetry — instead of a binary indicator for negative vs positive shocks, it shifts the entire shock term by theta times the previous standard deviation. This captures a more subtle asymmetry: the effect of a shock depends on its magnitude relative to the current volatility level, not just its sign.

Result: ΔAIC = -1782 vs baseline, -1557 vs GARCH-X. A dramatic improvement. theta = -0.303 — negative, meaning positive price spikes drive more future volatility than negative episodes of equal magnitude. This is the inverse leverage effect documented in the electricity price literature. Beta = 0 — once asymmetric shocks and exogenous variables are included, variance persistence disappears. Physically plausible but unusual.

---

**Why we added the ARMA mean equation**

The ACF of raw RRP showed strong autocorrelation at lag 1 (0.75). Subtracting the seasonal mean removes the daily price cycle but not the price level autocorrelation. If this autocorrelation leaks into the residuals fed to NAGARCH-X, the variance model is partly modelling mean dynamics rather than pure variance — contaminating the parameter estimates.

ARMA(1,1) was tried first but failed the Ljung-Box test at lags 5-20. The reason: electricity prices have daily, weekly and monthly periodicities that simple consecutive ARMA lags cannot capture. This is documented in Liu & Shi (2013) who used AR terms at economically meaningful intervals (1 hour, half-day, 1 day, 2 days, 1 week etc.) rather than consecutive lags.

Python's statsmodels was computationally infeasible for this lag structure — the 336-dimensional Kalman filter state space took 18+ minutes without converging. R's Fortran-based implementation fitted the same model in under 20 seconds.

The seasonal ARMA specification (AR at lags 2, 23, 48, 96, 144, 336 + MA(1-10)) achieved clean residuals at lags 1, 5, and 10 (p > 0.05), with some remaining structure at lag 20 reflecting the weekly periodicity. Squared residuals showed massive volatility clustering (p = 0 at all lags), confirming NAGARCH-X remains justified.

---

**Why ARMA-NAGARCH-X is the final model**

Fitting NAGARCH-X on the seasonally ARMA-cleaned residuals produced more interpretable parameters:

- **theta = -0.703** — stronger and cleaner asymmetry signal than without ARMA (theta = -0.303). Positive price spikes drive more future volatility than negative episodes.
- **beta = 0.189** — genuine variance persistence emerges once mean dynamics are properly removed. The beta = 0 result in plain NAGARCH-X was an artefact of the mean equation absorbing variance structure.
- **gamma1, gamma2 positive** — curtailment and demand continue to shift variance meaningfully.
- **alpha = 0.543** — lower than NAGARCH-X alone (0.916), because the seasonal AR structure absorbed autocorrelation that was previously attributed to shock effects.

The combined model is more honestly specified — mean dynamics modelled by ARMA, variance dynamics modelled by NAGARCH-X — consistent with the ARMA-GARCH framework recommended in the literature.

# How the percentage of negative price is calulated:

---

**What we know at each interval**

At any given 30-minute interval t, we have two things:

**1. The seasonal mean** — the average historical price at this time of day. For example, at 2pm on a weekday the average price might be $80/MWh. This is our best guess of what the price "should" be right now based purely on time of day patterns.

**2. The conditional standard deviation σ_t** — this is what ARMA-NAGARCH-X gives us. It's our estimate of how uncertain the market is right now. High curtailment, recent price spikes, high demand — all of these shift σ_t upward.

---

**The assumption**

We assume that at time t, the actual price is normally distributed around the seasonal mean with standard deviation σ_t:

```
RRP_t ~ Normal(seasonal_mean_t, σ²_t)
```

In plain English: we expect the price to be around the seasonal mean, but it could deviate by roughly σ_t in either direction.

---

**The probability calculation**

Given that distribution, we ask: what's the probability the price lands below zero?

```
P(RRP < 0) = P(Z < (0 - seasonal_mean) / σ_t)
```

Where Z is the standard normal distribution. This is just asking: how many standard deviations below the expected price is zero?

A concrete example:

- Seasonal mean = $80, σ = $20 → zero is 4 standard deviations away → P(negative) ≈ 0.003%
- Seasonal mean = $20, σ = $50 → zero is 0.4 standard deviations away → P(negative) ≈ 34%
- Seasonal mean = -$10, σ = $30 → zero is actually above the mean → P(negative) > 50%

---

**In code this is just:**

```python
prob = norm.cdf(0, loc=seasonal_mean, scale=sigma)
```

`norm.cdf` is the normal distribution's cumulative distribution function — it tells you the probability of landing below a given value. We're asking it: given a normal distribution centred at `seasonal_mean` with spread `sigma`, what fraction of that distribution sits below zero?

---

**So where does NAGARCH-X actually fit in?**

NAGARCH-X is what gives us σ_t at each interval. It's the engine that converts curtailment levels, demand, and past price shocks into a volatility estimate. The probability calculation itself is just one line of maths on top of that.

The quality of P(RRP < 0) is entirely determined by how good σ_t is. That's why the model selection journey mattered — every step from GARCH to GARCH-X to NAGARCH-X to ARMA-NAGARCH-X was improving the σ_t estimate, which directly improves the probability estimates.
