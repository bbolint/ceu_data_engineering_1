# create and use schema:
DROP SCHEMA IF EXISTS macroeconomic_db;
CREATE SCHEMA macroeconomic_db;
USE macroeconomic_db;

# create frame for gdp table
DROP TABLE IF EXISTS GDP;
CREATE TABLE  GDP(
	ID INT NOT NULL,
	period VARCHAR(50) NOT NULL,
	GDP_Germany DOUBLE NOT NULL,
	GDP_France DOUBLE NOT NULL,
    GDP_Hungary DOUBLE NOT NULL,
    GDP_Austria DOUBLE NOT NULL,
    GDP_UK DOUBLE NOT NULL,
    PRIMARY KEY (ID));
    
LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\gdp.csv'
INTO TABLE GDP
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;





