-- Exercise 1:
DROP PROCEDURE IF EXISTS display_first_x_rows;
DELIMITER //
CREATE PROCEDURE display_first_x_rows(
	IN x INT
)
BEGIN
	SELECT * FROM offices LIMIT x;
END //
DELIMITER ;
CALL display_first_x_rows(3);
--

-- Exercise 2:
DROP PROCEDURE IF EXISTS display_amount_xth_row_payments;
DELIMITER //
CREATE PROCEDURE display_amount_xth_row_payments(
	IN x INT
)
BEGIN
	SET x = x-1;
	SELECT amount FROM payments LIMIT x,1;
END //
DELIMITER ;
CALL display_amount_xth_row_payments(10);
--

-- Exercise 3:
DROP PROCEDURE IF EXISTS get_row_category;
DELIMITER $$
CREATE PROCEDURE get_row_category(
    	IN  rownumber INT, 
    	OUT category  VARCHAR(20)
)
BEGIN
	SET rownumber = rownumber - 1;
	SELECT amount 
	INTO category
	FROM payments
	LIMIT rownumber,1;

	IF category <= 10000 THEN
		SET category = 'CAT3';
	ELSEIF category > 10000 THEN
		SET category = 'CAT2';
	ELSEIF category > 100000 THEN
		SET category = 'CAT1';
	END IF;
END$$
DELIMITER ;
CALL get_row_category(9,@category);
SELECT @category;
--

-- Exercise 4:
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (message varchar(100) NOT NULL);
TRUNCATE messages;

DROP PROCEDURE IF EXISTS count_to_five;
DELIMITER $$
CREATE PROCEDURE count_to_five()
BEGIN
	
    DECLARE x INT;
	SET x = 1;
    
	loop_label:  LOOP

        INSERT INTO messages SELECT CONCAT('x:',x);
        SELECT x;
        
        SET  x = x + 1;
		IF  x > 5 THEN LEAVE  loop_label;
        END  IF;

	END LOOP;

 END$$
DELIMITER ;

CALL count_to_five();
SELECT * FROM messages;
-- 

-- HOMEWORK: --
DROP TABLE IF EXISTS zip_codes; 
CREATE TABLE zip_codes 
(
	zip INTEGER(10),
	area_code INTEGER(10)
);


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\zip_code_database_v002.csv' 
INTO TABLE zip_codes 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(
	zip,
	@v_area_code
)
SET
area_code = nullif(@v_area_code, '');

SELECT * FROM zip_codes;

DROP PROCEDURE IF EXISTS FixUSPhones; 
DELIMITER $$
CREATE PROCEDURE FixUSPhones ()
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE phone varchar(50) DEFAULT "x";
	DECLARE customerNumber INT DEFAULT 0;
	DECLARE country varchar(50) DEFAULT "";

	-- declare cursor for customer
	DECLARE curPhone
	CURSOR FOR 
	SELECT customers.customerNumber, customers.phone, customers.country 
	FROM classicmodels.customers;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
	FOR NOT FOUND SET finished = 1;

	OPEN curPhone;
    
	-- create a copy of the customer table 
	DROP TABLE IF EXISTS classicmodels.fixed_customers;
	CREATE TABLE classicmodels.fixed_customers LIKE classicmodels.customers;
	INSERT fixed_customers SELECT * FROM classicmodels.customers;

	fixPhone: LOOP
	FETCH curPhone INTO customerNumber,phone, country;
	IF finished = 1 THEN 
		LEAVE fixPhone;
	END IF;
		 
	-- insert into messages select concat('country is: ', country, ' and phone is: ', phone);
	IF country = 'USA'  THEN
		IF phone NOT LIKE '+%' THEN
			IF LENGTH(phone) = 10 THEN 
				SET  phone = CONCAT('+1',phone);
				UPDATE classicmodels.fixed_customers 
					SET fixed_customers.phone=phone 
						WHERE fixed_customers.customerNumber = customerNumber;
					END IF;    
			END IF;
		 END IF;

	END LOOP fixPhone;
	CLOSE curPhone;

END$$
DELIMITER ;