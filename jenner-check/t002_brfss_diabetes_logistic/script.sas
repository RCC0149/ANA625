/* ANA 625 Homework 2 - Categorical Data Analysis of BRFSS diabetes data.
   Restriction, recode, contingency table, and logistic regression of
   DIABETES = f(BMI, SEX, EXERCISE). Data source is the mock cdbrfs10 built
   in autoexec; all restriction/recode/modeling statements are the author's. */

/* 5. Restrict the sample to the complete-case conditions. */
data HW2; set Data_625_cdbrfs10;
where (18<=AGE<=99) and SEX in(1,2) and DIABETE2 in(1,3) and EXERANY2 in(1,2) and (1<=EDUCA<=6) and _BMI4CAT in(1,2,3) and (1<=GENHLTH<=5);

/* Check restricted sample for missing values. */
proc means data=HW2 n nmiss;
	var AGE SEX DIABETE2 EXERANY2 EDUCA _BMI4CAT GENHLTH;
run;

/* 1. Use the raw variable _BMI4CAT and call it BMI */
data HW2; set HW2(rename=(_BMI4CAT=BMI));

/* 2. Recode SEX (male=0, female=1). */
array RECODE SEX;
do over RECODE;
if RECODE = 2 then RECODE = 1;
else if RECODE = 1 then RECODE = 0;
end;

/* 3. Recode DIABETES (no=0, yes=1). */
if DIABETE2=1 then DIABETES = 1;
if DIABETE2=3 then DIABETES = 0;

/* 4. Recode EXERCISE (no=0, yes=1). */
if EXERANY2=1 then EXERCISE = 1;
if EXERANY2=2 then EXERCISE = 0;
run;

/* Check modified sample for missing values. */
proc means data=HW2 n nmiss;
	var BMI SEX DIABETES EXERCISE;
run;

/* 1) Create "Table 2": control variables by the outcome DIABETES. */
proc freq data=HW2;
    tables (BMI SEX EXERCISE)*DIABETES / norow chisq;
run;

/* 3) Odds ratios for DIABETES from the logistic model. */
proc logistic data=HW2;
    class DIABETES (ref='0') BMI (ref='1') SEX (ref='0') EXERCISE (ref='0') /
    param=ref;
    model DIABETES = BMI SEX EXERCISE;
run;
