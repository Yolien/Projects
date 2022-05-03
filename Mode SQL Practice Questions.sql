Basic SQL 
SELECT year, month, month_name, south, west, midwest, northeast
  FROM tutorial.us_housing_units;

SELECT year, month, month_name, south, west, midwest, northeast
  FROM tutorial.us_housing_units
  LIMIT 15;

SELECT year, month, month_name, south, west, midwest, northeast
  FROM tutorial.us_housing_units
  WHERE west > 50;

SELECT *
  FROM tutorial.us_housing_units
  WHERE south <= 20;

SELECT *
  FROM tutorial.us_housing_units
  WHERE month_name = 'February'

SELECT *
  FROM tutorial.us_housing_units
  WHERE month_name < ‘o’  
  ORDER BY month_name;

SELECT year, month, west+south+northeast+midwest AS all_regions
  FROM tutorial.us_housing_units

SELECT year, month, west, midwest + northeast AS midwest_and_northeast
  FROM tutorial.us_housing_units
  WHERE west > (midwest + northeast)

SELECT year, month_name, south, west, midwest, northeast, 
   south/(south+west+midwest+northeast)*100 AS south_percent,
   west/(south+west+midwest+northeast)*100 AS west_percent,
   midwest/(south+west+midwest+northeast)*100 AS midwest_percent,
   northeast/(south+west+midwest+northeast)*100 AS northeast_percent
  FROM tutorial.us_housing_units
  WHERE year >= 2000;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" ILIKE '%ludacris%';

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" ILIKE 'DJ%'

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" IN ('Hammer', 'M.C. Hammer', 'Elvis Presley')

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year BETWEEN 1985 AND 1990

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE song_name IS NULL;
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" ILIKE '%ludacris%'
  AND year_rank <=10

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year IN (1990, 2000, 2010)
  AND year_rank = 1;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE song_name ILIKE '%love%'
    AND year BETWEEN 1960 AND 1969

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" IN ('Katy Perry', 'Bon Jovi')
  AND year_rank <=10

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE song_name ILIKE '%california%'
  AND (year BETWEEN 1970 AND 1979
  OR year BETWEEN 1990 AND 1999)

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" LIKE '%Dr. Dre%'
  AND (year<2001 OR year>2009)

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2013
 AND song_name NOT ILIKE '%a%'

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2012
 ORDER BY song_name;

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year = 2010
 ORDER BY year_rank, artist

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE "group" ILIKE '%t-pain%'
 ORDER BY year_rank DESC

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year_rank BETWEEN 10 AND 20
 AND year IN (1993, 2003, 2013)
 ORDER BY year, year_rank

Intermediate SQL 
SELECT COUNT(low)
  FROM tutorial.aapl_historical_stock_price

SELECT COUNT(date) AS cdate, 
       COUNT(year) AS cyear, 
       COUNT(month) AS cmonth,
       COUNT(open) AS copen,
       COUNT(high) AS chigh,
       COUNT(low) AS clow,
       COUNT(close) AS cclose,
       COUNT(volume) AS cvolume, 
       COUNT(id) AS cid
  FROM tutorial.aapl_historical_stock_price

SELECT SUM(open)/COUNT(open) AS avg_open
  FROM tutorial.aapl_historical_stock_price

SELECT MIN(low)
  FROM tutorial.aapl_historical_stock_price;

SELECT MAX(close-open)
  FROM tutorial.aapl_historical_stock_price

SELECT AVG(volume)
  FROM tutorial.aapl_historical_stock_price

SELECT year, month, SUM(volume)
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year, month
  ORDER BY year, month

SELECT year, AVG(close-open)
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year
  ORDER BY year

SELECT year, month, MIN(low) AS month_low, MAX(high) AS month_high
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year, month
  ORDER BY year, month

SELECT player_name,
       state,
       CASE WHEN state = 'CA' THEN 'yes'
            ELSE 'no' END AS CA_player
  FROM benn.college_football_players
ORDER BY CA_player DESC;

SELECT player_name,
       height,
       CASE WHEN height = 0 THEN 'Height missing'
            WHEN height > 50 AND height <= 65 THEN '50-65'
            WHEN height > 65 AND height <= 80 THEN '65-80'
            ELSE 'Over 80' END AS height_group
FROM benn.college_football_players

SELECT player_name,
       year, 
       CASE WHEN year IN ('JR','SR') THEN player_name
       ELSE 'frosh' END AS upperclassmen
FROM benn.college_football_players

SELECT CASE WHEN state IN ('CA', 'OR', 'WA') THEN 'West Coast'
            WHEN state = 'TX' THEN 'Texas'
            ELSE 'Other' END AS groups,
            COUNT(1) AS COUNT
FROM benn.college_football_players
WHERE weight >= 300
GROUP BY 1

SELECT CASE WHEN year IN ('FR','SO') THEN 'under'
            ELSE 'upper' END as class,
            SUM(weight)
FROM benn.college_football_players
WHERE state = 'CA'
GROUP BY 1

SELECT state, 
       COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(year) AS total_player_count
FROM benn.college_football_players
GROUP BY state
ORDER BY total_player_count DESC

SELECT COUNT (CASE WHEN school_name < 'n' THEN 1 ELSE NULL END) AS a_to_m_count,
       COUNT (CASE WHEN school_name > 'n' THEN 1 ELSE NULL END) AS n_to_z_count
 FROM benn.college_football_players

SELECT DISTINCT year
FROM tutorial.aapl_historical_stock_price
ORDER BY year ASC

SELECT COUNT(DISTINCT month), year
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year

SELECT COUNT(DISTINCT month) AS month_count,
       COUNT (DISTINCT year) AS year_count
FROM tutorial.aapl_historical_stock_price

SELECT players.school_name, players.player_name, players.position, players.weight
FROM benn.college_football_players players
WHERE state = 'GA'
ORDER BY weight DESC

SELECT players.school_name, players.player_name, teams.conference
FROM benn.college_football_teams teams
JOIN benn.college_football_players players
ON teams.school_name = players.school_name
WHERE teams.division ='FBS (Division I-A Teams)'


JOIN tutorial.crunchbase_companies c

--SQL LEFT JOIN – EXERCISE 1 – INNER JOIN
SELECT COUNT(c.permalink) AS companies_rowcount,
       COUNT(a.company_permalink) AS acquisitions_rowcount
FROM tutorial.crunchbase_companies c 
JOIN tutorial.crunchbase_acquisitions a
ON a.company_permalink=c.permalink
-- All 1673 lines from the companies table match up with the acquisitions table when using an INNER JOIN

--SQL LEFT JOIN – EXERCISE 2 – LEFT JOIN
SELECT COUNT(c.permalink) AS companies_rowcount,
       COUNT(a.company_permalink) AS acquisitions_rowcount
FROM tutorial.crunchbase_companies c 
LEFT JOIN tutorial.crunchbase_acquisitions a
ON a.company_permalink=c.permalink
-- All 1673 lines from the companies table are listed, and 7414 lines are listed from the acquisitions table. There are lots people from the acquisitions table that are not in the companies table, so when there is no match, there are blanks when doing a left join. 


SELECT c.state_code,
       COUNT(DISTINCT c.permalink) AS distinct_companies,
       COUNT(DISTINCT a.company_permalink) AS distinct_acquisitions
FROM tutorial.crunchbase_companies c 
LEFT JOIN tutorial.crunchbase_acquisitions a
ON a.company_permalink=c.permalink
WHERE c.state_code IS NOT NULL
GROUP BY c.state_code
ORDER BY distinct_acquisitions DESC;

--RIGHT JOIN
SELECT COUNT(c.permalink) AS companies_rowcount,
       COUNT(a.company_permalink) AS acquisitions_rowcount
FROM tutorial.crunchbase_acquisitions a 
RIGHT JOIN  tutorial.crunchbase_companies c 
ON a.company_permalink=c.permalink
--SQL Joins Using WHERE or ON : PRACTICE QUESTION 1
SELECT c.name, c.status,
       COUNT(DISTINCT i.investor_permalink) as investor_count
FROM tutorial.crunchbase_companies c 
LEFT JOIN tutorial.crunchbase_investments i
ON i.company_permalink= c.permalink
WHERE c.state_code = 'NY'
GROUP BY c.name, c.status
ORDER BY investor_count DESC
--SQL Joins Using WHERE or ON : PRACTICE QUESTION 2
SELECT CASE WHEN i.investor_name IS NULL THEN 'No investors'
            ELSE i.investor_name END AS investor, 
      COUNT (DISTINCT c.permalink) AS count_of_companies_invested_in
FROM tutorial.crunchbase_companies c 
LEFT JOIN tutorial.crunchbase_investments i
ON i.company_permalink= c.permalink
GROUP BY 1
ORDER BY 2 DESC;


--SQL FULL OUTER JOIN Practice Problem
SELECT 
   COUNT (CASE WHEN c.permalink IS NOT NULL AND i.company_permalink IS NOT NULL THEN c.permalink ELSE NULL END) AS both_tables,
   COUNT (CASE WHEN c.permalink IS NOT NULL AND i.company_permalink IS NULL THEN c.permalink ELSE NULL END) AS company_table_only,
   COUNT (CASE WHEN c.permalink IS NULL and i.company_permalink IS NOT NULL THEN i.company_permalink ELSE NULL END) AS investments_table_only 
FROM tutorial.crunchbase_investments_part1 i
    FULL JOIN tutorial.crunchbase_companies c
    ON i.company_permalink = c.permalink;

--SQL UNION Practice Problem 1
SELECT company_permalink, company_name, investor_name
  FROM tutorial.crunchbase_investments_part1
  WHERE company_name ILIKE 't%'

 UNION ALL

SELECT company_permalink, company_name, investor_name
   FROM tutorial.crunchbase_investments_part2
   WHERE company_name ILIKE 'm%'
--SQL UNION Practice Problem 2

SELECT 'table1' AS table_source, 
       c.status,
       COUNT(DISTINCT i1.investor_permalink) AS investor_count
  FROM tutorial.crunchbase_companies c 
  LEFT JOIN tutorial.crunchbase_investments_part1 i1
  ON c.permalink =i1.company_permalink
  GROUP BY 1,2
  
 UNION ALL

 SELECT 'table2' AS table_source,
         c.status, 
         COUNT(DISTINCT i2.investor_permalink) AS investor_count
   FROM tutorial.crunchbase_companies c
   LEFT JOIN tutorial.crunchbase_investments_part2 i2
    ON c.permalink =i2.company_permalink
    GROUP BY 1,2

Advanced
--SQL Data Types – Practice Problem
SELECT CAST(funding_total_usd AS VARCHAR) AS funding_varchar, 
       founded_at_clean::varchar as founded_varchar, 
       funding_total_usd AS funding_original, 
       founded_at_clean AS founded_original
FROM tutorial.crunchbase_companies_clean_date
--SQL Date Format – Practice Problem
SELECT companies.category_code,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '3 years' THEN 'Acquired within 3 years'
       ELSE NULL END) AS acquired_within_3_years,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years' THEN 'Acquired within 5 years'
       ELSE NULL END) AS acquired_within_5_years,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '10 years' THEN 'Acquired within 10 years'
       ELSE NULL END) AS acquired_within_10_years, 
       COUNT(*) AS total
  FROM tutorial.crunchbase_companies_clean_date companies
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
    ON acquisitions.company_permalink = companies.permalink
 WHERE founded_at_clean IS NOT NULL
 GROUP BY companies.category_code
 ORDER BY total DESC
--Using SQL String Functions to clean data – Practice 2
SELECT location, 
       CONCAT('(', lat, ', ', lon, ')') AS new_location
FROM tutorial.sf_crime_incidents_2014_01
--Using SQL String Functions to clean data – Practice 3
SELECT location, 
       '(' || lat || ', ' ||lon || ')'  AS new_location
FROM tutorial.sf_crime_incidents_2014_01
--Using SQL String Functions to clean data – Practice 3
SELECT date,
       CONCAT(SUBSTR(date,7, 4), '-', SUBSTR(date,4, 2), '-', SUBSTR(date,1,2))
FROM tutorial.sf_crime_incidents_2014_01
--Using SQL String Functions to clean data – Practice 4
SELECT category,
      CONCAT(LEFT(UPPER(category), 1), SUBSTR(LOWER(category),2,100))
FROM tutorial.sf_crime_incidents_2014_01
--Using SQL String Functions to clean data – Practice 5
SELECT date,
       time,
       (SUBSTR(date,7, 4) || '-' || SUBSTR(date,1,2)  || '-' || SUBSTR(date,4, 2) || ' ' || time || ':00')::timestamp AS timestamp,
       (SUBSTR(date,7, 4) || '-' || SUBSTR(date,1,2)  || '-' || SUBSTR(date,4, 2) || ' ' || time || ':00')::timestamp + 
          INTERVAL '1 week' AS plus_week
FROM tutorial.sf_crime_incidents_2014_01
--Using SQL String Functions to clean data – Practice 6
SELECT DATE_TRUNC('week', cleaned_date)::date AS week,
       COUNT(incidnt_num)
  FROM tutorial.sf_crime_incidents_cleandate
GROUP BY week
ORDER BY week
--Using SQL String Functions to clean data – Practice 7
SELECT incidnt_num,
       CURRENT_TIMESTAMP AT TIME ZONE 'PST' AS time_pst,
       (SUBSTR(date,7, 4) || '-' || SUBSTR(date,1,2)  || '-' || SUBSTR(date,4, 2) || ' ' || time || ':00')::timestamp AS timestamp,
       CURRENT_TIMESTAMP AT TIME ZONE 'PST'  -
       (SUBSTR(date,7, 4) || '-' || SUBSTR(date,1,2)  || '-' || SUBSTR(date,4, 2) || ' ' || time || ':00')::timestamp AS time_since_incident
  FROM tutorial.sf_crime_incidents_cleandate
  ORDER BY 1


--SQL Subqueries Practice #1
SELECT * 
FROM (SELECT * 
  FROM tutorial.sf_crime_incidents_2014_01) sub
WHERE sub.resolution = 'NONE'

--SQL Subqueries Practice #2
SElECT sub.category, AVG(sub.total_incidents)
FROM
  (SELECT LEFT(date, 2) AS month,
         category,
         COUNT(incidnt_num) AS total_incidents
  FROM tutorial.sf_crime_incidents_cleandate
  GROUP BY 1,2 )sub
GROUP BY sub.category
ORDER BY sub.category
--SQL Subqueries Practice #3
SELECT *
 FROM tutorial.sf_crime_incidents_cleandate o
JOIN (
  SELECT category, 
           COUNT(*)
    FROM tutorial.sf_crime_incidents_cleandate
    GROUP BY 1
    ORDER BY 2 ASC
    LIMIT 3) sub
ON sub.category = o.category
--SQL Subqueries Practice #4 
SELECT COALESCE (f.founded_quarter, a.acquired_quarter) AS quarter,
       companies_founded, 
       companies_aquired
FROM
(SELECT founded_quarter, 
       COUNT(DISTINCT permalink) AS companies_founded
FROM tutorial.crunchbase_companies
WHERE founded_year>= 2012
GROUP BY 1) f

FULL JOIN

(SELECT acquired_quarter, 
       COUNT(DISTINCT company_permalink) AS companies_aquired
FROM tutorial.crunchbase_acquisitions
WHERE acquired_year >= 2012
GROUP BY 1) a

ON a.acquired_quarter=f.founded_quarter
ORDER BY 1 DESC

--SQL Subqueries Practice #5
SELECT sub.investor_permalink, COUNT(sub.investor_permalink)
  FROM (
        SELECT *
          FROM tutorial.crunchbase_investments_part1

         UNION ALL

        SELECT *
          FROM tutorial.crunchbase_investments_part2
       ) sub
 GROUP BY 1
 ORDER BY 2 DESC;
--SQL Subqueries Practice #6
SELECT sub.investor_permalink, 
COUNT(sub.investor_permalink)
  FROM (
        SELECT *
          FROM tutorial.crunchbase_investments_part1

         UNION ALL

        SELECT *
          FROM tutorial.crunchbase_investments_part2
       ) sub
LEFT JOIN tutorial.crunchbase_companies c
 ON c.permalink = sub.company_permalink
 WHERE c.status= 'operating'
 GROUP BY 1
 ORDER BY 2 DESC;
--Window Functions 1
SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY start_terminal ORDER BY start_time) AS running_total,
       duration_seconds/ SUM(duration_seconds) OVER(PARTITION BY start_terminal)*100 AS percent_of_total
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
--Windows Functions 2
SELECT end_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY end_terminal ORDER BY start_time DESC)
         AS running_total
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
--Windows Functions 3
SELECT *
FROM(
  SELECT start_terminal,
         duration_seconds,
         RANK() OVER (PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS rank
    FROM tutorial.dc_bikeshare_q1_2012
    WHERE start_time < '2012-01-08'
)sub
WHERE rank<=5
ORDER BY start_terminal
--Windows Functions 4
SELECT duration_seconds,
       NTILE(100) OVER (ORDER BY duration_seconds)
FROM tutorial.dc_bikeshare_q1_2012 
WHERE start_time < '2012-01-08'
