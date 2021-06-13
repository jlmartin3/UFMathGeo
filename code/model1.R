
#deggs  <- fecun*bites*adults*(1-(adults/k)) - (eggs_surv+ldev)*eggs
#dadults <- ldev*eggs - life_span*adults - trapped*adults

require(deSolve)

rigidode <- function(t, y, parms) {
  dE <- parms[1]*parms[2]*y[2]*(1-(y[2]/parms[3])) - (parms[4]+parms[5])*y[1]
  dA <- parms[5]*y[1] - parms[6]*y[2] - parms[7]*y[2]
  list(c(dE,  dA))
}

# starting values
yini  <- c( eggs = 1000 
           ,adults = 10)

# parameters
p <- c(
         fecun  = 500         # eggs per cycle
        ,bites  = .1          # bites per day
        ,k      = 1000    # carrying capacity
        ,eggs_surv = .1      # prop of egg to adult
        ,eggs_dev  = .1      # dev per day
        ,life_span = 20      # adult life span
        ,trapped   = .05      # number trapped
)

# time span
times <- seq(from = 0, to = 365, by = 1)

# impliment
out   <- ode (times = times, y = yini,   func = rigidode, 
              parms =  p)
plot(out, lwd = 3)



(p["eggs_dev"]*p["fecun"]*p["bites"])/((
  p["eggs_surv"]+p["eggs_dev"])*(p["life_span"]+p["trapped"]))







  