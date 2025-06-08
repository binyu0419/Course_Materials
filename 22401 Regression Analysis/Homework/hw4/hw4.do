clear all

use "/Users/yubin/Desktop/STAT 22401/hw4/ozone_12.dta"

************************************************************
* 2. Fit a regression model using all predictors
************************************************************
regress ozone rad temp wind

************************************************************
* 3. Get predicted values (yhat) and raw residuals
************************************************************
predict yhat, xb        // predicted ozone
predict rawres, resid   // raw residuals (ozone - yhat)

************************************************************
* 4. Plot raw residuals vs. actual ozone values
************************************************************
twoway scatter rawres ozone ///
    , ///
    title("Raw Residuals vs. Actual Ozone") ///
    xtitle("Actual Ozone") ///
    ytitle("Raw Residuals")

************************************************************
* 5. Calculate standardized residuals and plot vs. yhat
************************************************************
predict rstd, rstandard

* Scatter plot of standardized residuals vs. fitted values
* with ID labels and y-axis range from -3 to 4
twoway scatter rstd yhat,                         ///
    mlabel(id)                                     ///   <-- adds point labels using 'id'
    yscale(range(-3 4))                            ///   <-- sets y-axis from -3 to 4
    title("Standardized Residuals vs. Fitted Values")  ///
    xtitle("Fitted Ozone (yhat)")                  ///
    ytitle("Standardized Residuals")               ///
    yline(-2 2, lstyle(dash))                      ///   <-- reference lines at ±2
    legend(off)

************************************************************
* 6. Identify observations with |standardized residual| > 2
************************************************************
list id ozone rad temp wind rstd if abs(rstd) > 2

sum ozone rad temp wind if inlist(id, 17, 26)

sum ozone rad temp wind if !inlist(id, 17, 26)

sum rawres rstd yhat ozone if inlist(id, 17, 26)
sum rawres rstd yhat ozone if !inlist(id, 17, 26)
************************************************************
* 7. Use QQ plot to check normality; check mean & SD
************************************************************
qnorm rstd
summ rstd

************************************************************
* 8. Check leverage (hat values) and Cook’s distance
************************************************************
predict leverage, hat
sum leverage,detail

predict cookd, cooksd
sum cookd,detail
list id ozone rstd cookd leverage if abs(rstd)>2

* Plot leverage vs. id
twoway scatter leverage id, mlabel(id) ///
    title("Leverage vs. Observation ID") ///
    xtitle("ID") ///
    ytitle("Leverage (hat)")

* Plot Cook's distance vs. id
twoway scatter cookd id, mlabel(id) ///
    title("Cook's Distance vs. Observation ID") ///
    xtitle("ID") ///
    ytitle("Cook's Distance")


clear all

import delimited "/Users/yubin/Desktop/STAT 22401/hw2/cigarettesales.txt", clear


************************************************************
* (a) Fit the model: Sales = β0 + β1*Age + β2*Income + β3*Price + ε
*    Check basic assumptions:
*    - Randomness of residuals
*    - Normality of residuals
************************************************************
regress sales age income price

************************************************************
* Obtain fitted values and residuals
************************************************************
predict yhat, xb        // fitted values of Sales
predict res, resid      // raw residuals

************************************************************
* Quick check: plot raw residuals vs. fitted values 
* to see if residuals appear random
************************************************************
twoway scatter res yhat, ///
    title("Residuals vs. Fitted Values") ///
    xtitle("Fitted Sales (yhat)") ///
    ytitle("Residuals")

************************************************************
* Normality check:
* 1) Generate standardized residuals
* 2) Q-Q plot
************************************************************
predict rstd, rstandard
qnorm rstd

************************************************************
* Summarize standardized residuals
* Ideally mean ~ 0, sd ~ 1
************************************************************
summ rstd

************************************************************
* (b) Plot standardized residuals vs. each predictor
*    to identify potential outliers for extreme predictor values
************************************************************
twoway scatter rstd age, ///
    title("Std Residuals vs. Age") ///
    ytitle("Standardized Residuals") // optional median line

twoway scatter rstd income, ///
    title("Std Residuals vs. Income") ///
    ytitle("Standardized Residuals")

twoway scatter rstd price, ///
    title("Std Residuals vs. Price") ///
    ytitle("Standardized Residuals")

************************************************************
* (c) Identify extreme or influential observations:
*    1) Using standardized residuals > |2|
*    2) Cook's distance
*    3) Compare outliers to rest of data
************************************************************
predict cookd, cooksd    // Cook's Distance
predict lev, hat
gen index = _n

twoway scatter rstd yhat,                         ///
    mlabel(state)                                     ///   <-- adds point labels using 'id'
    yscale(range(-3 4))                            ///   <-- sets y-axis from -3 to 4
    title("Standardized Residuals vs. Fitted Values")  ///
    xtitle("yhat")                  ///
    ytitle("Standardized Residuals")               ///
    yline(-2 2, lstyle(dash))                      ///   <-- reference lines at ±2
    legend(off)

* List any observations with abs(rstd) > 2 (potential outliers)
list state age income price sales rstd if abs(rstd) > 2

twoway scatter cookd index, ///
    mlabel(state) ///
    title("Cook's Distance by Observation Number") ///
    ytitle("Cook's Distance") ///
    xtitle("Observation Index")

twoway scatter lev index, ///
    mlabel(state) ///
    title("Leverage (hat) vs. Observation Number") ///
    ytitle("Leverage (hat)") ///
    xtitle("Observation Index")

************************************************************************/
sum sales age income price if state!="NV" & state!="NH"
sum sales age income price if state =="NV"
sum sales age income price if state =="NH"
************************************************************************
* 2. (Re)generate residuals and predicted values
*    'rawresid'  = ordinary residuals (Sales - yhat)
*    'i_stresid' = internally studentized residuals (rstandard)
*    'e_stresid' = externally studentized residuals (rstudent)
************************************************************************
predict rawresid, resid
predict i_stresid, rstandard
predict e_stresid, rstudent

/************************************************************************
 3. Summarize how the model fits for non-outliers vs. the outliers
************************************************************************/

* 3a. Non-outliers
sum sales yhat rawresid i_stresid e_stresid if state!="NV" & state!="NH"

* 3b. Nevada (NV)
sum sales yhat rawresid i_stresid e_stresid if state=="NV"

* 3c. New Hampshire (NH)
sum sales yhat rawresid i_stresid e_stresid if state=="NH"

clear all
use "/Users/yubin/Desktop/STAT 22401/hw4/brain_12.dta"
******************************************************************************
* 2. Create an indicator for primates. For instance, we define:
*    (monkeys, apes, humans) as primates, etc.
********************************************************************************
gen byte primate = 0
replace primate = 1 if inlist(name, "Gorilla", "Human", "Chimpanzee", ///
    "Rhesus monkey", "Potar monkey")

label define primatelbl 0 "Non-primate" 1 "Primate"
label values primate primatelbl

********************************************************************************
* 3. Part (a): On the log scale for both response and predictor:
*    log(brain) = b0 + b1 * log(body) + b2 * primate + error
********************************************************************************
regress logbrainwt logbodywt primate

* Check significance of the primate indicator:
test primate

* Alternatively, you could compare models with and without primate:
regress logbrainwt logbodywt
est store no_primate

regress logbrainwt logbodywt primate
est store with_primate

est table no_primate with_primate, b se p

********************************************************************************
* 4. Part (b): Add interaction term between log(body) and primate
********************************************************************************
gen interaction = logbodywt * primate

regress logbrainwt logbodywt primate interaction

* This tests whether the slope relating log(body) to log(brain) differs
* for primates vs. non-primates.
test interaction

* Compare nested models if desired
est store with_interact

* For interpretation: 
*  - If 'interaction' is significant, the slope for primates differs 
*    from the slope for non-primates.
*  - If not significant, you might retain only the indicator (if that 
*    is still significant) or drop it entirely.

********************************************************************************
* 5. Part (c): Run on arithmetic scale (brain vs. body) omitting dinosaurs
********************************************************************************
* Identify dinosaurs:
gen byte dinosaur = 0
replace dinosaur = 1 if inlist(name, "Diplodocus", "Triceratops", "Brachiosaurus")

regress brainwei bodyweig
regress brainwei bodyweig if dinosaur==0
* or you could create a separate dataset if you wish:
*   preserve
*   keep if dinosaur==0
*   regress brainwei bodyweig
*   restore

********************************************************************************
* 6. Part (d): 
*    (i) Keep predictor log-transformed, response in original form
*        regress brainwei on logbodywt
********************************************************************************
regress brainwei logbodywt

* Comment on the coefficient's interpretation 
* (each 1-unit increase in log(body) => a multiplicative effect on brain).
* e.g. brain = b0 + b1*log(body) => if body changes by x%, brain changes ???

********************************************************************************
*    (ii) Box-Cox approach to see what transform is suggested for brainwei
********************************************************************************
* Stata doesn't have a built-in "boxcox" with all the bells and whistles,
* but we can use the user-written command 'boxcox' from SSC:
*   ssc install boxcox
* Example usage:

boxcox brainwei logbodywt

gen BC_brain = (brainwei^0.0092 - 1) / 0.0092
regress BC_brain logbodywt
