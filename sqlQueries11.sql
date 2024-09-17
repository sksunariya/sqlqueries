

SELECT t.media_type_id, t.track_id, t.name, t.milliseconds,
	RANK () OVER (PARTITION BY t.media_type_id ORDER BY t.milliseconds DESC)
FROM track AS t;



WITH genreTrackDuration AS (
	SELECT t.genre_id, avg(t.milliseconds) AS avgDuration
	FROM track AS t
	GROUP BY t.genre_id
)
SELECT t.track_id, t.name, t.milliseconds, gt.avgDuration, 
	t.milliseconds - gt.avgDuration AS durationDiff
FROM track AS t
JOIN genreTrackDuration AS gt USING (genre_id);



SELECT t.track_id, t.name, t.milliseconds, 
	avg(t.milliseconds) OVER (PARTITION BY t.genre_id) AS avgTrackDuration,
	t.milliseconds - avg(t.milliseconds) OVER (PARTITION BY t.genre_id) AS durationDiff
FROM track AS t;
	


SELECT i.customer_id, i.billing_country, sum(i.total) AS totalSpents,
	RANK () OVER (PARTITION BY i.billing_country ORDER BY sum(i.total) DESC)
FROM invoice AS i
GROUP BY i.customer_id, i.billing_country;



SELECT e.employee_id, e.first_name, i.invoice_id, i.invoice_date,
	count(i.invoice_id) OVER (PARTITION BY e.employee_id ORDER BY i.invoice_date) AS employeeInvoices
FROM employee AS e
JOIN customer AS c ON e.employee_id = c.support_rep_id 
JOIN invoice AS i USING (customer_id);



SELECT DISTINCT c.support_rep_id, 
	sum(i.total) OVER (PARTITION BY c.support_rep_id) AS employeeSales,
	sum(i.total) OVER (PARTITION BY c.support_rep_id) / sum(i.total) OVER () * 100 AS percentageSales
FROM customer AS c
JOIN invoice AS i USING (customer_id) ;



WITH trackRanks AS (
	SELECT t.genre_id, t.track_id, t.name, t.milliseconds,
		RANK () OVER (PARTITION BY t.genre_id ORDER BY t.milliseconds DESC) AS rank_num
	FROM track AS t
)
SELECT * 
FROM trackRanks
WHERE rank_num <= 5;



WITH monthlySpents AS (
	SELECT i.billing_country, EXTRACT (YEAR FROM i.invoice_date) AS yr, EXTRACT (MONTH FROM i.invoice_date) AS mon, sum(i.total) AS countrySpents
	FROM invoice AS i
	GROUP BY i.billing_country, yr, mon
	ORDER BY i.billing_country, yr, mon
)
SELECT billing_country, yr, mon, countrySpents,
	countrySpents -  LAG (countrySpents) OVER ()
FROM monthlySpents;



SELECT i.invoice_id, i.invoice_date, i.total, EXTRACT (YEAR FROM i.invoice_date) AS yr,
	RANK () OVER (PARTITION BY EXTRACT (YEAR FROM i.invoice_date) ORDER BY i.total DESC)
FROM invoice AS i;



WITH tempTable AS (
	SELECT DISTINCT i.customer_id, 
		sum(i.total) OVER (PARTITION BY i.customer_id) AS spents
	FROM invoice AS i
)
SELECT c.customer_id, c.first_name, c.last_name, t.spents,
	RANK () OVER (ORDER BY spents desc)
FROM tempTable AS t
JOIN customer AS c USING (customer_id);


SELECT i.customer_id, i.invoice_id, i.total, 
	sum(i.total) OVER (PARTITION BY i.customer_id ORDER BY i.invoice_date)
FROM invoice AS i;



WITH albumTracks AS (
	SELECT t.album_id, 
		count(t.track_id) OVER (PARTITION BY t.album_id) AS numOfTracks
	FROM track AS t
)
SELECT album_id, numOfTracks,
	RANK () OVER (ORDER BY numOfTracks DESC)
FROM albumTracks;



WITH invoiceAmount AS (
	SELECT i.customer_id, i.invoice_date, i.total, 
		i.total - LAG (i.total) OVER (PARTITION BY i.customer_id ORDER BY i.invoice_date) AS invoiceDiff
	FROM invoice AS i
)
SELECT c.customer_id, c.first_name, c.last_name, i.invoice_date, i.total, i.invoiceDiff
FROM customer AS c
JOIN invoiceAmount AS i USING (customer_id);


SELECT i.customer_id, i.invoice_date,
	abs(date_part('day', i.invoice_date - LAG (i.invoice_date) OVER (PARTITION BY i.customer_id ORDER BY i.invoice_date))) AS diff
FROM invoice AS i;



WITH tempTable AS (
	SELECT i.customer_id, i.invoice_date,
		abs(date_part('day', i.invoice_date - LAG (i.invoice_date) OVER (PARTITION BY i.customer_id ORDER BY i.invoice_date))) AS diff
	FROM invoice AS i
)
SELECT customer_id, invoice_date, diff,
	avg(diff) OVER (PARTITION BY customer_id ORDER BY invoice_date)
FROM tempTable;

