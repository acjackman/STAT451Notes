proc mcmc data=examp2 outpost=post2 seed=1234 nmc=100000 nbi=5000
                      statistics(alpha=.05)=(summary interval) thin=10
                      moniter=( parms mudif varratio ) propcov=quanew
                      diagnostics=(all) dic ;
array mu[2] mu1-mu2;
arra sig2[2] sig21-sig22;
prams: mu: sig2:;
prior mu: ~ normal(0, sd=10000);
prior sig21 ~ unif(9, 5000); /*  gamma(shape=30, scale=50) */
prior sig22 ~ unif(9, 5000);
mudif = mu1 - mu2;
varratio = sig21/sig22;
mm = mu[tmt];
vv = sig2[tmt];
model response ~ normal(mm, var=vv);
run;

proc export data=post2 outfile='twogroups.csv' dbms=csv replace;
run;