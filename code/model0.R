



#deSolve:  main integration package
#IrootSolve:  steady-state solver
#IbvpSolve:  boundary value problem solvers
#IReacTran:  partial differential equations
#Isimecol:  interactive environment for implementing models

install.packages("deSolve", "rootSolve", "bvpSolve", 
                 "ReacTran", "simecol")

install.packages( "rootSolve")

require(deSolve)

logistic <- function(t, r, K, N0) {
     K * N0 * exp(r * t) / (K + N0 * (exp(r * t) - 1))
  } 
plot(0:100, logistic(t = 0:100, r = 0.1, K = 10, N0 = 0.1))
  



library(deSolve)

model <- function(time, y, parms) {
  with(as.list(c(y, parms)), {
    dN<-r * N * (1 -N / K)
    
    list(dN)})
}

y      <-c(N = 0.1)
parms<-c(r = 0.1, K = 10)
times<-seq(0, 100, 1)
out <- ode(y, times, model, parms)

plot(out, main = "logistic growth", lwd = 2)
  



#_________________________________________



library(deSolve)
rigidode <- function(t, y, parms) {
     dy1 <- -2  * y[2] * y[3]
     dy2 <- 1.25* y[1] * y[3]
     dy3 <- -0.5* y[1] * y[2]
     list(c(dy1, dy2, dy3))
   }
yini  <- c(y1 = 1, y2 = 0, y3 = 0.9)
times <- seq(from = 0, to = 20, by = 0.01)
out   <- ode (times = times, y = yini, func = rigidode, parms = NULL)

plot(out)


#_______________________________________

dPrey <- fecun*bites*adults*(1-(adults/k)) - (eggs_surv+ldev)*eggs
dPred <- ldev*eggs - life_span*adults - trapped*adults


dA
dL


## Parameter values
shit <- list( p1 = -2, p2 = 1.25, p3 = -0.5)

library(deSolve)
rigidode <- function(t, y, parms) {
  dy1 <- parms[1]  * y[2] * y[3]
  dy2 <- parms[2]  * y[1] * y[3]
  dy3 <- parms[3]  * y[1] * y[2]
  list(c(dy1, dy2, dy3))
}
yini  <- c(y1 = 1, y2 = 0, y3 = 0.9)
times <- seq(from = 0, to = 20, by = 0.01)
out   <- ode (times = times, y = yini, func = rigidode, 
              parms =  c(-2,1.25,-0.5))

plot(out)

params <- list(min=0, max=1)
do.call(runif, c(n=100, params))








#_______________________________________

#deggs  <- fecun*bites*adults*(1-(adults/k)) - (eggs_surv+ldev)*eggs
#dadults <- ldev*eggs - life_span*adults - trapped*adults


library(deSolve)
rigidode <- function(t, y, parms) {
  dE <- parms[1]*parms[2]*y[2]*(1-(y[2]/parms[3])) - (parms[4]+parms[5])*y[1]
  dA <- parms[5]*y[1] - parms[6]*y[2] - parms[7]*y[2]
  list(c(dE,  dA))
}

# starting values
yini  <- c( eggs = 100 
           ,adults = 100)

# parameters
p <- c(
         fecun  = 200         # eggs per cycle
        ,bites  = .1          # bites per day
        ,k      = 10000    # carrying capacity
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
plot(out)











  