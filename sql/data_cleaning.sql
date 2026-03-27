-- Project: Clinical Operations Dashboard
-- File: data_cleaning.sql
-- Purpose: Create cleaned views for analysis by standardizing fields, handling missing values, and converting booleans
-- Author: Ari M.



-- 1. Cleaned Views

-- 1a. Cleaned Patients View
-- Purpose: Standardize patient info, handle missing values, and prepare boolean flags for analysis

CREATE VIEW patients_clean AS
SELECT
    patient_id,
    first_name,
    last_name,
    date_of_birth,
    age,
    gender,
    -- Replacing NULL contact method with 'Unknown'
    COALESCE(preferred_contact_method, 'Unknown') AS preferred_contact_method,
    -- Converting Yes/No to boolean for easier analysis
    (pt_has_appt_y_n = 'Yes') AS has_appointment,
    (pt_has_referral_y_n = 'Yes') AS has_referral,
    -- Filling in missing insurance_type with 'Unknown' as well for easier analysis 
    COALESCE(insurance_type, 'Unknown') AS insurance_type,
    zip_code,
    patient_risk_score,
    registration_date
FROM patients;



-- 1b. Cleaned Providers View
-- Purpose: Standardize provider info for analytics

CREATE VIEW providers_clean AS
SELECT
    provider_id,
    first_name,
    last_name,
    specialty,
    tenure_years,
    COALESCE(clinic_location, 'Unknown') AS clinic_location,
    fte_status,
    department_id,
    active_months,
    min_patient_age_for_specialty,
    max_patient_age_for_specialty,
    fte_value,
    clinic_days_per_week,
    appointment_slots_per_week,
    annual_capacity
FROM providers;



-- 1c. Cleaned Appointments View
-- Purpose: Standardize appointments, handle missing flags, and create boolean for cancellations

CREATE VIEW appointments_clean AS
SELECT
    appointment_id,
    patient_id,
    provider_id,
    department_id,
    appointment_date,
    appointment_time,
    appointment_type,
    appointment_outcome,
    visit_reason,
    visit_duration,
    appointment_cost,
    scheduled_date,
    check_in_time,
    -- Converting Yes/No to boolean to make it easier to analyze
    (cancellation_flag = 'Yes') AS is_canceled
FROM appointments;



-- 1d. Cleaned Referrals View
-- Purpose: Standardize referral info, handle missing flags, and create boolean for SLA breaches

CREATE VIEW referrals_clean AS
SELECT
    referral_id,
    patient_id,
    referring_provider_id,
    referred_to_provider_id,
    referral_order_date,
    referral_priority,
    referral_reason,
    target_sla_days,
    referral_scheduled,
    days_to_schedule,
    -- Converting Yes/No to boolean to so the analysis can be done more easily
    (sla_breach_flag = 'Yes') AS sla_breach,
    referral_outcome,
    completed_in_network,
    completed_out_of_network,
    not_scheduled,
    expected_revenue,
    lost_revenue,
    referred_to_specialty
FROM referrals;



-- 1e. Cleaned Departments View
-- Purpose: Standardize department info and handle potential missing locations

CREATE VIEW departments_clean AS
SELECT
    department_id,
    department_name,
    COALESCE(location, 'Unknown') AS location,
    department_head_id,
    floor,
    default_reimbursement
FROM departments;



-- 2. Quick Spot Checks
-- Purpose: Verify views are created and data looks reasonable


-- 2a. Quick preview to verify patients_clean view
SELECT * FROM patients_clean LIMIT 10;

-- "patient_id"	"first_name"	"last_name"	"date_of_birth"	"age"	"gender"	"preferred_contact_method"	"has_appointment"	"has_referral"	"insurance_type"	"zip_code"	"patient_risk_score"	"registration_date"
-- 1	"Toni"	"Grant"	"1987-01-14"	37	"Male"	"Unknown"	true	true	"Commercial"	"48086"	65	"2023-06-03"
-- 2	"Ash"	"Porter"	"1979-01-08"	45	"Male"	"Email"	true	false	"Commercial"	"48172"	18	"2023-12-04"
-- 3	"Vian"	"Peterson"	"1994-09-24"	30	"Female"	"Unknown"	true	false	"Commercial"	"48657"	48	"2022-12-02"
-- 4	"Skylar"	"Howard"	"2007-07-24"	17	"Male"	"Email"	true	false	"Medicaid"	"49248"	11	"2022-05-04"
-- 5	"Cobalt"	"Knight"	"1967-05-23"	57	"Male"	"Email"	true	false	"Self-Pay"	"48626"	79	"2024-09-03"
-- 6	"Avi"	"Davis"	"2012-03-23"	12	"Male"	"Email"	true	false	"Commercial"	"49849"	48	"2022-10-31"
-- 7	"Oakley"	"Dean"	"1954-06-10"	70	"Female"	"Phone"	true	false	"Medicare"	"48211"	21	"2024-12-23"
-- 8	"Baylor"	"Johnston"	"2005-07-07"	19	"Female"	"Phone"	true	false	"Commercial"	"49434"	55	"2023-09-25"
-- 9	"Hunter"	"Albert"	"1965-04-27"	59	"Female"	"Unknown"	true	false	"Medicaid"	"48307"	92	"2024-03-20"
-- 10	"Teal"	"Fernandez"	"1980-09-09"	44	"Male"	"Email"	true	false	"Commercial"	"48530"	33	"2022-07-17"


-- 2b. Quick preview to verify providers_clean view
SELECT * FROM providers_clean LIMIT 10;

-- "provider_id"	"first_name"	"last_name"	"specialty"	"tenure_years"	"clinic_location"	"fte_status"	"department_id"	"active_months"	"min_patient_age_for_specialty"	"max_patient_age_for_specialty"	"fte_value"	"clinic_days_per_week"	"appointment_slots_per_week"	"annual_capacity"
-- 1	"Lee"	"Griffin"	"Primary Care"	25	"Main"	"Part-Time"	1	"2,3,4,5,6,8,11,12"	0	100	0.8	4	80	4000
-- 2	"Fawn"	"Warren"	"Primary Care"	25	"Main"	"Full-Time"	1	"All Year"	0	100	1	5	100	5000
-- 3	"Juniper"	"Allison"	"Primary Care"	25	"Main"	"Full-Time"	1	"All Year"	0	100	1	4	100	5000
-- 4	"Sutton"	"Clark"	"Primary Care"	3	"Main"	"Part-Time"	1	"1,3,4,5,6,9,10,11"	0	100	0.5	3	50	2500
-- 5	"Rylan"	"Diaz"	"Primary Care"	5	"Main"	"Full-Time"	1	"All Year"	0	100	1	5	100	5000
-- 6	"Shai"	"Wilson"	"Primary Care"	10	"Main"	"Full-Time"	1	"All Year"	0	100	1	4	100	5000
-- 7	"Rowan"	"Murray"	"Primary Care"	15	"Main"	"Full-Time"	1	"All Year"	0	100	1	5	100	5000
-- 8	"Sami"	"Cook"	"Primary Care"	4	"Main"	"Full-Time"	1	"All Year"	0	100	1	5	100	5000
-- 9	"Keely"	"Elliott"	"Primary Care"	25	"Main"	"Part-Time"	1	"1,2,3,5,6"	0	100	0.4	2	40	2000
-- 10	"Logan"	"Willis"	"Primary Care"	16	"Main"	"Part-Time"	1	"1,2,3,4,5,6,7,8,10,12"	0	100	0.7	4	70	3500


-- 2c. Quick preview to verify appointments_clean view
SELECT * FROM appointments_clean LIMIT 10;

-- "appointment_id"	"patient_id"	"provider_id"	"department_id"	"appointment_date"	"appointment_time"	"appointment_type"	"appointment_outcome"	"visit_reason"	"visit_duration"	"appointment_cost"	"scheduled_date"	"check_in_time"	"is_canceled"
-- 1	791	6	1	"2024-04-14"	"9:30 AM"	"Follow-up"	"Completed"	"Lab Review"	26	265	"2024-03-30"	"9:47 AM"	false
-- 2	418	11	1	"2024-03-16"	"8:00 AM"	"Procedure"	"No-Show"	"Procedure Needed"	0	0	"2024-03-16"		false
-- 3	824	12	1	"2024-03-14"	"3:30 PM"	"Follow-up"	"Completed"	"Preventive Visit"	55	265	"2024-03-14"	"3:35 PM"	false
-- 4	776	4	1	"2023-03-14"	"4:45 PM"	"Follow-up"	"Completed"	"Lab Review"	37	272	"2023-02-14"	"4:59 PM"	false
-- 5	992	2	1	"2023-04-19"	"8:00 AM"	"Procedure"	"Completed"	"Procedure Needed"	20	262	"2023-04-19"	"8:10 AM"	false
-- 6	214	10	1	"2023-12-16"	"4:30 PM"	"Follow-up"	"Completed"	"Chronic Disease Management"	58	255	"2023-11-16"	"4:38 PM"	false
-- 7	719	8	1	"2023-03-02"	"3:15 PM"	"New Patient"	"Completed"	"Routine Check"	54	258	"2023-02-14"	"3:29 PM"	false
-- 8	688	13	1	"2023-09-22"	"8:00 AM"	"New Patient"	"Completed"	"Initial Consultation"	43	246	"2023-08-29"	"8:19 AM"	false
-- 9	204	17	1	"2023-04-10"	"11:30 AM"	"New Patient"	"Completed"	"Initial Consultation"	15	269	"2023-04-10"	"11:39 AM"	false
-- 10	107	8	1	"2024-09-16"	"2:15 PM"	"Follow-up"	"Completed"	"Chronic Disease Management"	49	247	"2024-09-10"	"2:34 PM"	false


-- 2d. Quick preview to verify referrals_clean view
SELECT * FROM referrals_clean LIMIT 10;

-- "referral_id"	"patient_id"	"referring_provider_id"	"referred_to_provider_id"	"referral_order_date"	"referral_priority"	"referral_reason"	"target_sla_days"	"referral_scheduled"	"days_to_schedule"	"sla_breach"	"referral_outcome"	"completed_in_network"	"completed_out_of_network"	"not_scheduled"	"expected_revenue"	"lost_revenue"	"referred_to_specialty"
-- 1	29	16	32	"2024-01-21"	"Routine"	"Advanced Imaging"	30	"2024-02-29"	39	true	"Completed In-Network"	1	0	0	500	0	"Cardiology"
-- 2	178	3	40	"2024-03-24"	"Routine"	"Diagnostic Testing"	30	"2024-04-18"	25	false	"Completed In-Network"	1	0	0	500	0	"Cardiology"
-- 3	8	19	28	"2023-05-13"	"Urgent"	"Treatment Planning"	7	"2023-06-14"	32	true	"Completed Out-of-Network"	0	1	0	0	500	"Cardiology"
-- 4	311	18	49	"2023-06-12"	"Routine"	"Specialty Evaluation"	30	"2023-07-07"	25	false	"Completed Out-of-Network"	0	1	0	0	600	"Orthopedics"
-- 5	935	18	37	"2024-03-02"	"Urgent"	"Advanced Imaging"	7			true	"Not Scheduled"	0	0	1	0	600	"Orthopedics"
-- 6	153	6	38	"2024-10-06"	"Routine"	"Treatment Planning"	30	"2024-10-29"	23	false	"Completed In-Network"	1	0	0	600	0	"Dermatology"
-- 7	533	18	36	"2024-12-15"	"Urgent"	"Treatment Planning"	7	"2025-01-07"	23	true	"Completed In-Network"	1	0	0	500	0	"Cardiology"
-- 8	772	10	35	"2024-07-09"	"Routine"	"Treatment Planning"	30	"2024-07-17"	8	false	"Completed In-Network"	1	0	0	200	0	"Neurology"
-- 9	258	18	40	"2024-05-14"	"Urgent"	"Specialty Evaluation"	7	"2024-05-17"	3	false	"Completed In-Network"	1	0	0	500	0	"Cardiology"
-- 10	557	8	21	"2024-03-10"	"Routine"	"Surgical Consultation"	30	"2024-03-19"	9	false	"Completed In-Network"	1	0	0	600	0	"Orthopedics"


-- 2e. Quick preview to verify departments_clean view (expecting 5 rows)
SELECT * FROM departments_clean LIMIT 10;

-- "department_id"	"department_name"	"location"	"department_head_id"	"floor"	"default_reimbursement"
-- 1	"Primary Care"	"Main"	10	"Floor 5"	260
-- 2	"Cardiology"	"North"	32	"Floor 1"	260
-- 3	"Orthopedics"	"East"	49	"Floor 1"	260
-- 4	"Dermatology"	"West"	50	"Floor 2"	120
-- 5	"Neurology"	"South"	43	"Floor 2"	120
