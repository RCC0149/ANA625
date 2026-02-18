libname Data_625 '/home/u64094997/my_courses/ANA 625/Data_625/Case Studies';

/* 5. For the complete case analysis, restrict your sample based on the following conditions:
a.	18<=AGE<=99 
b.	SEX: raw categories 1 and 2
c.	DIABETE2: raw categories 1 and 3
d.	EXERANY2: raw categories 1 and 2
e.	EDUCA: raw categories 1-6
f.	_BMI4CAT: raw categories 1,2 and 3
g.	GENHLTH: raw categories 1-5 */

data HW2; set Data_625.cdbrfs10; 
where (18<=AGE<=99) and SEX in(1,2) and DIABETE2 in(1,3) and EXERANY2 in(1,2) and (1<=EDUCA<=6) and _BMI4CAT in(1,2,3) and (1<=GENHLTH<=5);

/* Check restricted sample for missing values. */

proc means data=HW2 n nmiss; 
	var AGE SEX DIABETE2 EXERANY2 EDUCA _BMI4CAT GENHLTH; 
run;  

/* 1. Use the raw variable _BMI4CAT and call it BMI*/

data HW2; set HW2(rename=(_BMI4CAT=BMI));

/* 2. Using the raw variable SEX, create a new two-level variable SEX (male=0, female=1) where male is category 1 of the raw variable and 
female is category 2 */
 
array RECODE SEX; 
do over RECODE; 
if RECODE = 2 then RECODE = 1; 
else if RECODE = 1 then RECODE = 0; 
end;  

/* 3. Using the raw variable DIABETE2, create a new two-level variable DIABETES (no=0, yes=1) where yes is category 1 of the raw variable 
and no is category 3 */
 
if DIABETE2=1 then DIABETES = 1; 
if DIABETE2=3 then DIABETES = 0;
 
/* 4. Using the raw variable EXERANY2, create a new two-level variable EXERCISE (no=0, yes=1) where yes is category 1 of the raw variable 
and no is category 2 */ 

if EXERANY2=1 then EXERCISE = 1; 
if EXERANY2=2 then EXERCISE = 0; 
run;

/* Check modified sample for missing values. */

proc means data=HW2 n nmiss; 
	var BMI SEX DIABETES EXERCISE;
run;

/* 1) (15 pts) Create your “Table 2” for this objective. */

proc freq data=HW2; 
    tables (BMI SEX EXERCISE)*DIABETES / norow chisq; 
run;

/* 2) (20 pts) Write the results section for this “Table 2”.  Use the “boilerplate” language shown in Case Study Example – 
Tables 1, 2 & 3.ppt exactly, allowing for discussed references for Normal(BMI), Male(SEX), No(EXERCISE), and No(DIABETES).

Of the 451,075 BRFSS 2010 participants, 413,748 (91.7%) had complete data for the objective. The demographic characteristics of this 
sample population are compared in Table 2 with respect to the outcome variable, presence of diabetes. Overall, 13% of the entire sample 
population had a diagnosis of diabetes.  With regards to body mass index (BMI), there were notably more obese than expected who had 
diabetes (52.6% vs 28.19%; p<0.0001), but there were relatively fewer overweight than expected who had diabetes (32.14% vs 36.68%). With 
regards to sex, there were relatively fewer females than expected who had diabetes (57.86% vs 60.74%; p<0.0001). With regards to exercise,
there were notably fewer exercisers than expected who had diabetes (59.63% vs 73.04%; p<0.0001). */

/* 3) (8 pts) Calculate the odds ratios (ORs) for a diagnosis of DIABETES using the data in Table 2. Fill in the table below with these ORs. */

proc logistic data=HW2; 
    class DIABETES (ref='0') BMI (ref='1') SEX (ref='0') EXERCISE (ref='0')  /
    param=ref; 
    model DIABETES = BMI SEX EXERCISE; 
run;

/* 4) (28 pts) Consider the simple model DIABETES = f (BMI).

    a. Create a binary variable OBESITY from BMI as follows:
       • if BMI = 2,3 then OBESITY = 1; else OBESITY = 0 */

data HW2; set HW2;
if BMI=1 then OBESITY = 0; 
if BMI=2 then OBESITY = 1;
if BMI=3 then OBESITY = 1;
run;

       /* i. Run a logistic regression that estimates the model DIABETES = f(OBESITY). Use DESCENDING option without a CLASS statement.
             Show the Analysis of Maximum Likelihood Estimates (MLEs) output table. */
      
proc logistic data=HW2 descending; 
	model DIABETES = OBESITY; 
run;

       /* ii. Show your hand calculation for the OR for a diagnosis of DIABETES with respect to OBESITY using the data shown in the MLEs
              table.
       
          OR = exp(1.228) = 3.414
       
          iii.	Interpret the magnitude of your calculated OR.
       
          The odds of a diabetes diagnosis from obesity are 3.4x greater relative to no obesity.
          
          iv. Show your hand calculation for the global chi-squared test statistic. Interpret your calculated value. */
         
proc freq data=HW2;
	tables OBESITY*DIABETES / norow nopercent nocol;
run;

          
/* p(OBESITY=0) => 145,352 / 413,748 = 0.3513
   p(OBESITY=1) => 268,396 / 413,748 = 0.6487
  p(DIABETES=0) => 360,098 / 413,748 = 0.8703
  p(DIABETES=1) =>  53,650 / 413,748 = 0.1297

Using p(OBESITY & DIABETES) identification:     Estimated       ((Estimated - Actual)^2) /  Estimated =   Result
	p(0 & 0) => 0.3513 x 0.8703 = 0.3057 	   126,482.76	  ((126,482.76 - 137,163)^2) / 126,482.76 =   901.84
	p(0 & 1) => 0.3513 x 0.1297 = 0.0456		18,866.91	   ((18,866.91 -   8,189)^2) /  18,866.91 = 6,043.27
	p(1 & 0) => 0.6487 x 0.8703 = 0.5646	   233,602.12	  ((233,602.12 - 222,935)^2) / 233,602.12 =   487.10
	p(1 & 1) => 0.6487 x 0.1297 = 0.0841 	    34,796.21	   ((34,796.21 -  45,461)^2) /  34,796.21 = 3,268.68
						Totals:	  1.0000	   413,748.00				   
						
Pearson's Chi-Square (X2):  10,700.89 > 3.841 Chi-Square Critical Value (a = 0.05 and dof = 1)
						
Given the Pearson's Chi-Square (X2) of 10,700.89 is greater than the critical Chi-Square value of 3.841, the null hypothesis (H0) is 
rejected in favor of a statistical association between the OBESITY and DIABETES variables. */		

  /* b. Now, run a logistic regression that estimates the model DIABETES = f(BMI). Use DESCENDING option without a CLASS statement. */
 
proc logistic data=HW2 descending; 
	model DIABETES = BMI; 
run;

     /* i. Show the MLEs output table. 
     
        ii.	Show your hand calculation for the OR for a diagnosis of DIABETES with respect to BMI using the data shown in the MLEs table.
        
        OR = exp(0.8527) = 2.346
        
        iii. Interpret the magnitude of your calculated OR.
        
        The odds of a diabetes diagnosis from body mass index (BMI) are 2.35x greater relative to not being from body mass index (BMI).
        
        iv.	Why does this OR differ from the OR you calculated in part (a)?
        
        The BMI OR looked at the variable in its totality, while the OBESITY OR focused on the Overweight and Obese that have a greater 
        occurrence of having diabetes. */
        
  /* c.	Now, run a logistic regression that estimates the model DIABETES = f(BMI) with a CLASS statement using DIABETES = 0 and BMI = 1 
        as the reference categories and PARAM = ref. */

proc logistic data=HW2; 
	class DIABETES (ref='0') BMI (ref='1') / 
	param=ref; 
	model DIABETES = BMI; 
run;

     /* i. Show the MLEs output table.
 
        ii.	Show your hand calculation for the OR for a diagnosis of DIABETES with respect to the two levels of BMI, 2 and 3, using the
            data shown in the MLEs table.
        
        OR(BMI=2) = exp(0.7635) = 2.146
        OR(BMI=3) = exp(1.6762) = 5.345
        
        iii. Interpret the magnitude of each of your calculated ORs.
        
        The odds of a diabetes diagnosis from being overweight (BMI=2) are 2.15x greater relative to being normal (BMI=1).
        The odds of a diabetes diagnosis from being obese (BMI=3) are 5.35x greater relative to being normal (BMI=1).
        
  /* d.	Finally, create two dummy variables as follows:  
        • If BMI = 2 then BMI_OVERWEIGHT = 1; else BMI_OVERWEIGHT = 0. 
        • If BMI = 3 then BMI_OBESE = 1; else BMI_OBESE = 0. */

data HW2; set HW2; 
    If BMI=2 then BMI_OVERWEIGHT = 1; 
    	else BMI_OVERWEIGHT = 0;
	If BMI=3 then BMI_OBESE = 1; 
    	else BMI_OBESE = 0;
run;

     /* i. Run a logistic regression that estimates the model DIABETES = f(BMI_OVERWEIGHT, BMI_OBESE). Use DESCENDING option without 
           a CLASS statement. Show the MLEs output table. */ 
 
proc logistic data=HW2 descending; 
	model DIABETES = BMI_OVERWEIGHT BMI_OBESE; 
run;

    /* ii. Show your hand calculation for the OR for a diagnosis of DIABETES with respect to BMI_OVERWEIGHT and BMI_OBESE using the data
           shown in the MLEs table.
           
       OR(BMI_OVERWEIGHT) = exp(0.7635) = 2.146
            OR(BMI_OBESE) = exp(1.6762) = 5.345
           
       iii. Why are these ORs the same as the ones calculated in part (c) above?
      
       The created dummy variables have the same number of affirming responses as their corresponding BMI value.  */
      
/* 5) (46 pts) Consider the expanded model DIABETES = f(BMI, SEX, EXERCISE).

    a. Run a logistic regression that estimates the model DIABETES = f (BMI, EXERCISE, SEX), with a CLASS statement which specifies 
       these reference categories: DIABETES = 0; EXERCISE = 0; SEX = 0; BMI = 1. Also use PARAM = ref. */
      
proc logistic data=HW2; 
	class DIABETES (ref='0') EXERCISE (ref='0') SEX (ref='0') BMI (ref='1') / 
	param=ref; 
	model DIABETES = BMI EXERCISE SEX; 
run;

    /* i. Show the Analysis of Maximum Likelihood Estimates (MLEs) output table.
    
       ii. Interpret both the sign and magnitude of the estimated coefficient for EXERCISE.
       
       An exerciser (EXERCISE=1) has a 0.5682 decrease in the log odds of DIABETES, controlling for BMI and SEX.
       
       iii. Show your hand calculation for the OR for a diagnosis of DIABETES with respect to EXERCISE using the data shown in the MLEs 
           table.
       
       OR(EXERCISE=1 vs 0) = exp(-0.5682) = 0.567
       
       iv. Interpret both the sign and magnitude of the estimated odds ratio for EXERCISE.
       
       An exerciser is 0.567 times as likely to have diabetes (42.3% lesser odds) than a non-exerciser, controlling for BMI and SEX. */
      
  /* b.	Run a logistic regression that estimates the following 2 models with the CLASS statement in 5(a) using PARAM=ref:  
       •	DIABETES = f(BMI, EXERCISE, SEX) 
       •	DIABETES = f(BMI, EXERCISE) */
      
proc logistic data=HW2; 
	class DIABETES (ref='0') EXERCISE (ref='0') SEX (ref='0') BMI (ref='1') / 
	param=ref; 
	model DIABETES = BMI EXERCISE SEX; 
run;

 proc logistic data=HW2; 
	class DIABETES (ref='0') EXERCISE (ref='0') BMI (ref='1') / 
	param=ref; 
	model DIABETES = BMI EXERCISE; 
run;      

    /* i. Show the MLEs output table for each estimated model.
    
       ii. Based on the estimated models’ AIC, which model is “better”?  Explain. Support your answer with the relevant statistical 
       output tables.
       
       The model for DIABETES = f(BMI, EXERCISE, SEX) is better with an AIC of 296,332.02, which is less than the AIC of 296,432.15 
       for the model for DIABETES = f(BMI, EXERCISE).
       
       iii.	Produce a single chart which shows the ROC for each model. */
      
proc logistic data=HW2 descending; 
	model DIABETES = BMI EXERCISE SEX;
	roc 'omit SEX' BMI EXERCISE ;
run;

    /* iv. Based only on the overlaid plot of the two model’s ROC in part 5(b)(iii), which model is better? Explain, ignoring the 
           shown AUC statistics in your answer.
           
       Both ROC curves for the models almost match up perfectly with the slight exception of DIABETES = f(BMI, EXERCISE, SEX), which is 
       better, due to a divergence beginning at approximately 0.70 Specificity and 0.90 Sensitivity to probably 0.99 Specificity and 
       Sensitivity.  This provides it slightly more area under the curve than the DIABETES = f(BMI, EXERCISE) model. */
	  
  /* c. For the estimated model (with the CLASS statement used in part 5(a) DIABETES = f (BMI, EXERCISE, SEX), consider the deviance 
        chi-squared test: */
       
proc logistic data=HW2 descending;
    class DIABETES (ref='0') EXERCISE (ref='0') SEX (ref='0') BMI (ref='1') / 
	param=ref;  
	model DIABETES = BMI EXERCISE SEX / aggregate scale=none lackfit; 
run;
        
    /* i. What question is the test attempting to answer? 
    
       The goodness of fit (GOF) deviance chi-squared test evaluates whether or not an unsaturated model is fitting better than a
       saturated model.

       ii. What is the null hypothesis H0 of the test?
       
       The null hypothesis H0 is that the current unsaturated model is fitting better than a saturated model.
       
       iii.	What does the test statistic show in this case and what should we do? Support your answer with the relevant SAS output 
       table from the above estimated regression.
       
       The p-value for deviance is <0.0001 indicating that the H0 of the current unsaturated model fitting better than a saturated 
       model can be rejected. So, we should investigate an interaction. */
      
  /* d. For the estimated model (with the CLASS statement used in part 5(a)) DIABETES = f (BMI, EXERCISE, SEX): */

proc logistic data=HW2 descending;
    class DIABETES (ref='0') EXERCISE (ref='0') SEX (ref='0') BMI (ref='1') / 
	param=ref;
	model DIABETES = BMI EXERCISE SEX / aggregate scale=none lackfit rsq;
	output out = probs predicted=PHAT;
run;

proc univariate data=probs; var PHAT; 
	histogram PHAT / normal; 
run;
  
    /* i. Create a cross-tabulation table showing predicted vs actual values for DIABETES using a cutoff value of probability 
       (DIABETES) >= 0.20. */
 
data probs; set probs;
	PRED_CLASS = 0;
	if PHAT >= .20 then PRED_CLASS = 1;  
run; 

proc sort data=probs; by descending DIABETES descending PRED_CLASS; run;

proc freq data=probs order=data;
	tables PRED_CLASS*DIABETES / norow nocol nopercent;
run;

    /* ii. Show your hand calculation for the associated sensitivity and specificity values for a cutoff value of >= 0.20.
    
       Sensitivity p(prediction = yes|actual = yes) = 19,556 / 53,650 = 0.365 = 36.5%
       Specificity p(prediction = no|actual = no) = 305,191 / 360,098 = 0.8475 = 84.75%
       
       iii. If the model is to be used to predict diabetes and the goal is to minimize false negatives (predicting no diabetes 
            when diabetes is present), then which is more important: sensitivity or specificity?  Explain.
            
       Sensitivity would be more important, given a higher percentage would serve to minimize false negatives.
       
       iv. Based on your answer to 5(d)(iii), to classify DIABETES (yes/no) based on the predicted probabilities, should a higher 
           or lower cut-off value be used? Explain.
           
           A lower cut-off value should be potentially used, given that reducing the cutoff value increases sensitivity and reduces 
           specificity.
           
  /* e.	Compare the unadjusted OR calculated in Question 3 and the adjusted OR from the estimated regression in part 5(a) above:
  
  	   i. Fill in the table below with these odds ratios.
  	   
  	   ii. In what sense are the ORs obtained from the logistic regression “adjusted”?  Does this account for the differences 
  	       between the unadjusted and adjusted ORs?  Explain.
  	       
  	       Odds ratios (ORs) from logistic regression account for the presence of covariates.  Yes, the odds ratios (ORS) were 
  	       calculated individually from contigency table 2 for each variable without the influence of the other covariates. */
  	      
/* 6) (12 pts) Create your “Table 3” for this objective using your regression results from Question 5(a) above.  
  	       
/* 7) (21 pts) Write the Table 3 results section/interpretation. Use the “boilerplate” language shown in Case Study Example – 
      Tables 1, 2 & 3.ppt exactly. 
           
Adjusted odds ratios from the logistic regression are presented in Table 3. Those who reported exercising had roughly half the odds 
(43.3% lower) of reporting diabetes when compared to those not exercising after controlling for BMI and sex (OR=0.567; 95% CI = 0.556-0.578). 
Females were at slightly lower odds (9.4% lower) of reporting diabetes when compared to males after controlling for BMI and exercise 
(OR=0.906; 95% CI = 0.889-0.923). With respect to the exposure variable BMI, those who were obese had substantially greater odds 
(4.9 times or 393.2% higher) of reporting diabetes as compared to those who were normal after controlling for sex and exercise 
(OR=4.932; 95% CI = 4.804-5.063). Those who were overweight had higher odds (2.1 times or 108.5% higher) of reporting diabetes as compared 
with those who were normal after controlling for sex and exercise (OR=2.085; 95% CI = 2.028-2.143). */

/* Extra Credit (10 pts)
Returning to our base logistic regression model for Table 3, DIABETES = f(BMI, EXERCISE, SEX), rerun the model using a CLASS statement 
which specifies these reference categories: DIABETES = 0; EXERCISE = 0; SEX = 0; BMI = 1. Also use PARAM = ref. */

proc logistic data=HW2 descending;
	class DIABETES (ref='0') EXERCISE (ref='0') SEX (ref='0') BMI (ref='1') / 
	param=ref;   
	model DIABETES = BMI EXERCISE SEX / aggregate scale=none lackfit; 
run;

proc logistic data=HW2; 
	class DIABETES (ref='0') EXERCISE (ref='0') SEX (ref='0') BMI (ref='1') / 
	param=ref; 
	model DIABETES = BMI EXERCISE SEX BMI*EXERCISE BMI*SEX EXERCISE*SEX BMI*EXERCISE*SEX /
	aggregate scale=none lackfit;
run;

   /* 1. Show your hand calculation for the Deviance statistic for this model. Show the relevant SAS output tables you need for this 
         calculation. Interpret your calculated value.

   -2 Log L for the DIABETES = f(BMI, EXERCISE, SEX) current model = 296,322.02
   -2 Log L for the DIABETES = f(BMI, EXERCISE, SEX, BMI*EXERCISE, BMI*SEX, EXERCISE*SEX, BMI*EXERCISE*SEX) saturated model = 296,018.04
   
   The deviance statistic = 296,322.02 - 296,018.04 = 303.98
   
   /* 2. Show the MLE for the fully saturated model.
   
   /* 3. Show the deviance output table for the fully saturated model. Does the estimated deviance statistic make sense? Explain.
   
   Given that two interactions have p-values greater than the 0.05 alpha standard, the deviance statistic of zero makes sense, because
   all interaction Beta coefficients must be statistically different from 0 to generate a proper statistic.
   
   /* 4. Identify which interactions should be removed, if any.
   
   EXERCISE*BMI(BMI=2) and EXERCISE*BMI(BMI=3) should be removed.
   
   /* 5. Estimate the final model and show the MLE table. */
   
proc logistic data=HW2; 
	class DIABETES (ref='0') EXERCISE (ref='0') SEX (ref='0') BMI (ref='1') / 
	param=ref; 
	model DIABETES = BMI EXERCISE SEX BMI*SEX EXERCISE*SEX BMI*EXERCISE*SEX /
	aggregate scale=none lackfit;
run; 

   /* 6. Show the final model deviance output table. Explain what the deviance statistic now shows and whether it makes sense.
   
   The final model deviance statistic is 4.1961, and the p-value of 0.1227 that is greater that the 0.05 alpha standard indicates that 
   the H0 of the final model fitting better than a saturated model cannot be rejected. So, there is no further need to investigate an 
   interaction.
   
