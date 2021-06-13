
#deggs  <- fecun*bites*adults*(1-(adults/k)) - (eggs_surv+ldev)*eggs
#dadults <- ldev*eggs - life_span*adults - trapped*adults


setwd("C:/Users/James/Desktop/mathbio")
source("code/nls_fits.R")
require(deSolve)

rigidode <- function(t, y, parms) {
  dE <- parms[1]*parms[2]*y[2]*(1-(y[2]/parms[3])) - (parms[4]+parms[5])*y[1]
  dA <- parms[5]*y[1] - (1/parms[6])*y[2] - parms[7]*y[2]
  list(c(dE,  dA))
}

# starting values
yini  <- c( eggs   = 0 
           ,adults = 1
           )

# parameters

t <- 41

p <- c(
   fecun  = predict(amort_fit, data.frame(temp = t) )  # eggs per cycle
  ,bites  = predict(bite_fit,  data.frame(temp = t) )  # bites per day
  ,k      = 10000    # carrying capacity
  ,eggs_surv = predict(larv_fit, data.frame(temp = t) )  # prop of egg to adult
  ,eggs_dev  = predict(dev_fit,   data.frame(temp = t) ) # dev per day
  ,life_span = predict(amort_fit, data.frame(temp = t) ) # adult life span
  ,trapped   = .05      # number trapped
)




# time span
times <- seq(from = 0, to = 30, by = 1)

# impliment
out   <- ode (times = times, y = yini,   func = rigidode, 
              parms =  p)
dev.off()
par(mar = c(6,3,3,3))
plot(out, lwd = 3,
     main = c("", 
              
              
              paste(t, "°C")),
     sub = c("
                   eggs", "
                   adults"),
     cex.sub = 3, 
     cex.main = 2,
     cex.axis = 1.5)


(p["eggs_dev"]*p["fecun"]*p["bites"])/((
  p["eggs_surv"]+p["eggs_dev"])*(p["life_span"]+p["trapped"]))







  