# Student Exam Performance: Multiple Linear Regression & Proportion Inference in SAS

**Course:** ASDS 5301 – Statistical Theory and Application  
**Author:** Tajwar Fahmid  
**Environment:** SAS OnDemand for Academics (SAS Studio)  
**Significance Level:** $\alpha = 0.01$ (conservative policy threshold)

---

## 📌 Project Overview
This study evaluates factors influencing academic performance among 200 students enrolled in an introductory statistics course. Using multiple linear regression, residual diagnostics, model reduction techniques, and binomial proportion tests, we assess whether weekly study hours and attendance percentages predict final exam outcomes, and whether an institutional claim regarding course pass rates holds up under statistical testing.

---

## 📊 Dataset Description
The dataset (`student.xlsx`) contains records for 200 students across the following variables:

| Variable | Type | Description |
| :--- | :--- | :--- |
| `ID` | Identifier | Unique student identifier |
| `Study_Hours` | Continuous | Average hours spent studying per week |
| `Class_Attendance` | Continuous | Percentage of class sessions attended ($0 - 100\%$) |
| `Final_Score` | Continuous | Final exam score ($0 - 100$) |
| `Pass` *(Derived)* | Binary | $1$ if $\text{Final\_Score} \ge 85$, otherwise $0$ |
| `Attendance_Group` *(Derived)* | Categorical | $\text{High } (\ge 85\%)$ vs. $\text{Low } (< 85\%)$ |

---

## 🔬 Methodology & Key Findings

### Part A: Exploratory Data Analysis (EDA)
- **Scatterplots & Bivariate Trends:**
  - `Final_Score` vs. `Study_Hours`: Displays a strong, positive linear association with observations tightly clustered along the trendline and no extreme outliers.
  - `Final_Score` vs. `Class_Attendance`: Displays a weak positive association characterized by substantial dispersion around the trendline.
- **Predictor Assessment:** Weekly study hours emerged as the primary driving predictor of final exam performance.

---

### Part B: Multiple Linear Regression (Full Model)

- **Model Equation:**
  $$\widehat{\text{Final\_Score}} = 49.4363 + 2.3203(\text{Study\_Hours}) + 0.1141(\text{Class\_Attendance})$$

- **Diagnostic Evaluation:**
  - **Linearity & Homoscedasticity:** Residual vs. Predicted plots display random, uniform scatter around zero without curvature or fanning.
  - **Normality:** Normal Q-Q plot tracks the 45-degree reference line closely.
  - **Influence/Leverage:** All Cook's Distance values remain below $0.07$, indicating no single point exerts distorting influence.

- **Hypothesis Testing ($\alpha = 0.01$):**
  - **`Study_Hours`:** $t = 14.53$, $p < 0.0001 \rightarrow$ **Statistically Significant**. Reject $H_0$. Each additional hour of study is associated with an average increase of $2.32$ points on the final exam.
  - **`Class_Attendance`:** $t = 2.28$, $p = 0.0238 \rightarrow$ **Statistically Insignificant** at $\alpha = 0.01$ ($0.0238 \ge 0.01$). Fail to reject $H_0$.

---

### Part C: Model Reduction & Parsimony
Removing the insignificant predictor (`Class_Attendance`) yields the reduced model:

$$\widehat{\text{Final\_Score}} = 59.3523 + 2.2964(\text{Study\_Hours})$$

- **Model Comparison:**
  - Full Model: $R^2 = 0.5192$, $\text{Adj } R^2 = 0.5143$, $\text{Root MSE} = 6.77$
  - Reduced Model: $R^2 = 0.5065$, $\text{Adj } R^2 = 0.5040$, $\text{Root MSE} = 6.85$
- **Conclusion:** Removing attendance decreases explained variance by only $1.27\%$. The reduced model is recommended to maintain parsimony and avoid unnecessary parameters without sacrificing predictive power.

---

### Part D: Proportion Inference (One-Sample $Z$-Test)
Testing the institutional claim that **at least 65%** of students pass ($\text{Final\_Score} \ge 85$):

$$H_0: p \ge 0.65 \quad \text{vs.} \quad H_a: p < 0.65$$

- Observed Sample Proportion: $\hat{p} = 118 / 200 = 0.59$ ($59.0\%$)
- Test Statistic: $Z = -1.7790$, One-sided $p\text{-value} = 0.0376$
- **Decision at $\alpha = 0.01$:** Fail to reject $H_0$ ($0.0376 \ge 0.01$). Insufficient evidence to dispute the university's claim at a strict 1% significance level.
- **Decision at $\alpha = 0.05$:** Reject $H_0$ ($0.0376 < 0.05$). Statistically significant evidence that the true pass rate is below 65% at the 5% level.

---

### Bonus: Attendance Categorization & Chi-Square Analysis
- **High Attendance ($\ge 85\%$):** Pass rate = $61.29\%$ ($57 / 93$)
- **Low Attendance ($< 85\%$):** Pass rate = $57.01\%$ ($61 / 107$)
- **Association Test:** Pearson $\chi^2 = 0.3770$, $p = 0.5392$. No statistically significant difference in pass rates between attendance tiers, mirroring the regression findings.

---

## 📁 Repository Structure
```text
├── README.md                            # Project documentation and summary
├── student (1).xlsx                     # Dataset (200 observations)
├── project4_analysis.sas                # Complete SAS analysis script
└── ASDS5301_Project4_Report.pdf         # Final report with interpretations and figures
