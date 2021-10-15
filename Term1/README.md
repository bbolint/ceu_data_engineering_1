# Term 1 Assignment for Data Engineering 1: SQL and Different Shapes of Data

## Overview of Project
...

## Description of Data Set
...

## Research Questions
- where are our clients distributed?
- where do our clients transact most to? (orders)
- what was our income from loans in the past x years?

## Results
...


## How to Reproduce the Data & Analysis
### Important notes

## Data Source


## Operational Layer
Note:s ecure-file-priv has to be disabled in MySQL before running the script. To achieve this, go to your MySQL directiory (e.g. C:\ProgramData\MySQL\MySQL Server 8.0\),
where you will find the my.ini file. Open the file in text editor (you may need admin privileges to do this), and set the secure-file-priv parameter to "" (secure-file-priv="").
Restart your mysql service. Or as alternative you can copy files to approved directory by MySQL WorkBench.

...

## Analytical Layer
...

## Data Markts as Inputs to Visualization Tools
...





Notes / can improve:
- relative path to raw data files
- have to come up with better namings for dates (not all dates can be expiry)... especially for loans it doesn't make sense (it doesn't add up for duration + year to be 
duration of loan + expiry date of loan.)
