-- Project: Clinical Operations Dashboard
-- File: data_validation.sql
-- Purpose: Validate imported tables and check for missing or duplicate data
-- Author: Ari M.
-- Date: 2026-03-08
-- Notes: Run after importing CSVs to ensure data integrity


-- 1. Row Counts
-- Purpose: Quickly check how many rows are in each table.

SELECT 'patients' AS table_name, COUNT(*) AS row_count FROM patients
UNION ALL
SELECT 'providers', COUNT(*) FROM providers
UNION ALL
SELECT 'departments', COUNT(*) FROM departments
UNION ALL
SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL
SELECT 'referrals', COUNT(*) FROM referrals
UNION ALL
SELECT 'calendar', COUNT(*) FROM calendar
UNION ALL
SELECT 'financial_assumptions', COUNT(*) FROM financial_assumptions;

-- Expected Results:
-- table_name: row_count
-- patients: 206
-- providers: 20
-- departments: 5
-- appointments: 1001
-- referrals: 300
-- calendar: 731
-- financial_assumptions: 5



-- 2. Check for Duplicate Primary Keys
-- Purpose: Ensure each table's primary key is unique.

-- Patients
SELECT patient_id, COUNT(*) AS duplicate_count
FROM patients
GROUP BY patient_id
HAVING COUNT(*) > 1;

-- Providers
SELECT provider_id, COUNT(*) AS duplicate_count
FROM providers
GROUP BY provider_id
HAVING COUNT(*) > 1;

-- Departments
SELECT department_id, COUNT(*) AS duplicate_count
FROM departments
GROUP BY department_id
HAVING COUNT(*) > 1;

-- Appointments
SELECT appointment_id, COUNT(*) AS duplicate_count
FROM appointments
GROUP BY appointment_id
HAVING COUNT(*) > 1;

-- Referrals
SELECT referral_id, COUNT(*) AS duplicate_count
FROM referrals
GROUP BY referral_id
HAVING COUNT(*) > 1;

-- Calendar
SELECT date, COUNT(*) AS duplicate_count
FROM calendar
GROUP BY date
HAVING COUNT(*) > 1;

-- Financial Assumptions
SELECT specialty, COUNT(*) AS duplicate_count
FROM financial_assumptions
GROUP BY specialty
HAVING COUNT(*) > 1;

-- Expected Results:
-- 0 rows



--3. Check Nulls in Key Fields
-- Purpose: Identify missing critical data.

-- Appointments
SELECT
    COUNT(*) FILTER (WHERE provider_id IS NULL) AS null_provider_id,
    COUNT(*) FILTER (WHERE patient_id IS NULL) AS null_patient_id,
    COUNT(*) FILTER (WHERE appointment_date IS NULL) AS null_appointment_date
FROM appointments;

-- Referrals
SELECT
    COUNT(*) FILTER (WHERE referral_id IS NULL) AS null_referral_id,
    COUNT(*) FILTER (WHERE referring_provider_id IS NULL) AS null_referring_provider_id,
    COUNT(*) FILTER (WHERE patient_id IS NULL) AS null_patient_id,
    COUNT(*) FILTER (WHERE referred_to_provider_id IS NULL) AS null_referred_to_provider_id
FROM referrals;

-- Departments
SELECT
    COUNT(*) FILTER (WHERE department_id IS NULL) AS null_department_id,
    COUNT(*) FILTER (WHERE department_name IS NULL) AS null_department_name
FROM departments;

-- Providers
SELECT
    COUNT(*) FILTER (WHERE provider_id IS NULL) AS null_provider_id,
    COUNT(*) FILTER (WHERE provider_name IS NULL) AS null_provider_name
FROM providers;

-- Patients
SELECT
    COUNT(*) FILTER (WHERE patient_id IS NULL) AS null_patient_id,
    COUNT(*) FILTER (WHERE first_name IS NULL OR last_name IS NULL) AS null_patient_name
FROM patients;

-- Calendar
SELECT COUNT(*) FILTER (WHERE date IS NULL) AS null_calendar_date
FROM calendar;

-- Financial Assumptions
SELECT COUNT(*) FILTER (WHERE specialty IS NULL) AS null_specialty
FROM financial_assumptions; --no assumption_id because "specialty" is the PK


-- Expected Results:
-- 0 rows



-- 4. Foreign Key Checks
-- Purpose: Ensure referential integrity between tables.

-- Appointments -> Providers
SELECT COUNT(*) AS invalid_provider_refs
FROM appointments a
LEFT JOIN providers p ON a.provider_id = p.provider_id
WHERE p.provider_id IS NULL;

-- Appointments -> Patients
SELECT COUNT(*) AS invalid_patient_refs
FROM appointments a
LEFT JOIN patients pt ON a.patient_id = pt.patient_id
WHERE pt.patient_id IS NULL;

-- Referrals -> Providers (referring)
SELECT COUNT(*) AS invalid_referring_provider_refs
FROM referrals r
LEFT JOIN providers p ON r.referring_provider_id = p.provider_id
WHERE p.provider_id IS NULL;

-- Referrals -> Providers (referred-to)
SELECT COUNT(*) AS invalid_referred_to_provider_refs
FROM referrals r
LEFT JOIN providers p ON r.referred_to_provider_id = p.provider_id
WHERE p.provider_id IS NULL;

-- Referrals -> Patients
SELECT COUNT(*) AS invalid_patient_refs
FROM referrals r
LEFT JOIN patients pt ON r.patient_id = pt.patient_id
WHERE pt.patient_id IS NULL;

-- Expected Results: 
-- 0 rows


-- 5. Validate cleaned views
SELECT COUNT(*) AS total_appointments_clean FROM appointments_clean;
SELECT COUNT(*) AS total_referrals_clean FROM referrals_clean;

-- Expected Results:
-- total_referrals_clean: 282


SELECT COUNT(*) FILTER (WHERE appointment_outcome IS NULL) AS null_outcomes_in_clean
FROM appointments_clean;

-- Expected Results:
-- null_outcomes_in_clean: 0


SELECT COUNT(*) FILTER (WHERE referral_id IS NULL) AS null_referrals_in_clean
FROM referrals_clean;

-- Expected Results:
-- null_referrals_in_clean: 0


-- Providers linked to valid departments
SELECT COUNT(*) AS invalid_provider_departments
FROM providers p
LEFT JOIN departments d ON p.department_id = d.department_id
WHERE d.department_id IS NULL;

-- Expected Results:
-- invalid_provider_departments: 0


-- Appointments linked to valid provider departments
SELECT COUNT(*) AS invalid_appointment_departments
FROM appointments a
JOIN providers p ON a.provider_id = p.provider_id
LEFT JOIN departments d ON p.department_id = d.department_id
WHERE d.department_id IS NULL;

-- Expected Results:
-- invalid_appointment_departments: 0



-- 6. Validate KPI Vies

-- KPI row count validation
SELECT COUNT(*) AS total_departments FROM appointments_kpi_department;

-- Expected Results:
-- total_departments:  5

SELECT COUNT(*) AS total_providers FROM appointments_kpi_provider;

-- Expected Results:
-- total_providers: 20


-- Validate department-level KPI view
SELECT *
FROM appointments_kpi_department;

-- Expected Results:
-- department_name:	 total_appointments 	no_show_count	no_show_rate_percent
-- Cardiolog: 	     107	                12	            11.21
-- Dermatology:	     156	                15	            9.62
-- Orthopedics:	     113	                17		        15.04
-- Primary Care:	 550	                74		        13.45
-- Neurology:	     75	                    9		        12.00


-- Validate provider-level KPI view
SELECT *
FROM appointments_kpi_provider;

-- Expected Results:
-- provider_id,  provider_name,	department_name, 	total_appointments,   no_show_count,	no_show_rate_percent"
-- 14	         Pierce, Kendall    Orthopedics	        36	                  3	                8.33
-- 12	         Sullivan, Jamie    Orthopedics	        38	                  8	                21.05
-- 9	         Collins, Blair     Cardiology	        44	                  4	                9.09
-- 3	         Fletcher, Rowan    Primary Care	    61	                  7	                11.48
-- 10	         Ramirez, Casey     Cardiology	        34	                  5	                14.71
-- 7	         Turner, Alex       Primary Care	    78	                  10	            12.82
-- 16	         Brooks, Parker     Dermatology	        45	                  9	                20.00
-- 5	         Montgomery, Skyler Primary Care	    56	                  13	            23.21
-- 2	         Lawson, Riley      Primary Care	    77	                  10	            12.99
-- 1	         Harper, Quinn      Primary Care	    58	                  6	                10.34
-- 20	         Whitaker, Sloane   Neurology	        38	                  2	                5.26
-- 17	         Blake, Arden       Dermatology	        40	                  2	                5.00
-- 18	         Carter, Jules      Dermatology	        33	                  2	                6.06
-- 19	         Delgado, Remy      Neurology	        37	                  7	                18.92
-- 13	         Hayes, Jordan      Orthopedics	        39	                  6	                15.38
-- 11	         Bennett, Dakota    Cardiology	        29	                  3	                10.34
-- 8	         Dawson, Avery      Primary Care	    63	                  8	                12.70
-- 6	         Franklin, Taylor   Primary Care	    80	                  12	            15.00
-- 4	         Bishop, Sawyer     Primary Care	    77	                  8	                10.39
-- 15	         Wallace, Morgan    Dermatology	        38	                  2	                5.26



-- 7. Check duplicates in cleaned views

-- Check duplicates in cleaned referrals
SELECT patient_id, referring_provider_id, referred_to_provider_id, referral_order_date, COUNT(*) AS cnt
FROM referrals_clean
GROUP BY patient_id, referring_provider_id, referred_to_provider_id, referral_order_date
HAVING COUNT(*) > 1;

-- Expected Results:
-- 0 rows

-- Check duplicates in cleaned appointments
SELECT patient_id, provider_id, appointment_date, COUNT(*) AS cnt
FROM appointments_clean
GROUP BY patient_id, provider_id, appointment_date
HAVING COUNT(*) > 1;

-- Expected Results:
-- 0 rows



-- 8. Check for any impossible no-show rates

SELECT provider_id, no_show_rate_percent
FROM appointments_kpi_provider
WHERE no_show_rate_percent < 0 OR no_show_rate_percent > 100;

-- Expected Results:
-- 0 rows


SELECT department_name, no_show_rate_percent
FROM appointments_kpi_department
WHERE no_show_rate_percent < 0 OR no_show_rate_percent > 100;

-- Expected Results:
-- 0 rows
