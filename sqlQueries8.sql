SELECT *
FROM track AS t
WHERE composer IS NULL
AND milliseconds >= ALL (
	SELECT milliseconds
	FROM track
);


SELECT e.employee_id, e.first_name, e.last_name, e.hire_date, EXTRACT (YEAR FROM e.hire_date) AS yr, EXTRACT (MONTH FROM e.hire_date) AS mon, count(e.employee_id)
FROM employee AS e
GROUP BY e.employee_id, e.first_name, e.last_name, e.hire_date, yr, mon
HAVING count(e.employee_id) = 1;



SELECT track_id, name, milliseconds,
	ROW_NUMBER() OVER (ORDER BY milliseconds DESC) AS rowNum
FROM track;


SELECT track_id, name, unit_price,
	RANK () OVER (ORDER BY unit_price desc) AS rank
FROM track;
	

SELECT e.employee_id, e.first_name, e.last_name,
	DENSE_RANK () OVER (ORDER BY e.hire_date) AS RANK 
FROM employee AS e;



SELECT i.customer_id, i.invoice_id, i.invoice_date, i.total,
	sum(i.total) OVER (PARTITION BY customer_id ORDER BY invoice_date) AS runningTotal 
FROM invoice AS i;



SELECT genre_id, name,
	avg(unit_price) OVER (PARTITION BY genre_id) AS avgPrice
FROM track;


SELECT album_id, track_id, name,
	LEAD (name) OVER (PARTITION BY album_id ORDER BY track_id) AS nextTrack
FROM track;


SELECT album_id, track_id, name,
	LAG (name) OVER (PARTITION BY album_id ORDER BY track_id) AS prevTrack
FROM track;


SELECT customer_id, first_name, last_name, totalSpents,
	NTILE (4) OVER (ORDER BY totalSpents DESC) AS spendingGroup
FROM (
	SELECT c.customer_id, c.first_name, c.last_name, sum(i.total) AS totalSpents
	FROM customer AS c
	JOIN invoice AS i USING (customer_id)
	GROUP BY customer_id
) AS customerSpents;



SELECT employee_id, first_name, last_name, city, hire_date,
	RANK () OVER (PARTITION BY city ORDER BY hire_date) AS RANK 
FROM employee;


SELECT * FROM employee;


SELECT track_id, album_id, milliseconds,
	LAG (milliseconds) OVER (PARTITION BY album_id ORDER BY track_id) AS prevTime, 
	milliseconds - LAG (milliseconds) OVER (PARTITION BY album_id ORDER BY track_id) AS durationDiff
FROM track;


WITH customerSpents AS (
	SELECT c.customer_id, c.first_name, c.last_name, sum(i.total) AS totalSpents
	FROM invoice AS i
	JOIN customer AS c USING (customer_id)
	GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT cs.customer_id, cs.first_name, cs.last_name, cs.totalSpents,
	totalSpents / sum (totalSpents) OVER () * 100 AS percentageSpents
FROM customerSpents AS cs;



WITH albumAndTracks AS (
	SELECT a.album_id, a.title, count(t.track_id) AS numOfTracks
	FROM album AS a
	JOIN track AS t USING (album_id)
	GROUP BY a.album_id, a.title
)
SELECT album_id, title, numOfTracks,
	RANK () OVER (ORDER BY numOfTracks DESC) AS RANK 
FROM albumAndTracks;



SELECT a.album_id, a.title, count(t.track_id),
	RANK () OVER (ORDER BY count(t.track_id))
FROM album AS a
JOIN track AS t USING (album_id)
GROUP BY a.album_id;


SELECT g.genre_id, g.name, t.track_id, t.name, t.unit_price,
	avg(unit_price) OVER (PARTITION BY g.genre_id ORDER BY t.track_id) AS runningAvg,
	sum(unit_price) OVER (PARTITION BY g.genre_id ORDER BY t.track_id) AS runningTotal
FROM genre AS g
JOIN track AS t USING (genre_id);



SELECT c.customer_id, c.first_name, c.last_name, i.invoice_date, i.invoice_id, i.total,
	LEAD (i.total) OVER (PARTITION BY c.customer_id ORDER BY i.invoice_date)
FROM customer AS c
JOIN invoice AS i USING (customer_id);



SELECT c.customer_id, c.first_name, c.last_name,  i.total,
	(SELECT sum(total) FROM invoice) - LEAD (i.total) OVER (ORDER BY i.invoice_date) AS diff
FROM customer AS c
JOIN invoice AS i USING (customer_id)
GROUP BY c.customer_id, i.invoice_id;


SELECT t.composer, count(t.track_id),
	RANK () OVER (ORDER BY count(t.track_id) DESC)
FROM track AS t
WHERE t.composer IS NOT NULL 
GROUP BY composer;


SELECT t.track_id, t.name, t.unit_price, t.genre_id ,
	avg(t.unit_price) OVER (PARTITION BY t.genre_id)
FROM track AS t;


SELECT c.customer_id, c.first_name, c.last_name, count(i.invoice_id),
	RANK () OVER (ORDER BY count(i.invoice_id) DESC)
FROM customer AS c
JOIN invoice AS i USING(customer_id)
GROUP BY c.customer_id;

