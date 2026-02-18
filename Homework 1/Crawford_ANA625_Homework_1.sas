libname Data_625 '/home/u64094997/my_courses/ANA 625/Data_625/Case Studies';

/* 5. For the complete case analysis, restrict your sample based on the following conditions:
a.	18<=AGE<=99 
b.	SEX: raw categories 1 and 2
c.	DIABETE2: raw categories 1 and 3
d.	EXERANY2: raw categories 1 and 2
e.	EDUCA: raw categories 1-6
f.	_BMI4CAT: raw categories 1,2 and 3
g.	GENHLTH: raw categories 1-5 */

data HW1; set Data_625.cdbrfs10; 
where (18<=AGE<=99) and SEX in(1,2) and DIABETE2 in(1,3) and EXERANY2 in(1,2) and (1<=EDUCA<=6) and _BMI4CAT in(1,2,3) and (1<=GENHLTH<=5);

/* Check restricted sample for missing values. */

proc means data=HW1 n nmiss; 
	var AGE SEX DIABETE2 EXERANY2 EDUCA _BMI4CAT GENHLTH; 
run;  

/* 1. Use the raw variable _BMI4CAT and call it BMI*/

data HW1; set HW1(rename=(_BMI4CAT=BMI));

/* 2. Using the raw variable SEX, create a new two-level variable SEX (male=0, female=1) where male is category 1 of the raw variable and female is category 2 */
 
array RECODE SEX; 
do over RECODE; 
if RECODE = 2 then RECODE = 1; 
else if RECODE = 1 then RECODE = 0; 
end;  

/* 3. Using the raw variable DIABETE2, create a new two-level variable DIABETES (no=0, yes=1) where yes is category 1 of the raw variable and no is category 3 */
 
if DIABETE2=1 then DIABETES = 1; 
if DIABETE2=3 then DIABETES = 0;
 
/* 4. Using the raw variable EXERANY2, create a new two-level variable EXERCISE (no=0, yes=1) where yes is category 1 of the raw variable and no is category 2 */ 

if EXERANY2=1 then EXERCISE = 1; 
if EXERANY2=2 then EXERCISE = 0; 
run;

/* Check modified sample for missing values. */

proc means data=HW1 n nmiss; 
	var BMI SEX DIABETES EXERCISE;
run;

/* 1) (20 pts) Using PROC FREQ, create a 2x2 contingency table for EXERCISE by SEX. 
	a. Show the PROC FREQ output which shows only the counts in each cell. */

proc freq data=HW1;
	tables EXERCISE*SEX / norow nopercent nocol;
run;

/*  b. Show your hand calculation of the Pearson chi-square statistic X2 for testing whether there is an association between sex and exercise.

p(EXERCISE=0) => 111,531 / 413,748 = 0.2696
p(EXERCISE=1) => 302,217 / 413,748 = 0.7304
     p(SEX=0) => 162,430 / 413,748 = 0.3926
     p(SEX=1) => 251,318 / 413,748 = 0.6074

Using p(EXERCISE & SEX) identification:         Estimated       ((Estimated - Actual)^2) /  Estimated = Result
	p(0 & 0) => 0.2696 x 0.3926 = 0.1058 		44,774.54		((44,774.54 - 39,424)^2) /  44,774.54 = 639.39
	p(0 & 1) => 0.2696 x 0.6074 = 0.1638		67,771.92		((67,771.92 - 72,107)^2) /  67,771.92 = 277.30
	p(1 & 0) => 0.7304 x 0.3926 = 0.2868	   118,662.93	  ((118,662.93 - 123,006)^2) / 118,662.93 = 158.96
	p(1 & 1) => 0.7304 x 0.6074 = 0.4436 	   183,538.61	  ((183,538.61 - 179,211)^2) / 183,538.61 = 102.04
						Totals:	  1.0000	   413,748.00				  Pearson's Chi-Square (X2):  1,177.69 > 3.841 Chi-Square Critical Value (a = 0.05 and dof = 1) */
						
/*  c. Based on your calculated chi-square value, is there an association between SEX and EXERCISE?  Explain. 
		i.	 What is your null hypothesis?
			The null hypothesis (H0) indicates there is no aggregate statistical association between the EXERCISE and SEX variables.
			
		ii.	 What significance level are use assuming?
			An alpha of 0.05 is being used as a significance level representing a 95% confidence.
			
		iii. What is the critical chi-square value?
			The critical Chi-Square value is 3.841 for an alpha of 0.05 and 1 degree of freedom.
			
		iv.	 What is the conclusion from your statistical test?
			Given the Pearson's Chi-Square (X2) of 1,177.69 is greater than the critical Chi-Square value of 3.841, the null hypothesis (H0) is rejected in favor of a 
			statistical association between the EXERCISE and SEX variables. */
			
/*  d.  Do your (1) hand calculated chi-square statistic, and (2) conclusion on the presence of an association match that produced by PROC FREQ?  Include the relevant 
PROC FREQ output in your explanation. */			
			
proc freq data=HW1;
	tables EXERCISE*SEX / norow nocol nopercent chisq relrisk;
run;
						
	/* (1) My hand calculated Pearson Chi-Square statistic of 1,177.69 differs from the Chi-Square value of 979.01 that is represented in the PROC FREQ output.
	   (2) The conclusions are similar though, the PROC FREQ Chi-Square p-value of <0.0001 is easily less than the 0.05 alpha standard indicating the null hypothesis 
	   (H0) is rejected in favor of a statistical association between the EXERCISE and SEX variables. */ 

/* Note: Manually performed the Cramer's V calculation and got 0.0486, but PROC FREQ shows it as -0.0486. Nonetheless, the absolute Cramer's V value is below 0.10 
indicating a weak association. */

/* 2) (26 pts) Create your “Table 1” for this objective.  You can use this table template (copy and paste into Excel):

/* Table 1: Control variables by exposure. */
 
proc freq data=HW1;
    tables (SEX EXERCISE)*BMI / norow chisq; 
run; 

/* 3) (20 pts) Write the results section for this “Table 1”.  Use the “boilerplate” language shown in Case Study Example – Tables 1, 2 & 3.ppt exactly, allowing for
discussed references for Male(SEX), No(EXERCISE), and Normal(BMI).

Of the 451,075 BRFSS 2010 participants, 413,748 (91.7%) had complete data for the objective.  The demographic characteristics of this sample population are compared in 
Table 1 with respect to the exposure variable BMI.  Of the entire sample population, 60.74% were female, 73.04% exercised, 36.68% were overweight, and 28.19% were obese.  
With respect to sex, there were relatively fewer females than expected in the overweight group (52.16% vs. 60.74%; p<0.0001), and slightly fewer females than expected in 
the obese group (59.90% vs. 60.74%; p<0.0001). With respect to exercise, there were relatively more exercisers than expected in the overweight group (75.38% vs. 73.04%; 
p<0.0001), and there were exercisers as expected in the obese group (73.04% vs. 73.04%; p<0.0001). */

/* 4) (34 pts) Consider a simple model: DIABETES =f(OBESITY, SEX). Investigate confounding between sex and obesity by first creating the binary variable, OBESITY: 0/1 
(BMI = 1 / BMI = 2,3). */

data HW1; set HW1;
if BMI=1 then OBESITY = 0; 
if BMI=2 then OBESITY = 1;
if BMI=3 then OBESITY = 1;
run;

 /* a.	Using PROC FREQ and a 2x2 contingency table between DIABETES and your new variable OBESITY: */

proc freq data=HW1;
	tables OBESITY*DIABETES / norow nopercent nocol;
run;

	 /* i.	Show your hand calculation for the odds ratio (OR) for a diagnosis of DIABETES with respect to OBESITY and interpret.
	 
	 odds of a diabetes diagnosis from no obesity: 	8,189 / 137,163	= 0.0597
     odds of a diabetes diagnosis from obesity:	   45,461 / 222,935	= 0.2039
     
     				Odds Ratio (OR) = 0.2039 / 0.0597 = 3.4154
     												
     The odds of a diabetes diagnosis from obesity are 2.84x greater relative to no obesity.

		ii.	Show your hand calculation of the 95% OR confidence interval and interpret in terms of its width.
		
	 Standard Error ln(OR) = SQRT(1/137,163 + 1/8,189 + 1/222,935 + 1/45,461) = 0.01249
	 Lower Confidence Limit = exp(ln(3.4154) - 1.96*0.01249) = 3.339 
	 Upper Confidence Limit = exp(ln(3.4154) + 1.96*0.01249) = 3.500
	 
	                 (OR=3.415, 95% CI=3.339~3.500)
	 
	 Given that the confidence interval width is 0.161, it implies a great deal of precision in the 3.415 OR estimate.
	 
		iii.	Determine and explain if the OR is statistically significant.
		
	 Given the OR 95% confidence interval is greater than and clearly does not include 1.0 (which implies no association), the estimated OR is statistically 
	 significant.
		
	b.	Using PROC FREQ and two, 2x2 contingency tables between DIABETES and OBESITY (one for females and one for males), for each stratum: */
	
proc freq data=HW1;
	tables SEX*OBESITY*DIABETES / norow nopercent nocol;
run;

	 /* i.	 Show your hand calculation for the OR for a diagnosis of DIABETES with respect to OBESITY and interpret.
	 
	 Regarding males:
	 odds of a diabetes diagnosis from no obesity: 	3,097 / 39,964	= 0.0775
     odds of a diabetes diagnosis from obesity:	   19,513 / 99,856	= 0.1954
     
     				Odds Ratio (OR) = 0.1954 / 0.0775 = 2.5213
     												
     For males, the odds of a diabetes diagnosis from obesity are 2.52x greater relative to no obesity.
     
     Regarding females:
	 odds of a diabetes diagnosis from no obesity: 	5,092 /  97,199	= 0.0524
     odds of a diabetes diagnosis from obesity:	   25,948 / 123,079	= 0.2108
     
     				Odds Ratio (OR) = 0.2108 / 0.0524 = 4.0229
     												
     For females, the odds of a diabetes diagnosis from obesity are 4.02x greater relative to no obesity.
     
     			   Average Odds Ratio (OR) = (2.5213 + 4.0229) / 2 = 3.2721
     
     With respects to sex, the average odds of a diabetes diagnosis from obesity are 3.27x greater relative to no obesity.
     
		ii.	 Show your hand calculation for the 95% OR confidence interval and interpret in terms of its width.
	
	 Regarding males:
	 Standard Error ln(OR) = SQRT(1/3,097 + 1/39,964 + 1/19,513 + 1/99,856) = 0.0202
	 Lower Confidence Limit = exp(ln(2.5213) - 1.96*0.0202) = 2.4234 
	 Upper Confidence Limit = exp(ln(2.5213) + 1.96*0.0202) = 2.6231
	 (OR=2.521, 95%CI=2.432~2.623)
	 
	 Given that the confidence interval width is 0.2, it implies a reasonably high level of precision in the 2.521 OR estimate.
	 
	 Regarding females:
	 Standard Error ln(OR) = SQRT(1/5,092 + 1/97,199 + 1/25,948 + 1/123,079) = 0.0159
	 Lower Confidence Limit = exp(ln(4.0229) - 1.96*0.0159) = 3.8995 
	 Upper Confidence Limit = exp(ln(4.0229) + 1.96*0.0159) = 4.1502
	 (OR=4.023, 95%CI=3.900~4.150)
	 
	 Given that the confidence interval width is 0.251, it implies a reasonably high level of precision in the 4.023 OR estimate.
		
		iii. Determine and explain if the OR are statistically significant.
		
	 Given the OR 95% confidence intervals for males and females are greater than and clearly do not include 1.0 (which implies no association), the estimated ORs 
	 are statistically significant.
	
	c.	Show your hand calculation for the Cochran-Mantel-Haenszel “weighted average” OR with respect to OBESITY and interpret.
	
	 CMH OR = [((39,964 * 19,513) / 162,430) + ((97,199 * 25,948) / 251,318)] / [((99,856 * 3,097) / 162,430) + ((123,079 * 5,092) / 251,318)] = 3.374
	 
	 With respects to sex, the weighted average odds of a diabetes diagnosis from obesity are 3.37x greater relative to no obesity.
	
	d.	Determine and explain if SEX is a confounding variable.
	
	 Unadjusted Odds Ratio (OR) = 3.415
	 CMH "Weighted Average" Odds Ratio (OR) = 3.374
	 
	 Difference = (3.374 / 3.415) - 1 = -0.0122 or -1.22%
	 
	 Given that the absolute value of 1.22% is less than the 10% rule of thumb, SEX is not considered a confounder of the association between OBESITY and DIABETES, 
	 and does not matter in terms of measuring the overall effectiveness of obesity on a diabetes diagnosis.
	
	e.	Determine and explain if SEX is an effect modifier (use PROC FREQ to generate any required statistics). */

proc freq data=HW1;
	tables SEX*OBESITY*DIABETES / norow nocol relrisk plots=mosaicplot cmh;
run;

     /* In the Breslow-Day test, there was an extremely low p-value of <0.0001 that is safely under the 0.05 alpha standard.  This indicates that the H0 of 
     homogeneity can be rejected, and the SEX variable is an effect modifier, due to the OR difference between males and females. This is clearly illustrated in the 
     Odds Ratio with 95% Wald Confidence Limits chart.*/
    
/* Extra Credit (10 pts)
	The following data are from a survey of US adults as to their “life satisfaction”: */

data life_satisfaction;
	input INCOME $15. Satisfaction $13. Count;
	datalines;
$0-$30,000      Dissatisfied 4
$0-$30,000      Neutral      10
$0-$30,000      Satisfied    6
$30,000-$55,000 Dissatisfied 5
$30,000-$55,000 Neutral      10
$30,000-$55,000 Satisfied    7
$55,000-$70,000 Dissatisfied 7
$55,000-$70,000 Neutral      11
$55,000-$70,000 Satisfied    17
>$70,000        Dissatisfied 4
>$70,000        Neutral      6
>$70,000        Satisfied    18
;
run;

	/* Is there an association between “life satisfaction” and income?  Explain using an appropriate statistical test. */

/* Run the Chi-Square & Fisher Test of Independence. */

proc freq data=life_satisfaction;
	weight Count;
	tables INCOME*Satisfaction / norow nocol chisq exact relrisk
	plots=mosaicplot cmh;
run;

/* Chi-Square (X2) Statistic: 8.2485 < 12.592 Chi-Square Critical Value (a = 0.05 and dof = 6)
   Chi-Square p-value: 0.2205 > 0.05 Alpha Standard
   Fisher p-value: 0.2199 > 0.05 Alpha Standard
   CMH General Association p-value: 0.2259 > 0.05 Alpha Standard
   
   All of the metrics listed above fail to reject the null hypothesis (H0), suggesting that there is no statistical association between income and satisfaction.
   Although in the Distribution of Income by Satisfaction plot, close to 75% of those who identified as satisfied had an income above $55,000. */