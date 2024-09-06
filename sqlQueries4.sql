
SELECT * 
FROM album JOIN artist 
USING (artist_id);



SELECT g.genre_id, g.name, sum(il.quantity) AS trackSold
FROM genre AS g
JOIN track AS t USING (genre_id)
JOIN invoice_line AS il USING (track_id)
GROUP BY g.genre_id, g.name
ORDER BY sum(il.quantity) DESC 
LIMIT 3;



SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer AS c
JOIN invoice AS i USING (customer_id)
JOIN invoice_line AS il USING (invoice_id)
WHERE il.track_id NOT IN (
	SELECT t.track_id
	FROM track AS t
	WHERE t.genre_id != (
		SELECT genre_id
		FROM genre 
		WHERE name = 'Jazz'
	)
)


SELECT * FROM customer


SELECT e.employee_id, e.first_name, e.last_name
FROM employee AS e
JOIN customer AS c ON e.employee_id = c.support_rep_id 
JOIN invoice AS i USING (customer_id)
GROUP BY e.employee_id, e.first_name, e.last_name 
HAVING sum(i.total) > (
	SELECT sum(newTable.employeeSales)/(SELECT count(employee_id) FROM employee) -- not using avg here, it will give the average OF VALUES WHERE sales IS NOT NULL. Hence, employees who haven't done ANY sales will NOT be considered IN avg
	FROM (	
		SELECT e.employee_id, sum(i.total) AS employeeSales
		FROM employee AS e
		LEFT JOIN customer AS c ON e.employee_id = c.support_rep_id 
		LEFT JOIN invoice AS i USING (customer_id)
		GROUP BY e.employee_id 
	) AS newTable
);

-- optimised above query
SELECT e.employee_id, e.first_name, e.last_name
FROM employee AS e
JOIN customer AS c ON e.employee_id = c.support_rep_id 
JOIN invoice AS i USING (customer_id)
GROUP BY e.employee_id, e.first_name, e.last_name 
HAVING sum(i.total) > (
	SELECT (SELECT sum(total) FROM invoice) * 1.0/(SELECT count(employee_id) FROM employee) 
);


-- above query using CTE
WITH saleTable AS (
	SELECT e.employee_id,e.first_name, e.last_name, sum(i.total) AS sales
	FROM employee AS e
	LEFT JOIN customer AS c ON e.employee_id = c.support_rep_id 
	LEFT JOIN invoice AS i USING (customer_id)
	GROUP BY e.employee_id 
)
SELECT *
FROM saleTable
WHERE sales > ( 
	SELECT avg(sales) -- IF we use avg here it will give the average OF VALUES WHERE sales IS NOT NULL. TO consider correct avg, we can use: SELECT (SELECT sum(total) FROM invoice)/(SELECT count(employee_id) FROM employee) 
	FROM saleTable
);




SELECT a.title, count(t.track_id) AS numOfTracks
FROM album AS a
JOIN track AS t USING (album_id)
GROUP BY a.title 
HAVING count(t.track_id) > 5;

SELECT * FROM album;
SELECT composer FROM track;



SELECT DISTINCT a.title
FROM album AS a
JOIN track AS t USING (album_id)
WHERE t.composer LIKE '%,%'


SELECT a.album_id ,a.title
FROM album AS a
JOIN track AS t USING (album_id)
GROUP BY a.title, a.album_id 
HAVING count(DISTINCT t.composer) > 1;


SELECT track_id, composer FROM track WHERE album_id = 8


SELECT track_id 
FROM track 
WHERE track_id NOT IN (
	SELECT track_id 
	FROM invoice_line
);


SELECT g.name , count(il.invoice_line_id), sum(il.quantity)
FROM genre AS g
JOIN track AS t USING (genre_id)
JOIN invoice_line AS il USING (track_id)
GROUP BY g.name 
HAVING sum(il.quantity) > 100;

SELECT * FROM invoice_line WHERE quantity > 1;


WITH activeCustomers AS (
	SELECT DISTINCT c.*
	FROM customer AS c
	JOIN invoice AS i USING (customer_id)
)
SELECT DISTINCT ac.customer_id, ac.first_name, ac.last_name, g.name
FROM activeCustomers AS ac
JOIN invoice AS i ON ac.customer_id = i.customer_id 
JOIN invoice_line AS il ON i.invoice_id = il.invoice_id 
JOIN track AS t ON t.track_id = il.track_id 
JOIN genre AS g ON g.genre_id = t.genre_id 
WHERE g.name != 'Pop'



SELECT t.track_id , t.name, sum(il.quantity)
FROM track AS t
LEFT JOIN invoice_line AS il USING (track_id)
GROUP BY t.track_id 
ORDER BY sum(il.quantity) DESC ;



SELECT ( count(invoice_id) * 1.0 )/(SELECT count( customer_id) FROM customer)
FROM invoice;

SELECT 412/59

SELECT (412 * 1.0) / 59

SELECT count(invoice_id) FROM invoice;

SELECT DISTINCT customer_id FROM invoice



SELECT c.customer_id, c.first_name, c.last_name , count(i.invoice_id)
FROM customer AS c
JOIN invoice AS i USING (customer_id)
GROUP BY c.customer_id , c.first_name , c.last_name 
HAVING count(i.invoice_id) > (
	SELECT ( count(invoice_id) * 1.0 )/(SELECT count( customer_id) FROM customer)
	FROM invoice
);



SELECT milliseconds FROM track;

SELECT a.album_id, a.title, sum(t.milliseconds) AS totalDuration
FROM album AS a
JOIN track AS t USING (album_id)
GROUP BY a.album_id, a.title
HAVING sum(milliseconds) > (
	SELECT (SELECT sum(milliseconds) FROM track) * 1.0/ (SELECT count(album_id) FROM album) -- IF we take avg INSTEAD OF this EXPRESSION TO find average, it can be incorrect AS there can be multiple ROWS CORRESPONDING TO same album
)



WITH avgGenreDuration AS (
	SELECT g.genre_id, g.name, avg(t.milliseconds) AS avgDuration
	FROM genre AS g
	JOIN track AS t USING (genre_id)
	GROUP BY g.genre_id , g.name 
)
SELECT t.track_id, t.name, g.genre_id, t.milliseconds AS trackDuration, g.avgDuration
FROM track AS t
JOIN avgGenreDuration AS g USING (genre_id)
WHERE t.milliseconds > g.avgDuration;




WITH avgCountrySpents AS (
	SELECT billing_country, avg(total) AS avgSpents
	FROM invoice 
	GROUP BY billing_country
)
SELECT c.customer_id , c.first_name , c.last_name, c.country , sum(total) AS customerSpents
FROM customer AS c
JOIN invoice AS i USING (customer_id)
GROUP BY c.customer_id , c.first_name , c.last_name 
HAVING sum(total) > (
	SELECT avgSpents
	FROM avgCountrySpents
	WHERE billing_country = c.country 
)
ORDER BY sum(total);
	

















