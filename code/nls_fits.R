


setwd("C:/Users/James/Desktop/mathbio")
source("code/temp_functions.R")
library(minpack.lm)

# amort: quad
#  larv: quad
#  eggs: biere
#  bite: biere
#   dev: biere

amort_data  <- read.csv("data/traits/albo_amort.csv")
bite_data   <- read.csv("data/traits/albo_bite.csv")
dev_data    <- read.csv("data/traits/albo_dev.csv")
eggs_data   <- read.csv("data/traits/albo_eggs.csv")
larv_data   <- read.csv("data/traits/albo_larv.csv")

#_________________________________________________________________

plot(amort_data$temp, amort_data$amort, xlim = c(10,50))
lines(1:100, quad(1:100, 14, 36, -.8))

amort_fit <- nls(amort ~ quad(T = temp, T0, Tm, qd), 
                   amort_data,
         list( T0 = 14, Tm = 36, qd = -.8  ))

lines(1:100, predict(amort_fit, data.frame(temp = 1:100) ), 
      col = "red", lwd = 3)

#_________________________________________________________________

plot(larv_data$temp, larv_data$larv )
quad(larv_data$temp, 10, 40, -.0035)
lines(1:100, quad(1:100, 10, 40, -.0035))


larv_fit <- nls(larv ~ quad(T = temp, T0, Tm, qd), 
                larv_data,
                list(  T0 = 10, Tm = 40, qd = -.0035))

lines(1:100, predict(larv_fit, data.frame(temp = 1:100) ), 
      col = "red", lwd = 3)

#_________________________________________________________________

plot(eggs_data$temp, eggs_data$eggs, xlim = c(10,40) )
briere(eggs_data$temp, .05, 35, 14)
lines(1:100, briere(1:100, .05, 35, 14))


eggs_fit <- nls(eggs ~ briere(T = temp, c, Tm, T0), 
                eggs_data,
                list(  c = 0.5, Tm = 35, T0 = 14 ))

lines(1:100, predict(eggs_fit, data.frame(temp = 1:100) ), 
      col = "red", lwd = 3)

#_________________________________________________________________

plot(bite_data$temp, bite_data$bite, xlim = c(0,40),ylim = c(0,.3))
briere(bite_data$temp, .0001, 36, 10)
lines(10:36, briere(10:36, .00013, 36, 10))


bite_fit <- nls(bite ~ briere(T = temp, c, Tm, T0), 
                  bite_data,
                  list(  c = .00013, Tm = 36, T0 = 10  ))

lines(1:100, predict(bite_fit, data.frame(temp = 1:100) ), 
      col = "red", lwd = 3)


#_________________________________________________________________

plot(dev_data$temp, dev_data$dev, xlim = c(0,50) )
briere(dev_data$temp, .00007, 40, 10)
lines(10:50, briere(10:50, .00007, 40, 10))


dev_fit <- nls(dev ~ briere(T = temp, c, Tm, T0), 
                  dev_data,
                  list(  c = .00007, Tm = 40, T0 = 10  ))

lines(1:100, predict(dev_fit, data.frame(temp = 1:100) ), 
      col = "red", lwd = 3)




amort_fit <- glm(amort ~ temp, 
                 data  = amort_data)



data.frame(temp = 23)
predict(amort_fit, data.frame(temp = 23, 24),
        se.fit=TRUE, interval="confidence", level=0.90)

gg <- predict.glm(amort_fit, data.frame(temp = c(23, 24)),
        se.fit=TRUE, interval="confidence", level=0.95)

predict.glm(amort_fit, #amort_data$,
            se.fit=TRUE,
            #interval="confidence", 
            level=0.95)



