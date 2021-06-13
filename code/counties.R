


setwd("C:/Users/James/Desktop/mathbio")

clim <- read.csv("data/clim_nc.csv")


clim$mean_t <- sapply( clim$mean_t, function(x) 
  (x-32)*(5/9) )

clim$sum_p <- sapply( clim$sum_p, function(x) 
  (x * 25.4)) 

df <- read.csv( "data/mosqutio_data.csv")
df <- subset(df, trap_type ==  "CO2")

clim$prop_pos  <- NA
clim$std_catch <- NA

for(i in 1:nrow(clim)){
  for(j in 1:nrow(df)){
    if(clim$year[i]   == df$year[j]  &
       clim$month[i]  == df$month[j] &
       clim$county[i] == df$county[j]){
      
          clim$prop_pos[i]  <- df$prop_pos[j]
          clim$std_catch[i] <- df$std_catch[j] 
    }
  }
}

write.csv(clim, "data/comb_data.csv")




