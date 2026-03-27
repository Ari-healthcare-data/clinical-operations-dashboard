-- Project: Clinical Operations Dashboard
-- File: data_validation.sql
-- Purpose: Validate imported tables and check for missing or duplicate data
-- Author: Ari M.



-- 1. Row Counts
-- Purpose: Quickly check how many rows are in each table.

SELECT COUNT(*) FROM financial_assumptions;

-- "count"
-- 5


SELECT COUNT(*) FROM departments;

-- "count"
-- 5


SELECT COUNT(*) FROM holidays;

-- "count"
-- 12


SELECT COUNT(*) FROM calendar;

-- "count"
-- 1096


SELECT COUNT(*) FROM patients;

-- "count"
-- 1001


SELECT COUNT(*) FROM providers;

-- "count"
-- 50


SELECT COUNT(*) FROM appointments;

-- "count"
-- 3001

SELECT COUNT(*) FROM referrals;

-- "count"
-- 801



-- 2. Check for Duplicate Primary Keys
-- Purpose: Ensure each table's primary key is unique.

-- Patients
SELECT patient_id, COUNT(*)
FROM patients
GROUP BY patient_id
HAVING COUNT(*) > 1;

-- 0 rows


-- Providers
SELECT provider_id, COUNT(*)
FROM providers
GROUP BY provider_id
HAVING COUNT(*) > 1;

-- 0 rows


-- Appointments
SELECT appointment_id, COUNT(*)
FROM appointments
GROUP BY appointment_id
HAVING COUNT(*) > 1;

-- 0 rows


-- Referrals
SELECT referral_id, COUNT(*)
FROM referrals
GROUP BY referral_id
HAVING COUNT(*) > 1;

-- 0 rows



-- 3. Check Nulls in Key Fields
-- Purpose: Identify missing critical data.

SELECT *
FROM patients
WHERE patient_id IS NULL
   OR first_name IS NULL
   OR last_name IS NULL;

-- 0 rows


SELECT *
FROM providers
WHERE provider_id IS NULL
   OR first_name IS NULL
   OR last_name IS NULL;

-- 0 rows


SELECT *
FROM appointments
WHERE appointment_id IS NULL
   OR patient_id IS NULL
   OR provider_id IS NULL
   OR department_id IS NULL;

-- 0 rows



-- 4. Referential integrity check
-- Purpose: Make sure foreign key relationships are valid (no orphan records).

-- Appointments → Patients
SELECT COUNT(*) AS orphan_appointments_patients
FROM appointments a
LEFT JOIN patients p
ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- "orphan_appointments_patients"
-- 0


-- Appointments → Providers
SELECT COUNT(*) AS orphan_appointments_providers
FROM appointments a
LEFT JOIN providers p
ON a.provider_id = p.provider_id
WHERE p.provider_id IS NULL;

-- "orphan_appointments_providers"
-- 0


-- Appointments → Departments
SELECT COUNT(*) AS orphan_appts_departments
FROM appointments a
LEFT JOIN departments d
ON a.department_id = d.department_id
WHERE d.department_id IS NULL;

-- "orphan_appts_departments"
-- 0


-- Providers → Departments
SELECT COUNT(*) AS orphan_providers_departments
FROM providers p
LEFT JOIN departments d
ON p.department_id = d.department_id
WHERE d.department_id IS NULL;

-- "orphan_providers_departments"
-- 0


-- Referrals → Patients
SELECT COUNT(*) AS orphan_referrals_patients
FROM referrals r
LEFT JOIN patients p
ON r.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- "orphan_referrals_patients"
-- 0


-- Referrals → Referring Providers
SELECT COUNT(*) AS orphan_referrals_referring_providers
FROM referrals r
LEFT JOIN providers p
ON r.referring_provider_id = p.provider_id
WHERE p.provider_id IS NULL;

-- "orphan_referrals_referring_providers"
-- 0


-- Referrals → Referred Providers
SELECT COUNT(*) AS orphan_referrals_referred_providers
FROM referrals r
LEFT JOIN providers p
ON r.referred_to_provider_id = p.provider_id
WHERE p.provider_id IS NULL;

-- "orphan_referrals_referred_providers"
-- 0



-- 5. Data Quality Check
-- Purpose: Look for unrealistic or unexpected values in the data

-- Invalid ages
SELECT *
FROM patients
WHERE age < 0 OR age > 120;

-- 0 rows


-- Invalid appointment costs
SELECT *
FROM appointments
WHERE appointment_cost < 0;

-- 0 rows


-- Zero-duration appointments with "Completed" status (sanity check)
SELECT *
FROM appointments
WHERE appointment_outcome = 'Completed'
  AND visit_duration = 0;

-- 0 rows


-- Check for missing preferred contact method (expected some NULLs)
SELECT COUNT(*) AS missing_contact_method
FROM patients
WHERE preferred_contact_method IS NULL;

-- "missing_contact_method"
-- 326


-- Quick look at gender values to make sure nothing unexpected slipped in
SELECT DISTINCT gender
FROM patients;

-- "gender"
-- "Other"
-- "Male"
-- "Female"


-- Check for invalid appointment outcomes
SELECT DISTINCT appointment_outcome
FROM appointments;

-- "appointment_outcome"
-- "Completed"
-- "Canceled"
-- "No-Show"


-- Check for negative or zero visit duration (outside expected cases)
SELECT *
FROM appointments
WHERE visit_duration < 0;

-- 0 rows

-- Check referrals with negative days_to_schedule
SELECT *
FROM referrals
WHERE days_to_schedule < 0;

-- 0 rows



-- 6. Data Distribution Checks
-- Purpose: Get a general sense of how the data is spread across key fields

-- Providers per department
SELECT department_id, COUNT(*) AS provider_count
FROM providers
GROUP BY department_id
ORDER BY department_id;

-- "department_id"	"provider_count"
-- 1	19
-- 2	8
-- 3	8
-- 4	8
-- 5	7


-- Appointment volume per department
SELECT department_id, COUNT(*) AS appointment_count
FROM appointments
GROUP BY department_id
ORDER BY department_id;

-- "department_id"	"appointment_count"
-- 1	1650
-- 2	329
-- 3	347
-- 4	354
-- 5	321


-- Referral volume per provider (referring)
SELECT referring_provider_id, COUNT(*) AS referral_count
FROM referrals
GROUP BY referring_provider_id
ORDER BY referral_count DESC;

-- "referring_provider_id"	"referral_count"
-- 18	55
-- 14	54
-- 17	51
-- 8	51
-- 15	49
-- 13	48
-- 1	48
-- 2	44
-- 16	44
-- 6	42
-- 3	41
-- 5	39
-- 10	38
-- 11	37
-- 4	37
-- 9	35
-- 12	35
-- 7	28
-- 19	25


-- Appointment outcomes distribution
SELECT appointment_outcome, COUNT(*) AS total
FROM appointments
GROUP BY appointment_outcome
ORDER BY total DESC;

-- "appointment_outcome"	"total"
-- "Completed"	2502
-- "No-Show"	356
-- "Canceled"	143


-- Referral outcomes distribution
SELECT referral_outcome, COUNT(*) AS total
FROM referrals
GROUP BY referral_outcome
ORDER BY total DESC;

-- "referral_outcome"			"total"
-- "Completed In-Network"		472
-- "Not Scheduled"				197
-- "Completed Out-of-Network"	132



-- 7. Foreign Key Verification
-- Purpose: Double-check that foreign keys are set up correctly

SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY';

-- "table_name"	"column_name"	"referenced_table"	"referenced_column"
-- "appointments"	"department_id"	"departments"	"department_id"
-- "appointments"	"patient_id"	"patients"	"patient_id"
-- "appointments"	"provider_id"	"providers"	"provider_id"
-- "departments"	"department_head_id"	"providers"	"provider_id"
-- "providers"	"department_id"	"departments"	"department_id"
-- "referrals"	"patient_id"	"patients"	"patient_id"
-- "referrals"	"referred_to_provider_id"	"providers"	"provider_id"
-- "referrals"	"referring_provider_id"	"providers"	"provider_id"


