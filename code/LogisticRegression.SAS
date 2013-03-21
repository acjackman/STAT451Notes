data chd;
    infile '09logistic.dat' firstobs=2;
    input chd nrisk cat agegrp abEcg;
    tmt=_n_;
run;

proc mcmc data=chd seed=12 nmc=200000 nbi=2000 thin=20 propcov=quanew
                   statistics=(summary interval) diag=(rl ess) moniter=( _parms_ p)
                   outpost=chdout dic;
    array p[8] p1-p8;
    parms bint bcat bage becg;
    prior bint ~ normal(0, var=10);
    prior bcat ~ normal(0, var=10);
    prior bage ~ normal(0, var=10);
    prior becg ~ normal(0, var=10);
    p[tmt] = logistic(bint+bcat*cat+bage*agegrp becg*abEcg);
    model chd ~ binomial(nrisk, p[tmt]);
run;
