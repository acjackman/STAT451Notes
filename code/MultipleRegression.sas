%let datadir = Z:\Dropbox\Active\STAT451\Notes\data;
data vo2;
    infile "&datadir.\03vo2.dat" firstobs=2;
    input id gender age bmi mph hr rpe maxvo2;
run;

ods _all_ close;
ods html;

proc mcmc data=vo2 outpost=vo2out seed=1234
          nmc=300000
          nbi=60000
          thin=30
          statistics=(summary interval)
          diagnostics=(rl ess)
          dic
          propcov=quanew
          monitor=(_parms_);

    parms b1 50 b2 10 b3 0 b4 0 b5 0 b6 0 s2f 20 s2m 30;

    prior b1 ~ normal(50, var=1000);
    prior b2 ~ normal(10, var=1000);
    prior b3 ~ normal(0, var=1000);
    prior b4 ~ normal(0, var=1000);
    prior b5 ~ normal(0, var=1000);
    prior b6 ~ normal(0, var=1000);
    prior s2f ~ gamma(2, scale=20);
    prior s2m ~ gamma(2, scale=30);

    mu= b1 + b2*gender + b3*bmi + b4*mph + b5*hr + b6*rpe;
    if gender=0 then vv=s2f;
    else vv=s2m;

    model maxvo2 ~ normal(mu, var=vv);
run;
