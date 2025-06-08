clear all

use "/Users/yubin/Desktop/STAT 22401/hw5/fev_by_age.dta"

rename FEV fev
* Scatter plot with a fitted line
twoway (scatter fev age) (lfit fev age)

* Simple regression of FEV on age
regress fev age

* Box plot of FEV by smoking status
graph box fev, over(nsmoke)

* Regression of FEV on the indicator variable for smoke
regress fev nsmoke

regress fev age nsmoke

* For non-smokers (assuming smoke==0)
regress fev age if nsmoke==0

* For smokers (assuming smoke==1)
regress fev age if nsmoke==1

* Regression with interaction term
regress fev c.age##i.nsmoke
test 1.nsmoke#c.age

clear all

use "/Users/yubin/Desktop/STAT 22401/hw5/Zika_12.dta"


*-----------------------------------------
* (a) Examine summary statistics and evaluate the Poisson model
* Overall summary for infection counts
summarize infect

* Summary statistics stratified by net use (netting: 0 = no, 1 = yes)
by netting, sort: summarize infect
tabstat infect, statistics(mean variance N) by(netting)

*-----------------------------------------
* (b) Fit the Poisson regression model with net use as predictor
poisson infect netting
estat gof
* The model estimated on the log(counts) scale is:
*    log(E[infect]) = _b[_cons] + _b[1.netting]*netting
* To obtain predictions on the counts scale, take the exponent of the linear predictor.

*-----------------------------------------
* (c) Check that the model reproduces the mean counts by netting strata 
* and re-fit the model to display incidence rate ratios (IRRs)
poisson infect netting
* Re-fit the Poisson model with the IRR option to get the relative infection reduction
poisson infect netting, irr
* The IRR for netting gives the ratio of infection rate for villages with nets versus those without.

*-----------------------------------------
* (d) Predict the counts and compare them to the actual counts
predict infect_hat
list netting infect infect_hat, clean
* Note: This model only produces two possible predicted values (one for each netting category),
* which captures the overall mean and range differences between the groups.

clear all
use "/Users/yubin/Desktop/STAT 22401/hw5/stones_12.dta"

* Summarize stones and follow-up years
summarize stones yrfu

******************************************************
* (b) Calculate the incidence rate ratio (IRR) for males vs. females
******************************************************
ir stones sex yrfu


******************************************************
* (c) Fit the Poisson regression model with sex as predictor,
*     including follow-up time as the exposure variable.
******************************************************
poisson stones sex, exposure(yrfu) irr

test sex
* The coefficient for sex estimates the rate ratio for males relative to females.
* Compare this model estimate to the IRR calculated in (b).


******************************************************
* (d) [No code required]
* It is important to include follow-up time as exposure because patients have 
* different lengths of follow-up, and the incidence rate is defined per unit time.
 

******************************************************
* (e) Assess effect of having only one functional kidney (nx1) on stone rate
******************************************************
poisson stones nx1, exposure(yrfu) irr
test nx1
* The IRR for nx1 compares patients with one kidney (nx1=1) to those with two kidneys (nx1=0).


******************************************************
* (f) Assess the effect of age on kidney-stone formation rate
******************************************************
poisson stones age, exposure(yrfu) irr

* This model estimates the change in the incidence rate for each one-year increase in age.


******************************************************
* (g) Fit a model with sex, nx1, and age as predictors and predict the rate 
*     for a 45-year-old female patient with only one functional kidney.
******************************************************
poisson stones sex nx1 age, exposure(yrfu) irr

display exp(_b[_cons] + _b[sex] + _b[nx1] + _b[age]*45)

