# Run results — 2026-05-15T18:29:27

## Environment
```
python          3.11.2
platform        Windows-10-10.0.26200-SP0
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
| accuracy | 0.9513 |
| precision | 0.8721 |
| recall | 0.9526 |
| f1 | 0.9106 |
| roc_auc | 0.9909 |
| pr_auc | 0.9773 |
| brier | 0.0431 |
| log_loss | 0.1685 |

## Logistic Regression (test set)
| Metric | Value |
|---|---|
| accuracy | 0.9441 |
| precision | 0.8581 |
| recall | 0.9406 |
| f1 | 0.8974 |
| roc_auc | 0.9860 |
| pr_auc | 0.9673 |
| brier | 0.0400 |
| log_loss | 0.1473 |

## Regime stability
| period           |     n |   neg_rate |     f1 |   precision |   recall |
|:-----------------|------:|-----------:|-------:|------------:|---------:|
| H2a Jul-Sep 2024 | 13152 |     0.2227 | 0.8997 |      0.8536 |   0.9512 |
| H2b Oct-Dec 2024 |  4369 |     0.3731 | 0.9307 |      0.9073 |   0.9552 |

## Ablation study
| config                  |   n_removed |   n_features |     f1 |   pr_auc |   delta_f1 |
|:------------------------|------------:|-------------:|-------:|---------:|-----------:|
| All features (baseline) |           0 |           33 | 0.9106 |   0.9773 |     0      |
| no_rrp_lags             |           4 |           29 | 0.8552 |   0.9432 |    -0.0553 |
| no_rrp_lag1_only        |           1 |           32 | 0.8654 |   0.9492 |    -0.0452 |
| no_curtailment          |           4 |           29 | 0.9051 |   0.9715 |    -0.0055 |
| no_fcas                 |           8 |           25 | 0.9117 |   0.9813 |     0.0011 |
| no_interconnector       |           5 |           28 | 0.9102 |   0.9781 |    -0.0003 |
| short_lags_only         |           3 |           30 | 0.9108 |   0.9772 |     0.0003 |
| long_lags_only          |          10 |           23 | 0.8524 |   0.9408 |    -0.0582 |
