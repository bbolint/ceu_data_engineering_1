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
LINES TERMINATED BY '\n'
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
LINES TERMINATED BY '\n'
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
LINES TERMINATED BY '\n'
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
LINES TERMINATED BY '\n'
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
LINES TERMINATED BY '\n'
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
LINES TERMINATED BY '\n'
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
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, account_id, bank_to, account_to, amount, k_symbol);

-- Step 2: Creating analytical data layer to answer questions of interest
SELECT 
"account" product,
account_id product_id, 
district_id, 
"account", 
frequency AS "product_group",
CONCAT(purchase_year,"-", QUARTER(purchase_date)) purchase_quarter
FROM accounts;

SELECT * FROM loans;


