USE HEALTHCARE_DATASET;

-- View general structure of the dataset
SELECT *, COUNT(*) OVER() AS num_rows
FROM HEALTHCARE_DATASET
LIMIT 5;


-- Get unique counts for bloodtype, medical condition, & insurance provider
SELECT
    COUNT(DISTINCT BLOODTYPE) AS unique_bloodtypes, 
    COUNT(DISTINCT MEDICALCONDITION) AS unique_medical_conditions,
    COUNT(DISTINCT INSURANCEPROVIDER) AS unique_insurance_providers
FROM
    HEALTHCARE_DATASET;


-- Distribution of patient ages in bins of 10 years
SELECT 
  CASE 
    WHEN AGE BETWEEN 0 AND 9 THEN '0-9'
    WHEN AGE BETWEEN 10 AND 19 THEN '10-19'
    WHEN AGE BETWEEN 20 AND 29 THEN '20-29'
    WHEN AGE BETWEEN 30 AND 39 THEN '30-39'
    WHEN AGE BETWEEN 40 AND 49 THEN '40-49'
    WHEN AGE BETWEEN 50 AND 59 THEN '50-59'
    WHEN AGE BETWEEN 60 AND 69 THEN '60-69'
    WHEN AGE BETWEEN 70 AND 79 THEN '70-79'
    WHEN AGE BETWEEN 80 AND 89 THEN '80-89'
    WHEN AGE BETWEEN 90 AND 99 THEN '90-99'
    ELSE '100+'
  END AS age_group,
  COUNT(*) AS count
FROM 
  HEALTHCARE_DATASET
GROUP BY 
  age_group
ORDER BY 
  age_group;


-- Average billing by insurance provider and admission type
SELECT INSURANCEPROVIDER, ADMISSIONTYPE, TO_CHAR(AVG(BILLINGAMOUNT), '$999,999,999.00') AS avg_billing
FROM HEALTHCARE_DATASET
GROUP BY INSURANCEPROVIDER, ADMISSIONTYPE
ORDER BY avg_billing DESC;


-- Standardize names to proper case
SELECT
    INITCAP(NAME) AS standardized_name, *
FROM
    HEALTHCARE_DATASET;

    
-- Identify outliers in AGE and BILLINGAMOUNT
SELECT AGE, BILLINGAMOUNT 
FROM HEALTHCARE_DATASET
WHERE AGE > 100 
OR BILLINGAMOUNT > (SELECT AVG(BILLINGAMOUNT) + 3 * STDDEV(BILLINGAMOUNT) 
FROM HEALTHCARE_DATASET);

-- Drilling down to one hospital (Sons and Miller)
SELECT *
FROM HEALTHCARE_DATASET
WHERE HOSPITAL = 'Sons and Miller';

-- Patient count by medical condition
SELECT
  MEDICALCONDITION,
  COUNT(*) AS patient_count
FROM
  HEALTHCARE_DATASET
WHERE HOSPITAL = 'Sons and Miller'
GROUP BY MEDICALCONDITION
ORDER BY patient_count DESC;

-- Average billing by admission type
SELECT
  ADMISSIONTYPE,
  TO_CHAR(AVG(BILLINGAMOUNT), '$999,999,999.00') AS average_billing
FROM
  HEALTHCARE_DATASET
WHERE HOSPITAL = 'Sons and Miller'
GROUP BY ADMISSIONTYPE
ORDER BY average_billing DESC;

-- Distribution of patient count by age by groups
SELECT
  CASE 
    WHEN AGE BETWEEN 0 AND 18 THEN '0-18'
    WHEN AGE BETWEEN 19 AND 35 THEN '19-35'
    WHEN AGE BETWEEN 36 AND 50 THEN '36-50'
    WHEN AGE BETWEEN 51 AND 65 THEN '51-65'
    ELSE '65+'
  END AS age_group,
  COUNT(*) AS patient_count
FROM
  HEALTHCARE_DATASET
WHERE HOSPITAL = 'Sons and Miller'
GROUP BY age_group
ORDER BY age_group;

-- Top 5 doctors with highest patient count at Sons and Miller
SELECT
  DOCTOR,
  COUNT(*) AS patient_count
FROM
  HEALTHCARE_DATASET
WHERE HOSPITAL = 'Sons and Miller'
GROUP BY DOCTOR
ORDER BY patient_count DESC
LIMIT 5;

-- Average length of stay by medical condition
SELECT
  MEDICALCONDITION,
  TRUNC(AVG(DATEDIFF(DAY, DATEOFADMISSION, DISCHARGEDATE))) AS avg_length_of_stay
FROM
  HEALTHCARE_DATASET
WHERE HOSPITAL = 'Sons and Miller'
GROUP BY MEDICALCONDITION
ORDER BY avg_length_of_stay DESC;

-- Average billing amount by medical condition, formatted as dollar ammount
SELECT
  MEDICALCONDITION,
  TO_CHAR(AVG(BILLINGAMOUNT), '$999,999,999.00') AS avg_billing_amount
FROM
  HEALTHCARE_DATASET
WHERE HOSPITAL = 'Sons and Miller'
GROUP BY MEDICALCONDITION
ORDER BY avg_billing_amount DESC;

-- Sum billing amount by insurance provider, formatted as dollar ammount
SELECT
  INSURANCEPROVIDER,
  TO_CHAR(SUM(BILLINGAMOUNT), '$999,999,999.00') AS total_billing
FROM
  HEALTHCARE_DATASET
WHERE HOSPITAL = 'Sons and Miller'
GROUP BY INSURANCEPROVIDER
ORDER BY total_billing DESC
LIMIT 5;

-- Check to see if there is a correlation between age and billing amount
SELECT
  CORR(AGE, BILLINGAMOUNT) AS age_billing_correlation
FROM
  HEALTHCARE_DATASET
WHERE HOSPITAL = 'Sons and Miller';
