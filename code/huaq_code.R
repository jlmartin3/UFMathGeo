


setwd("C:/Users/James/Desktop")

t <- c(25.89, 26.70, 26.8,  27,    27.1, 
       27.54, 27.63, 27.63, 27.23, 27.7 )

p <- c( 0.111, 0.335, 0.399, 0.47, 0.434,
        0.326, 0.442, 0.578, 0.649, 0.611 )


log.ss <- nls(p ~ SSlogis(t, phi1, phi2, phi3))


plot(p ~ t,  xlab="temp", ylab="p")
lines( seq(0,max(t), by = .1), 
       predict(log.ss, data.frame(t =  seq(0,max(t), by = .1)  )), 
       col="red")

asp  <- summary(log.ss)$coef[1]
tmid <- summary(log.ss)$coef[2]
rate <- summary(log.ss)$coef[3]



mod1 <- function(t, p, parameters){

  t0    <- tmid 
  k     <- parameters[1]
  
  dp <- 1/(1-exp((-k)*(t-t0)))
  list(dp)
}



mod1.flowField <- flowField(mod1, xlim = c(20, 30), 
                                  ylim = c(.9, 1), 
         parameters = c(  1), 
                  points = 10, system = "one.dim", 
                  add = FALSE, xlab = "temp", ylab = "P")
grid()


model1 <- function(k, t0, t){
  1/(1-exp((-k)*(t-t0)))
}




install.packages("phaseR")
library(phaseR)
apma1 <- function(t, y, parameters){
  a <- parameters[1]
  dy <- a*((y/3) - 360)
  list(dy)
} 

apma1.flowField <- flowField(apma1, xlim = c(0, 10), 
                  ylim    = c(0, 2000), parameters = c(1), 
                  points = 9, system = "one.dim", 
                  add = FALSE, xlab = "time", ylab = "P", 
                  main = "Mice Population")

grid()