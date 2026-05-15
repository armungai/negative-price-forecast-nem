# Run results — 2026-05-15T11:42:56

## Environment
```
python          3.11.2
platform        macOS-26.4.1-arm64-arm-64bit
pandas          3.0.3
numpy           2.4.4
scikit-learn    1.8.0
matplotlib      3.10.9
seaborn         0.13.2
scipy           1.17.1
statsmodels     0.14.6
```

## Random Forest (test set)
| Metric | Value |
|---|---|
| accuracy | 0.9490 |
| precision | 0.8968 |
| recall | 0.9583 |
| f1 | 0.9265 |
| roc_auc | 0.9912 |
| pr_auc | 0.9836 |
| brier | 0.0399 |
| log_loss | 0.1490 |

## Logistic Regression (test set)
| Metric | Value |
|---|---|
| accuracy | 0.9424 |
| precision | 0.8854 |
| recall | 0.9515 |
| f1 | 0.9172 |
| roc_auc | 0.9882 |
| pr_auc | 0.9740 |
| brier | 0.0410 |
| log_loss | 0.1512 |

## Regime stability
| period           |    n |   neg_rate |     f1 |   precision |   recall |
|:-----------------|-----:|-----------:|-------:|------------:|---------:|
| H2a Jul-Sep 2024 | 4416 |     0.2982 | 0.9164 |      0.8787 |   0.9575 |
| H2b Oct-Dec 2024 | 4369 |     0.3731 | 0.9348 |      0.9119 |   0.9589 |

## Ablation study
| config                  |   n_removed |   n_features |     f1 |   pr_auc |   delta_f1 |
|:------------------------|------------:|-------------:|-------:|---------:|-----------:|
| All features (baseline) |           0 |           33 | 0.9265 |   0.9836 |     0      |
| no_rrp_lags             |           4 |           29 | 0.886  |   0.959  |    -0.0406 |
| no_rrp_lag1_only        |           1 |           32 | 0.8917 |   0.9642 |    -0.0348 |
| no_curtailment          |           4 |           29 | 0.9161 |   0.9788 |    -0.0104 |
| no_fcas                 |           8 |           25 | 0.9236 |   0.986  |    -0.0029 |
| no_interconnector       |           5 |           28 | 0.9255 |   0.9842 |    -0.001  |
| short_lags_only         |           3 |           30 | 0.9261 |   0.9837 |    -0.0004 |
| long_lags_only          |          10 |           23 | 0.8816 |   0.9571 |    -0.0449 |
