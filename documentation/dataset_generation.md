# Dataset Generation

## Overview

This dataset was created to simulate a simplified version of an electronic medical record (EMR) system. The goal was not to make it perfectly realistic, but to make it realistic enough to support meaningful analysis around clinic operations, referrals, and provider performance.

Instead of using a single flat dataset, I structured the data into multiple related tables to better reflect how healthcare data is typically organized.

---

## Tables Included

- Patients
- Providers
- Departments
- Appointments
- Referrals
- Calendar
- Financial Assumptions
- Holidays

Each table represents a different part of the workflow in a clinical setting.

---

## How the Tables Connect

I tried to follow a basic relational structure:

- Patients are linked to appointments and referrals
- Providers are linked to appointments and also involved in referrals
- Departments group providers and appointments
- Referrals are generated from completed primary care visits
- The calendar table supports time-based analysis

The goal here was to avoid disconnected data and instead create something that behaves more like a real system.

---

## Data Generation Approach

I used Excel formulas to generate the dataset. Most of the logic combines:

- Randomization (to create variability)
- Conditional logic (to enforce realistic rules)
- Lookup functions (to maintain relationships between tables)

Some examples:

- Age is calculated from randomized generated date of birth instead of just assiging an age
- Insurance type is partially based on age (e.g., Medicare for older patients)
- Appointments are assigned to providers based on specialty and patient age
- Referrals only come from completed primary care visits to ensure the workflow follows a realistic clinical sequence.

I also added fallback logic in some places to prevent broken relationships when filters didn’t return results.

The following example shows how the Appointments table is structured:

![Appointments Table](../images/table_samples/appointments_table.png)

---

## Key Design Decisions

A few decisions I made while building this:

- **Appointments as the central table**
  Most analysis will come from appointments, so I treated this as the core dataset.

- **Referrals tied to real visits**
  Instead of generating referrals randomly, I linked them to completed visits to make the workflow more realistic.

- **Controlled randomness**
  I didn’t fully randomize everything. I tried to guide the randomness so the data still makes sense (for example, keeping a higher percentage of primary care visits).

- **Separate financial assumptions**
  Financial values are stored in a separate table so they can be reused and adjusted easily.

---

## Things That Were Tricky

Some parts took a few iterations to get right:

- Making sure registration dates made sense relative to age
- Fixing referral logic so it actually connects to completed visits
- Handling cases where provider filters returned no results
- Keeping all dates within a consistent time range (2022–2024)
- Avoiding circular references across sheets

---

## Limitations

This dataset is still a simplification of a real healthcare system.

- Some values are randomized and may not match real-world distributions exactly
- Financial data is approximate and not tied to real reimbursement models
- There are likely edge cases that wouldn’t exist in production data

---

## Why This Matters for the Project

Spending time on dataset design upfront makes the later steps (SQL, dashboards, analysis) much more meaningful.

Instead of just visualizing random data, this setup allows me to:

- Analyze patient flow across the system
- Measure operational issues like no-shows and referral delays
- Simulate financial impact (lost revenue, utilization)

---
---
---

## Initial Data Quality Review (Day 2)

After generating the dataset, I took a step back and did an initial validation pass to make sure everything behaves the way a real EMR dataset would.

### What I Checked

- Relationships between tables (patient_id, provider_id, department_id)
- Missing values in key fields
- Consistency in categorical variables (e.g., appointment outcomes, insurance types)
- Date ranges and formatting
- Numeric ranges (age, risk scores, costs, durations)

### Key Observations

- Some patient records are missing `preferred_contact_method`
- The `active_months` field in the PROVIDERS table is not standardized (mix of "All Year" and comma-separated values)
- A duplicate holiday entry (07/04/2024) was identified
- A small number of records extend into 2025, likely representing future scheduled activity
- Appointment data reflects realistic behavior (e.g., no-shows with missing check-in times, cancellations)

### Summary

Overall, the dataset is structurally sound and closely mirrors real-world healthcare data.

The issues identified here are either intentional or realistic and will be addressed during the SQL cleaning phase. Keeping them at this stage allows for a more complete and practical demonstration of data preparation and validation.

---
---
---

## Data Realism (Day 4)

- Appointment distributions reflect realistic patterns: same-day scheduling, multi-week lead times, cancellations, no-shows
- Risk scoring and referral SLA metrics mimic healthcare operational standards
- Metrics across departments and providers were validated to ensure realistic workloads and plausible KPI ranges
- Spot checks were applied to ensure values are consistent and internally logical

### Transition to Analytics

With the database and clean layers established, the dataset is now ready for analytical modeling. The focus shifts from data generation to transformation, aggregation, and insight generation using SQL.

---
---
---

## Data Processing (Day 5)

- Raw simulated EMR data was cleaned and normalized into relational tables: Patients, Providers, Appointments, Departments, Referrals.  
- SQL cleaning scripts were used to fix duplicates, correct patient counts, and categorize appointment outcomes (Completed, Canceled, No-Show).  
- Aggregated data was exported to CSV files for Power BI visualization.

## Data Validation

- Total Appointments = 3,001  
- Completed + Canceled + No-Show = 3,001  
- Total Referrals = 801, SLA Breaches = 464
- Patient Risk Totals = 1,001 

## Realism Notes

- Same-day appointment rate (~42%), which is higher than typical healthcare systems, which may represent urgent care or open-access scheduling in my model. 
- Patient risk segmentation only includes patients with appointments.  
- Metrics were cross-checked for internal consistency across SQL views and Power BI dashboards.

---
---
---

## Notes

All data in this project is synthetic and created for learning purposes only. No real PHI, patient data or provider data is used. 

For a more detailed breakdown of the column-level logic, formulas, and design decisions used to generate this dataset, see the <br> [Dataset Formulas Reference](dataset_formulas_reference.md).

