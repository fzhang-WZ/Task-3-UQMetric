#--------------------------------  NOTE  ----------------------------------------
# 1 This code is to quantify uncertainty based on ensemble members;
# 2 The format of the input data is [Actual ensemble ens1 ...ensN];
# 3 Coder: Flora Zhang         Date: 08/02/2023       @ NREL
#--------------------------------------------------------------------------------

mw_ensemble <- function(df){
  library(MLmetrics)
  library(zoo)
  library(ForeCA)
  library(fields)
  library(hydroGOF)
  # df <- data.frame(dataset[,c('Actual', 'ens1',..., 'ensN')])
  # window size: 12
   
  # Moving-window Correlation
  cor_ens <- c()
  for (i in 1:(dim(df)[1]-12)){
     cor_ens <- cor(df$ens1, df$ensN,use = "pairwise.complete.obs")
  } 

  # Moving-window MAPE
  mape_ens <- c()
  for (i in 1:(dim(df)[1]-12)){
     mape_ens <- MAPE(df$ens1, df$ensN)
  } 
  
  # Moving-window nRMSE
  nRMSE_ens <- c()
  for (i in 1:(dim(df)[1]-12)){
     nRMSE_ens <- nrmse(df$ens1, df$ensN)
  } 
    
  # Moving-window nMAE
  nMAE_ens <- c()
  for (i in 1:(dim(df)[1]-12)){
     nMAE_ens <- mean(abs(df$ens1-df$ensN))/12
  } 
  
  result <- list('correlation' = cor_ens,  'MAPE' = mape_ens, 
  'nRMSE' = nRMSE_ens, 'nMAE' = nMAE_ens))
  
  return(result)
}

dis_ensemble <- function(df) {
  library(MLmetrics)
  library(zoo)
  library(ForeCA)
  library(fields)
  library(scoringRules)
  library(magrittr)
  library(dplyr)
  # df <- data.frame(dataset[,c('Actual', 'ens1',..., 'ensN')])
  
  ens_quantile <- apply(df, 1, quantile,probs = seq(0.1, 0.9, by = 0.1), na.rm = TRUE)
  
  # Spread Index
  si_ens <- matrix(0, ncol = 5, nrow = dim(df)[1])
  for (i in 1:(dim(df)[1])){
     si_ens[i,1] <- (max(df[i,])-min(df[i,]))/mean(df[i,])*100
     si_ens[i,2] <- (ens_quantile[i,9]-ens_quantile[i,1])/mean(df[i,])*100
     si_ens[i,3] <- (ens_quantile[i,8]-ens_quantile[i,2])/mean(df[i,])*100
     si_ens[i,4] <- (ens_quantile[i,7]-ens_quantile[i,3])/mean(df[i,])*100
     si_ens[i,5] <- (ens_quantile[i,6]-ens_quantile[i,4])/mean(df[i,])*100   
  } 

  # Predictability Index
  # window size: 12
  pi_ens <- matrix(0, ncol = 5, nrow = dim(df)[1])
  for (i in 1:(dim(df)[1])){
     pi_ens[i,1] <- mean(si_ens[i:(i+12),1]) - si_ens[(i+12),1]
     pi_ens[i,2] <- mean(si_ens[i:(i+12),2]) - si_ens[(i+12),2]
     pi_ens[i,3] <- mean(si_ens[i:(i+12),3]) - si_ens[(i+12),3]
     pi_ens[i,4] <- mean(si_ens[i:(i+12),4]) - si_ens[(i+12),4]
     pi_ens[i,5] <- mean(si_ens[i:(i+12),5]) - si_ens[(i+12),5] 
  } 
  
  # CRPS
  ens_quantile <- apply(df, 1, quantile,probs = seq(0.01, 0.99, by = 0.01), na.rm = TRUE)
  colnames(ens_quantile) <-  paste0('Q', seq(1,99,by = 1))
  stand_dev <- (ens_quantile[, 'Q99']-ens_quantile[, 'Q50'])/qnorm(.99)
  stand_dev[stand_dev <= 0] <- 1e-10
  CRPS_all <- scoringRules::crps.numeric(df[, 'Actual'], family = 'norm', mean = ens_quantile[, 'Q50'], sd = stand_dev)
  nCRPS <- mean(CRPS_all)/max(df$Actual)
  
  #result <- as.matrix(cbind(nCRPS, pb_ave, npb_ave, ACE, CE_98, reliability, sharpness))
  result <- list('SI' = si_ens,  'PI' = pi_ens, 'CRPS' = nCRPS)
  
  return(result)
}
