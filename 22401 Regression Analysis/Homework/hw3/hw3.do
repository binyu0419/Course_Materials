*------------------------------------------------------------
* 1. 导入数据（假设数据文件“fert.txt”在工作目录中）
*    文件中每行包括两个变量：Yield 和 Fertilizer
*------------------------------------------------------------
infile Yield Fertilizer using "/Users/yubin/Desktop/STAT 22401/hw3/fert.txt", clear
drop in 1

*------------------------------------------------------------
* (a) 创建指示变量 F1, F2, F3 分别代表 Fertilizer 组别 1、2、3
*     注意：本题设中组别4为对照组，所以F1=1表示使用肥料1，依此类推。
*------------------------------------------------------------
gen F1 = (Fertilizer == 1)
gen F2 = (Fertilizer == 2)
gen F3 = (Fertilizer == 3)

*------------------------------------------------------------
* (b) 拟合模型：
*     yij = μ0 + μ1*F1 + μ2*F2 + μ3*F3 + εij
*------------------------------------------------------------
regress Yield F1 F2 F3

*------------------------------------------------------------
* (c) 检验假设：三种肥料对玉米产量均无影响，即 H0: μ1 = μ2 = μ3 = 0
*     使用 F 检验来进行联合假设检验
*------------------------------------------------------------
test F1 F2 F3

*------------------------------------------------------------
* (d) 检验假设：三种肥料的效果相等，即 H0: μ1 = μ2 = μ3
*     可以通过对系数之间差值为0的联合假设检验来实现：
*     先检验 μ1 = μ2，再检验 μ2 = μ3
*------------------------------------------------------------
test F1 = F2 = F3

*------------------------------------------------------------
* (e) 检验任意肥料（1、2、3）与对照组（4）是否存在共同效应
*     首先生成一个新的指示变量 anyfert，当 Fertilizer 为 1,2,3 时取值1，
*     当 Fertilizer 为4时取值0
*------------------------------------------------------------
gen anyfert = (Fertilizer < 4)
regress Yield anyfert

* 对 anyfert 的系数进行 t 检验，检验其是否显著不为零
test anyfert = 0

clear all
use "/Users/yubin/Desktop/STAT 22401/hw3/educ_expend_12.dta"


***************************************
* (a) Examine the relationships among Y and X1, X2, X3 
*     via scatter plots and correlations.
***************************************
graph matrix expend_per_k income kids_per_k urban_per_k
* Calculate correlation coefficients
correlate expend_per_k income kids_per_k urban_per_k

***************************************
* (b) Test the overall effects of X1, X2, X3 on Y.
*     First, estimate the multiple regression model:
*         Y = β₀ + β₁·income + β₂·kids_per_k + β₃·urban_per_k + ε
***************************************
regress expend_per_k income kids_per_k urban_per_k

* Test the joint null hypothesis:
*   H₀: β₁ = β₂ = β₃ = 0   versus   H₁: at least one β ≠ 0.
test income kids_per_k urban_per_k

***************************************
* (c) Create indicator variables for the categorical variable yearint 
*     and include them in the multivariable model.
*     Use year interval 1 as the baseline.
***************************************
* Using factor-variable notation, Stata automatically creates dummies:
regress expend_per_k income kids_per_k urban_per_k i.yearint

***************************************
* (d) Change the baseline level for yearint to level 2.
*     This is done by specifying the base level in the factor notation.
***************************************
regress expend_per_k income kids_per_k urban_per_k ib2.yearint

test 2.yearint = 3.yearint
* (Comment: Observe how the coefficient and significance for level 3 change,
*  which is due to the reparameterization of the model when the reference level is altered.)

***************************************
* (e) Test whether the effect of X₂ (kids_per_k) is constant across year intervals.
*     Create interaction terms between yearint and kids_per_k.
*     For this model, reset the baseline for yearint back to 1.
***************************************
regress expend_per_k i.yearint##c.kids_per_k i.yearint##c.income i.yearint##c.urban_per_k

testparm i.yearint#c.income
* The model now is:
*   Y = β₀ + β₁·income + β₂·kids_per_k + β₃·urban_per_k 
*       + δ₂·I(yearint=2) + δ₃·I(yearint=3)
*       + γ₂·[I(yearint=2)*kids_per_k] + γ₃·[I(yearint=3)*kids_per_k] + ε.
*
* The hypotheses to test are:
*   H₀: γ₂ = γ₃ = 0   versus   H₁: at least one γ ≠ 0.
* The test is carried out as follows:
testparm i.yearint#c.kids_per_k

***************************************
* (f) Report coefficients for kids_per_k (X₂) separately by year interval.
*     Run stratified (separate) regressions by yearint.
***************************************
by yearint, sort: regress expend_per_k income kids_per_k urban_per_k

* (Interpret the coefficient on kids_per_k in each subgroup.)

***************************************
* (g) Check if there is any suggestion that other predictors may vary over year intervals.
*     (Examine the stratified regressions from part (f) to see if the slopes
*      for income or urban_per_k differ markedly by year interval.)
***************************************
* (The results from (f) should be inspected for differences in coefficients.)

***************************************
* (h) Write out the slopes for kids_per_k in each year interval in terms of the estimated β’s.
*
*  From the interaction model in (e):
*    - For year interval 1 (baseline): 
*          Slope = β₂.
*    - For year interval 2: 
*          Slope = β₂ + γ₂.
*    - For year interval 3: 
*          Slope = β₂ + γ₃.
*
* Compare these slopes with those from the stratified regressions in (f).
***************************************
* (This is typically written out in the report based on the estimated coefficients.)

***************************************
* (i) Compute the predicted expenditure for each of the three year intervals.
*     For this calculation, set X₁ (income) and X₃ (urban_per_k) at their mean values.
*     (We also set X₂ (kids_per_k) at its mean to obtain a complete prediction.)
***************************************
* Estimate the interaction model
regress expend_per_k income urban_per_k i.yearint##c.kids_per_k

* Calculate means for income and urban_per_k
summarize income, meanonly
local mean_income = r(mean)
summarize urban_per_k, meanonly
local mean_urban = r(mean)

* Determine the range of kids_per_k (adjust step size as desired)
summarize kids_per_k, meanonly
local min_kids = r(min)
local max_kids = r(max)

* Use margins to compute predicted values while varying kids_per_k
margins i.yearint, at(income = `mean_income' urban_per_k = `mean_urban' kids_per_k = (`min_kids'(5)`max_kids'))

* Plot only the predicted lines, without confidence intervals
marginsplot, xdimension(kids_per_k) recast(line) noci ///
    title("Predicted Expenditure vs. number of school age kids by Year Interval") ///
    xtitle("number of school age kids") ytitle("Predicted Expenditure per 1000") ///
    legend(title("Year Interval"))

* Estimate the interaction model
regress expend_per_k income urban_per_k i.yearint##c.kids_per_k

* Calculate means for income and urban_per_k
summarize income, meanonly
local mean_income = r(mean)
summarize urban_per_k, meanonly
local mean_urban = r(mean)

* Determine the range of kids_per_k (adjust step size as desired)
summarize kids_per_k, meanonly
local min_kids = r(min)
local max_kids = r(max)

* Use margins to compute predicted values while varying kids_per_k
margins i.yearint, at(income = `mean_income' urban_per_k = `mean_urban' kids_per_k = (`min_kids'(5)`max_kids'))

marginsplot, xdimension(kids_per_k) recast(line) noci ///
    plotopts(msymbol(O)) ///
    title("Predicted Expenditure vs. Number of School Age Kids by Year Interval") ///
    xtitle("Number of School Age Kids") ytitle("Predicted Expenditure per 1000") ///
    legend(title("Year Interval"))
