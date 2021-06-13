


require(deSolve)
setwd("C:/Users/James/Desktop/mathbio")
source("code/nls_fits.R")

df <- read.csv("data/comb_data.csv")
df <- subset(df, county == "New Hanover")

row.names(df) <- NULL

df[13:24,]$month <- df[13:24,]$month + 12

times <- seq(1, 24, by = 1)



plot( df$month, df$mean_t)
temp <- as.data.frame(list(times = times, 
                          import = rep(0, length(times))))
temp$import <- df$mean_t
temp
input_temp <- approxfun(temp, rule = 2)

plot(seq(1,24, by = .1), input_temp(seq(1,24, by = .1)))




plot( df$month, df$sum_p)
precip <- as.data.frame(list(times = times, 
                           import = rep(0, length(times))))
precip$import <- df$sum_p
precip
input_precip <- approxfun(precip, rule = 2)

plot(seq(1,24, by = .1), input_precip(seq(1,24, by = .1)))



#______________________________________________________

#times <- seq(1, 24, by = .1)

SPCmod <- function(t, y, parms) {
  with(as.list(c(parms, y)), {
    
    import_temp   <- input_temp(t)
    import_precip <- input_precip(t)
    
    fecun     <- predict(amort_fit, data.frame(temp = import_temp) )
    bites     <- predict(bite_fit,  data.frame(temp = import_temp) )
    eggs_surv <- predict(larv_fit,  data.frame(temp = import_temp) )
    eggs_dev  <- predict(dev_fit,   data.frame(temp = import_temp) )
    life_span <- predict(amort_fit, data.frame(temp = import_temp) )
    
    carry_cap <-  (import_precip)*5 
    
    #deggs  <- fecun*bites*adults*(1-(eggs/k)) - (eggs_surv+ldev)*eggs
    #dadults <- ldev*eggs - life_span*adults - trapped*adults
  
    dE <- fecun*bites*y[2]*(1-(y[1]/ carry_cap)) - (eggs_surv+eggs_dev)*y[1]
    dA <- eggs_dev*y[1] - (1/life_span)*y[2] - parms[1]*y[2]
    
    res <- c(dE, dA)
    list(res, temp = import_temp, precip = import_precip)
  })
}


# starting values
yini  <- c( eggs = 500,   adults = 500 )
p     <- c(  trapped = .05 )

out   <- ode(times = times, y = yini,   func = SPCmod, 
              parms =  p)

plot(out)
dev.off()


resultz <- data.frame(out)

resultz$std.catch <- df$std_catch
resultz$prop_pos  <- df$prop_pos

plot(resultz$time, resultz$adults, type = "l", lwd = 2,
     ylim = c(400,1000))
lines(resultz$time, resultz$std.catch*90+400, lwd = 2, col = "red")


plot(resultz$time, resultz$adults, type = "l", lwd = 2,
     ylim = c(0,1000))
lines(resultz$time, resultz$prop_pos*500+450, lwd = 2, col = "red")


#plot(out)





