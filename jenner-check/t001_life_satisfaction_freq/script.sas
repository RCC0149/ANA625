/* Extra Credit: survey of US adults on "life satisfaction" by income.
   Is there an association between "life satisfaction" and income? */

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

/* Run the Chi-Square & Fisher Test of Independence. */

proc freq data=life_satisfaction;
	weight Count;
	tables INCOME*Satisfaction / norow nocol chisq exact relrisk
	plots=mosaicplot cmh;
run;
