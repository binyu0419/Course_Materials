clear all

**Q2**
infile waist age triglyc using "/Users/yubin/Desktop/STAT 22401/triglyc.txt", clear
drop in 1

*Q2A
scatter triglyc waist

correlate waist triglyc

regress triglyc waist

clear all

infile y1 x1 y2	x2 y3 x3 y4	x4 using "/Users/yubin/Desktop/STAT 22401/anscombe.txt", clear
drop in 1


correlate y1 x1
regress y1 x1

predict resid1, resid

predict yhat1, xb
scatter resid1 yhat1, ///
    title("Residuals vs Fitted for model y1 ~ x1") ///
    ytitle("Residuals") xtitle("Fitted values")

kdensity resid1, normal ///
    title("Kernel Density of Residuals for y1 ~ x1") ///
    xtitle("Residuals") ytitle("Density")

correlate y2 x2
regress y2 x2
	
predict resid2, resid

predict yhat2, xb
scatter resid2 yhat2, ///
    title("Residuals vs Fitted for model y2 ~ x2") ///
    ytitle("Residuals") xtitle("Fitted values")

kdensity resid2, normal ///
    title("Kernel Density of Residuals for y2 ~ x2") ///
    xtitle("Residuals") ytitle("Density")

clear all

infile mht fht using "/Users/yubin/Desktop/STAT 22401/heights.txt", clear

correlate mht fht, cov
correlate mht fht

twoway (scatter fht mht) (lfit fht mht), ///
    title("Wife's Height vs. Husband's Height") ///
    ytitle("Wife's Height (cm)") ///
    xtitle("Husband's Height (cm)")
	
regress fht mht

clear all
import excel "/Users/yubin/Desktop/STAT 22401/question5.xlsx", ///
    sheet("Sheet1") firstrow clear
****************************************************
* (a) Create lnum = ln(number), then make scatterplot
****************************************************
* 1) Generate the natural log of the parasite count
gen lnum = log(number)

* 2) Scatter plot of lnum (y-axis) vs age (x-axis)
twoway (scatter lnum age), ///
    title("Scatter: ln(Number) vs. Age") ///
    ytitle("ln(Number of parasites)") ///
    xtitle("Age (years)")

****************************************************
* (b) Determine and interpret the Pearson correlation
****************************************************
correlate lnum age

* This reports:
*  - The correlation coefficient between 'age' and 'lnum'
*  - A significance test (two-sided) for H0: corr = 0

*******************************************************
* (c) Regress ln(Number) on Age; display regression line
*******************************************************
regress lnum age

* The above gives you:
*   lnum = _b[_cons] + _b[age]*age + error
* Save fitted values (ln scale) for plotting
predict lnfitted, xb

* Plot fitted line over data:
twoway (scatter lnum age) ///
       (line lnfitted age, sort), ///
       title("Linear Fit: ln(Number) on Age") ///
       ytitle("ln(Number of parasites)") ///
       xtitle("Age (years)")

**********************************************************
* (d) Graph residuals vs. fitted values to check patterns
**********************************************************
predict lnresid, residual
twoway (scatter lnresid lnfitted), ///
    title("Residuals vs. Fitted (ln scale)") ///
    ytitle("Residuals (ln)") ///
    xtitle("Fitted ln(Number)")

* Check if residuals are roughly centered around zero 
* and if there's any obvious pattern.

**********************************************************
* (e) Estimate number of parasites in original scale
*     and plot results
**********************************************************
* 1) Generate the predicted values in ln-scale (already done: lnfitted).
*    Convert them back to the original scale:
gen fitted_number = exp(lnfitted)

* 2) Plot the original parasite counts vs. age 
*    along with the fitted curve in the original scale
twoway (scatter number age, ///
        ytitle("Number of parasites") ///
        xtitle("Age (years)")) ///
       (line fitted_number age, sort lcolor(red)), ///
       title("Fitted Number of parasites vs. Age")

* The line shows the exponential back-transformation 
* from the fitted ln(Number) model.
