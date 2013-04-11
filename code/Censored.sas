data mice;
    infile 'micesurvival.dat' firstobs=2;
    input mid tmt time censored;
run;

proc mcmc data=mice outpost=mice1 nmc=1000000 nbi=2000 thin=100 seed=1234
          monitor=(r mu) diag=(ess autocorr r1) dic propcov=quanew;

    array mu[4] mu1-mu4;
    parms mu:;
    parms r;
    prior mu: ~gamma(1.5, scale=3);
    prior r ~ gamma(1.5, scale=4);
    mm = mu[tmt];
    if censored = 0 then
        ll = logpdf('gamma', time, r, mm);
    else
        ll = logpdf('gamma', censored, r, mm);
    model general(ll);
run;
