#--------------------------------  NOTE  ----------------------------------------
# 1 This code is to quantify single time series uncertainty based on different data sources;
# 2 The format of the input data is [ERA WTK];
# 3 Coder: Flora Zhang         Date: 08/02/2023       @ NREL
#--------------------------------------------------------------------------------

mv_single <- function(df) {
  library(ForeCA)
  library(fields)
  library(imputeTestbench)
  # df <- data.frame(dataset[,c('ERA', 'WTK')])
  # window size: 12
   
  # Moving-window Entropy
  en_era <- c()
  en_wtk <- c()
  for (i in 1:(dim(df)[1]-12)){
     en_era <- ForeCA::spectral_entropy(df$ERA[i:(i+12)])
     en_wtk <- ForeCA::spectral_entropy(df$WTK[i:(i+12)])
  } 

  # Moving-window Standard Deviation
  sd_era <- c()
  sd_wtk <- c()
  for (i in 1:(dim(df)[1]-12)){
     sd_era <- sd(df$ERA[i:(i+12)])
     sd_wtk <- sd(df$WTK[i:(i+12)])
  } 
  
  # Moving-window Turbulence Intensity
  ti_era <- c()
  ti_wtk <- c()
  for (i in 1:(dim(df)[1]-12)){
     ti_era <- (max(df$ERA[i:(i+12)])-min(df$ERA[i:(i+12)]))/mean(df$ERA[i:(i+12)])
     ti_wtk <- (max(df$WTK[i:(i+12)])-min(df$WTK[i:(i+12)]))/mean(df$WTK[i:(i+12)])
  } 
    
  # Moving-window Variability Index
  vi_era <- c()
  vi_wtk <- c()
  for (i in 1:(dim(df)[1]-12)){
     ti_era <- sd(df$ERA[i:(i+12)])/mean(df$ERA[i:(i+12)])
     ti_wtk <- sd(df$WTK[i:(i+12)])/mean(df$WTK[i:(i+12)])
  } 
  #result <- as.matrix(cbind(nCRPS, pb_ave, npb_ave, ACE, CE_98, reliability, sharpness))
  result <- list('entropy' = cbind(en_era, en_wtk),  'sd' = cbind(sd_era, sd_wtk), 
  'ti' = cbind(ti_era, ti_wtk), 'vi' = cbind(vi_era, vi_wtk))
  
  return(result)
}

# visualize the metrics in heatmaps
# given example: hourly data
en_era.matrix <- matrix(en_era, nrow = 365, ncol = 24)
sd_era.matrix <- matrix(sd_era, nrow = 365, ncol = 24)
ti_era.matrix <- matrix(ti_era, nrow = 365, ncol = 24)
vi_era.matrix <- matrix(vi_era, nrow = 365, ncol = 24)

en_wtk.matrix <- matrix(en_wtk, nrow = 365, ncol = 24)
sd_wtk.matrix <- matrix(sd_wtk, nrow = 365, ncol = 24)
ti_wtk.matrix <- matrix(ti_wtk, nrow = 365, ncol = 24)
vi_wtk.matrix <- matrix(vi_wtk, nrow = 365, ncol = 24)

image.plot(1:365, 1:24, en_era.matrix, xlab = "day", ylab = "hour", main = "Entropy")
image.plot(1:365, 1:24, en_wtk.matrix, xlab = "day", ylab = "hour", main = "Entropy")

image.plot(1:365, 1:24, sd_era.matrix, xlab = "day", ylab = "hour", main = "Standard Deviation")
image.plot(1:365, 1:24, sd_wtk.matrix, xlab = "day", ylab = "hour", main = "Standard Deviation")

image.plot(1:365, 1:24, ti_era.matrix, xlab = "day", ylab = "hour", main = "Turbulence Intensity",zlim=c(0,1))
image.plot(1:365, 1:24, ti_wtk, xlab = "day", ylab = "hour", main = "Turbulence Intensity",zlim=c(0,1))

image.plot(1:365, 1:24, vi_era.matrix, xlab = "day", ylab = "hour", main = "Variability Index")
image.plot(1:365, 1:24, vi_wtk.matrix, xlab = "day", ylab = "hour", main = "Variability Index")


