options obs=100;   /* cap input rows for the captured run */

/* The upstream scripts read Data_625.cdbrfs10 from a SAS Studio course
   library that isn't part of this repo. This autoexec builds a small mock
   cdbrfs10 with the same raw BRFSS columns the analysis reads, so the
   author's restriction, recode, and modeling logic runs unmodified below. */
data Data_625_cdbrfs10;
    input AGE SEX DIABETE2 EXERANY2 EDUCA _BMI4CAT GENHLTH;
    datalines;
34 1 1 1 4 2 2
52 2 3 1 5 1 1
61 1 1 2 3 3 4
45 2 3 1 6 2 3
29 1 3 2 2 1 2
70 2 1 1 4 3 5
38 1 3 1 5 2 2
55 2 1 2 3 3 4
41 1 3 1 4 1 1
63 2 1 1 2 3 5
47 1 3 2 6 2 3
33 2 3 1 5 1 2
58 1 1 1 3 3 4
26 2 3 2 4 1 1
49 1 1 1 5 2 3
67 2 3 1 2 2 4
31 1 3 2 6 1 2
54 2 1 1 3 3 5
43 1 3 1 4 2 3
60 2 1 2 5 3 4
;
run;
