library(R2jags)
mdl <- "
    model {
        for (i in 1:33) {
            y[i] ~ dnorm(mu[tmt[i]], prec[tmt[i]])
        }

        for (i in 1:2) {
            mu[i] ~ dnorm(0,0.000001)
            vr[i] ~ dunif(0,5000)
            prec[i] <- 1/vr[i]
        }
    }
"
mdl <- "
    model {
        for (i in 1:33) {
            y[i] ~ dnorm(mu[tmt[i]], prec[tmt[i]])
        }

        for (i in 1:2) {
            mu[i] ~ dnorm(100,0.01)
            vr[i] ~ dgamma(20,.05)
            prec[i] <- 1/vr[i]
        }
    }
"
mdl <- "
    model {
        for (i in 1:33) {
            y[i] ~ dnorm(mu[tmt[i]], prec[tmt[i]])
        }

        for (i in 1:2) {
            mu[i] ~ dnorm(100,0.01)
            vr[i] ~ dgamma(10,200)
            prec[i] <- 1/vr[i]
        }
    }
"
groups <- read.table("../data/01twogroups.dat", col.names=c("tmt", "y"))
writeLines(mdl, "twogroups.jags")
tmt <- groups$tmt
y <- groups$y
# Data to go into jags
data.jags <- c('tmt','y')
# what parameters to keep track of
parms <- c('mu','vr')
# Initial Values
innts <- function() {list('mu' = rnorm(2,125,5), 'vr' = runif(2,0,5000))}
twogroups.sim <- jags(data=data.jags, parameters.to.save=parms, inits=innts, model.file="twogroups.jags",
    n.iter=11000, n.burnin=1000, n.chains=1, n.thin=1)

twogroups.sim

sims <- as.mcmc(twogroups.sim)
plot(sims)

plot(sims[,2], type='l')


