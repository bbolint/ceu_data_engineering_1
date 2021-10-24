-- Step 1: Creating new database with raw .csv files (Operational Layer):
-- Step 1.1: Creating schema:
DROP SCHEMA IF EXISTS eagle_bank_db;
CREATE SCHEMA eagle_bank_db;
USE eagle_bank_db;

-- Step 1.2: Defining and importing clients table:
-- creating frame:
DROP TABLE IF EXISTS clients;
CREATE TABLE clients 
(
	client_id VARCHAR(9),
	sex VARCHAR(6),
	fulldate DATE,
	day INTEGER,
	month INTEGER,
	year INTEGER,
	age INTEGER,
	social VARCHAR(11),
	first VARCHAR(30),
	middle VARCHAR(30),
	last VARCHAR(30),
	phone VARCHAR(20),
	email VARCHAR(50),
	address_1 VARCHAR(30),
	address_2 VARCHAR(30),
	city VARCHAR(30),
	state VARCHAR(2),
	zipcode INTEGER,
	district_id INTEGER
);

-- loading data:
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\raw_data\\completedclient.csv' 
INTO TABLE clients 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(client_id, sex, fulldate, day, 
month, year, age, 
social, first, middle, 
last, phone, email, 
address_1, address_2, city, 
state, zipcode, district_id);

-- changing column names:
ALTER TABLE clients 
RENAME COLUMN fulldate TO birth_date,
RENAME COLUMN day TO birth_day,
RENAME COLUMN month TO birth_month,
RENAME COLUMN year TO birth_year,
RENAME COLUMN social TO social_number,
RENAME COLUMN first TO first_name,
RENAME COLUMN middle TO middle_name,
RENAME COLUMN last TO last_name;

-- check table:
SELECT * FROM eagle_bank_db.clients;


-- Step 1.3: Defining and importing disposition table:
-- creating frame:
DROP TABLE IF EXISTS disposition;
CREATE TABLE disposition 
(
	disp_id VARCHAR(9),
    client_id VARCHAR(9),
    account_id VARCHAR(9),
	type VARCHAR(6)
);

-- loading data:
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\raw_data\\completeddisposition.csv' 
INTO TABLE disposition 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(disp_id, client_id, account_id, type);

-- check table:
SELECT * FROM eagle_bank_db.disposition;

-- Step 1.4: Defining and importing cards table:
DROP TABLE IF EXISTS cards;
CREATE TABLE cards 
(
	card_id VARCHAR(9),
	disp_id VARCHAR(9),
	type VARCHAR(14),
	year INTEGER,
	month INTEGER,
	day INTEGER,
	fulldate DATE
);

-- loading data:
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\raw_data\\completedcard.csv' 
INTO TABLE cards 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(card_id, disp_id, type, year, month, day, fulldate);

-- changing column names:
ALTER TABLE cards 
RENAME COLUMN year TO purchase_year,
RENAME COLUMN month TO purchase_month,
RENAME COLUMN day TO purchase_day,
RENAME COLUMN fulldate TO purchase_date;

-- check table:
SELECT * FROM eagle_bank_db.cards;

-- Step 1.5: Defining and importing accounts table:
-- creating frame:
DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts 
(
	account_id VARCHAR(9),
	district_id INT,
	frequency VARCHAR(30),
	parseddate DATE,
	year INTEGER,
	month INTEGER,
	day INTEGER
);

-- loading data:
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\raw_data\\completedacct.csv' 
INTO TABLE accounts 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(account_id, district_id, frequency, parseddate, year, month, day);

-- changing column names:
ALTER TABLE accounts 
RENAME COLUMN year TO purchase_year,
RENAME COLUMN month TO purchase_month,
RENAME COLUMN day TO purchase_day,
RENAME COLUMN parseddate TO purchase_date;

-- check table:
SELECT * FROM eagle_bank_db.accounts;

-- Step 1.6: Defining and importing loans table:
-- creating frame:
DROP TABLE IF EXISTS loans;
CREATE TABLE loans 
(
	loan_id VARCHAR(9),
	account_id VARCHAR(9),
	amount INT,
	duration INT,
	payments INT,
	status VARCHAR(1),
	year INT,
	month INT,
	day INT,
	fulldate DATE,
	location INT,
	purpose VARCHAR(20)
);

-- loading data:
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\raw_data\\completedloan.csv' 
INTO TABLE loans 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(loan_id, account_id, amount, duration, payments, status, year, month, day, fulldate, location, purpose);

-- changing column names:
ALTER TABLE loans 
RENAME COLUMN year TO purchase_year,
RENAME COLUMN month TO purchase_month,
RENAME COLUMN day TO purchase_day,
RENAME COLUMN fulldate TO purchase_date;

-- check table:
SELECT * FROM eagle_bank_db.loans;

-- Step 1.6: Defining and importing districts table:
-- creating frame:
DROP TABLE IF EXISTS districts;
CREATE TABLE districts 
(
	district_id INTEGER,
	city VARCHAR(20),
	state_name VARCHAR(20),
	state_abbrev VARCHAR(2),
	region VARCHAR(20),
	division VARCHAR(20)
);

-- loading data:
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\raw_data\\completeddistrict.csv' 
INTO TABLE districts 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(district_id, city, state_name, state_abbrev, region, division);

-- check table:
SELECT * FROM eagle_bank_db.districts;

-- Step 1.7: Defining and importing orders table:
-- creating frame:
DROP TABLE IF EXISTS orders;
CREATE TABLE orders 
(
	order_id INTEGER,
	account_id VARCHAR(9),
	bank_to VARCHAR(2),
	account_to INTEGER,
	amount FLOAT,
	k_symbol VARCHAR(20)
);

-- loading data:
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\raw_data\\completedorder.csv' 
INTO TABLE orders 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(order_id, account_id, bank_to, account_to, amount, k_symbol);

-- Step 2: Creating analytical data layer to answer questions of interest
-- 2.1: Loan portfolio
-- 2.1.1: Creating table for overview of loan portfolio over time (per month, long table format). Fields: quarter, category, no_loans_active, sum_payments
-- creating table to store list of dates between first loan purchase and current date (2018-01-01):
DROP TABLE IF EXISTS loan_timeline;
CREATE TABLE loan_timeline
(
	date_loan_timeline DATE
);
-- creating procedure to calculate list of dates between first loan purchase and current date (2018-01-01):
DROP PROCEDURE IF EXISTS filldates;
DELIMITER $$
CREATE PROCEDURE filldates(dateEnd DATE)
BEGIN
    DECLARE dateStart DATE;
	DECLARE adate DATE;
    SET dateStart = (SELECT MIN(purchase_date) FROM loans);
	WHILE dateStart <= dateEnd DO
		SET adate = (SELECT date_loan_timeline FROM loan_timeline WHERE date_loan_timeline = dateStart);
		IF adate IS NULL THEN BEGIN
			INSERT INTO loan_timeline (date_loan_timeline) VALUES (dateStart);
		END; END IF;
		SET dateStart = date_add(dateStart, INTERVAL 1 DAY);
	END WHILE;
END;$$
DELIMITER ;
-- populating loan_timeline table with list of dates between first loan purchase and current date (2018-01-01):
CALL filldates('2018-01-01'); -- needs current date as input. as this is now the fictional 2018-01-01, I have to pass this manually
-- sanity check for list of dates between first loan purchase and current date (2018-01-01):
SELECT min(date_loan_timeline), max(date_loan_timeline) FROM loan_timeline;

-- listing for each date the active loans and aggregating per month and loan purpose:
DROP TABLE IF EXISTS loan_portfolio_per_month;
CREATE TABLE loan_portfolio_per_month AS
SELECT 
month,
purpose,
COUNT(loan_id) count_loans,
SUM(payments) sum_payments
FROM
(
	SELECT
	DISTINCT
	DATE_FORMAT(date_loan_timeline,'%Y-%m-01') month,
	loan_id,
	purpose,
	payments
	FROM
	(
		SELECT
		a.date_loan_timeline,
		b.purchase_date,
		b.end_date,
		b.loan_id,
		b.purpose,
		b.payments
		FROM loan_timeline a
		LEFT JOIN 
		(
			SELECT
			loan_id,
			purchase_date,
			DATE_ADD("2017-06-15", INTERVAL duration MONTH) end_date,
			purpose,
			payments
			FROM loans
		) b ON a.date_loan_timeline BETWEEN b.purchase_date AND b.end_date
	) monthly
) monthly_agg 
GROUP BY month, purpose;
-- check table:
SELECT * FROM loan_portfolio_per_month;

-- 2.1.2: Creating view for loan portfolio over time (per quarter, wide table). 
-- Fields: quarter, car_no_loans_active, car_sum_payments, debt_cons_no_loans_active, debt_cons_sum_payments, 
-- home_impr_no_loans_active, home_impr_sum_payments, home_no_loans_active, home_sum_payments
DROP VIEW IF EXISTS loan_portfolio_report;
CREATE VIEW loan_portfolio_report AS
SELECT
CONCAT(DATE_FORMAT(month,'%Y'),'-',QUARTER(month)) quarter,
ROUND(SUM(CASE WHEN purpose = 'car' THEN count_loans END)/4) AS car_avg_no_loans_active_per_month,
SUM(CASE WHEN purpose = 'car' THEN sum_payments END) AS car_sum_payments,
ROUND(SUM(CASE WHEN purpose = 'debt_consolidation' THEN count_loans END)/4) AS debt_cons_avg_no_loans_active_per_month,
SUM(CASE WHEN purpose = 'debt_consolidation' THEN sum_payments END) AS debt_cons_sum_payments,
ROUND(SUM(CASE WHEN purpose = 'home_improvement' THEN count_loans END)/4) AS home_impr_avg_no_loans_active_per_month,
SUM(CASE WHEN purpose = 'home_improvement' THEN sum_payments END) AS home_impr_sum_payments,
ROUND(SUM(CASE WHEN purpose = 'home' THEN count_loans END)/4) AS home_avg_no_loans_active_per_month,
SUM(CASE WHEN purpose = 'home' THEN sum_payments END) AS home_sum_payments
FROM loan_portfolio_per_month
GROUP BY CONCAT(DATE_FORMAT(month,'%Y'),'-',QUARTER(month));
-- check view:
SELECT * FROM loan_portfolio_report;

-- 2.1: Overview of sales over time per district. Fields: quarter, location, category, no_loans_active, sum_payments
-- 2.1.1.: create DW table sales_per_quarter (long table):
DROP TABLE IF EXISTS sales_per_quarter;
CREATE TABLE sales_per_quarter AS
SELECT
"accounts" product_cat,
frequency product_sub_cat,
CONCAT(purchase_year,'-',QUARTER(purchase_date)) quarter,
district_id,
COUNT(*) no_sales
FROM accounts
GROUP BY CONCAT(purchase_year,'-',QUARTER(purchase_date)), district_id, frequency
UNION ALL
SELECT
"cards" product_cat,
a.type product_sub_cat,
CONCAT(a.purchase_year,'-',QUARTER(a.purchase_date)) quarter,
c.district_id,
COUNT(*) no_sales
FROM cards a
LEFT JOIN disposition b ON b.disp_id = a.disp_id
LEFT JOIN clients c ON c.client_id = b.client_id
GROUP BY CONCAT(purchase_year,'-',QUARTER(purchase_date)), district_id, a.type
UNION ALL
SELECT
"loans" product_cat,
purpose product_sub_cat,
CONCAT(a.purchase_year,'-',QUARTER(a.purchase_date)) quarter,
c.district_id,
COUNT(*) no_sales
FROM LOANS a
LEFT JOIN disposition b ON b.account_id = a.account_id
LEFT JOIN clients c ON c.client_id = b.client_id
GROUP BY CONCAT(purchase_year,'-',QUARTER(purchase_date)), district_id, purpose;
-- check table:
SELECT * FROM sales_per_quarter;

-- 2.1.2.: Creating view for sales over time (per quarter per district, wide table):
DROP VIEW IF EXISTS sales_report;
CREATE VIEW sales_report AS
SELECT
quarter,
district_id,
SUM(CASE WHEN (product_cat = 'accounts' AND product_sub_cat = 'Monthly Issuance') THEN no_sales ELSE 0 END) AS acc_monthly_issuance,
SUM(CASE WHEN (product_cat = 'accounts' AND product_sub_cat = 'Issuance After Transaction') THEN no_sales ELSE 0 END) AS acc_issuance_after_tx,
SUM(CASE WHEN (product_cat = 'accounts' AND product_sub_cat = 'Weekly Issuance') THEN no_sales ELSE 0 END) AS acc_weekly_issuance,
SUM(CASE WHEN (product_cat = 'cards' AND product_sub_cat = 'VISA Signature') THEN no_sales ELSE 0 END) AS cards_visa_signature,
SUM(CASE WHEN (product_cat = 'cards' AND product_sub_cat = 'VISA Standard') THEN no_sales ELSE 0 END) AS cards_visa_standard,
SUM(CASE WHEN (product_cat = 'cards' AND product_sub_cat = 'VISA Infinite') THEN no_sales ELSE 0 END) AS cards_visa_infinite,
SUM(CASE WHEN (product_cat = 'loans' AND product_sub_cat = 'debt_consolidation') THEN no_sales ELSE 0 END) AS loans_debt_consolidation,
SUM(CASE WHEN (product_cat = 'loans' AND product_sub_cat = 'car') THEN no_sales ELSE 0 END) AS loans_car,
SUM(CASE WHEN (product_cat = 'loans' AND product_sub_cat = 'home_improvement') THEN no_sales ELSE 0 END) AS loans_home_improvement,
SUM(CASE WHEN (product_cat = 'loans' AND product_sub_cat = 'home') THEN no_sales ELSE 0 END) AS loans_home
FROM sales_per_quarter
GROUP BY quarter, district_id;
SELECT * FROM sales_report;
