# Clinical Operations Dashboard

## Overview

This project is a healthcare analytics case study I built using a synthetic EMR-style dataset to simulate how clinical operations teams use data to identify gaps in patient access, provider utilization, and referral workflows, and turn those insights into actionable decisions.

I designed this project to mirror the type of work done in clinical operations and healthcare analytics teams, especially in environments that use EMR systems like Epic's MiChart.

This dataset is fully synthetic and created for learning purposes only. It does not contain any real patient data or provider data. Please see [Dataset Generation](documentation/dataset_generation.md) for more details on how the dataset was created.

---

## Why I Built This

I’m transitioning into a healthcare data/analyst role, and I wanted a project that reflects real-world workflows instead of just isolated datasets.

Instead of using a simple dataset, I built a multi-table system (patients, providers, appointments, referrals, etc.) to better understand:

- How clinical data is structured
- How different parts of the system connect
- How operational issues (like no-shows or referral leakage) show up in the data

---

## Project Focus

The main question behind this project is:

> How can clinic operations be improved using EMR data?

Some of the areas I plan to analyze:

- No-show rates and scheduling patterns
- Provider utilization and workload
- Referral completion and leakage
- Operational bottlenecks in access to care

---

## Business Value

This project is designed to support common clinical operations decisions, such as:

- Identifying departments with high no-show rates
- Understanding provider capacity and utilization gaps
- Reducing referral leakage and improving care coordination
- Highlighting scheduling inefficiencies impacting patient access

---

## Dataset Overview

Tables included:

- Patients (demographics, risk, insurance)
- Providers (specialty, capacity, availability)
- Departments (clinic structure)
- Appointments (core operational data)
- Referrals (care transitions + revenue impact)
- Calendar (time-based analysis)
- Financial Assumptions (cost + revenue modeling)

The dataset includes:

- ~1,000 patients
- ~3,000 appointments
- ~800 referrals

## Dataset Overview

Below is an example of the Patients table used in this project:

![Patients Table](images/table_samples/patients_table.png)

This table contains simulated demographic and insurance information used for patient segmentation and analysis.

---

## Core Tables

### Appointments Table

![Appointments Table](images/table_samples/appointments_table.png)

The appointments table serves as the central fact table, capturing patient encounters, provider assignments, and visit outcomes such as completed visits and no-shows.

### Referrals Table

![Referrals Table](images/table_samples/referrals_table.png)

The referrals table connects completed appointments to specialty care providers, enabling analysis of referral flow and care transitions.

---

---

## Tools Used

- Excel for data generation
- PostgreSQL (pgAdmin) for data cleaning and transformation
- Power BI for dashboard development
- GitHub for version control and documentation

---

## Project Structure

```
Clinical-Operations-Dashboard/
  - data/
  - sql/
  - powerbi/
  - documentation/
  - images/
  - README.md
```

---

## Next Steps

- Export all tables into CSV files
- Load data into PostgreSQL
- Create cleaned tables and KPI views
- Build Power BI dashboard (multi-page)
- Summarize insights and recommendations

---

## Notes

All data used in this project is synthetic and created for learning and portfolio purposes only. No real PHI, patient data or provider data. Please see [Dataset Generation](documentation/dataset_generation.md) for more details on how the dataset was created.
