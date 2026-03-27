# Portfolio Notes

---
---

# Day 1 - Summary

Today I focused on building the dataset that will support the rest of the project. Instead of starting with analysis or dashboards, I spent time designing the structure and making sure the data behaves in a way that makes sense for a clinical setting.

At this point, the dataset is complete and ready to be exported and used in SQL.

---

## What I Worked On

- Designed a multi-table dataset (patients, providers, appointments, referrals)
- Built relationships between tables using IDs and lookup logic
- Created formulas to simulate realistic workflows (appointments → referrals)
- Added constraints to keep data within a reasonable time range (2022–2024)
- Documented the purpose and logic behind each column

---

## What I Noticed While Building This

One thing that stood out pretty quickly is how connected everything is.

For example, generating a single referral required:

- a valid patient
- a completed appointment
- a primary care provider
- a matching specialty provider

It made me realize that even small issues in one table can affect multiple parts of the system.

I also noticed that randomness alone doesn’t create realistic data. I had to guide it with rules (like keeping most visits in primary care, or tying referrals to completed visits) to make the dataset usable.

---

## Challenges

Some parts of the dataset took a few attempts to get right:

- Making sure registration dates made sense relative to patient age
- Fixing referral logic so it actually reflects a real workflow
- Handling cases where provider filters returned no results
- Avoiding broken relationships between tables
- Keeping formulas manageable as the dataset grew

A lot of the work was trial and error, especially when formulas became more complex.

---

## Decisions I Made

- Treated appointments as the central dataset since most metrics come from it
- Linked referrals to completed visits instead of generating them randomly
- Used fallback logic to prevent missing provider assignments
- Kept financial assumptions in a separate table for flexibility

These design choices will support more accurate analysis of operational metrics such as no-show rates, provider utilization, and referral completion patterns when I get to the cleaning, validation analysis phases of the project.

---

## Lessons Learned

- It’s much easier to build analysis on top of clean structure than to fix problems later
- Relational thinking (tables + keys) is really important, even for small projects
- Data quality issues can start at the data generation stage, not just during cleaning
- Simulating real workflows is harder than it looks

---

## What I Would Improve Later

- Make distributions more realistic (age, insurance, referral rates)
- Add more edge cases (e.g., rescheduled appointments, multiple referrals)
- Possibly generate the dataset using Python instead of Excel for better control

---

## Next Step

Next, I’ll export the dataset into CSV files and load it into PostgreSQL.

From there, I’ll start:

- Data cleaning
- Building analytical views
- Defining KPIs

This is where the project will start to shift from data setup to actual analysis.

---

## Personal Reflection

This part of the project took longer than expected, but it helped me understand how much work goes into preparing data before any analysis even begins.

I’m expecting the next phase (SQL and KPIs) to be challenging in a different way, especially when it comes to defining metrics clearly and making sure they are consistent across the dataset. 

---
---
---

# Day 2 – Dataset Review & Validation

Before jumping into SQL, I wanted to make sure the dataset actually holds up, so today focused on validating structure, relationships, and overall data quality.

I reviewed all tables (patients, providers, appointments, referrals, financials, and calendar data) to understand how everything connects and whether it behaves like a real EMR system.

### What I Checked

- Relationships between tables (patient_id, provider_id, department_id)
- Missing values across key fields
- Date ranges and consistency
- Basic distributions (age, costs, durations)
- Whether tables can be joined cleanly

### Observations

- The dataset is well-structured and behaves like a relational healthcare system
- Appointment data includes realistic scenarios like no-shows, cancellations, and follow-ups
- Financial and operational data are integrated, which will support more meaningful analysis later

This was the point where the dataset started to feel less like something generated in Excel and more like something you’d actually work with.

---

### Challenges / Observations

- Some patient records are missing `preferred_contact_method`, which will need to be standardized (likely set to "Unknown")
- The `active_months` field for providers is inconsistent ("All Year" vs comma-separated month values)
- Found a duplicate holiday record (07/04/2024)
- Missing check-in times for no-shows (expected, but still something to account for in analysis)
- A few referral-related records extend into 2025, which may represent future scheduled activity and will need to be handled intentionally

---

### Key Takeaways

- Real-world healthcare data is rarely perfectly clean, and designing for those imperfections matters
- Strong relational structure upfront makes everything downstream (SQL, dashboards) much easier
- Combining operational, clinical, and financial data opens the door for more meaningful insights

---

### Next Steps

- Clean and standardize the dataset using SQL
- Handle missing values and inconsistent formats
- Begin exploratory data analysis (EDA)
- Start identifying key metrics for dashboard development

---
---
---

# Day 3 – Database Setup & Validation

**What I Accomplished**

- Converted structured Excel datasets into CSV files for database ingestion.
- Resolved formatting issues:
  - Excel date serial numbers converted to proper date formats.
  - NULL/blank fields handled correctly.
  - Quoting, escaping, and delimiter inconsistencies fixed.
- Created a relational schema in PostgreSQL using pgAdmin 4.
- Loaded all datasets into corresponding tables successfully.
- Implemented foreign key constraints to enforce relational integrity:
  - Patients, Providers, Departments, Appointments, Referrals.
- Performed validation checks:
  - Row counts across all tables.
  - Referential integrity verification.
- Confirmed database reflects the intended dataset accurately:
  - Patients: 1001
  - Providers: 50
  - Appointments: 3001
  - Referrals: 801
  - Supporting tables (Calendar, Holidays, Departments, Financial Assumptions) loaded correctly.

**Challenges / Observations – Day 3**

- Excel converted dates to numeric serials, requiring careful correction.
- CSV import failures occurred due to mismatched data types.
- NULL and blank values needed explicit handling for PostgreSQL.
- CSV formatting (extra commas, quotes, line breaks) caused temporary issues.
- Ensuring foreign key constraints aligned with CSV structure required iterative debugging.
- Confirming row counts and relationships reinforced data validation skills.
- Encountering real-world ETL friction mirrored challenges in enterprise healthcare data workflows.

**Reflection**

Setting up a fully relational database emphasized the importance of clean, well-structured data before analysis. Resolving the CSV to SQL challenges highlighted the attention to detail required in healthcare analytics, and prepared the system for KPI creation and dashboard development in the next phase.

---
---
---

# Day 4 – Analytical Layer & KPI Development

In this phase, I focused on building analytical views on top of the cleaned dataset to prepare for dashboard development.

### What I Worked On

- Created SQL views to support analytics and reporting
- Developed KPI-focused datasets including:
  - Patient risk segmentation
  - Provider workload summaries
  - Referral SLA performance
  - Appointment lead time analysis
  - Department-level metrics
- Used aggregations and CASE statements to derive meaningful metrics
- Implemented CTEs to structure complex queries and avoid duplication issues

### Key Observations

- Aggregations require careful handling to avoid double counting when joining multiple tables
- Pre-aggregating data before joins improves both accuracy and readability
- Different levels of granularity must be respected when combining datasets
- Clear separation between raw, cleaned, and analytical layers improves maintainability

### Challenges

- Encountered inflated metrics due to joins across multiple tables
- Diagnosed the issue as row multiplication caused by many-to-many relationships
- Resolved the issue by restructuring queries using CTE-based pre-aggregation
- Ensured consistency between totals in analytical views and base tables
- Balanced performance considerations with query readability

### What I Learned

- Importance of grain (level of detail) in SQL queries
- How joins can unintentionally duplicate records
- How to use CTEs to control aggregation logic
- How to design queries specifically for dashboard consumption
- The value of validating aggregated outputs against expected totals

### Minor Observations

- Provider workloads varied realistically (some busier than others)
- Department-level KPIs reflected expected patterns (Primary Care highest volume)
- Referral SLA metrics showed plausible variation and some high breach rates
- Appointment lead times included same-day scheduling and multi-week delays
- Synthetic dataset is very clean; few anomalies, which is expected for the generated data I created

### Next Step

The project is now ready for visualization. The next phase will focus on building an interactive dashboard using Power BI or Tableau, leveraging these analytical views.

