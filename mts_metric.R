#--------------------------------  NOTE  ----------------------------------------
# 1 This code is to quantify uncertainty based on multiple time series;
# 2 The format of the input data is [ts ts1 ...tsN];
# 3 Coder: Flora Zhang         Date: 08/02/2023       @ NREL
#--------------------------------------------------------------------------------

mw_mts <- function(df){
  library(MLmetrics)
  library(zoo)
  library(ForeCA)
  library(fields)
  library(hydroGOF)
  # df <- data.frame(dataset[,c('ts1',..., 'tsN')])
  # window size: 12
   
  # Moving-window Correlation
  cor_ts <- c()
  for (i in 1:(dim(df)[1]-12)){
     cor_ts <- cor(df$ts1, df$tsN,use = "pairwise.complete.obs")
  } 

  # Moving-window MAPE
  mape_ts <- c()
  for (i in 1:(dim(df)[1]-12)){
     mape_ts <- MAPE(df$ts1, df$tsN)
  } 
    
  result <- list('correlation' = cor_ts,  'MAPE' = mape_ts))
  
  return(result)
}

dis_ts <- function(df) {
  library(MLmetrics)
  library(zoo)
  library(ForeCA)
  library(fields)
  library(scoringRules)
  library(magrittr)
  library(dplyr)
  # df <- data.frame(dataset[,c('ts1',..., 'tsN')])
  
  ts_quantile <- apply(df, 1, quantile,probs = seq(0.1, 0.9, by = 0.1), na.rm = TRUE)
  
  # Spread Index
  si_ts <- matrix(0, ncol = 5, nrow = dim(df)[1])
  for (i in 1:(dim(df)[1])){
     si_ts[i,1] <- (max(df[i,])-min(df[i,]))/mean(df[i,])*100
     si_ts[i,2] <- (ts_quantile[i,9]-ts_quantile[i,1])/mean(df[i,])*100
     si_ts[i,3] <- (ts_quantile[i,8]-ts_quantile[i,2])/mean(df[i,])*100
     si_ts[i,4] <- (ts_quantile[i,7]-ts_quantile[i,3])/mean(df[i,])*100
     si_ts[i,5] <- (ts_quantile[i,6]-ts_quantile[i,4])/mean(df[i,])*100   
  } 

  # Predictability Index
  # window size: 12
  pi_ts <- matrix(0, ncol = 5, nrow = dim(df)[1])
  for (i in 1:(dim(df)[1])){
     pi_ts[i,1] <- mean(si_ts[i:(i+12),1]) - si_ts[(i+12),1]
     pi_ts[i,2] <- mean(si_ts[i:(i+12),2]) - si_ts[(i+12),2]
     pi_ts[i,3] <- mean(si_ts[i:(i+12),3]) - si_ts[(i+12),3]
     pi_ts[i,4] <- mean(si_ts[i:(i+12),4]) - si_ts[(i+12),4]
     pi_ts[i,5] <- mean(si_ts[i:(i+12),5]) - si_ts[(i+12),5] 
  } 
  
  result <- list('SI' = si_ts,  'PI' = pi_ts)
  
  return(result)
}

spatial_ts <- function(df){
	library(fields)
	# cc <- data.frame(dataset[,c(windspeed 'turbine1',..., 'turbineN')])
	# sites <- data.frame(,c('Latitude', 'Longtitude')
	br = seq(0,0.2,0.005) # farm lat/lon degree; this is for Cedar Creek wind farm
    ini.vals <- expand.grid(br, br)
	nug <- c()
	ran <- c()
	sill <- c()
	for (i in 1:dim(cc)[1]){
	  df.cc <- data.frame(cbind(ws = cc[i,], lat = sites$Latitude, lon = sites$Longitude))
 	  geo.cc <- as.geodata(df.cc, coords.col = 3:2, data.col = 1)
	  variog.mat<-variog(geo.cc,uvec = br, trend="1st", pairs.min = 30)
	  ols <- variofit(variog.mat, ini=ini.vals, fix.nug=FALSE)
	  nug <- c(nug, ols$nugget)
	  ran <- c(ran, ols$practicalRange)
	  sill <- c(sill, ols$cov.pars[1])
	}
	
	result <- list('nugget' = nug,  'range' = ran, 'sill' = sill)
  
  return(result)

}

# to visualize the trend of each parameter
nug.matrix <- matrix(nug, nrow = 365, ncol = 24)
ran.matrix <- matrix(range, nrow = 365, ncol = 24)
sill.matrix <- matrix(sill, nrow = 365, ncol = 24)
image.plot(1:365, 1:24, nug.matrix, xlab = "day", ylab = "hour", main = "Nugget")
image.plot(1:365, 1:24, sill.matrix, xlab = "day", ylab = "hour", main = "Sill")
image.plot(1:365, 1:24, ran.matrix, xlab = "day", ylab = "hour", main = "Range")
