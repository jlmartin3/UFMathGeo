

setwd("C:/Users/James/Desktop/mathbio")

aedes <- read.csv("data/aedes_collections_nc.csv")
clim  <- read.csv("data/clim_nc.csv")


clim$mean_t <- sapply( clim$mean_t, function(x) 
                           (x-32)*(5/9) )





clim$countymonth <- NA
clim$countymonth <- paste0(clim$county, "_",
                           clim$month, "_",
                           clim$year)

aedes$countymonth <- NA
aedes$countymonth <- paste0(aedes$county, "_",
                            aedes$month, "_",
                            aedes$year)

aedes$mean_t <- NA
aedes$sum_p  <- NA


for(i in 1:nrow(aedes)){
  for(j in 1:nrow(clim)){
    if(aedes$countymonth[i] == clim$countymonth[j]){
      aedes$mean_t[i] <- clim$mean_t[j]
       aedes$sum_p[i] <-  clim$sum_p[j]
}}}



aedes <- aedes[,c(3,5:7, 9, 10, 12, 14, 16, 17)]


aedes$prop_pos <- aedes$num_collections_albopictus/
                  aedes$num_collection_events


aedes$std_catch <- aedes$num_albopictus_collected/
                   aedes$num_trap_nights

#aedes <- aedes[,c(1:4, 9:12)]

levels(aedes$trap_type)

aedes_BGS  <- subset(aedes, trap_type == "BGS")
aedes_CO2  <- subset(aedes, trap_type == "CO2")
aedes_GRAV <- subset(aedes, trap_type == "GRAV")

write.csv(aedes, "data/mosqutio_data.csv")




plot( aedes_BGS$mean_t,  aedes_BGS$prop_pos, col = "blue",
      xlim = c(5,30), pch = 19)
points( aedes_CO2$mean_t,  aedes_CO2$prop_pos, 
        col = "red", pch = 19)


plot( aedes_BGS$mean_t,  aedes_BGS$prop_pos)
plot( aedes_CO2$mean_t,  aedes_CO2$prop_pos)
plot(aedes_GRAV$mean_t, aedes_GRAV$prop_pos)

plot( aedes_BGS$sum_p,  aedes_BGS$prop_pos)
plot( aedes_CO2$sum_p,  aedes_CO2$prop_pos)
plot(aedes_GRAV$sum_p, aedes_GRAV$prop_pos)



plot( aedes_BGS$mean_t,  aedes_BGS$std_catch)
plot( aedes_CO2$mean_t,  aedes_CO2$std_catch)
plot(aedes_GRAV$mean_t, aedes_GRAV$std_catch)

plot( aedes_BGS$sum_p,  aedes_BGS$std_catch)
plot( aedes_CO2$sum_p,  aedes_CO2$std_catch)
plot(aedes_GRAV$sum_p, aedes_GRAV$std_catch)






