# Clinical Operations Dashboard

## Project Summary
This project is a **Healthcare Analytics Portfolio** project focused on improving **clinic operational efficiency** through the analysis of appointments and referrals. The dashboard provides actionable KPIs on **attendance, no-show rates, provider performance, and referral management**. 

This project uses a **synthetic healthcare dataset** created to simulate real-world EMR operations, including appointments, referrals, providers, departments, and patients. No real patient information or provider information is used. **ALL patient and provider names and demographics were ALL created for the synthetic healthcare dataset**. (See [Dataset Generation](documentation/dataset_generation.md))

**Tools & Technologies Used:**
- PostgreSQL (SQL) for data cleaning, validation, and KPI calculations
- Power BI Desktop for interactive dashboard visualizations
- CSVs and structured healthcare EMR data for realistic simulations

---

## Business Problem / Story
Clinics often face challenges like:
- High no-show rates leading to lost revenue and inefficient provider schedules
- Inefficient referral management and referral leakage
- Difficulty monitoring performance at department and provider levels  

This dashboard was created to answer these questions:
1. Which departments and providers have the worst attendance?
2. How effective is the referral system, and are patients referred outside target departments?
3. What trends in appointments and referrals can inform operational decisions?

---

## Skills Applied
- Designed a **synthetic healthcare dataset** simulating real-world EMR operations, including appointments, referrals, providers, departments, and patients.
- Ensured the dataset supported **realistic KPI calculations and dashboard visuals** without including any real patient information.
- Designed a **structured SQL pipeline** to clean raw EMR data and calculate KPIs
- Validated data for **duplicates, nulls, and referential integrity**
- Created **department- and provider-level KPI views**
- Built a **professional Power BI dashboard** with multiple pages:
  - Clinic Operations Overview
  - Provider Performance
  - Access & Referral Flow

---

## Methodology
See [methodology.md](documentation/methodology.md) for detailed technical steps including data cleaning, KPI calculations, and dashboard preparation.

---

## Key Findings & Business Impact
See [portfolio_notes.md](documentation/portfolio_notes.md) for insights, business implications, and actionable takeaways.

---

## Dashboard Screenshots

- **Page 1 — Clinic Operations Overview**  
  **KPI Cards**: Total Appointments, No-Show Rate  
  **Charts**: No-Shows by Department & Provider, Appointment Volume Trend
![Page 1 Overview](documentation/dashboard_images/page1_clinic_operations_overview.png)

- **Page 2 — Provider Performance**  
  **KPI & Charts**: Provider no-show ranking, appointment volume, department filters
![Page 2 Provider](documentation/dashboard_images/page2_provider_performance.png)


- **Page 3 — Access & Referral Flow**  
  **KPI & Charts**: Referrals by Department, Referral Leakage %, Referral Volume Trends
![Page 3 Referrals](documentation/dashboard_images/page3_referral_access_flow.png)

---

## Clean Tables from SQL Views

- **Appointments Clean Table**  
![Appointments Clean Table](documentation/clean_tables/appointments_clean_table.png)

- **Department KPI Table**  
![Department KPI Table](documentation/clean_tables/appointments_kpi_department_table.png)

- **Provider KPI Table**  
![Provider KPI Table](documentation/clean_tables/appointments_kpi_provider_table.png)

- **Referrals Clean Table** 
![Referrals Clean Table 1](documentation/clean_tables/referrals_clean_table_01.png)
![Referrals Clean Table 2](documentation/clean_tables/referrals_clean_table_02.png)

---

## Dataset Generation

The `dataset_generation.md` file provides a detailed description of how the synthetic datasets were created for this project. It includes:

- Formulas and methods for generating each table: **Patients, Providers, Departments, Appointments, Referrals, Financial_Assumptions, Calendar**

- Logic for realistic values such as age distributions, gender ratios, appointment scheduling, provider eligibility, and referral patterns

- Guidance for reproducing or extending the dataset for further analytics

For more details, see [Dataset Generation](documentation/dataset_generation.md).







