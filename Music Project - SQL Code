/* Query 1 - US State Spending */
SELECT c.state, sum(i.total) totalspend
FROM Invoice i
JOIN customer c
ON c.CustomerId=i.CustomerId
WHERE c.country='USA'
GROUP By c.state
ORDER BY totalspend DESC; 


/* Query 2 - Largest yearly purchase */

SELECT strftime('%Y',  i.invoicedate) year, max(i.total)
FROM Invoice i
JOIN customer c
ON c.CustomerId=i.CustomerId
GROUP BY year
ORDER BY year ASC


/* Query 3 - Common media types */
Select m.Name, count(m.mediatypeid) mediacount
FROM MediaType m
JOIN Track t on t.MediaTypeId=m.MediaTypeId
GROUP BY t.MediaTypeId
ORDER BY mediacount DESC

/* Query 4 - Shortest Song Length*/
SELECT  avg(t.Milliseconds) avgsonglength, g.Name
FROM Track t
JOIN Genre g ON g.GenreId=t.GenreId
GROUP BY g.GenreId
ORDER BY avgsonglength ASC
LIMIT 5; 
