clear all

**Q1**
infile F P1 P2 using "/Users/yubin/Desktop/STAT 22401/hw2/assessments.txt", clear
drop in 1

graph matrix F P1 P2


/******************************************************************
(b) 拟合三个回归模型
******************************************************************/
* F = β0 + β1 * P1 + ε
regress F P1
estimates store Model1

* F = β0 + β2 * P2 + ε
regress F P2
estimates store Model2

* F = β0 + β1 * P1 + β2 * P2 + ε
regress F P1 P2
estimates store Model3

/******************************************************************
(f) 预测一个 P1=78 和 P2=85 的个体的 F 分数
******************************************************************/
* 使用 Model3 进行预测
* 创建一个新的数据集包含要预测的值
clear
input P1 P2
78 85
end

* 使用之前的模型参数进行预测
* 重新加载模型3的估计
estimates restore Model3

* 预测 F 值
predict F_predicted, xb

* 显示预测结果
list

clear all

infile BMI age cholest glucose using "/Users/yubin/Desktop/STAT 22401/hw2/BMIdat.txt",clear
drop in 1
// -----------------------------------------------------------------------------
// (a) Evaluate the correlation of BMI predictors with each other and with BMI
// -----------------------------------------------------------------------------

// Display the correlation matrix with significance levels
correlate BMI age cholest glucose

// -----------------------------------------------------------------------------
// (b) Use simple linear regression to evaluate each candidate predictor alone
// -----------------------------------------------------------------------------

// Regression of BMI on Age
regress BMI age
// Summarize findings based on output

// Regression of BMI on Cholesterol
regress BMI cholest
// Summarize findings based on output

// Regression of BMI on Glucose
regress BMI glucose
// Summarize findings based on output

// -----------------------------------------------------------------------------
// (c) Use multiple linear regression to evaluate all predictors
// -----------------------------------------------------------------------------

// Multiple Regression: BMI on Age, Cholesterol, and Glucose
regress BMI age cholest glucose
// Summarize findings based on output

// -----------------------------------------------------------------------------
// (d) Reduce the model to a suitable 2-variable (or one-variable) model
// -----------------------------------------------------------------------------

// Stepwise Selection based on p-value < 0.15
stepwise, pr(.15): regress BMI age cholest glucose

// -----------------------------------------------------------------------------
// (e) Obtain the predicted values and plot these against the BMI values
// -----------------------------------------------------------------------------
regress BMI cholest glucose
// Generate predicted BMI values from the regression model
predict BMI_hat, xb

// Scatter plot of Predicted BMI vs Actual BMI
twoway (scatter BMI_hat BMI, mcolor(blue) msymbol(o)) || ///
       (line BMI BMI, lcolor(red)), ///
       title("Predicted BMI vs Actual BMI") ///
       xlabel(, grid) ylabel(, grid) ///
       legend(order(1 "Predicted BMI" 2 "Actual BMI (y=x)"))


// -----------------------------------------------------------------------------
// End of Analysis
// -----------------------------------------------------------------------------

*--------------------------------------------
* Cigarette Consumption Analysis in Stata
* Variables:
*   State   - U.S. State/Territory (string)
*   Age     - Median resident age (numeric)
*   HS      - Percentage high school graduates (numeric)
*   Income  - Income measure (numeric)
*   AA      - Percentage African-American (numeric)
*   Female  - Percentage female (numeric)
*   Price   - Price measure (numeric)
*   Sales   - Packs per capita sold (numeric; Outcome Variable)
*--------------------------------------------

* Clear any existing data
clear all

*--------------------------------------------
* Step 1: Import the Data
*--------------------------------------------
* Adjust the delimiter if your file uses commas or another delimiter
infile State Age HS Income AA Female Price Sales using"/Users/yubin/Desktop/STAT 22401/hw2/cigarettesales.txt", clear
drop in 1
* Verify the data has been imported correctly
describe
summarize

*--------------------------------------------
* Step 2: Define the Full Regression Model
*--------------------------------------------
* The full model includes all numeric predictors:
* Age, HS, Income, AA, Female, Price
regress Sales Age HS Income AA Female Price

*--------------------------------------------
* Part (a): Overall Significance Test
* Hypothesis:
*   H0: All coefficients (except intercept) are equal to zero
*   HA: At least one coefficient is not zero
* Test: F-test (automatically provided in the regression output)
* Conclusion: Check the p-value of the F-statistic
*--------------------------------------------
* The F-test is already included in the regression output above.
* To explicitly test, you can use:
test Age HS Income AA Female Price

*--------------------------------------------
* Part (b): Test if 'Female' is Not Needed
* Hypothesis:
*   H0: The coefficient of Female = 0
*   HA: The coefficient of Female ≠ 0
* Test: t-test for the 'Female' coefficient
*--------------------------------------------
* The t-test is included in the regression output.
* To explicitly test:
test Female

*--------------------------------------------
* Part (c): Test if 'Female' and 'HS' are Not Needed
* Hypothesis:
*   H0: The coefficients of Female = 0 AND HS = 0
*   HA: At least one of the coefficients ≠ 0
* Test: Joint F-test
*--------------------------------------------
test Female HS

*--------------------------------------------
* Part (d): 95% Confidence Interval for 'Income' Coefficient
*--------------------------------------------
* Obtain the 95% confidence interval for the 'Income' coefficient
regress Sales Age HS Income AA Female Price
confint Income

* Alternatively, display confidence intervals for all coefficients
* which includes 'Income'
regress Sales Age HS Income AA Female Price
* The output will show 95% CIs by default

*--------------------------------------------
* Part (e): R-squared After Removing Income, Female, and HS
*--------------------------------------------
* Remove Income, Female, and HS from the model
* Predictors remaining: Age, AA, Price
regress Sales Age AA Price

* Display R-squared
display "R-squared after removing Income, Female, and HS: " e(r2)

*--------------------------------------------
* Part (f): R-squared with Price, Age, and Income
* Predictors: Price, Age, Income
regress Sales Price Age Income

* Display R-squared
display "R-squared with Price, Age, and Income: " e(r2)

*--------------------------------------------
* Part (g): R-squared with Income Alone
* Predictor: Income
regress Sales Income

* Display R-squared
display "R-squared with Income alone: " e(r2)

*--------------------------------------------
* Part (h): Final Model Selection and Interpretation
* Steps:
*   1. Start with the full model.
*   2. Omit non-significant predictors based on previous tests.
*   3. Describe remaining predictors (direction and magnitude).
*--------------------------------------------

* Based on parts (b) and (c), 'Female' and 'HS' are not significant.
* Suppose 'AA' is also not significant (based on t-test).
* Adjust the model accordingly.

* Run the final model excluding 'Female', 'HS', and 'AA'
regress Sales Age Income Price

* Check the significance of remaining predictors
* Assume all are significant based on output

* Display coefficients with interpretation
* The coefficients are provided in the regression output

* Example Interpretation:
* - Age: Positive coefficient means older median age is associated with higher sales.
* - Income: Negative coefficient means higher income is associated with lower sales.
* - Price: Negative coefficient means higher price is associated with lower sales.

* To export the final model results, use outreg2 or other export commands
* Ensure 'outreg2' is installed: ssc install outreg2
outreg2 using final_model.doc, replace ctitle(Final Regression Model)

* Alternatively, use esttab for exporting results
* Ensure 'estout' is installed: ssc install estout
esttab using final_model.txt, replace

*--------------------------------------------
* End of Analysis
*--------------------------------------------
*--------------------------------------------
* Part (d): 95% Confidence Interval for 'Income' Coefficient
*--------------------------------------------
* Obtain the 95% confidence interval for the 'Income' coefficient
regress Sales Age Income AA Price

*--------------------------------------------
* Part (e): R-squared After Removing Income, Female, and HS
*--------------------------------------------
* Remove Income, Female, and HS from the model
* Predictors remaining: Age, AA, Price
regress Sales Age AA Price

* Display R-squared
display "R-squared after removing Income, Female, and HS: " e(r2)

*--------------------------------------------
* Part (f): R-squared with Price, Age, and Income
* Predictors: Price, Age, Income
regress Sales Price Age Income

* Display R-squared
display "R-squared with Price, Age, and Income: " e(r2)

*--------------------------------------------
* Part (g): R-squared with Income Alone
* Predictor: Income
regress Sales Income

* Display R-squared
display "R-squared with Income alone: " e(r2)

*--------------------------------------------
* Part (h): Final Model Selection and Interpretation
* Steps:
*   1. Start with the full model.
*   2. Omit non-significant predictors based on previous tests.
*   3. Describe remaining predictors (direction and magnitude).
*--------------------------------------------

* Based on parts (b) and (c), 'Female' and 'HS' are not significant.
* Suppose 'AA' is also not significant (based on t-test).
* Adjust the model accordingly.

* Run the final model excluding 'Female', 'HS', and 'AA'
stepwise, pr(.05): regress Sales Age HS Income AA Female Price

*Or to have higher p-value for higher
stepwise, pr(0.10): regress Sales Age HS Income AA Female Price
*--------------------------------------------
* End of Analysis
*--------------------------------------------
