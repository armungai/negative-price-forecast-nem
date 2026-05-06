# ============================================================
# NEM SA1 — Seasonal ARMA mean equation
# Fits AR at economically meaningful lags + MA(1-10)
# Exports residuals for NAGARCH-X in Python
# ============================================================

# Install required packages if needed
install.packages("forecast")
library(forecast)

# ============================================================
# Load data
# ============================================================
df <- read.csv("../../data/sa1_merged_eda.csv")
df$SETTLEMENTDATE <- as.POSIXct(df$SETTLEMENTDATE)
df <- df[order(df$SETTLEMENTDATE), ]

# Split train/test
train <- df[df$SETTLEMENTDATE < as.POSIXct("2024-01-01"), ]

# Seasonal adjustment — subtract mean by time slot
train$time_slot <- as.integer(format(train$SETTLEMENTDATE, "%H")) * 2 + 
                   as.integer(format(train$SETTLEMENTDATE, "%M") >= 30)

slot_means <- tapply(train$RRP, train$time_slot, mean, na.rm=TRUE)
train$RRP_seasonal_mean <- slot_means[as.character(train$time_slot)]
train$RRP_adjusted <- train$RRP - train$RRP_seasonal_mean

# Drop first row to match Python (lost to lag)
y <- train$RRP_adjusted[2:nrow(train)]
cat("Training series length:", length(y), "\n")

# ============================================================
# Fit ARIMA with seasonal lag structure
# AR lags scaled to 30-min intervals:
#   lag 2   = 1 hour
#   lag 23  = ~half day
#   lag 48  = 1 day
#   lag 96  = 2 days
#   lag 144 = 3 days
#   lag 336 = 1 week
# MA lags 1-10
# ============================================================
cat("Fitting ARIMA — this will take 1-2 minutes...\n")

# Use Arima() from forecast package with fixed parameter approach
# We specify exact lags via the xreg approach for AR terms
# and standard MA terms

ar_lags <- c(2, 23, 48, 96, 144, 336)

# Build AR regressor matrix
T <- length(y)
max_lag <- max(ar_lags)

X_ar <- matrix(NA, nrow=T - max_lag, ncol=length(ar_lags))
for (i in seq_along(ar_lags)) {
    lag <- ar_lags[i]
    X_ar[, i] <- y[(max_lag - lag + 1):(T - lag)]
}
colnames(X_ar) <- paste0("AR_lag", ar_lags)

y_trimmed <- y[(max_lag + 1):T]
cat("Trimmed series length:", length(y_trimmed), "\n")

# Fit ARIMA(0,0,10) with AR lags as external regressors
# This gives us MA(1-10) properly estimated via MLE
# plus the seasonal AR structure via OLS-style regressors
fit <- Arima(
    y_trimmed,
    order = c(0, 0, 10),
    xreg = X_ar,
    method = "ML"
)

cat("Done.\n")
cat("AIC:", fit$aic, "\n")
cat("BIC:", fit$bic, "\n")

# Extract residuals
residuals_arma <- as.numeric(residuals(fit))
cat("Residuals length:", length(residuals_arma), "\n")
cat("Residuals mean:", mean(residuals_arma), "\n")
cat("Residuals std:", sd(residuals_arma), "\n")

# Ljung-Box tests
lb1  <- Box.test(residuals_arma, lag=1,  type="Ljung-Box")
lb5  <- Box.test(residuals_arma, lag=5,  type="Ljung-Box")
lb10 <- Box.test(residuals_arma, lag=10, type="Ljung-Box")
lb20 <- Box.test(residuals_arma, lag=20, type="Ljung-Box")

cat("\nLjung-Box test on residuals:\n")
cat("  Lag 1  p-value:", lb1$p.value,  "\n")
cat("  Lag 5  p-value:", lb5$p.value,  "\n")
cat("  Lag 10 p-value:", lb10$p.value, "\n")
cat("  Lag 20 p-value:", lb20$p.value, "\n")
cat("p > 0.05 = residuals are white noise\n")

lb1sq  <- Box.test(residuals_arma^2, lag=1,  type="Ljung-Box")
lb5sq  <- Box.test(residuals_arma^2, lag=5,  type="Ljung-Box")
lb10sq <- Box.test(residuals_arma^2, lag=10, type="Ljung-Box")
lb20sq <- Box.test(residuals_arma^2, lag=20, type="Ljung-Box")

cat("\nLjung-Box test on squared residuals:\n")
cat("  Lag 1  p-value:", lb1sq$p.value,  "\n")
cat("  Lag 5  p-value:", lb5sq$p.value,  "\n")
cat("  Lag 10 p-value:", lb10sq$p.value, "\n")
cat("  Lag 20 p-value:", lb20sq$p.value, "\n")
cat("p < 0.05 = volatility clustering remains -> NAGARCH-X justified\n")

# ============================================================
# Export residuals for Python
# ============================================================
output_path <- "../../data/arma_seasonal_residuals.csv"
write.csv(
    data.frame(residual = residuals_arma),
    output_path,
    row.names = FALSE
)
cat("\nResiduals saved to:", output_path, "\n")
cat("Load in Python with: pd.read_csv('../../data/arma_seasonal_residuals.csv')\n")