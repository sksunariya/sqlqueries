

WITH customerSpentsTable AS (
	SELECT c.customer_id, c.first_name, c.last_name, c.country, sum(i.total) AS customerSpents
	FROM customer AS c
	JOIN invoice AS i USING (customer_id)
	GROUP BY c.customer_id, c.first_name, c.last_name, c.country
	HAVING c.country = 'Canada'
)
SELECT customer_id, first_name, last_name
FROM customerSpentsTable
WHERE customerSpents > ANY (
	SELECT customerSpents
	FROM customerSpentsTable
)


SELECT * 
FROM customer 
WHERE country = 'Canada';


SELECT t.track_id, t.name
FROM track AS t
WHERE unit_price > ALL (
	SELECT unit_price
	FROM track AS t2
	WHERE genre_id = (
		SELECT genre_id
		FROM genre
		WHERE name = 'Jazz'
	)
);



SELECT a.album_id, a.title
FROM album AS a
WHERE NOT EXISTS (
	SELECT 1
	FROM track AS t
	WHERE t.album_id = a.album_id AND EXISTS (
		SELECT 1 
		FROM invoice_line AS il
		WHERE il.track_id = t.track_id AND il.invoice_id IS NOT NULL 
	)
)
ORDER BY album_id;



SELECT a.album_id, a.title
FROM album AS a
WHERE album_id NOT IN (
	SELECT t.album_id
	FROM track AS t
	JOIN invoice_line AS il USING (track_id)
	WHERE il.invoice_id IS NOT NULL 
)
ORDER BY album_id;



SELECT DISTINCT p.playlist_id, p.name
FROM playlist AS p
JOIN playlist_track AS pt USING (playlist_id)
WHERE EXISTS (
	SELECT 1
	FROM track AS t
	JOIN genre AS g USING (genre_id)
	WHERE pt.track_id = t.track_id AND g.name IN ('Rock', 'Pop')
)

SELECT * from playlist

SELECT c.customer_id, c.first_name, c.last_name 
FROM customer AS c 
WHERE customer_id IN (
	SELECT DISTINCT i.customer_id
	FROM invoice AS i
	JOIN invoice_line AS il USING (invoice_id)
	JOIN track AS t USING (track_id)
	JOIN genre AS g USING (genre_id)
	WHERE g.name = 'Classical'
);


SELECT DISTINCT a.album_id, a.title
FROM album AS a
JOIN track AS t ON t.album_id = a.album_id 
WHERE t.milliseconds > ANY (
	SELECT t2.milliseconds
	FROM track AS t2
	JOIN genre AS g USING (genre_id)
	WHERE g.name = 'Blues'
)


SELECT DISTINCT album_id FROM album;



WITH employeeSales AS (
	SELECT e.employee_id, e.first_name, e.last_name, e.reports_to, sum(i.total) AS sales
	FROM employee AS e
	JOIN customer AS c ON c.support_rep_id = e.employee_id
	JOIN invoice AS i USING (customer_id)
	GROUP BY e.employee_id, e.first_name, e.last_name, e.reports_to
)
SELECT DISTINCT es.reports_to
FROM employeeSales AS es
WHERE es.sales < (
	SELECT es2.sales
	FROM employeesales AS es2
	WHERE es2.employee_id = es.reports_to
)


SELECT i.invoice_id, i.customer_id, i.invoice_date
FROM invoice AS i
WHERE EXTRACT (YEAR FROM i.invoice_date) = 2022;



SELECT c.customer_id, c.first_name, c.last_name
FROM customer AS c
WHERE c.last_name LIKE 'S%';



SELECT t.track_id, t.name, t.composer
FROM track AS t
WHERE t.composer IS NULL;


SELECT * FROM employee;

SELECT e.employee_id, e.first_name, e.last_name, e.hire_date 
FROM employee AS e
WHERE EXTRACT (YEAR FROM e.hire_date) = 2003;


SELECT email FROM customer;

SELECT customer_id, first_name, last_name, email
FROM customer 
WHERE email LIKE '%gmail.com';



SELECT invoice_id, customer_id, invoice_date, billing_city ,billing_state, billing_country
FROM invoice
WHERE billing_state IS NULL;



SELECT t.track_id, t.name, t.composer
FROM track AS t
WHERE composer = 'Jimi Hendrix' OR composer IS NULL;


SELECT now();

SELECT EXTRACT (YEAR FROM now());

SELECT EXTRACT (MONTH FROM now());

SELECT EXTRACT (DAY FROM now());

SELECT EXTRACT (TIMEZONE_HOUR FROM now());

SELECT EXTRACT (TIMEZONE_MINUTE FROM now());

SELECT EXTRACT (HOUR FROM now());

SELECT EXTRACT (MINUTE FROM now());

SELECT EXTRACT (SECOND FROM now());


SELECT CURRENT_DATE;

SELECT current_time;

SELECT current_timestamp;



