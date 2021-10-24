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
-- 2.1.1: Creating procedure to calculate list of dates between first loan purchase and current date (2018-01-01):
DROP PROCEDURE IF EXISTS filldates;
DELIMITER $$
CREATE PROCEDURE filldates(dateEnd DATE)
BEGIN
	
    DECLARE dateStart DATE;
	DECLARE adate DATE;
    
    DROP TABLE IF EXISTS loan_timeline;
	CREATE TABLE loan_timeline
	(
	date_loan_timeline DATE
	);
    
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

-- 2.1.2: Creating procedure to list for each date the active loans and aggregating per month and loan purpose:
DROP PROCEDURE IF EXISTS create_loan_portfolio_per_month;
DELIMITER $$
CREATE PROCEDURE create_loan_portfolio_per_month()
BEGIN
	DROP TABLE IF EXISTS loan_portfolio_per_month;
	CREATE TABLE loan_portfolio_per_month AS
	SELECT 
	month,
	purpose,
	COUNT(loan_id) no_active_loans,
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
END;$$
DELIMITER ;
-- creating loan_portfolio_per_month table with stored procedure:
CALL create_loan_portfolio_per_month();
-- check table:
SELECT * FROM loan_portfolio_per_month;

-- 2.1.3: Creating procedure for view for loan portfolio over time (per quarter, wide table). 
DROP PROCEDURE IF EXISTS create_loan_portfolio_report;
DELIMITER $$
CREATE PROCEDURE create_loan_portfolio_report()
BEGIN
	DROP VIEW IF EXISTS loan_portfolio_report;
	CREATE VIEW loan_portfolio_report AS
	SELECT
	CONCAT(DATE_FORMAT(month,'%Y'),'-',QUARTER(month)) quarter,
	ROUND(SUM(CASE WHEN purpose = 'car' THEN no_active_loans END)/4) AS car_avg_no_loans_active_per_month,
	SUM(CASE WHEN purpose = 'car' THEN sum_payments END) AS car_sum_payments,
	ROUND(SUM(CASE WHEN purpose = 'debt_consolidation' THEN no_active_loans END)/4) AS debt_cons_avg_no_loans_active_per_month,
	SUM(CASE WHEN purpose = 'debt_consolidation' THEN sum_payments END) AS debt_cons_sum_payments,
	ROUND(SUM(CASE WHEN purpose = 'home_improvement' THEN no_active_loans END)/4) AS home_impr_avg_no_loans_active_per_month,
	SUM(CASE WHEN purpose = 'home_improvement' THEN sum_payments END) AS home_impr_sum_payments,
	ROUND(SUM(CASE WHEN purpose = 'home' THEN no_active_loans END)/4) AS home_avg_no_loans_active_per_month,
	SUM(CASE WHEN purpose = 'home' THEN sum_payments END) AS home_sum_payments
	FROM loan_portfolio_per_month
	GROUP BY CONCAT(DATE_FORMAT(month,'%Y'),'-',QUARTER(month));
END;$$
DELIMITER ;
CALL create_loan_portfolio_report();
-- check view:
SELECT * FROM loan_portfolio_report;

-- 2.2: Overview of sales over time per district
-- 2.2.1.: Create procedure for DW table sales_per_month (long table):
DROP PROCEDURE IF EXISTS create_sales_per_month;
DELIMITER $$
CREATE PROCEDURE create_sales_per_month()
BEGIN
	DROP TABLE IF EXISTS sales_per_month;
	CREATE TABLE sales_per_month AS
	SELECT
	"accounts" product_cat,
	frequency product_sub_cat,
	CONCAT(DATE_FORMAT(purchase_date,'%Y-%m'),'-01') month,
	district_id,
	COUNT(*) no_sales
	FROM accounts
	GROUP BY CONCAT(DATE_FORMAT(purchase_date,'%Y-%m'),'-01'), district_id, frequency
	UNION ALL
	SELECT
	"cards" product_cat,
	a.type product_sub_cat,
	CONCAT(DATE_FORMAT(purchase_date,'%Y-%m'),'-01') month,
	c.district_id,
	COUNT(*) no_sales
	FROM cards a
	LEFT JOIN disposition b ON b.disp_id = a.disp_id
	LEFT JOIN clients c ON c.client_id = b.client_id
	GROUP BY CONCAT(DATE_FORMAT(purchase_date,'%Y-%m'),'-01'), district_id, a.type
	UNION ALL
	SELECT
	"loans" product_cat,
	purpose product_sub_cat,
	CONCAT(DATE_FORMAT(purchase_date,'%Y-%m'),'-01') month,
	c.district_id,
	COUNT(*) no_sales
	FROM LOANS a
	LEFT JOIN disposition b ON b.account_id = a.account_id
	LEFT JOIN clients c ON c.client_id = b.client_id
	GROUP BY CONCAT(DATE_FORMAT(purchase_date,'%Y-%m'),'-01'), district_id, purpose;
END;$$
DELIMITER ;
CALL create_sales_per_month();
-- check table:
SELECT * FROM sales_per_month;

-- 2.2.2.: Creating procedure for view for sales over time (per quarter per district, wide table):
DROP PROCEDURE IF EXISTS create_sales_report;
DELIMITER $$
CREATE PROCEDURE create_sales_report()
BEGIN
	DROP VIEW IF EXISTS sales_report;
	CREATE VIEW sales_report AS
	SELECT
	CONCAT(DATE_FORMAT(month,'%Y'),'-',QUARTER(month)) quarter,
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
	FROM sales_per_month
	GROUP BY CONCAT(DATE_FORMAT(month,'%Y'),'-',QUARTER(month)), district_id;
END;$$
DELIMITER ;
CALL create_sales_report();
SELECT * FROM sales_report;

-- 3: Create triggers to update Data Warehouse if table(s) in operational layer change:
-- When the 'accounts' table changes:
DELIMITER $$
CREATE TRIGGER accounts_change
    AFTER UPDATE
    ON accounts FOR EACH ROW
BEGIN
    CALL create_sales_per_month();
END$$    
DELIMITER ;

-- When the 'cards' table changes:
DELIMITER $$
CREATE TRIGGER cards_change
    AFTER UPDATE
    ON cards FOR EACH ROW
BEGIN
    CALL create_sales_per_month();
END$$    
DELIMITER ;

-- When the 'clients' table changes:
DELIMITER $$
CREATE TRIGGER clients_change
    AFTER UPDATE
    ON clients FOR EACH ROW
BEGIN
    CALL create_sales_per_month();
END$$    
DELIMITER ;

-- When the 'disposition' table changes:
DELIMITER $$
CREATE TRIGGER disposition_change
    AFTER UPDATE
    ON disposition FOR EACH ROW
BEGIN
    CALL create_sales_per_month();
END$$    
DELIMITER ;

-- When the 'loans' table changes:
DELIMITER $$
CREATE TRIGGER loans_change
    AFTER UPDATE
    ON loans FOR EACH ROW
BEGIN
	CALL filldates('2018-01-01'); -- (fictional) current date has to be passed manually
	CALL create_loan_portfolio_per_monthsales_per_month();
END$$    
DELIMITER ;

-- 4: Check final DW and DM tables:
SELECT * FROM loan_portfolio_per_month;
SELECT * FROM loan_portfolio_report;
SELECT * FROM sales_per_month;
SELECT * FROM sales_report;
