-- Create the Table
CREATE TABLE bank (age INT, job VARCHAR, marital VARCHAR, education VARCHAR, "default" VARCHAR,
 				   balance INT, housing VARCHAR, loan VARCHAR, contact VARCHAR, day INT, month VARCHAR, 
				   duration INT, campaign INT, pdays INT, previous INT, poutcome VARCHAR, y VARCHAR);
				   
SELECT *
FROM bank

-- Import data from CSV into the table using the drop down option

-- Check the data
SELECT *
FROM bank
LIMIT 10

-- Count the total rows
SELECT COUNT(*)
FROM bank

-- Exploratory data analysis
-- Checking for null or blank values
-- Checking for and removing duplicated value
-- Standardize the data
-- Remove unnecessary columns

-- We replicate the bank data before working further on it
CREATE TABLE bank_2 AS
SELECT * FROM bank;

SELECT *
FROM bank_2

-- Check for duplicates
SELECT *,
ROW_NUMBER() OVER(PARTITION BY age, job, marital, education, balance, duration, campaign, y, pdays)
FROM bank_2

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY age, job, marital, education, balance, duration, campaign, y, pdays)
FROM bank_2
)
SELECT * FROM duplicate_cte
WHERE row_number >1

/*
From the above, there are no duplicate data
*/

--Standardizing the data
SELECT DISTINCT job
FROM bank_2

SELECT DISTINCT marital
FROM bank_2

SELECT DISTINCT education
FROM bank_2

SELECT DISTINCT contact
FROM bank_2

SELECT DISTINCT poutcome
FROM bank_2

SELECT day, month
FROM bank_2

SELECT day || ' ' || month
FROM bank_2

-- Add a new column to join day and month
ALTER TABLE bank_2
ADD COLUMN "date" VARCHAR;

UPDATE bank_2
SET date = month || ' ' || day;

SELECT date
FROM bank_2;

SELECT UPPER(date)
FROM bank_2;

UPDATE bank_2
SET date = INITCAP(date);

SELECT date
FROM bank_2;

/*
Exploratory Analysis
*/
SELECT *
FROM bank_2;

-- Age
SELECT MAX(age), AVG(age), MIN(age)
FROM bank_2;

SELECT MAX(duration), MAX(duration)/60 AS max_duration
FROM bank_2

SELECT MIN(duration), MIN(duration)/60 AS min_duration
FROM bank_2

SELECT MIN(age) AS min_age, MAX(age) AS max_age
FROM bank_2;

-- Group age into categories
SELECT CASE 
		WHEN age <=30 THEN 'Less than 30 Years'
		WHEN age <=50 THEN '31 - 50 Years'
		ELSE 'Above 50 Years'
		END AS age_cat
FROM bank_2;

-- Insert age categories into the Table
ALTER TABLE bank_2
ADD COLUMN age_cat VARCHAR;

UPDATE bank_2
SET age_cat =
		CASE 
		WHEN age <=30 THEN 'Less than 30 Years'
		WHEN age <=50 THEN '31 - 50 Years'
		ELSE 'Above 50 Years'
		END;
		
SELECT COUNT(age_cat)
FROM bank_2;

SELECT age_cat
FROM bank_2
LIMIT 10;

-- Explore age category based on other variables
SELECT age_cat, SUM(duration)/60 AS duration_min
FROM bank_2
GROUP BY age_cat;

SELECT *
FROM bank_2;

SELECT age_cat, contact, COUNT(contact) AS contact
FROM bank_2
GROUP BY age_cat, contact
ORDER BY age_cat;

SELECT age_cat, poutcome, COUNT(*) AS outcome
FROM bank_2
GROUP BY age_cat, poutcome
ORDER BY outcome DESC;

SELECT age_cat, poutcome, COUNT(*) AS outcome
FROM bank_2
WHERE poutcome IN('success','failure')
GROUP BY age_cat, poutcome
ORDER BY age_cat;

--Count of outcome
SELECT poutcome, COUNT(poutcome)
FROM bank_2
GROUP BY poutcome; --From this, the success rate is very low

--Subscription per month
SELECT month, COUNT(*) AS total,
       SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed
FROM bank_2
GROUP BY month
ORDER BY subscribed DESC;

-- Call by month
SELECT month, SUM(duration)/60, AVG(duration)/60
FROM bank_2
GROUP BY month;

-- Defeault in credit by age, marital status, job, education
SELECT age_cat, "default", COUNT("default")
FROM bank_2
GROUP BY age_cat, "default"
ORDER BY age_cat;

--Default by education
SELECT education, "default", COUNT("default")
FROM bank_2
GROUP BY education, "default"
ORDER BY education;

--Default by marital status
SELECT marital, "default", COUNT("default")
FROM bank_2
GROUP BY marital, "default"
ORDER BY marital;

-- Default by job
SELECT job, "default", COUNT("default")
FROM bank_2
GROUP BY job, "default"
ORDER BY job;

SELECT *
FROM bank_2;

/*
Loan by age category
*/
-- housing loan
SELECT age_cat, housing, COUNT(housing)
FROM bank_2
GROUP BY age_cat, housing
ORDER BY age_cat;

SELECT  -- proportion
  age_cat, 
  housing, 
  COUNT(*) AS count,
  ROUND(COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY age_cat), 3) AS proportion
FROM bank_2
GROUP BY age_cat, housing
ORDER BY age_cat, housing;

-- personal loan
SELECT age_cat, loan, COUNT(loan)
FROM bank_2
GROUP BY age_cat, loan
ORDER BY age_cat;

SELECT   --proportion
  age_cat, 
  loan, 
  COUNT(*) AS count,
  ROUND(COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY age_cat), 3) AS proportion
FROM bank_2
GROUP BY age_cat, loan
ORDER BY age_cat, loan;

/*
Loan by education
*/
-- housing loan
SELECT education, housing, COUNT(housing)
FROM bank_2
GROUP BY education, housing
ORDER BY education;

SELECT  --proportion
  education, 
  housing, 
  COUNT(*) AS count,
  ROUND(COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY education), 3) AS proportion
FROM bank_2
GROUP BY education, housing
ORDER BY education, housing;

-- personal loan
SELECT education, loan, COUNT(loan)
FROM bank_2
GROUP BY education, loan
ORDER BY education;

SELECT   --proportion
  education, 
  loan, 
  COUNT(*) AS count,
  ROUND(COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY education), 3) AS proportion
FROM bank_2
GROUP BY education, loan
ORDER BY education, loan;

/*
Loan by marital status
*/
-- housing loan
SELECT marital, housing, COUNT(housing)
FROM bank_2
GROUP BY marital, housing
ORDER BY marital;

SELECT  --proportion
  marital, 
  housing, 
  COUNT(*) AS count,
  ROUND(COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY marital), 3) AS proportion
FROM bank_2
GROUP BY marital, housing
ORDER BY marital, housing;

-- personal loan
SELECT marital, loan, COUNT(loan)
FROM bank_2
GROUP BY marital, loan
ORDER BY marital;

SELECT   --proportion
  marital, 
  loan, 
  COUNT(*) AS count,
  ROUND(COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY marital), 3) AS proportion
FROM bank_2
GROUP BY marital, loan
ORDER BY marital, loan;
