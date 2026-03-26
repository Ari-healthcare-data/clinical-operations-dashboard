# Methodology

## Overview

This project follows a structured workflow that mirrors how healthcare data is typically prepared for reporting and analytics.

The goal was to move from a raw, multi-table dataset to a format that can support reliable analysis and dashboard development.


---

## Approach

Instead of jumping straight into visualization, I focused on building a strong data foundation first. This includes making sure the data is structured correctly, relationships are valid, and key metrics are clearly defined before building any dashboards.

This approach reflects how data is typically handled in healthcare environments, where accuracy and consistency are critical.

---

## Step 1: Data Modeling

The dataset was designed using a relational structure with separate tables for patients, providers, appointments, referrals, and supporting dimensions.

Key considerations:

- Use of primary and foreign keys to maintain relationships
- Separation of entities to avoid duplication
- Clear linkage between operational data (appointments) and supporting data (patients, providers, departments)

Appointments were treated as the central fact table, since most operational metrics (volume, no-shows, utilization) are derived from it.

---

## Step 2: Data Cleaning (Planned in SQL)

The next step is to load the dataset into PostgreSQL and create cleaned versions of the core tables.

Planned cleaning steps include:

- Removing or handling null values in critical fields
- Ensuring unique primary keys (e.g., appointment_id)
- Validating foreign key relationships across tables
- Standardizing date formats
- Filtering out invalid or inconsistent records

The goal is to ensure that downstream analysis is based on reliable and consistent data.

---

## Step 3: Data Transformation & Feature Engineering

After cleaning, I will create derived fields and views to support analysis.

Examples include:

- No-show flag and no-show rate calculations
- Days between referral order and scheduling
- SLA compliance indicators for referrals
- Revenue and lost revenue calculations
- Patient segmentation (age groups, risk levels)

These transformations will be implemented using SQL to create reusable analytical views.

---

## Step 4: KPI Development

Instead of calculating metrics directly in Power BI, I plan to create KPI tables in SQL.

Examples of KPI tables:

- Appointments by department (volume, no-show rate, revenue impact)
- Provider-level performance metrics
- Referral outcomes and leakage rates

This approach ensures that:

- Metrics are consistent across all visuals
- Logic is centralized and easier to maintain
- Power BI is used mainly for visualization, not heavy data processing

---

## Step 5: Data Validation

Before building dashboards, I will validate the data to ensure accuracy.

Planned validation checks:

- Row counts between raw and cleaned tables
- Duplicate detection for key identifiers
- Spot-checking relationships between tables
- Verifying KPI calculations against sample data

This step is important because incorrect metrics can lead to misleading conclusions, especially in a healthcare context.

---

## Step 6: Visualization (Power BI)

Once the data is cleaned and validated, it will be connected to Power BI.

The dashboard will be structured into multiple pages:

- Clinic Operations Overview
- Provider Performance
- Referral Flow and Access

The focus will be on:

- Clear KPIs
- Simple, readable visuals
- Interactive filtering for different segments

---

## Design Philosophy

A few principles guiding this project:

- Accuracy over complexity
- Clear definitions of metrics
- Separation of data preparation and visualization
- Focus on business-relevant questions

---

## Challenges Anticipated

- Managing relationships across multiple tables
- Defining KPIs in a consistent way
- Handling edge cases in synthetic data
- Avoiding overly complex SQL while still building meaningful logic

---

## Summary

The methodology focuses on building a reliable data pipeline from raw data to final insights.

Rather than treating this as a visualization project, I am approaching it as a full analytics workflow, where each step builds on the previous one.

---
---

## Day 2: Data Validation & Initial Review

Before starting analysis, I performed an initial validation step to understand the condition of the dataset and make sure it was ready for downstream work.

This included:
- Reviewing table structure and relationships
- Checking for missing or inconsistent values
- Identifying duplicate records
- Evaluating date ranges and formatting
- Confirming that tables can be joined cleanly

This step helped ensure the dataset reflects realistic healthcare operations and highlighted areas that will need cleaning or standardization.

The findings from this phase directly inform the next step: SQL-based data cleaning and transformation.

The next phase focuses on cleaning, standardizing, and preparing the data for analysis using SQL.

---
---

## Day 3: CSV Preparation & Database Upload

After validating the dataset structure on Day 2, I prepared each table for ingestion into PostgreSQL:

### Steps Performed

- Exported each Excel sheet as a UTF-8 encoded CSV file.
- Standardized column names to match the SQL schema.
- Converted Excel serial numbers to proper dates (YYYY-MM-DD).
- Preserved blank cells for SQL NULL values.
- Ensured proper quoting/escaping to prevent import errors.
- Verified that relational integrity (foreign key relationships) would be maintained after import.

### Database Import

- Created relational schema in PostgreSQL using pgAdmin 4.
- Loaded tables in the recommended order:
  DEPARTMENTS → PROVIDERS → PATIENTS → FINANCIAL_ASSUMPTIONS → CALENDAR → HOLIDAYS → APPOINTMENTS → REFERRALS
- Implemented foreign key constraints to enforce relationships across tables.

### Challenges Encountered

- Excel date fields converted to numeric serial numbers.
- Some columns required manual adjustments to match SQL data types.
- CSV encoding and quoting issues caused temporary import failures.
- Ensuring NULL/blank fields were correctly interpreted by PostgreSQL.

### Outcome

All datasets were successfully transformed into CSV format and imported into PostgreSQL. The database now fully mirrors the synthetic EMR dataset with proper relational integrity, ready for analytics and KPI development.

