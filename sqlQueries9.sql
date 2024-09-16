

WITH countrySales AS (
	SELECT c.customer_id, c.first_name, c.last_name, c.country, sum(i.total) AS custSpents
	FROM invoice AS i
	JOIN customer AS c USING (customer_id)
	GROUP BY c.customer_id, c.first_name, c.last_name, c.country
)
SELECT customer_id, first_name, last_name, country ,
	sum(custSpents) OVER (PARTITION BY country ) AS countrySales,
	RANK () OVER (PARTITION BY country)
FROM countrySales
ORDER BY customer_id;



SELECT DISTINCT customer_id, 
	avg(total) OVER (PARTITION BY customer_id),
	avg(total) OVER ()
FROM invoice;



SELECT t.track_id, t.name, t.milliseconds, a.album_id, a.title,
	RANK () OVER (PARTITION BY a.album_id ORDER BY t.milliseconds)
FROM track AS t
JOIN album AS a USING (album_id);



SELECT e.employee_id, e.first_name, e.last_name,
	e.hire_date - LAG (e.hire_date) OVER (ORDER BY e.hire_date) AS hireDiff
FROM employee AS e;



SELECT e.employee_id , e.first_name, e.last_name, sum(i.total) AS employeeSales,
	RANK () OVER (ORDER BY sum(i.total))
FROM employee AS e
JOIN customer AS c ON e.employee_id = c.support_rep_id 
JOIN invoice AS i USING (customer_id)
GROUP BY e.employee_id;



SELECT DISTINCT c.customer_id, c.first_name, c.last_name, 
	avg(i.total) OVER (PARTITION BY c.customer_id) AS custAVG,
	avg(i.total) OVER (PARTITION BY c.customer_id) - avg(i.total) OVER () AS totalAVG
FROM customer AS c
JOIN invoice AS i USING (customer_id);



WITH customerSpents AS (
	SELECT DISTINCT c.customer_id, c.first_name, c.last_name, c.country,
		sum(i.total) OVER (PARTITION BY c.customer_id) AS custSpents
	FROM customer AS c
	JOIN invoice AS i USING (customer_id)
)
SELECT cs.customer_id, cs.first_name, cs.last_name, cs.country, cs.custSpents,
	RANK () OVER (PARTITION BY cs.country ORDER BY cs.custSpents DESC)
FROM customerSpents AS cs;




SELECT DISTINCT a.album_id, a.title, 
	sum(il.unit_price * il.quantity) OVER (PARTITION BY a.album_id) AS albumSales,
	sum(il.unit_price * il.quantity) OVER (PARTITION BY a.album_id) / sum(il.unit_price * il.quantity) OVER () * 100 AS percentageSales
FROM album AS a
JOIN track AS t USING (album_id)
JOIN invoice_line AS il USING (track_id);



WITH albumWithTrack AS (
	SELECT DISTINCT a.album_id, a.title, t.genre_id,
		count(track_id) OVER (PARTITION BY a.album_id) AS numOfTracks
	FROM album AS a
	JOIN track AS t USING (album_id)
)
SELECT a.album_id, a.title, numOfTracks, genre_id,
	RANK () OVER (PARTITION BY a.genre_id ORDER BY numOfTracks DESC)
FROM albumWithTrack a;



SELECT genre_id, album_id, count(track_id),
	RANK () OVER (PARTITION BY genre_id ORDER BY count(track_id))
FROM track 
GROUP BY genre_id, album_id;



SELECT composer, name,
	count(track_id) OVER (PARTITION BY composer)
FROM track 



SELECT e.employee_id, e.first_name, e.last_name,
	RANK () OVER (ORDER BY hire_date),
	now() - e.hire_date AS timeEmployed
FROM employee AS e



SELECT c.customer_id, c.first_name, c.last_name, c.country, sum(i.total) AS customerSpents,
	RANK() OVER (PARTITION BY country ORDER BY sum(i.total) DESC) AS countryRank,
	RANK() OVER (ORDER BY sum(i.total) DESC ) AS worldRank
FROM customer AS c
JOIN invoice AS i USING (customer_id)
GROUP BY c.customer_id;



SELECT DISTINCT a.artist_id, a.album_id, a.title, count(t.track_id) AS numOfTrack,
	count(t.track_id) - LAG (count(t.track_id)) OVER (PARTITION BY a.artist_id ORDER BY a.album_id)
FROM album AS a
JOIN track AS t USING (album_id)
GROUP BY a.artist_id, a.album_id, a.title ;



SELECT i.customer_id, i.invoice_id, i.total,
	sum(i.total) OVER (PARTITION BY i.customer_id ORDER BY i.invoice_id)
FROM invoice AS i;



SELECT t.name, t.album_id,
	RANK () OVER (PARTITION BY t.album_id ORDER BY t.unit_price DESC)
FROM track AS t;


SELECT t.album_id, t.name, t.milliseconds,
	sum(milliseconds) OVER (PARTITION BY album_id ORDER BY milliseconds)
FROM track AS t;



SELECT t.album_id, t.name, t.milliseconds,
	sum(milliseconds) OVER (PARTITION BY album_id ORDER BY milliseconds)
FROM track AS t;


SELECT i.customer_id, i.total,
	avg(i.total) OVER (PARTITION BY i.customer_id),
	i.total - avg(i.total) OVER (PARTITION BY i.customer_id) AS diff
FROM invoice AS i;



WITH composerTrackTable AS (
	SELECT composer, count(track_id) AS composerTracks
	FROM track 
	GROUP BY composer
	HAVING composer IS NOT NULL
)
SELECT ct.composer, ct.composerTracks, t.name,
	RANK () OVER (ORDER BY composerTracks DESC) AS composerRank,
	RANK () OVER (PARTITION BY ct.composer ORDER BY milliseconds DESC ) AS trackRank
FROM track AS t
JOIN composerTrackTable AS ct ON ct.composer = t.composer;



