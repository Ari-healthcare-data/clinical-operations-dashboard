# Dataset Generation — Clinical Operations Dashboard

## Overview

All datasets used in this project are synthetic, created to simulate realistic healthcare EMR operations.
No real patient or provider information is included.

This documentation summarizes the logic and formulas used to generate each table: Patients, Providers, Departments, Appointments, Referrals, Financial_Assumptions, and Calendar.

---

## PATIENTS Table

**Column**: patient_id

**Formula/Method**: `=ROW()-1`

**Purpose**: Unique identifier for each patient for reliable joins.
<br><br>

**Column**: first_name

**Formula/Method**: Manually entered gender neutral names

**Purpose**: Realistic patient first names for readability.
<br><br>

**Column**: last_name

**Formula/Method**: Manually entered random last names

**Purpose**: Realistic patient surnames.
<br><br>

**Column**: date_of_birth

**Formula/Method**: `=DATE(RANDBETWEEN(1930,2022),RANDBETWEEN(1,12),RANDBETWEEN(1,28))`

**Purpose**: Random DOB for realistic age distribution (ages 1–94).
<br><br>

**Column**: gender

**Formula/Method**: `=LET(r,RAND(),IF(r<0.53,"Female",IF(r<0.995,"Male","Other")))`

**Purpose**: Simulates realistic gender distribution.
<br><br>

**Column**: zip_code

**Formula/Method**: `=TEXT(RANDBETWEEN(48000,48999),"00000")`

**Purpose**: Generates ZIP codes in a regional range (Michigan).
<br><br>

**Column**: insurance_type

**Formula/Method**: Age-based logic

**Purpose**: Assigns insurance (Medicare, Medicaid, Commercial, Self-Pay) realistically.
<br><br>

**Column**: age

**Formula/Method**: Calculated from DOB

**Purpose**: Supports eligibility rules and demographic analysis.
<br><br>

**Column**: date_standard

**Formula/Method**: `=TEXT(D2,"yyyy-mm-dd")`

**Purpose**: Standardizes dates for downstream SQL ingestion.
<br><br>

**Column**: check_pt_has_appt

**Formula/Method**: `=IF(COUNTIF(Appointments!$B$2:$B$1002,A2)=0,"No Appointment","OK")`

**Purpose**: Validates patients linked to appointments.
<br><br>

**Column**: check_pt_has_referral

**Formula/Method**: `=IF(COUNTIF(Referrals!$B$2:$B$305,A2)=0,"No Referral","OK")`

**Purpose**: Validates patients linked to referrals.
<br><br>

---

## PROVIDERS Table

**Column**: provider_id

**Formula/Method**: `=ROW()-1`

**Purpose**: Primary key for linking appointments and referrals.
<br><br>

**Column**: first_name

**Formula/Method**: Manually entered gender neutral names

**Purpose**: Realistic provider first names for readability.
<br><br>

**Column:** last_name

**Formula/Method**: Manually entered random last names

**Purpose**: Realistic provider surnames.
<br><br>

**Column**: provider_name

**Formula/Method**: `=B2 & ", " & C2`

**Purpose**: Full name for reporting & dashboards.
<br><br>

**Column**: specialty

**Formula/Method**: Manual

**Purpose**: Determines department, referral routing, appointment types.
<br><br>

**Column**: clinic_location

**Formula/Method**: `=CHOOSE(RANDBETWEEN(1,5),...)`

**Purpose**: Randomized clinic site for geographic analysis.
<br><br>

**Column**: fte_status

**Formula/Method**: `=IF(RAND()>0.25,"Full-Time","Part-Time")`

**Purpose**: Simulates provider capacity.
<br><br>

**Column**: department_id

Formula/Method: `XLOOKUP` from specialty

**Purpose**: Enables normalized relational structure.
<br><br>

**Column**: annual_capacity

**Formula/Method**: Calculated from FTE & slots

**Purpose**: Supports utilization and productivity analysis.

**Note**: Additional columns define availability patterns, age eligibility, appointment capacity, and FTE values to simulate realistic operational variability.
<br><br>

---


## DEPARTMENTS Table

**Column**: department_id

**Formula/Method**: `=ROW()-1`

**Purpose**: Numeric ID for relational joins.
<br><br>

**Column**: department_name

**Formula/Method**: Manual (Primary Care, Cardiology, Orthopedics, Dermatology, Neurology)

**Purpose**: Department names corresponding to each ID.
<br><br>

**Column**: default_reimbursement

**Formula/Method**: `XLOOKUP` from Financial_Assumptions

**Purpose**: Supports revenue modeling and KPI calculations.
<br><br>

---

## APPOINTMENTS Table

**Column**: appointment_id

**Formula/Method**: `=ROW()-1`

**Purpose**: Primary key for each appointment encounter.
<br><br>

**Column**: patient_id

**Formula/Method**: Random from Patients

**Purpose**: Assigns patients to visits realistically.
<br><br>

**Column**: provider_id

**Formula/Method**: Conditional based on specialty & age

**Purpose**: Ensures patient-provider eligibility.
<br><br>

**Column**: appointment_date

**Formula/Method**: Random within 2023–2024

**Purpose**: Models realistic visit dates; follow-ups scheduled days/weeks after prior visits.
<br><br>

**Column**: appointment_type

**Formula/Method**: First visit `= "New Patient", else mostly "Follow-up"`

**Purpose**: Differentiates visit types.
<br><br>

**Column**: appointment_outcome

**Formula/Method**: `=LET(r,RAND(),IF(r<0.12,"No-Show",IF(r<0.17,"Cancelled","Completed")))`

**Purpose**: Simulates real-world outcomes.
<br><br>

**Column**: visit_reason

**Formula/Method**: Based on appointment type

**Purpose**: Assigns plausible clinical reasons.
<br><br>

**Column**: department_name

**Formula/Method**: `XLOOKUP` from provider

**Purpose**: Maintains provider-department consistency.
<br><br>

**Column**: patient_age

**Formula/Method**: `XLOOKUP` from Patients

**Purpose**: Supports age-based reporting and specialty eligibility.
<br><br>

**Column**: appointment_month / year_month

**Formula/Method**: Derived from date

**Purpose**: Enables time-series aggregation for Power BI visuals.
<br><br>

---

## REFERRALS Table

**Column**: referral_id

**Formula/Method**: `=ROW()-1`

**Purpose**: Unique referral identifier.
<br><br>

**Column**: patient_id

**Formula/Method**: Random completed primary care patients

**Purpose**: Models realistic referral generation.
<br><br>

**Column**: referring_provider_id

**Formula/Method**: Lookup from patient appointment

**Purpose**: Identifies referring PCP.
<br><br>

**Column**: referred_to_provider_id

**Formula/Method**: Random eligible specialist

**Purpose**: Prevents self-referrals; enforces specialty match.
<br><br>

**Column**: referral_order_date

**Formula/Method**: Appointment completion date

**Purpose**: Models referral timing.
<br><br>

**Column**: referral_reason

**Formula/Method**: Random clinical reason

**Purpose**: Simulates realistic referral purpose.
<br><br>

**Column**: referral_priority

**Formula/Method**: `=IF(RAND()<0.7,"Routine",IF(RAND()<0.95,"Urgent","STAT"))`

**Purpose**: Assigns urgency level probabilistically.
<br><br>

**Column**: referral_scheduled

**Formula/Method**: Referral date + random days

**Purpose**: Models actual scheduling delays.
<br><br>

**Column**: referral_outcome

**Formula/Method**: Randomized Completed In/Out-of-Network or Not Scheduled

**Purpose**: Simulates patient behavior and network adherence.
<br><br>

**Column**: completed_in_network / out_of_network / not_scheduled

**Formula/Method**: Binary flags

**Purpose**: Enable KPI calculations for referral performance.
<br><br>

**Column**: expected_revenue / lost_revenue

**Formula/Method**: Lookup from Financial_Assumptions

**Purpose**: Supports revenue analysis and leakage calculations.
<br><br>

---

## FINANCIAL_ASSUMPTIONS Table

**Column**: specialty

**Value/Method**: Manual

**Purpose**: List of specialties used in revenue modeling.
<br><br>

**Column**: reimbursement_per_visit

**Value/Method**: Manual

**Purpose**: Average revenue per visit by specialty.
<br><br>

**Column**: avg_cost_per_slot

**Value/Method**: Manual

**Purpose**: Estimated operational cost for cost vs. revenue analysis.
<br><br>

## CALENDAR Table

**Column**: date

**Formula/Method**: Manual

**Purpose**: Base date for analysis (2023–2024).
<br><br>

**Column**: year

**Formula/Method**: `=YEAR(A2)`

**Purpose**: Enables annual reporting.
<br><br>

**Column**: month

**Formula/Method**: `=TEXT(A2,"mmm")`

**Purpose**: Month-level aggregation & visuals.
<br><br>

**Column**: quarter

**Formula/Method**: `="Q"&ROUNDUP(MONTH(A2)/3,0)`

**Purpose**: Fiscal/quarterly KPIs.
<br><br>

**Column:** weekday

**Formula/Method**: `=TEXT(A2,"dddd")`

**Purpose**: Supports day-of-week pattern analysis.
<br><br>

## Notes & Best Practices

* The dataset is fully synthetic, designed for realistic operational insights.
* All randomization ensures reproducibility using formulas, but no real PHI is included.
* This documentation enables reproduction of the dataset or extension for additional analytics.


