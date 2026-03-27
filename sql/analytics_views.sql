-- Project: Clinical Operations Dashboard
-- File: analytics_views.sql
-- Purpose: Create dashboard-ready analytics views derived from cleaned data
-- Author: Ari M.



-- 1. Analytical Views

-- 1a. Patient Risk Categories
-- Purpose: Categorize patients by risk score for dashboards

CREATE VIEW patient_risk_categories AS
SELECT
    patient_id,
    age,
    gender,
    patient_risk_score,
    CASE
        WHEN patient_risk_score >= 75 THEN 'High Risk'
        WHEN patient_risk_score >= 40 THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM patients_clean;



-- 1b. Provider Workload Summary
-- Purpose: Summarize appointments per provider

CREATE VIEW provider_workload_summary AS
SELECT
    p.provider_id,
    p.first_name,
    p.last_name,
    p.specialty,

    COUNT(a.appointment_id) AS total_appointments,

    SUM(CASE 
        WHEN a.is_canceled THEN 1 
        ELSE 0 
    END) AS canceled_appointments,

    SUM(CASE 
        WHEN a.appointment_outcome = 'No-Show' 
        THEN 1 
        ELSE 0 
    END) AS no_show_appointments,

    SUM(CASE 
        WHEN a.appointment_outcome = 'Completed' 
             AND NOT a.is_canceled 
        THEN 1 
        ELSE 0 
    END) AS completed_appointments

FROM providers_clean p
LEFT JOIN appointments_clean a
    ON p.provider_id = a.provider_id

GROUP BY 
    p.provider_id, 
    p.first_name, 
    p.last_name, 
    p.specialty;



-- 1c. Referral SLA Performance
-- Purpose: Track SLA breaches and referral outcomes

CREATE VIEW referral_sla_summary AS
SELECT
    referred_to_specialty,
    COUNT(referral_id) AS total_referrals,
    SUM(CASE WHEN sla_breach THEN 1 ELSE 0 END) AS sla_breaches,
    SUM(CASE WHEN NOT sla_breach THEN 1 ELSE 0 END) AS on_time_referrals,
    SUM(expected_revenue) AS total_expected_revenue,
    SUM(lost_revenue) AS total_lost_revenue
FROM referrals_clean
GROUP BY referred_to_specialty;



-- 1d. Appointment Timeliness
-- Purpose: Compute lead time between scheduling and appointment
-- Lead time helps measure scheduling efficiency and access to care

CREATE VIEW appointment_lead_time AS
SELECT
    appointment_id,
    patient_id,
    provider_id,
    department_id,
    appointment_date,
    scheduled_date,
    (appointment_date - scheduled_date) AS lead_days
FROM appointments_clean;



-- 1e. Department-Level Summary (Enhanced with appointment breakdown)
-- Purpose: Aggregate provider, patient, and appointment metrics per department

CREATE VIEW department_summary AS
-- Use CTEs to avoid row multiplication from joining multiple fact tables
WITH appointment_stats AS (
    SELECT
        department_id,
        COUNT(*) AS total_appointments,
	     -- Appointment breakdown by outcome
        SUM(CASE WHEN is_canceled THEN 1 ELSE 0 END) AS canceled_appointments,
        SUM(CASE WHEN appointment_outcome = 'No-Show' THEN 1 ELSE 0 END) AS no_show_appointments,
        SUM(CASE 
                WHEN appointment_outcome = 'Completed' AND NOT is_canceled 
                THEN 1 ELSE 0 
            END) AS completed_appointments,
        COUNT(DISTINCT patient_id) AS unique_patients
    FROM appointments_clean
    GROUP BY department_id
),

provider_stats AS (
    SELECT
        department_id,
        COUNT(DISTINCT provider_id) AS total_providers
    FROM providers_clean
    GROUP BY department_id
)

SELECT
    d.department_id,
    d.department_name,
    COALESCE(a.unique_patients, 0) AS unique_patients,
    COALESCE(p.total_providers, 0) AS total_providers,
    COALESCE(a.canceled_appointments, 0) AS canceled_appointments,
    COALESCE(a.no_show_appointments, 0) AS no_show_appointments,
    COALESCE(a.completed_appointments, 0) AS completed_appointments,
    COALESCE(a.total_appointments, 0) AS total_appointments

FROM departments_clean d
LEFT JOIN appointment_stats a
    ON d.department_id = a.department_id
LEFT JOIN provider_stats p
    ON d.department_id = p.department_id

ORDER BY d.department_name;



-- 2. Quick Spot Checks
-- Purpose: Verify that the views are created and the data looks reasonable

-- 2a. Quick preview to verify patient_risk_categories view
SELECT * FROM patient_risk_categories LIMIT 10;

-- "patient_id"	"age"	"gender"	"patient_risk_score"	"risk_category"
-- 1	37	"Male"	65	"Moderate Risk"
-- 2	45	"Male"	18	"Low Risk"
-- 3	30	"Female"	48	"Moderate Risk"
-- 4	17	"Male"	11	"Low Risk"
-- 5	57	"Male"	79	"High Risk"
-- 6	12	"Male"	48	"Moderate Risk"
-- 7	70	"Female"	21	"Low Risk"
-- 8	19	"Female"	55	"Moderate Risk"
-- 9	59	"Female"	92	"High Risk"
-- 10	44	"Male"	33	"Low Risk"

-- 2b. Quick preview to verify provider_workload_summary view
SELECT * FROM provider_workload_summary LIMIT 10;

-- "provider_id"	"first_name"	"last_name"	"specialty"	"total_appointments"	"canceled_appointments"	"no_show_appointments"	"completed_appointments"
-- 22	"London"	"Santiago"	"Dermatology"	47	2	3	42
-- 42	"Winslow"	"Dixon"	"Dermatology"	47	3	6	38
-- 40	"Pax"	"Turner"	"Cardiology"	41	3	5	33
-- 43	"Akira"	"Ortiz"	"Neurology"	54	3	9	42
-- 15	"Kim"	"Daniels"	"Primary Care"	78	3	9	66
-- 48	"Blaine"	"Montgomery"	"Cardiology"	41	2	7	32
-- 19	"Riven"	"Turner"	"Primary Care"	60	4	6	50
-- 5	"Rylan"	"Diaz"	"Primary Care"	81	2	9	70
-- 29	"Jory"	"Wells"	"Orthopedics"	47	2	2	43
-- 4	"Sutton"	"Clark"	"Primary Care"	92	7	7	78


-- 2c. Quick preview to verify referral_sla_summary view
SELECT * FROM referral_sla_summary LIMIT 10;

-- "referred_to_specialty"	"total_referrals"	"sla_breaches"	"on_time_referrals"	"total_expected_revenue"	"total_lost_revenue"
-- "Orthopedics"	210	111	99	76800	49200
-- "Dermatology"	193	113	80	68400	47400
-- "Cardiology"	224	141	83	67000	45000
-- "Neurology"	174	99	75	19200	15600


-- 2d. Quick preview to verify appointment_lead_time view
SELECT * FROM appointment_lead_time LIMIT 10;

-- "appointment_id"	"patient_id"	"provider_id"	"department_id"	"appointment_date"	"scheduled_date"	"lead_days"
-- 1	791	6	1	"2024-04-14"	"2024-03-30"	15
-- 2	418	11	1	"2024-03-16"	"2024-03-16"	0
-- 3	824	12	1	"2024-03-14"	"2024-03-14"	0
-- 4	776	4	1	"2023-03-14"	"2023-02-14"	28
-- 5	992	2	1	"2023-04-19"	"2023-04-19"	0
-- 6	214	10	1	"2023-12-16"	"2023-11-16"	30
-- 7	719	8	1	"2023-03-02"	"2023-02-14"	16
-- 8	688	13	1	"2023-09-22"	"2023-08-29"	24
-- 9	204	17	1	"2023-04-10"	"2023-04-10"	0
-- 10	107	8	1	"2024-09-16"	"2024-09-10"	6


-- 2e. Quick preview to verify department_summary view
SELECT * FROM department_summary LIMIT 10;

-- "department_id"	"department_name"	"unique_patients"	"total_providers"	"canceled_appointments"	"no_show_appointments"	"completed_appointments"	"total_appointments"
-- 2	"Cardiology"	282	8	14	41	274	329
-- 4	"Dermatology"	309	8	18	46	290	354
-- 5	"Neurology"	272	7	19	39	263	321
-- 3	"Orthopedics"	290	8	20	37	290	347
-- 1	"Primary Care"	814	19	72	193	1385	1650



