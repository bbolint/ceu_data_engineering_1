-- Exercise 1:
-- Q: Do the same with speed. If speed is NULL or speed < 100 create a “LOW SPEED” category, otherwise, mark as “HIGH SPEED”. Use IF instead of CASE!
-- A: 
SELECT *, IF(speed < 100 OR speed IS NULL, 'LOW SPEED', 'HIGH SPEED') AS speed_category
FROM  birdstrikes
ORDER BY speed_category;

-- Exercise 2:
-- Q: How many distinct ‘aircraft’ we have in the database?
-- A: 2
SELECT COUNT(DISTINCT(aircraft)) no_aircraft_types FROM birdstrikes WHERE (aircraft IS NOT NULL) AND (aircraft != '');

-- Exercise 3:
-- Q: What was the lowest speed of aircrafts starting with ‘H’
-- A: 9
SELECT MIN(speed) FROM birdstrikes WHERE aircraft LIKE 'H%';

-- Exercise 4:
-- Q: Which phase_of_flight has the least of incidents?
-- A: Taxi
SELECT
phase_of_flight,
COUNT(*) no_incidents
FROM birdstrikes
GROUP BY phase_of_flight
ORDER BY COUNT(*) ASC;

-- Exercise 5:
-- Q: What is the rounded highest average cost by phase_of_flight?
-- A: 54673
SELECT
phase_of_flight,
ROUND(AVG(cost)) rounded_avg_cost
FROM birdstrikes
GROUP BY phase_of_flight
ORDER BY ROUND(AVG(cost)) DESC;

-- Exercise 6: 
-- Q: What the highest AVG speed of the states with names less than 5 characters?
-- A: 2862.5
SELECT 
state,
AVG(speed) avg_speed
FROM birdstrikes
GROUP BY state
HAVING LENGTH(state) < 5
ORDER BY AVG(speed) DESC

