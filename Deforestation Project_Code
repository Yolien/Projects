SQL Queries

/*Create view*/
CREATE VIEW forestation 
AS
SELECT f.country_code AS code, f.country_name AS name, f.year AS year, f.forest_area_sqkm, l.total_area_sq_mi*2.59 AS total_area_sqkm, (f.forest_area_sqkm/(total_area_sq_mi* 2.59))*100 AS percent_forest, r.region AS region, r.income_group AS income_group
FROM forest_area f
JOIN land_area l
ON l.country_code=f.country_code AND l.year=f.year
LEFT JOIN regions r
ON r.country_code=l.country_code
ORDER BY l.country_name, l.year;


---Global Situation

/*Change since 1990*/
 SELECT year,
       new,
       LEAD(new) OVER (ORDER BY year) AS lead,
       LEAD(new) OVER (ORDER BY year) - new AS change,
       (LEAD(new) OVER (ORDER BY year) - new)/new *100  AS percent_change
FROM (
SELECT year,
       SUM(forest_area_sqkm) AS new
  FROM forestation 
  WHERE YEAR IN (1990, 2016)
  AND name = 'World'
  AND forest_area_sqkm IS NOT NULL
 GROUP BY 1
) sub;

/*Find country matching size of forest area lost*/
SELECT name, ROUND(total_area_sqkm::DECIMAL, 2) 
FROM forestation
WHERE year = '2016'
AND total_area_sqkm < 1324449
ORDER BY total_area_sqkm DESC
LIMIT 1;


---REGIONAL OUTLOOK

/*Table 2.1: Percent Forest Area by Region, 1990 & 2016:*/
WITH t1 AS (SELECT region, ROUND(AVG(percent_forest)::DECIMAL, 2) AVG_1990
            FROM forestation
            WHERE year = '1990'
            GROUP BY region),
            
t2 AS (SELECT region, ROUND(AVG(percent_forest)::DECIMAL, 2) AVG_2016
            FROM forestation
            WHERE year = '2016'
            GROUP BY region)
SELECT DISTINCT t1.region, t1.AVG_1990, t2.AVG_2016
FROM t1
JOIN t2
ON t1.region=t2.region
ORDER BY AVG_2016 DESC;

---COUNTRY-LEVEL DETAIL
Success stories
/*Success Stories: Top countries by TOTAL forest area*/
WITH t1 AS (SELECT name, ROUND(SUM(forest_area_sqkm)::DECIMAL,2) AS forest_1990
            FROM forestation
            WHERE year = '1990'
            GROUP BY name),  
t2 AS (SELECT name, ROUND(SUM(forest_area_sqkm)::DECIMAL,2) AS forest_2016
            FROM forestation
            WHERE year = '2016'
            GROUP BY name)
SELECT DISTINCT t1.name, t1.forest_1990, t2.forest_2016, ROUND((t2.forest_2016-t1.forest_1990)::DECIMAL,2) AS difference
FROM t1
JOIN t2
ON t1.name=t2.name
WHERE t1.forest_1990 IS NOT NULL
AND t2.forest_2016 IS NOT NULL
ORDER BY difference DESC
LIMIT 2; 


/*Success Stories: Top country by PERCENT forest area*/
WITH t1 AS (SELECT name, ROUND(AVG(percent_forest)::DECIMAL,2)  AS forest_1990
            FROM forestation
            WHERE year = '1990'
            GROUP BY name
            HAVING ROUND(AVG(percent_forest)::DECIMAL,2) !=0),
t2 AS (SELECT name, ROUND(AVG(percent_forest)::DECIMAL,2) AS forest_2016
            FROM forestation
            WHERE year = '2016'
            GROUP BY name
            HAVING ROUND(AVG(percent_forest)::DECIMAL,2) !=0)
SELECT DISTINCT t1.name, t1.forest_1990, t2.forest_2016, ROUND((t2.forest_2016-t1.forest_1990)/t1.forest_1990::DECIMAL,2) AS percent_change
FROM t1
JOIN t2
ON t1.name=t2.name
WHERE t1.forest_1990 IS NOT NULL AND t2.forest_2016 IS NOT NULL
ORDER BY percent_change DESC
LIMIT 1; 


---Largest Concerns

/*Table 3.1: Top 5 Amount Decrease in Forest Area by Country, 1990 & 2016*/
WITH t1 AS (SELECT name, SUM(forest_area_sqkm) AS forest_1990
            FROM forestation
            WHERE year = '1990'
            GROUP BY name),  
t2 AS (SELECT name, SUM(forest_area_sqkm) AS forest_2016
            FROM forestation
            WHERE year = '2016'
            GROUP BY name)
SELECT DISTINCT t1.name, f.region,ROUND((t2.forest_2016-t1.forest_1990)::DECIMAL,2) AS difference
FROM t1
JOIN t2
ON t1.name=t2.name
JOIN forestation f
ON f.name=t1.name
WHERE region != 'World'
ORDER BY difference ASC
LIMIT 5;


/*Table 3.2: Top 5 Percent Decrease in Forest Area by Country,1990 &2016*/
WITH t1 AS (SELECT name, AVG(percent_forest) AS forest_1990
            FROM forestation
            WHERE year = '1990'
            GROUP BY name),
t2 AS (SELECT name, AVG(percent_forest) AS forest_2016
            FROM forestation
            WHERE year = '2016'
            GROUP BY name)
SELECT DISTINCT t1.name, f.region, ROUND((((t2.forest_2016-t1.forest_1990)/t1.forest_1990)*100)::DECIMAL,2) AS percent_difference
FROM t1
JOIN t2
ON t1.name=t2.name
JOIN forestation f
ON f.name=t1.name
ORDER BY percent_difference ASC
LIMIT 5;

---Quartiles

/*Table 3.3: Count of Countries Grouped by Forestation Percent Quartiles, 2016:*/
SELECT DISTINCT(quartiles), COUNT(name) OVER (PARTITION BY quartiles)
FROM
(SELECT name,
CASE WHEN percent_forest<=25 THEN '0 to 25%'
WHEN percent_forest<=50 AND percent_forest>25 THEN '25-50%'
WHEN percent_forest<=75 AND percent_forest>50 THEN '50-75%'
ELSE '75-100%'
END AS quartiles
FROM forestation
WHERE percent_forest IS NOT NULL AND year=2016) sub
ORDER BY quartiles;


 
/*Table 3.4: Top Quartile Countries, 2016*/
SELECT name, region, ROUND(percent_forest :: DECIMAL, 2) percent_forest
FROM forestation
WHERE percent_forest >= 75
AND year = '2016'
ORDER BY percent_forest DESC;

