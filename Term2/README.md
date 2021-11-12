# Term 2 Assignment - GDP models for Austria, France, Germany, Hungary and the United Kingdom 

## Motivation

The purpose of this project is to build a model that allows estimating the impact of the different macroeconomic variables and in 5 countries in the European Union. Based on the expenditure method, we will measure the impact of Government spending, Investment, household consumption and net exports on the countries’ GDP. Using information from the World Bank during the period 1980-2019, we will estimate the equation for GDP using a multiple regression model.

## Description

One of the most common indicators to measure the economic performance of a country is the gross domestic product (GDP). This indicator seeks to reflect all the income and expenses in goods and services of a country in a period. There are different ways to calculate GDP, for our work we will focus on the expenditure method. This method aggregates the expenditures of the different economic actors (Households, Companies, Government, and external market), and it is formulated in the following way:

GDP = C + I + G + X - M

GDP:
C: Household expenditures
I: Private sector expenditures
G: Public sector expenditures
X: Exports
M: Imports

## Model 

Our model consists of a multiple regression by ordinary least squares (OLS). The dependent variable corresponds to GDP and the independent variables to the expenditure of the sectors described in the previous section (Households, Companies, government, exports and imports). We will use quarterly data extracted from the database of the European statistics office (Euro stat) of Germany, France, UK, Hungary, and Austria. All variables are in millions of euros at current prices. In addition, the variables are seasonally adjusted to eliminate the influence of cyclical phenomena in our analysis.

(insert regression equation here)
