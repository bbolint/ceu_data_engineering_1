# Term 1 Assignment - Eagle Bank Database

## Overview of Project
...

## Description of Data Set
...

<p align="center">
	<img src="db_model/db_model_overview.PNG" alt="Eagle Bank Database: Overview of Operational Layer" width="800"/>
</p>

Current date: 2018-01-01

Clients can have 3 general types of products:

- Accounts
	- Monthly issuance
	- Issuance after transaction
	- Weekly issuance
- Cards
	- VISA Signature
	- VISA Standard
	- VISA Infinite
- Loans
	- Duration: 12, 24, 36, 48, 60 months
	- Status: A, B, C, D
	- Purpose: Car, Debt Consolidation, Home Improvement, Home


## Interests of Management and Corresponding Data Markt Assets
### Interest 1: Overview of loan portfolio over time (per quarter), with projections for the future
### Data Markt Asset 1:

### Interest 2: Overview of sales over time per district (per quarter)
### Data Martk Asset 2:

## Results
...


## How to Reproduce the Project
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
- how to ETL to data markts: create materialized views for 1 of the data markt with most complex data & longest query time


