/*****************************************************************************
 * ASDS 5301 - Statistical Theory and Application
 * Project 4: Multiple Linear Regression and Proportion Inference
 * Significance Level: alpha = 0.01 (unless noted otherwise)
 *****************************************************************************/

/* Step 0: Import the Excel Dataset */
%web_drop_table(WORK.IMPORT);

FILENAME REFFILE '/home/u63988430/student (1).xlsx';

PROC IMPORT DATAFILE=REFFILE
    DBMS=XLSX
    OUT=WORK.IMPORT
    REPLACE;
    GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; 
RUN;

%web_open_table(WORK.IMPORT);


/* Step 1: Data Preparation for Parts D & Bonus */
DATA WORK.student_analysis;
    SET WORK.IMPORT;
        /* Part D variable */
    IF Final_Score >= 85 THEN Pass = 1;
    ELSE IF Final_Score < 85 AND NOT MISSING(Final_Score) THEN Pass = 0;

    /* Bonus variable */
    IF Class_Attendance >= 85 THEN Attendance_Group = 'High (>=85%)';
    ELSE IF Class_Attendance < 85 AND NOT MISSING(Class_Attendance) THEN Attendance_Group = 'Low (<85%)';
RUN;

    /* Part D: Binary indicator for passing (Final_Score >= 85) */
    IF Final_Score >= 85 THEN Pass = 1;
    ELSE IF Final_Score < 85 AND NOT MISSING(Final_Score) THEN Pass = 0;

    /* Bonus Part 3: Attendance Groups */
    IF Class_Attendance >= 85 THEN Attendance_Group = 'High (>=85%)';
    ELSE IF Class_Attendance < 85 AND NOT MISSING(Class_Attendance) THEN Attendance_Group = 'Low (<85%)';
RUN;


/* -------------------------------------------------------------------------
   PART A: Exploratory Data Analysis
   ------------------------------------------------------------------------- */

/* A1: Summary Statistics for all continuous variables */
TITLE "Part A1: Descriptive Summary Statistics";
PROC UNIVARIATE DATA=WORK.student_analysis;
    VAR Final_Score Study_Hours Class_Attendance;
RUN;
TITLE;

/* A3: Scatterplots with Regression and Loess Smoothers */
ODS GRAPHICS ON;

TITLE "Part A3: Scatterplot of Final Score vs. Study Hours";
PROC SGPLOT DATA=WORK.student_analysis;
    SCATTER X=Study_Hours Y=Final_Score / 
        MARKERATTRS=(COLOR=cx1F497D SYMBOL=circlefilled SIZE=7);
    REG X=Study_Hours Y=Final_Score / 
        LINEATTRS=(COLOR=cxC00000 THICKNESS=2);
    LOESS X=Study_Hours Y=Final_Score / 
        LINEATTRS=(COLOR=cx385723 THICKNESS=2 PATTERN=dash);
    XAXIS LABEL="Average Weekly Study Hours" GRID;
    YAXIS LABEL="Final Exam Score" GRID;
RUN;

TITLE "Part A3: Scatterplot of Final Score vs. Class Attendance";
PROC SGPLOT DATA=WORK.student_analysis;
    SCATTER X=Class_Attendance Y=Final_Score / 
        MARKERATTRS=(COLOR=cx1F497D SYMBOL=circlefilled SIZE=7);
    REG X=Class_Attendance Y=Final_Score / 
        LINEATTRS=(COLOR=cxC00000 THICKNESS=2);
    LOESS X=Class_Attendance Y=Final_Score / 
        LINEATTRS=(COLOR=cx385723 THICKNESS=2 PATTERN=dash);
    XAXIS LABEL="Class Attendance Percentage (%)" GRID;
    YAXIS LABEL="Final Exam Score" GRID;
RUN;
TITLE;


/* -------------------------------------------------------------------------
   PART B: Multiple Linear Regression (Full Model)
   ------------------------------------------------------------------------- */

TITLE "Part B: Full Multiple Linear Regression Model & Diagnostics";
PROC REG DATA=WORK.student_analysis 
    PLOTS(MAXPOINTS=NONE)=(DIAGNOSTICS RESIDUALS(SMOOTH) OBSERVEDBYPREDICTED);
    MODEL Final_Score = Study_Hours Class_Attendance / ALPHA=0.01 CLB VIF;
RUN;
QUIT;
TITLE;


/* -------------------------------------------------------------------------
   PART C: Model Reduction
   (Execute after checking Part B p-values at alpha = 0.01)
   ------------------------------------------------------------------------- */

/* Option 1: If Class_Attendance is insignificant */
TITLE "Part C: Reduced Model (Study_Hours Only)";
PROC REG DATA=WORK.student_analysis;
    MODEL Final_Score = Study_Hours / ALPHA=0.01;
RUN;
QUIT;
TITLE;

/* Option 2: If Study_Hours is insignificant */
/*
TITLE "Part C: Reduced Model (Class_Attendance Only)";
PROC REG DATA=WORK.student_analysis;
    MODEL Final_Score = Class_Attendance / ALPHA=0.01;
RUN;
QUIT;
TITLE;
*/


/* -------------------------------------------------------------------------
   PART D: Proportion Inference (One-Sample Proportion Test)
   University Claim: p >= 0.65
   ------------------------------------------------------------------------- */

/* At alpha = 0.01 */
TITLE "Part D: Proportion Inference Test (p0 = 0.65, Alpha = 0.01)";
PROC FREQ DATA=WORK.student_analysis;
    TABLES Pass / BINOMIAL(P=0.65 LEVEL='1') ALPHA=0.01;
RUN;

/* At alpha = 0.05 */
TITLE "Part D: Proportion Inference Test (p0 = 0.65, Alpha = 0.05)";
PROC FREQ DATA=WORK.student_analysis;
    TABLES Pass / BINOMIAL(P=0.65 LEVEL='1') ALPHA=0.05;
RUN;
TITLE;


/* -------------------------------------------------------------------------
   BONUS: Attendance Group Analysis
   ------------------------------------------------------------------------- */

TITLE "Bonus Part 3: Pass Rates by Attendance Group";
PROC FREQ DATA=WORK.student_analysis;
    TABLES Attendance_Group * Pass / CHISQ RELRISK NOROW NOCOL;
RUN;
TITLE;
