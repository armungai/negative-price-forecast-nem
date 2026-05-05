# Section 3 — Experimental Analysis Inputs

*Auto-generated from `notebooks/Random_Forest_V2.ipynb`*


## Environment

- **Python:** `3.11.2 (v3.11.2:878ead1ac1, Feb  7 2023, 10:02:41) [Clang 13.0.0 (clang-1300.0.29.30)]`
- **OS:** `macOS-26.3-arm64-arm-64bit` (`arm64`)
- **Processor:** `arm` (8 cores)
- **RAM:** 16.0 GB
- **numpy:** `2.4.3`
- **pandas:** `3.0.1`
- **scikit-learn:** `1.8.0`
- **matplotlib:** `3.10.8`
- **nemosis:** `not available`
- **random_state:** `42`
- **Train period:** 2023-01-02 00:00:00 to 2024-06-30 23:30:00
- **Test period:** 2024-07-01 00:00:00 to 2024-12-31 00:00:00
- **X_train shape:** (26208, 33)
- **X_test shape:** (8785, 33)
- **Train positive rate:** 0.2353 (23.5%)
- **Test positive rate:** 0.3355 (33.5%)

### Feature list (33 features)

1. `RAISE6SECRRP`
2. `RAISE60SECRRP`
3. `RAISE5MINRRP`
4. `RAISEREGRRP`
5. `LOWER6SECRRP`
6. `LOWER60SECRRP`
7. `LOWER5MINRRP`
8. `LOWERREGRRP`
9. `TOTALDEMAND`
10. `AVAILABLEGENERATION`
11. `AVAILABLELOAD`
12. `DEMANDFORECAST`
13. `DISPATCHABLEGENERATION`
14. `DISPATCHABLELOAD`
15. `NETINTERCHANGE`
16. `CLEAREDSUPPLY`
17. `UIGF`
18. `SEMISCHEDULE_CLEAREDMW`
19. `SEMISCHEDULE_COMPLIANCEMW`
20. `MWFLOW_V-SA`
21. `MWLOSSES_V-SA`
22. `CURTAILMENT_MW`
23. `RRP_lag1`
24. `RRP_lag6`
25. `RRP_lag12`
26. `RRP_lag48`
27. `TOTALDEMAND_lag1`
28. `TOTALDEMAND_lag6`
29. `TOTALDEMAND_lag12`
30. `CURTAILMENT_MW_lag1`
31. `CURTAILMENT_MW_lag6`
32. `NETINTERCHANGE_lag1`
33. `NETINTERCHANGE_lag6`


## Baseline Comparison

| Metric | Logistic Regression | Random Forest | Δ (RF − LR) |
|--------|--------------------:|-------------:|------------:|
| F1 | 0.9172 | 0.9265 | +0.0093 |
| Accuracy | 0.9424 | 0.9490 | +0.0066 |
| Precision | 0.8854 | 0.8968 | +0.0114 |
| Recall | 0.9515 | 0.9583 | +0.0068 |
| ROC-AUC | 0.9882 | 0.9912 | +0.0029 |
| PR-AUC | 0.9740 | 0.9836 | +0.0096 |
| Brier | 0.0410 | 0.0399 | -0.0011 |

### LR Confusion Matrix (raw)

|  | Pred Normal | Pred Negative |
|--|------------|--------------|
| **Actual Normal** | 5475 | 363 |
| **Actual Negative** | 143 | 2804 |

### LR Confusion Matrix (normalised by true class)

|  | Pred Normal | Pred Negative |
|--|------------|--------------|
| **Actual Normal** | 0.9378 | 0.0622 |
| **Actual Negative** | 0.0485 | 0.9515 |

### Top 10 LR Coefficients (standardised features)

| Feature | Coefficient |
|---------|------------:|
| `RRP_lag1` | -15.3693 |
| `LOWER60SECRRP` | +2.9577 |
| `CURTAILMENT_MW` | +2.5435 |
| `CURTAILMENT_MW_lag1` | -1.6383 |
| `LOWER6SECRRP` | +1.5446 |
| `CLEAREDSUPPLY` | +1.3526 |
| `UIGF` | +1.1545 |
| `RAISE5MINRRP` | -1.1404 |
| `NETINTERCHANGE_lag1` | -1.1154 |
| `MWFLOW_V-SA` | -1.0760 |


## Ablation Study

Full model baseline: F1 = 0.9265, PR-AUC = 0.9836

| Ablation | Features Removed | N Removed | F1 | PR-AUC | Δ F1 | Δ PR-AUC |
|----------|-----------------|:---------:|:----:|:------:|:----:|:--------:|
| no_rrp_lags | RRP_lag1, RRP_lag6, RRP_lag12, RRP_lag48 | 4 | 0.8860 | 0.9590 | -0.0406 | -0.0246 |
| no_rrp_lag1_only | RRP_lag1 | 1 | 0.8917 | 0.9642 | -0.0348 | -0.0194 |
| no_curtailment | UIGF, CURTAILMENT_MW, CURTAILMENT_MW_lag1, CURTAILMENT_MW_lag6 | 4 | 0.9161 | 0.9788 | -0.0104 | -0.0049 |
| no_fcas | RAISE6SECRRP, RAISE60SECRRP, RAISE5MINRRP, RAISEREGRRP, LOWER6SECRRP, LOWER60SECRRP, LOWER5MINRRP, LOWERREGRRP | 8 | 0.9236 | 0.9860 | -0.0029 | +0.0023 |
| no_interconnector | NETINTERCHANGE, MWFLOW_V-SA, MWLOSSES_V-SA, NETINTERCHANGE_lag1, NETINTERCHANGE_lag6 | 5 | 0.9255 | 0.9842 | -0.0010 | +0.0006 |
| short_lags_only | RRP_lag12, RRP_lag48, TOTALDEMAND_lag12 | 3 | 0.9261 | 0.9837 | -0.0004 | +0.0001 |
| long_lags_only | RRP_lag1, RRP_lag6, RRP_lag12, TOTALDEMAND_lag1, TOTALDEMAND_lag6, TOTALDEMAND_lag12, CURTAILMENT_MW_lag1, CURTAILMENT_MW_lag6, NETINTERCHANGE_lag1, NETINTERCHANGE_lag6 | 10 | 0.8816 | 0.9571 | -0.0449 | -0.0265 |

Chart: `figures/ablation_delta_f1.png`


## Calibration

- **Brier Score (RF):** 0.0399
- **Brier Score (LR):** 0.0410

### Per-Decile Calibration (RF)

| Decile | Mean Predicted | Actual Positive Rate | Count |
|:------:|:--------------:|:-------------------:|:-----:|
| 0 | 0.0020 | 0.0000 | 879 |
| 1 | 0.0087 | 0.0000 | 878 |
| 2 | 0.0215 | 0.0000 | 879 |
| 3 | 0.0526 | 0.0046 | 878 |
| 4 | 0.1037 | 0.0068 | 879 |
| 5 | 0.2033 | 0.0342 | 878 |
| 6 | 0.5453 | 0.4066 | 878 |
| 7 | 0.8786 | 0.9067 | 879 |
| 8 | 0.9673 | 0.9966 | 878 |
| 9 | 0.9922 | 0.9989 | 879 |

Plots: `figures/rf_pr_curve.png`, `figures/rf_calibration.png`, `figures/rf_confusion_matrix_normalised.png`


## Regime Stability

| Regime | N | Pos Rate | RF F1 | RF Prec | RF Rec | RF PR-AUC | LR F1 | LR Prec | LR Rec | LR PR-AUC |
|--------|--:|:--------:|:-----:|:-------:|:------:|:---------:|:-----:|:-------:|:------:|:---------:|
| H2a (Jul-Sep) | 4416 | 29.8% | 0.9164 | 0.8787 | 0.9575 | 0.9801 | 0.8982 | 0.8587 | 0.9415 | 0.9637 |
| H2b (Oct-Dec) | 4369 | 37.3% | 0.9348 | 0.9119 | 0.9589 | 0.9864 | 0.9329 | 0.9077 | 0.9595 | 0.9817 |


## Feature Importance (Full Model)

| Rank | Feature | Gini Importance |
|:----:|---------|:---------------:|
| 1 | `RRP_lag1` | 0.2944 |
| 2 | `CURTAILMENT_MW` | 0.1509 |
| 3 | `SEMISCHEDULE_COMPLIANCEMW` | 0.1028 |
| 4 | `CURTAILMENT_MW_lag1` | 0.0652 |
| 5 | `LOWER60SECRRP` | 0.0552 |
| 6 | `TOTALDEMAND` | 0.0441 |
| 7 | `CLEAREDSUPPLY` | 0.0421 |
| 8 | `TOTALDEMAND_lag1` | 0.0331 |
| 9 | `RRP_lag6` | 0.0267 |
| 10 | `MWFLOW_V-SA` | 0.0262 |
| 11 | `LOWER6SECRRP` | 0.0207 |
| 12 | `UIGF` | 0.0165 |
| 13 | `LOWER5MINRRP` | 0.0156 |
| 14 | `DISPATCHABLELOAD` | 0.0144 |
| 15 | `LOWERREGRRP` | 0.0130 |
