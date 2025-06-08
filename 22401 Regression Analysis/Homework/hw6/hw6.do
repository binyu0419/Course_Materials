* 载入数据
clear all
use "/Users/yubin/Desktop/STAT 22401/hw6/tam_12.dta"

**********************************
* 对“复发”（recur）进行分析
**********************************
tabulate recur trt
tabulate dead trt

logit recur trt, or
logit dead trt, or

logit recur trt age bmi tumsiz, or

logit dead trt age bmi tumsiz, or

logit ned trt age bmi tumsiz, or

logit endo trt, or
predict prob_d
tabulate prob_d
tabulate endo trt

logit recur trt age tumsiz
* Fit the logistic regression model (omitting BMI)
logit recur trt age tumsiz

* Case 1: age = 50, tumor size = 30 mm, tamoxifen (trt = 1)
margins, at(trt=1 age=50 tumsiz=30)

* Case 2: age = 50, tumor size = 30 mm, placebo (trt = 0)
margins, at(trt=0 age=50 tumsiz=30)

* Case 3: age = 65, tumor size = 10 mm, tamoxifen (trt = 1)
margins, at(trt=1 age=65 tumsiz=10)

* Case 4: age = 65, tumor size = 10 mm, placebo (trt = 0)
margins, at(trt=0 age=65 tumsiz=10)

*--- Breast Cancer Recurrence ---
* Fit logistic regression for recurrence (omitting BMI as specified)
logit recur trt age tumsiz
* Obtain predicted probabilities of recurrence for treatment groups
margins, at(trt=(0 1)) 

*--- Breast Cancer Death ---
* Fit logistic regression for death (including covariates as needed)
logit dead trt age bmi tumsiz
* Obtain predicted probabilities of death for treatment groups
margins, at(trt=(0 1)) 

*--- Endometrial Cancer ---
* Fit logistic regression for endometrial cancer
logit endo trt age tumsiz
margins, at(trt=(0 1)) 

clear all
use "/Users/yubin/Desktop/STAT 22401/hw6/Orings_12.dta"

gen fail = (damaged > 0)
logit fail temp, or
predict prob_f
tabulate prob_f

* (b) Exclude flight #18 (the problematic launch at 75°F)
drop if flightno == 18
logit fail temp,or

* (c)
logit fail temp

* (d)
logit fail temp
predict phat
list fail temp phat
estat classification

*(e)
estat classification
estat classification, cutoff(.67)
estat classification, cutoff(.33)
