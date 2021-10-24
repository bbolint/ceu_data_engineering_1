# Term 1 Assignment - Eagle Bank Database

## Overview of Project
...

## Description of Data Set
...

<p align="center">
	<img src="db_model/db_model_overview_2.png" alt="Eagle Bank Database: Overview of Operational Layer" width="800"/>
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


## Data Marts to Answer Key Points of Management Interest

### Data Mart 1: Overview of loan portfolio over time (per quarter), with projections for the future
_*Created as view*_

- Fields
- Source Tables
- Aggregations
_*picture*_

### Data Mart 2: Overview of sales over time per district (per quarter)
_*Created as materialized view*_

- Fields
- Source Tables
- Aggregations
_*picture*_

## How to Reproduce the Project

1. Software: MySQL, MySQL WorkBench, Git
2. Creating Operational Layer: The source files need to be copied to the upload folder within MySQL software folder
3. Creating Data Marts: Data Marts should be automatically created by running the attached .SQL script

