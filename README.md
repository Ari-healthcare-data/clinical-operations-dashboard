# Clinical Operations Dashboard

## Overview

This project is a healthcare analytics case study I built using a synthetic EMR-style dataset to simulate how clinical operations teams use data to identify gaps in patient access, provider utilization, and referral workflows, and turn those insights into actionable decisions.

I designed this project to mirror the type of work done in clinical operations and healthcare analytics teams, especially in environments that use EMR systems like Epic's MiChart.

This dataset is fully synthetic and created for learning purposes only. It does not contain any real patient data or provider data. Please see [Dataset Generation](documentation/dataset_generation.md) for more details on how the dataset was created.

---

## Project Status

On Day 4, I focused on building the analytical layer of the project by validating, cleaning, and transforming the data into dashboard-ready views.

- Developed a comprehensive data validation script to check row counts, primary key uniqueness, null values, and referential integrity across all tables.
Performed data quality checks to identify unrealistic or inconsistent values and reviewed distributions for key fields.
- Created cleaned views for each core table to standardize fields, handle missing values, and convert flags into analysis-friendly formats.
- Built analytics views to support key business insights, including provider workload, referral SLA performance, patient risk segmentation, appointment lead time, and department-level summaries.
- Structured the workflow into separate SQL files (validation, cleaning, analytics) to mirror a modern analytics pipeline approach.

The dataset is now fully validated, standardized, and transformed into business-ready views that can directly support dashboard development.

Next:

KPI layer and dashboard development (Power BI)

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

## Data Quality Note

This dataset intentionally includes a few common real-world data challenges, such as:
- Missing values (e.g., patient contact preferences)
- Inconsistent formatting (e.g., provider availability fields)
- Duplicate records (e.g., holiday entries)

These were not treated as mistakes, but as part of the design. In real healthcare data environments, datasets are rarely perfect, and handling these issues is a key part of the analysis process.

They will be cleaned and standardized in later phases using SQL.

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

## Data Transformation Layers

This project follows a multi-layer data architecture:

### 1. Raw Layer
- Original dataset stored in Excel format
- Exported into CSV files for database ingestion

### 2. Database Layer
- Data loaded into PostgreSQL using pgAdmin 4
- Tables represent structured relational entities

### 3. Clean Layer (data_cleaning.sql)
- Created standardized views for analysis
- Handled missing values using COALESCE
- Converted categorical flags (Yes/No) into boolean fields
- Spot checks applied to ensure correctness

### 4. Analytics Layer (analytics_views.sql)
- Built aggregated views for reporting and dashboards
- Metrics include:
  - Provider workload
  - Department-level summaries
  - Referral SLA performance
  - Appointment lead time
  - Patient risk segmentation

---

## KPI Development

Analytical views were designed to support key healthcare KPIs:

- Appointment completion rate
- No-show rate
- Cancellation rate
- Provider workload distribution
- Referral SLA breach rate
- Department utilization metrics
- Patient risk segmentation
- Appointment lead time

These KPIs will form the foundation for dashboards in the next phase of the project.

---

## Next Steps

- Build Power BI dashboard (multi-page)
- Summarize insights and recommendations

---

## Notes

All data used in this project is synthetic and created for learning and portfolio purposes only. No real PHI, patient data or provider data. Please see [Dataset Generation](documentation/dataset_generation.md) for more details on how the dataset was created.
