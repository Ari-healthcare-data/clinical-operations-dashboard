# Dataset Formulas Reference

## Overview

This document provides a technical reference for how the synthetic clinical dataset was generated in Excel.

Rather than listing every formula in full, the focus is on explaining the logic, structure, and design decisions used to simulate realistic healthcare data. The goal was to create a dataset that behaves like a simplified electronic medical record (EMR) system while still being fully synthetic.

---

## How to Read This Document

- Each table includes column-level logic used to simulate real-world healthcare data
- Emphasis is placed on why the logic was used, not just the formula itself
- Randomness is intentionally controlled, not purely arbitrary
- The most important tables for analytics are:
- Appointments (core operational data)
- Referrals (workflow and financial impact)
---

What Makes This Dataset Realistic

While the dataset is synthetic, several design decisions were made to reflect real clinical workflows:

- Referrals are only generated from completed primary care visits
- Appointment types follow a realistic pattern (new patient → follow-up)
- No-show and cancellation rates are weighted, not purely random
- Provider assignment accounts for specialty and patient age
- Scheduling dates are constrained to occur after registration and before visits
- Financial outcomes reflect completed vs missed vs leaked care

These constraints ensure the dataset supports meaningful operational analysis, not just random exploration.

---

# **_PATIENTS Table_**

**Column**: patient_id  
**Formula/Method**: =ROW()-1  
**Purpose**: Unique identifier for each patient to ensures consistent linking across tables.

**Column**: first_name  
**Formula/Method**: Random selection from an alphabetized master list of 300+ gender neutral first names using `RANDBETWEEN` <br>
**Purpose**: Simulates realistic first names while maintaining privacy.

**Column**: last_name  
**Formula/Method**: Random selection from an alphabetized master list of 300+ common last names using `RANDBETWEEN`<br>
**Purpose**: Simulates realistic common last names while maintaining privacy.

**Column**: date_of_birth  
**Formula/Method**: Randomized dates between 1930–2022 using `RANDBETWEEN` <br>
**Purpose**: Creates realistic age distribution; enables age-based logic for insurance and provider assignments.

**Column**: age  
**Formula/Method**: Calculated from date_of_birth  
**Purpose**: Provides patient age for eligibility checks, provider matching, and analytics.

**Column**: gender  
**Formula/Method**: Weighted random (Female 53%, Male 44.5%, Other 2.5%)  
**Purpose**: Supports gender-based reporting and demographic analysis.

**Column**: chronic_conditions  
**Formula/Method**: Weighted random selection: None, Diabetes, Hypertension, Asthma, Multiple  
**Purpose**: Adds patient health complexity for realistic scenarios and analytics.

**Column**: insurance_type  
**Formula/Method**: Age-based with random weighting (Medicare ≥65, Medicaid <18, Commercial/self-pay)  
**Purpose**: Simulates realistic insurance coverage distribution for analysis.

**Column**: zip_code  
**Formula/Method**: Random 5-digit Michigan zip (48000–49999)  
**Purpose**: Provides geographic data for reporting and provider mapping.

**Column**: patient_risk_score  
**Formula/Method**: Random 0–100  
**Purpose**: Simulates patient acuity for analytics, prioritization, or outcome modeling.

**Column**: registration_date  
**Formula/Method**: Logic ensures adult patients register ≥18, children register after birth; capped to 2024  
**Purpose**: Provides realistic registration timelines for workflow and reporting.

**Column**: preferred_contact_method  
**Formula/Method**: Random selection among Phone, Email, or none  
**Purpose**: Simulates patient communication preferences for outreach and engagement.

**Column**: pt_has_appt_y_n  
**Formula/Method**: Boolean flag if patient has appointments  
**Purpose**: Quick reference for reporting and conditional logic.

**Column**: pt_has_referral_y_n  
**Formula/Method**: Boolean flag if patient has referrals  
**Purpose**: Enables reporting and workflow tracking.

---

# **_PROVIDERS Table_**

**Column**: provider_id  
**Formula/Method**: =ROW()-1  
**Purpose**: Unique identifier for each provider that links to appointments, referrals, and departments.

**Column**: first_name  
**Formula/Method**: Random selection from an alphabetized master list of 300+ gender neutral first names using `RANDBETWEEN`<br>
**Purpose**: Simulates realistic first names while maintaining privacy.

**Column**: last_name  
**Formula/Method**: Random selection from an alphabetized master list of 300+ common last names using `RANDBETWEEN`<br>
**Purpose**: Simulates realistic common last names while maintaining privacy.

**Column**: specialty  
**Formula/Method**: Manual assignment: Primary Care or specialist (Cardiology, Orthopedics, Dermatology, Neurology)  
**Purpose**: Categorizes providers for realistic patient assignment and referral workflows.

**Column**: tenure_years  
**Formula/Method**: Random integer 1–30  
**Purpose**: Simulates provider experience for scheduling, capacity, and reporting.

**Column**: clinic_location  
**Formula/Method**: Lookup from Departments table  
**Purpose**: Maps provider to physical clinic location for logistics and planning.

**Column**: fte_status  
**Formula/Method**: Random Full-Time/Part-Time (25% Part-Time)  
**Purpose**: Determines weekly availability and affects capacity calculations.

**Column**: department_id  
**Formula/Method**: Lookup based on specialty  
**Purpose**: Links provider to department for organizational structure and reporting.

**Column**: active_months  
**Formula/Method**: Full-Time = all months; Part-Time = random months  
**Purpose**: Models seasonal/flexible provider availability.

**Column**: min_patient_age_for_specialty  
**Formula/Method**: Assigned by specialty  
**Purpose**: Ensures age-appropriate patient assignments.

**Column**: max_patient_age_for_specialty  
**Formula/Method**: Assigned by specialty  
**Purpose**: Ensures valid patient-provider assignment.

**Column**: fte_value  
**Formula/Method**: Full-Time =1, Part-Time = 0.4–0.8  
**Purpose**: Scales weekly appointment capacity and analytics.

**Column**: clinic_days_per_week  
**Formula/Method**: Based on FTE  
**Purpose**: Defines provider availability per week.

**Column**: appointment_slots_per_week  
**Formula/Method**: Scaled by specialty and FTE  
**Purpose**: Determines weekly appointment capacity.

**Column**: annual_capacity  
**Formula/Method**: appointment_slots_per_week × 50  
**Purpose**: Provides annual provider capacity for planning.

---

# **_DEPARTMENTS Table_**

**Column**: department_id  
**Formula/Method**: =ROW()-1  
**Purpose**: Unique identifier that links to providers and appointments.

**Column**: department_name  
**Formula/Method**: Manual (Primary Care, Cardiology, Orthopedics, Dermatology, Neurology)  
**Purpose**: Categorizes departments; used in reporting and provider mapping.

**Column**: location  
**Formula/Method**: Manual choice (Main, North, East, West, South)  
**Purpose**: Maps physical department location for operational analysis.

**Column**: department_head_id  
**Formula/Method**: Randomly assigned provider from department  
**Purpose**: Adds hierarchy for reporting and analytics.

**Column**: floor / building  
**Formula/Method**: Random Floor 1–5  
**Purpose**: Simulates realistic location data.

**Column**: default_reimbursement  
**Formula/Method**: Lookup from Financial_Assumptions  
**Purpose**: Provides baseline revenue assumptions per department.

---

# **_APPOINTMENTS Table_**

**Column**: appointment_id  
**Formula/Method**: =ROW()-1  
**Purpose**: Unique identifier for each appointment.

**Column**: patient_id  
**Formula/Method**: Random selection of patients  
**Purpose**: Simulates patient assignment for appointments.

**Column**: provider_id  
**Formula/Method**: Assigned based on patient age, specialty, primary care distribution, with fallback logic  
**Purpose**: Ensures realistic patient-provider matching.

**Column**: department_id  
**Formula/Method**: Lookup provider department  
**Purpose**: Supports department-level analytics.

**Column**: appointment_date  
**Formula/Method**: Randomized dates for 2023–2024; future appointments build on previous visits  
**Purpose**: Simulates realistic appointment scheduling patterns.

**Column**: appointment_time  
**Formula/Method**: Random clinic time (8:00–16:45)  
**Purpose**: Models daily scheduling.

**Column**: appointment_type  
**Formula/Method**: “New Patient” for first visits; others are weighted follow-ups or procedures  
**Purpose**: Differentiates appointment type for analysis.

**Column**: appointment_outcome  
**Formula/Method**: Weighted random: Completed, Canceled, No-Show  
**Purpose**: Models operational results and revenue impact.

**Column**: visit_reason  
**Formula/Method**: Assigned based on appointment_type  
**Purpose**: Provides context for visits and procedure planning.

**Column**: department_name  
**Formula/Method**: Lookup provider specialty  
**Purpose**: Supports reporting and analytics.

**Column**: visit_duration  
**Formula/Method**: Random 15–60 min if completed, 0 otherwise  
**Purpose**: Reflects realistic visit durations.

**Column**: appointment_cost  
**Formula/Method**: Lookup reimbursement by specialty with ±20 variance; 0 if not completed  
**Purpose**: Models revenue for each visit.

**Column**: scheduled_date  
**Formula/Method**: Ensures appointment occurs after patient registration but before actual appointment date  
**Purpose**: Simulates realistic scheduling lead times.

**Column**: check_in_time  
**Formula/Method**: Appointment time plus random variance; blank if not completed  
**Purpose**: Models patient arrival behavior.

**Column**: cancellation_flag  
**Formula/Method**: Yes if canceled, No otherwise  
**Purpose**: Enables operational and revenue reporting.

---

# **_REFERRALS Table_**

**Column**: referral_id  
**Formula/Method**: =ROW()-1  
**Purpose**: Unique identifier for tracking referrals.

**Column**: patient_id  
**Formula/Method**: Random patient with completed PCP appointment  
**Purpose**: Simulates realistic referral workflow.

**Column**: referring_provider_id  
**Formula/Method**: Derived from patient’s prior PCP appointment  
**Purpose**: Identifies source provider for referral.

**Column**: referred_to_provider_id  
**Formula/Method**: Assigns specialty provider based on age, availability, with fallback  
**Purpose**: Ensures realistic referral assignment.

**Column**: referral_order_date  
**Formula/Method**: Derived from PCP appointment date  
**Purpose**: Ensures logical sequencing of referral workflow.

**Column**: referral_priority  
**Formula/Method**: Weighted random: Routine, Urgent, STAT  
**Purpose**: Models referral urgency for scheduling SLA.

**Column**: referral_reason  
**Formula/Method**: Random typical reasons: Specialty Eval, Diagnostic Testing, Surgical Consultation, Imaging, Treatment Planning  
**Purpose**: Provides clinical context.

**Column**: target_sla_days  
**Formula/Method**: Depends on priority: Routine 30, Urgent 7, STAT 2  
**Purpose**: Sets SLA for referral scheduling.

**Column**: referral_scheduled  
**Formula/Method**: Random scheduled date within SLA  
**Purpose**: Simulates real-world scheduling variance of some referrals having specialist appointments that are scheduled and some that do not have a scheduled specialist appointment scheduled.

**Column**: days_to_schedule  
**Formula/Method**: Scheduled minus order date  
**Purpose**: Measures SLA compliance.

**Column**: sla_breach_flag  
**Formula/Method**: Yes if days_to_schedule > target_sla_days  
**Purpose**: Tracks SLA violations for operational monitoring.

**Column**: referral_outcome  
**Formula/Method**: Completed In-Network, Out-of-Network, or Not Scheduled  
**Purpose**: Tracks referral completion for operational and revenue analysis.

**Column**: completed_in_network / completed_out_of_network / not_scheduled  
**Formula/Method**: Binary flags (1 or 0)  
**Purpose**: Supports reporting and revenue calculations.

**Column**: expected_revenue / lost_revenue  
**Formula/Method**: Revenue lookup based on outcome and specialty  
**Purpose**: Calculates financial impact of referral completion or leakage.

**Column**: self_referred_provider_check  
**Formula/Method**: Detects improper self-referral  
**Purpose**: Maintains data integrity and auditing.

**Column**: referred_to_specialty  
**Formula/Method**: Lookup specialty of referred provider  
**Purpose**: Supports analysis of specialty demand and revenue attribution.

---

# **_FINANCIAL ASSUMPTIONS Table_**

**Column**: specialty  
**Formula/Method**: Manual assignment  
**Purpose**: Maps financial assumptions by specialty.

**Column**: cost_per_appointment  
**Formula/Method**: Random selection (80–200)  
**Purpose**: Base cost per visit for financial modeling.

**Column**: cost_per_appt_slot  
**Formula/Method**: 80% of cost_per_appointment  
**Purpose**: Scales cost for appointment slots.

**Column**: revenue_per_referral  
**Formula/Method**: Random selection (200–600)  
**Purpose**: Revenue estimate per referral.

**Column**: revenue_per_appointment_type  
**Formula/Method**: Random selection (100–300)  
**Purpose**: Models variation in revenue by appointment type.

**Column**: penalty_cost_no_show  
**Formula/Method**: 50% of cost_per_appointment  
**Purpose**: Models financial impact of no-show appointments.

**Column**: reimbursement_per_visit  
**Formula/Method**: Random selection (120–300)  
**Purpose**: Simulates realistic reimbursement per visit.

---

# **_CALENDAR Table_**

**Column**: date  
**Formula/Method**: Manual (master list 2022–2024)  
**Purpose**: Provides master calendar for scheduling and reporting.

**Column**: year / month / quarter / weekday  
**Formula/Method**: Extracted from date  
**Purpose**: Supports grouping, filtering, and seasonality analysis.

**Column**: holiday_flag  
**Formula/Method**: Lookup in Holidays table  
**Purpose**: Identifies recognized holidays for realistic operations modeling.

**Column**: week_of_year  
**Formula/Method**: WEEKNUM(date)  
**Purpose**: Enables week-based reporting.

**Column**: is_weekend  
**Formula/Method**: Yes if Saturday or Sunday  
**Purpose**: Supports operational planning and staffing.

---

# **_HOLIDAYS Table_**

**Column**: holiday_date  
**Formula/Method**: Manual list of major holidays (New Year, Independence Day, Thanksgiving, Christmas) for 2022–2024  
**Purpose**: Centralized reference to support calendar and scheduling logic.

---

### Notes

- Randomness is intentionally guided by rules to maintain realism
- Fallback logic prevents broken relationships
- Temporal constraints ensure events follow a logical sequence
- Financial modeling reflects operational outcomes (completed vs missed vs leaked care)

This reference is intended to show not just how I built the dataset, but how I designed it to support real-world healthcare analytics use cases.
