#--------------------------------  NOTE  ----------------------------------------
# 1 This code is to quantify single time series uncertainty based on different data sources;
# 2 The format of the input data is [ERA OBS];
# 3 Coder: Flora Zhang         Date: 08/02/2023       @ NREL
#--------------------------------------------------------------------------------

mv_single <- function(df) {
  library(ForeCA)
  library(fields)
  library(imputeTestbench)
  library(zoo)
  # df <- data.frame(dataset[,c('ERA', 'OBS')])
  # window size: 12
  
  # Moving-window Entropy
  en_era <- c()
  en_obs <- c()
  for (i in 1:(dim(df)[1]-12)){
    en_era[i] <- ForeCA::spectral_entropy(df$ERA[i:(i+12)])
    en_obs[i] <- ForeCA::spectral_entropy(df$OBS[i:(i+12)])
  } 
  
  # Moving-window Standard Deviation
  sd_era <- c()
  sd_obs <- c()
  for (i in 1:(dim(df)[1]-12)){
    sd_era[i] <- sd(df$ERA[i:(i+12)])
    sd_obs[i] <- sd(df$OBS[i:(i+12)])
  } 
  
  # Moving-window Turbulence Intensity
  ti_era <- c()
  ti_obs <- c()
  for (i in 1:(dim(df)[1]-12)){
    ti_era[i] <- (max(df$ERA[i:(i+12)])-min(df$ERA[i:(i+12)]))/mean(df$ERA[i:(i+12)])
    ti_obs[i] <- (max(df$OBS[i:(i+12)])-min(df$OBS[i:(i+12)]))/mean(df$OBS[i:(i+12)])
  } 
  
  # Moving-window Variability Index
  vi_era <- c()
  vi_obs <- c()
  for (i in 1:(dim(df)[1]-12)){
    ti_era[i] <- sd(df$ERA[i:(i+12)])/mean(df$ERA[i:(i+12)])
    ti_obs[i] <- sd(df$OBS[i:(i+12)])/mean(df$OBS[i:(i+12)])
  } 
  #result <- as.matrix(cbind(entropy, sd, ti, vi))
  result <- list('entropy' = cbind(en_era, en_obs),  'sd' = cbind(sd_era, sd_obs), 
                 'ti' = cbind(ti_era, ti_obs), 'vi' = cbind(vi_era, vi_obs))
  
  return(result)
}


# visualize the metrics in heatmaps
# given example: hourly data
en_era.matrix <- matrix(en_era, nrow = 365, ncol = 24)
sd_era.matrix <- matrix(sd_era, nrow = 365, ncol = 24)
ti_era.matrix <- matrix(ti_era, nrow = 365, ncol = 24)
vi_era.matrix <- matrix(vi_era, nrow = 365, ncol = 24)

en_obs.matrix <- matrix(en_obs, nrow = 365, ncol = 24)
sd_obs.matrix <- matrix(sd_obs, nrow = 365, ncol = 24)
ti_obs.matrix <- matrix(ti_obs, nrow = 365, ncol = 24)
vi_obs.matrix <- matrix(vi_obs, nrow = 365, ncol = 24)

image.plot(1:365, 1:24, en_era.matrix, xlab = "day", ylab = "hour", main = "Entropy")
image.plot(1:365, 1:24, en_obs.matrix, xlab = "day", ylab = "hour", main = "Entropy")

image.plot(1:365, 1:24, sd_era.matrix, xlab = "day", ylab = "hour", main = "Standard Deviation")
image.plot(1:365, 1:24, sd_obs.matrix, xlab = "day", ylab = "hour", main = "Standard Deviation")

image.plot(1:365, 1:24, ti_era.matrix, xlab = "day", ylab = "hour", main = "Turbulence Intensity",zlim=c(0,1))
image.plot(1:365, 1:24, ti_obs, xlab = "day", ylab = "hour", main = "Turbulence Intensity",zlim=c(0,1))

image.plot(1:365, 1:24, vi_era.matrix, xlab = "day", ylab = "hour", main = "Variability Index")
image.plot(1:365, 1:24, vi_obs.matrix, xlab = "day", ylab = "hour", main = "Variability Index")


