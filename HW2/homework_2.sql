-- exercise 1:
DROP TABLE employee;
CREATE TABLE employee 
(id INT NOT NULL PRIMARY KEY,
employee_name VARCHAR(30) NOT NULL);
--

DESCRIBE employee;

INSERT INTO employee (id,employee_name) VALUES(1,'Student1');
INSERT INTO employee (id,employee_name) VALUES(2,'Student2');
INSERT INTO employee (id,employee_name) VALUES(3,'Student3');

SELECT * FROM employee;

INSERT INTO employee (id,employee_name) VALUES(3,'Student4');


UPDATE employee SET employee_name='Arnold Schwarzenegger' WHERE id = '1';
UPDATE employee SET employee_name='The Other Arnold' WHERE id = '2';

SELECT * FROM employee;

DELETE FROM employee WHERE id = 3;

SELECT * FROM employee;

TRUNCATE employee;

SELECT * FROM employee;

CREATE USER 'balintbojko'@'%' IDENTIFIED BY '';

GRANT ALL ON firstdb.employee TO 'balintbojko'@'%';

GRANT SELECT (state) ON firstdb.birdstrikes TO 'balintbojko'@'%';

DROP USER 'balintbojko'@'%';

SELECT * FROM birdstrikes LIMIT 10,1;

-- exercise 2: --
SELECT STATE FROM birdstrikes LIMIT 144,1;
-- 

SELECT state, cost FROM birdstrikes ORDER BY cost;
SELECT state, cost FROM birdstrikes ORDER BY state, cost ASC;

SELECT state, cost FROM birdstrikes ORDER BY cost DESC;

-- exercise 3: -- 
SELECT MAX(flight_date) FROM birdstrikes;

-- exercise 4:
SELECT cost FROM birdstrikes ORDER BY cost DESC LIMIT 49,1;

SELECT * FROM birdstrikes WHERE state = 'Alabama';


SELECT * FROM birdstrikes WHERE state != 'Alabama';

SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'A%';

SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'a%';

SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'ala%';

SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'North _a%';

SELECT DISTINCT state FROM birdstrikes WHERE state NOT LIKE 'a%' ORDER BY state;

SELECT * FROM birdstrikes WHERE state = 'Alabama' AND bird_size = 'Small';
SELECT * FROM birdstrikes WHERE state = 'Alabama' OR state = 'Missouri';

SELECT DISTINCT(state) FROM birdstrikes WHERE state IS NOT NULL AND state != '' ORDER BY state;

SELECT * FROM birdstrikes WHERE state IN ('Alabama', 'Missouri','New York','Alaska');

SELECT DISTINCT(state) FROM birdstrikes WHERE LENGTH(state) = 5;

SELECT * FROM birdstrikes WHERE speed = 350;

SELECT * FROM birdstrikes WHERE speed >= 10000;

SELECT speed, ROUND(SQRT(speed/2) * 10) AS synthetic_speed FROM birdstrikes;

SELECT * FROM birdstrikes where cost BETWEEN 20 AND 40;

-- exercise 5: --
SELECT state FROM birdstrikes WHERE state IS NOT NULL AND state != '' AND bird_size IS NOT NULL AND bird_size != '' LIMIT 1,1;

SELECT * FROM birdstrikes WHERE flight_date = "2000-01-02";

SELECT * FROM birdstrikes WHERE flight_date >= '2000-01-01' AND flight_date <= '2000-01-03';

SELECT * FROM birdstrikes where flight_date BETWEEN "2000-01-01" AND "2000-01-03";


-- exercise 6: --
-- How many days elapsed between the current date and the flights happening in week 52, for incidents from Colorado? (Hint: use NOW, DATEDIFF, WEEKOFYEAR)
SELECT
*,
CURRENT_DATE,
flight_date,
DATEDIFF(CURRENT_DATE, flight_date) date_dif,
DATEDIFF(CURRENT_DATE, flight_date)/365 year_dif
FROM birdstrikes
WHERE WEEKOFYEAR(flight_date) = 52
AND state = 'Colorado'