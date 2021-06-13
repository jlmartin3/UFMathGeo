

setwd("C:/Users/James/Desktop/mathbio")



# import count data
comb          <- read.csv("data/comb.csv")


comb <- subset(comb, trap_type == "CO2")

# drop columns and rename rows
comb <- comb[-c(8,9,10,14,15)]
rownames(comb) <- 1:nrow(comb)

# reorder
comb_points <- comb[c(2,4,6,7)]

# drop dublicates
which(duplicated(comb_points))
comb[ which(duplicated(comb_points)),   ]
comb <- comb[complete.cases(comb),]



# import climate data
counties_clim <- read.csv("data/counties_clim.csv")


# match climate to count
combGEOID <- comb$GEOID
combyear  <- comb$year
combmonth <- comb$month

climGEOID <- counties_clim$GEOID
climyear  <- counties_clim$year
climmonth <- counties_clim$month

combppt   <- c()
combtmean <- c()

climppt   <- counties_clim$ppt
climtmean <- counties_clim$tmean

for(i in 1:nrow(comb)){
  for(j in 1:nrow(counties_clim)){
    
    if(combGEOID[i] == climGEOID[j] &
       combyear[i]  == climyear[j] &
       combmonth[i] == climmonth[j]){
      
      combppt[i]   <- climppt[j]
      combtmean[i] <- climtmean[j]
    }
  }
} # 11:44 11:46  453    #11:52 done


comb$ppt <- combppt
comb$tmean <- combtmean

#____________________________________________________________

comb$albo_std <- log((comb$num_albopictus_collected/comb$num_trap_nights))
comb$aegy_std <- log((comb$num_aegypti_collected/comb$num_trap_nights))

# remove inf values for each species
comb_albo <- comb[!is.infinite(comb$albo_std),]
comb_aegy <- comb[!is.infinite(comb$aegy_std),]

# remove 0 precip, causes trouble later with logs
comb_albo <- comb_albo[ comb_albo$ppt != 0,]
comb_aegy <- comb_aegy[ comb_aegy$ppt != 0,]

plot(comb$ppt, comb$albo_std)
plot(comb$ppt, comb$aegy_std)
#___________________________________________________________
#       polynomial 

plot(comb_albo$ppt, comb_albo$albo_std)
albo_p1 <- lm(  comb_albo$albo_std ~ poly(comb_albo$ppt, 1)  )
test <- data.frame(x = comb_albo$ppt, y = predict(albo_p1))
test <- test[order(test$x),]
lines( test$x, test$y, col = "red", lwd = 3, type = "l")

plot(comb_albo$ppt, comb_albo$albo_std)
albo_p2 <- lm(  comb_albo$albo_std ~ poly(comb_albo$ppt, 2)  )
test <- data.frame(x = comb_albo$ppt, y = predict(albo_p2))
test <- test[order(test$x),]
lines( test$x, test$y, col = "red", lwd = 3, type = "l")

plot(comb_albo$ppt, comb_albo$albo_std)
albo_p3 <- lm(  comb_albo$albo_std ~ poly(comb_albo$ppt, 3)  )
test <- data.frame(x = comb_albo$ppt, y = predict(albo_p3))
test <- test[order(test$x),]
lines( test$x, test$y, col = "red", lwd = 3, type = "l")

#----------------------------------------------------------


plot(comb_aegy$ppt, comb_aegy$aegy_std)
aegy_p1 <- lm(  comb_aegy$aegy_std ~ poly(comb_aegy$ppt, 1)  )
test <- data.frame(x = comb_aegy$ppt, y = predict(aegy_p1))
test <- test[order(test$x),]
lines( test$x, test$y, col = "red", lwd = 3, type = "l")

plot(comb_aegy$ppt, comb_aegy$aegy_std)
aegy_p2 <- lm(  comb_aegy$aegy_std ~ poly(comb_aegy$ppt, 2)  )
test <- data.frame(x = comb_aegy$ppt, y = predict(aegy_p2))
test <- test[order(test$x),]
lines( test$x, test$y, col = "red", lwd = 3, type = "l")

plot(comb_aegy$ppt, comb_aegy$aegy_std)
aegy_p3 <- lm(  comb_aegy$aegy_std ~ poly(comb_aegy$ppt, 3)  )
test <- data.frame(x = comb_aegy$ppt, y = predict(aegy_p3))
test <- test[order(test$x),]
lines( test$x, test$y, col = "red", lwd = 3, type = "l")

#___________________________________________________________
#                LOESS

plot(comb_albo$ppt, comb_albo$albo_std)
albo_lw1 <- loess(comb_albo$albo_std ~ comb_albo$ppt, 
              degree = 1, 
              control=loess.control(surface = "direct"))
albo_test <- data.frame(x = comb_albo$ppt, y = predict(albo_lw1))
albo_test <- albo_test[order(albo_test$x),]
lines( albo_test$x, albo_test$y, col = "red", lwd = 3 )

library(gamm4)
plot(comb_albo$ppt, comb_albo$albo_std)
albo_g1 <- gamm4(albo_std ~ s(X) + ppt, data = comb_albo)
albo_testg <- data.frame(x = comb_albo$ppt, y = predict(albo_g1$gam))
albo_testg <- albo_testg[order(albo_testg$x),]
lines( albo_testg$x, albo_testg$y, col = "red", lwd = 3 )


plot(comb_albo$ppt, comb_albo$albo_std)
albo_lw2 <- loess(comb_albo$albo_std ~ comb_albo$ppt, 
                  degree = 2, 
                  control=loess.control(surface = "direct"))
test <- data.frame(x = comb_albo$ppt, y = predict(albo_lw2))
test <- test[order(test$x),]
lines( test$x, test$y, col = "red", lwd = 3 )

#-----------------------------------------------------------

plot(comb_aegy$ppt, comb_aegy$aegy_std)
aegy_lw1 <- loess(comb_aegy$aegy_std ~ comb_aegy$ppt, 
                  degree = 1, 
                  control=loess.control(surface = "direct"))
aegy_test <- data.frame(x = comb_aegy$ppt, y = predict(aegy_lw1))
aegy_test <- aegy_test[order(aegy_test$x),]
lines( aegy_test$x, aegy_test$y, col = "red", lwd = 3 )

plot(comb_aegy$ppt, comb_aegy$aegy_std)
aegy_lw2 <- loess(comb_aegy$aegy_std ~ comb_aegy$ppt, 
                  degree = 2, 
                  control=loess.control(surface = "direct"))
test <- data.frame(x = comb_aegy$ppt, y = predict(aegy_lw2))
test <- test[order(test$x),]
lines( test$x, test$y, col = "red", lwd = 3 )


#____________________________________________________________
library(minpack.lm)

fit1 <- function(x, A, V, alpha){
  A - V*exp(-alpha*x)
}

plot(comb_albo$ppt, comb_albo$albo_std)
# guess
lines(1:1000, fit1(A = 1, V = 2, alpha = .01, x = 1:1000), lwd = 3, col = "blue")
# fit
albo_fit1 <- nls(albo_std ~ fit1(x = ppt, A, V, alpha), 
                 comb_albo,
                 list( A = 1, V = 2, alpha = 0.01  ))
# plot
lines(1:1000, predict(albo_fit1, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)


plot(comb_aegy$ppt, comb_aegy$aegy_std)
lines(1:1000, fit1(A = 1, V = 2, alpha = .01, x = 1:1000), lwd = 3, col = "blue")
aegy_fit1 <- nls(aegy_std ~ fit1(x = ppt, A, V, alpha), 
                 comb_aegy,
                 list( A = 1, V = 2, alpha = 0.01  ))
lines(1:1000, predict(aegy_fit1, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)

#------------------------------------------------------------------------

fit2 <- function(x, A, B, C){
  A*log(B*x)-C
}

plot(comb_albo$ppt, comb_albo$albo_std)
lines( albo_test$x, albo_test$y, col = "green", lwd = 3 )
lines(1:1000, fit2(x = 1:1000, A = .5, B = .1, C = 1.5), lwd = 3, col = "blue")
albo_fit2 <- nls(albo_std ~ fit2(x = ppt, A, B, C), 
                 comb_albo,
                 start = list( A = .5, B = .1, C = 1.5 ))
lines(1:1000, predict(albo_fit2, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)

plot(comb_aegy$ppt, comb_aegy$aegy_std)
lines(1:1000, fit2(x = 1:1000, A = .7, B = .4, C = 3.5), lwd = 2.5, col = "blue")
aegy_fit2 <- nlsLM(aegy_std ~ fit2(x = ppt, A, B, C), 
                 comb_aegy,
                 start = list( A = .7, B = .4, C = 3.5 ))
lines(1:1000, predict(albo_fit2, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)


#------------------------------------------------------------------------

fit3 <- function(x,A,B,C,D){
 ( (A*x +B)/(C*x + D) ) + 1.5##
 }


plot(comb_albo$ppt, comb_albo$albo_std)
lines( albo_test$x, albo_test$y, col = "green", lwd = 3 )
lines(1:1000, fit3(x = 1:1000, A = 1, B = 2000, C = -4, D = -500), 
           lwd = 3, col = "blue")
albo_fit3 <- nls(albo_std ~ fit3(x = ppt, A, B, C, D), 
                 comb_albo,
                 start = list( A = 1, B = 2000, C = -4, D = -500))
lines(1:1000, predict(albo_fit3, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)

plot(comb_aegy$ppt, comb_aegy$aegy_std)
lines( aegy_test$x, aegy_test$y, col = "green", lwd = 3 )
lines(1:1000, fit3(x = 1:1000, A = 1, B = 2000, C = -4, D = -500), 
      lwd = 3, col = "blue")
aegy_fit3 <- nls(aegy_std ~ fit3(x = ppt, A, B, C, D), 
                 comb_aegy,
                 start = list( A = 1, B = 2000, C = -4, D = -500))
lines(1:1000, predict(aegy_fit3, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)


#------------------------------------------------------------------------

fit4 <- function(x,A,B,C){
    A*x^2 + B*x + C
}

plot(comb_albo$ppt, comb_albo$albo_std)
lines( albo_test$x, albo_test$y, col = "green", lwd = 3 )
lines(1:1000, fit4(x = 1:1000, A = .00001, B = 0.00000001, C = -2), 
      lwd = 3, col = "blue")

albo_fit4 <- nls(albo_std ~ fit4(x = ppt, A, B, C), 
                 comb_albo,
                 start = list( A = .00001, B = 0.00000001, C = -2))
lines(1:1000, predict(albo_fit4, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)


plot(comb_aegy$ppt, comb_aegy$aegy_std)
lines( aegy_test$x, aegy_test$y, col = "green", lwd = 3 )
lines(1:1000, fit4(x = 1:1000, A = -.00001, B = .0111, C = -2.3), 
      lwd = 3, col = "blue")
aegy_fit4 <- nls(aegy_std ~ fit4(x = ppt, A, B, C), 
                 comb_aegy,
                 start = list( A = -.00001, B = .0111, C = -2.3))
lines(1:1000, predict(aegy_fit4, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)

#------------------------------------------------------------------------

fit5 <- function(x,A,B,C,D){
  A*x^3 + B*x^2 + C*x + D
}

plot(comb_albo$ppt, comb_albo$albo_std)
lines( albo_test$x, albo_test$y, col = "green", lwd = 3 )
lines(1:1000, fit5(x = 1:1000, 
          A = -0.000000001, B = 0.0001, C =  0.00000001, D = -2), 
      lwd = 3, col = "blue")
albo_fit5 <- nls(albo_std ~ fit5(x = ppt, A, B, C, D), 
                 comb_albo,
      start = list( A = -0.000000001, B = 0.0001, C =  0.00000001, D = -2))
lines(1:1000, predict(albo_fit5, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)


plot(comb_aegy$ppt, comb_aegy$aegy_std)
lines( aegy_test$x, aegy_test$y, col = "green", lwd = 3 )
lines(1:1000, fit5(x = 1:1000, 
                   A = -0.000000001, B = 0.0001, C =  0.00000001, D = -2), 
      lwd = 3, col = "blue")
aegy_fit5 <- nls(aegy_std ~ fit5(x = ppt, A, B, C, D), 
                 comb_aegy,
        start = list( A = -0.000000001, B = 0.0001, C =  0.00000001, D = -2))
lines(1:1000, predict(aegy_fit5, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)

#__________________________________________________________________________


min(c(
  mean(residuals(albo_p1)^2),  # 2.923646
  mean(residuals(albo_p2)^2),  # 2.898563 
  mean(residuals(albo_p3)^2),  # 2.827292
  mean(residuals(albo_lw1)^2), # 2.840793
  mean(residuals(albo_lw2)^2), # 2.778192 <<<
  mean(residuals(albo_fit1)^2),# 2.799782
  mean(residuals(albo_fit4)^2),# 2.898563
  mean(residuals(albo_fit5)^2) # 2.827292 
))

     
min(c(
  AIC(albo_p1),  # 3932.351
  AIC(albo_p2),  # 3925.701
  AIC(albo_p3),  # 3902.705
  AIC(albo_fit1),# 3890.888 <<<
  AIC(albo_fit4),# 3925.701
  AIC(albo_fit5) # 3902.705 
))

plot(comb_albo$ppt, comb_albo$albo_std)
lines(1:1000, predict(albo_fit1, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)



min(c(
  mean(residuals(aegy_p1)^2),  # 3.21283
  mean(residuals(aegy_p2)^2),  # 3.180717 
  mean(residuals(aegy_p3)^2),  # 3.147691
  mean(residuals(aegy_lw1)^2), # 3.159866
  mean(residuals(aegy_lw2)^2), # 3.146016 <<<
  mean(residuals(aegy_fit1)^2),# 3.160864
  mean(residuals(aegy_fit4)^2),# 3.180717
  mean(residuals(aegy_fit5)^2) # 3.147691 
))

min(c(
  AIC(aegy_p1),  # 2857.581
  AIC(aegy_p2),  # 2852.428 
  AIC(aegy_p3),  # 2846.997
  AIC(aegy_fit1),# 2847.970
  AIC(aegy_fit4),# 32852.428
  AIC(aegy_fit5) # 2846.997 <<<
))

plot(comb_aegy$ppt, comb_aegy$aegy_std)
lines(1:1000, predict(aegy_fit5, data.frame(ppt = 1:1000) ), 
      col = "red", lwd = 3)     







