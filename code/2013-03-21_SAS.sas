%let hwdir=Z:/Dropbox/Active/STAT451/Notes;
filename data "&hwdir./pbib.dat";
filename chains "&hwdir./MCMCChains.csv";
filename html "&hwdir./MCMC_Output.html";

ods html close;
ODS GRAPHICS on / imagename="MCMCPlots";
ods html body=html (url=none) 
         GPATH="&hwdir/figure/";

data seeds;
	infile"'&hwdir./data/seeds.dat" firstobs=2;
	input seed $ type $ r n;
	if seed='a75' and type='bean' then tmt=1;
	if seed='a75' and type='cuc' then tmt=2;
	if seed='a73' and type='bean' then tmt=3;
	if seed='a73' and type='cuc' then tmt=4;
	plate=_N_;
run;

/* Our attempt */
proc mcmc data=seeds seed=12 nmc=200000 nbi=2000 thin=20 propcov=quanew
                   statistics=(summary interval) diag=(rl ess) moniter=( _parms_ p)
                   outpost=chdout dic;
    array b[4];
	array e[21];
	array p[4];
    parms b p e s2;
	
	prior b: ~ normal(0, prec=1);
	random e ~ normal(0, var=s2) subject=plate;
    prior s2 ~ uniform(0,2);

    p[tmt] = logistic(b[tmt]) ;
    model chd ~ binomial(nrisk, p[tmt]);
run;

/* His Code */
proc mcmc data=seeds seed=12 nmc=200000 nbi=2000 thin=20 outpost=chdout
                   statistics=(summary interval) diag=(rl autocorr ess) 
				   monitor=( p alpha s2plate )
                   propcov=quanew dic;
	array alpha[4] alpha1-alpha4;
	array p[4] p1-p4;
	parms alpha: 0;
	parms s2plate 1;
	prior alpha: ~ normal(0, var=10); /* Fixed Effect */
	random b~ normal(0, var=s2plate) subject=plate monitor=(b); /* Random Effect: has hyper-prior */
	prior s2plate ~ gamma(1.5, scale=2);
	
    p[tmt] = logistic(alpha[tmt]+b) ;
    model r ~ binomial(n, p[tmt]);
run;
