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

- Age is calculated from date of birth instead of randomly assigned
- Insurance type is partially based on age (e.g., Medicare for older patients)
- Appointments are assigned to providers based on specialty and patient age
- Referrals only come from completed primary care visits to ensure the workflow follows a realistic clinical sequence.

I also added fallback logic in some places to prevent broken relationships when filters didn’t return results.

The following example shows how the Appointments table is structured:

![Appointments Table](images/table_samples/appointments_table.png)

---

## Key Design Decisions

A few decisions I made while building this:

- **Appointments as the central table**
  Most analysis will come from appointments, so I treated this as the core dataset.

- **Referrals tied to real visits**
  Instead of generating referrals randomly, I linked them to completed visits to make the workflow more realistic.

- **Controlled randomness**
  I didn’t fully randomize everything — I tried to guide the randomness so the data still makes sense (for example, keeping a higher percentage of primary care visits).

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

## Notes

All data in this project is synthetic and created for learning purposes only. No real PHI, patient data or provider data is used. 

For a more detailed breakdown of the column-level logic, formulas, and design decisions used to generate this dataset, see the [Dataset Formulas Reference](documentation/dataset_formulas_reference.md).
