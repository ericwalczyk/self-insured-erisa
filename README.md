# Self Insured Employer Health Plans, ERISA Preemption, and Benefit Generosity

This repo contains a descriptive, data driven project on how self insured employer health plans differ from fully insured plans in the United States, and what that means for the real world reach of state benefit mandates.

The project focuses on what can be done with publicly available data. It is not trying to claim causal effects of ERISA preemption or the Affordable Care Act. Instead, it maps the landscape in a careful way and asks a simple but under answered question:

> How much of the employer sponsored market is actually affected by state benefit mandates, and how do spending and benefit generosity differ between self insured and fully insured plans?

---

## Research questions

The project is organized around three concrete questions:

1. **Market structure and coverage**
   - What share of workers with employer sponsored insurance are enrolled in self insured plans versus fully insured plans?
   - How does that share vary by firm size, industry, income, and state?

2. **Spending, out of pocket burden, and simple utilization**
   - Among people with employer coverage, do individuals in self insured plans have different:
     - Total health care spending
     - Out of pocket spending
     - Use of broad service categories such as inpatient, outpatient, and prescription drugs
   - How much of these differences remain after adjusting for observable characteristics such as age, income, health status, and region?

3. **Exposure to state benefit mandates**
   - State benefit mandates for services like mental health treatment, fertility services, or autism therapies generally apply to fully insured products.
   - Self insured ERISA plans are not regulated by state insurance law in the same way.
   - For a given state and mandate, what share of workers with employer coverage are plausibly:
     - Directly exposed to that mandate because they are in fully insured plans, versus
     - Enrolled in self insured plans that sit outside the state mandate

The goal is not to resolve every theoretical issue around ERISA preemption. The goal is to make the structure of the market visible in a way that links together coverage, spending, and mandate exposure.

---

## Data sources

This project only uses publicly available data. The main sources are:

1. **Medical Expenditure Panel Survey (MEPS) – Household Component and Insurance Component**
   - Nationally representative survey of health care use, spending, insurance coverage, and demographics.
   - Key variables:
     - Employer sponsored coverage
     - Whether the plan is self insured
     - Total and out of pocket spending
     - Use of major service categories
     - Demographic and health status controls
   - Used for individual level comparisons of spending and utilization between self insured and fully insured enrollees.

2. **State benefit mandate data**
   - Hand constructed dataset based on public trackers (for example NCSL, KFF, state statutes).
   - For each state and year, codes whether specific benefit mandates are in place, such as:
     - Mental health parity or specific MH/SUD benefits
     - Infertility treatment coverage
     - Autism therapy coverage
     - Selected other high profile mandates
   - Used to approximate whether an individual with employer coverage lives in a state where some mandated benefits exist.

3. **KFF Employer Health Benefits Survey (summary tables)**
   - Public summary tables on:
     - Prevalence of self insured plans by firm size and industry
     - Average premiums and cost sharing
     - Coverage of selected services
   - Used for cross checks and descriptive figures, not micro level modeling.

4. **CPS ASEC (optional)**
   - The Current Population Survey Annual Social and Economic Supplement.
   - Used for additional state level context on:
     - Employer coverage rates
     - Income distribution
     - Population denominators

No proprietary claims data are used. That is intentional. The project is designed to be fully replicable by anyone with access to standard public data.

---

## Methods overview

The empirical work is primarily descriptive, with some simple regression based adjustments.

1. **Descriptive comparisons of self insured vs fully insured**
   - Using MEPS, classify individuals with employer sponsored insurance into self insured vs fully insured groups.
   - Compare distributions of:
     - Total spending
     - Out of pocket spending
     - Utilization of broad service categories
   - Stratify by firm size, income, and state where possible.

2. **Regression adjusted differences**
   - Run simple models of the form:

     ```text
     outcome = alpha + beta * self_insured
                    + gamma' * X
                    + epsilon
     ```

     where `X` includes age, sex, income, self reported health, and region.

   - The coefficient `beta` is interpreted as an adjusted difference in means, not a causal effect of self insurance.

3. **Mandate exposure mapping**
   - Build a state by year dataset of selected benefit mandates.
   - Link individuals in MEPS to their state and year.
   - For each mandate, calculate the share of workers with employer coverage who are:
     - In a state with that mandate in place, and
     - In a fully insured versus self insured plan.
   - This gives a simple measure of how much of the employer market is actually touched by state mandates.

4. **Sensitivity and robustness**
   - Alternative definitions of self insured where MEPS offers more than one indicator.
   - Alternative outcome measures such as high out of pocket burden flags.
   - Simple checks that results are not driven solely by one region or firm size category.

The project does not attempt formal causal identification. Where appropriate, the documentation explains what would be required to move from descriptive to causal analysis, for example the need for claims data and a convincing source of quasi experimental variation.

---

## Repo structure

The repo is organized as follows:

```text
self-insured-erisa/
│
├── README.md
├── LICENSE
├── .gitignore
├── self-insured-erisa.Rproj
│
├── data/
│   ├── raw/
│   │   ├── meps/
│   │   ├── cps_asec/
│   │   ├── kff_employer/
│   │   └── state_mandates/
│   ├── intermediate/
│   └── final/
│
├── code/
│   ├── 00_setup.R
│   ├── 01_meps_clean.R
│   ├── 02_state_mandates_build.R
│   ├── 03_merge_analysis_data.R
│   ├── 04_descriptive_analysis.R
│   ├── 05_visualizations.R
│   ├── 06_sensitivity_checks.R
│   └── utils/
│       ├── helpers.R
│       └── labels.R
│
├── analysis/
│   ├── tables/
│   ├── figures/
│   ├── memo/
│   │   └── self_insured_memo.md
│   └── paper/
│       ├── self_insured_paper.Rmd
│       └── refs.bib
│
└── docs/
    └── index.md
