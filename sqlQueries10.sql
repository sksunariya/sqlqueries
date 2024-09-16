

SELECT i.customer_id, i.invoice_id, 
	i.total - LAG (i.total) OVER (PARTITION BY customer_id ORDER BY i.total)
FROM invoice AS i;



SELECT g.genre_id, g.name, t.track_id, t.unit_price,
	RANK () OVER (PARTITION BY g.genre_id ORDER BY t.unit_price DESC) AS trackRank
FROM genre AS g
JOIN track AS t USING (genre_id);


WITH custInvoice AS (
	SELECT i.customer_id, i.invoice_id, i.invoice_date,
		i.invoice_date - LAG (i.invoice_date) OVER (PARTITION BY i.customer_id ORDER BY invoice_date) AS diff 
	FROM invoice AS i
)
SELECT customer_id, avg(diff)
FROM custInvoice
GROUP BY customer_id;



SELECT t.track_id, t.name, t.unit_price,
	sum(t.unit_price) OVER (),
	t.unit_price / sum(t.unit_price) OVER () * 100
FROM track AS t;



SELECT t.track_id, t.name, mt.media_type_id, mt.name, t.unit_price ,
	RANK () OVER (PARTITION BY media_type_id ORDER BY t.unit_price DESC)
FROM track AS t
JOIN media_type AS mt USING (media_type_id);

SELECT * FROM media_type;


SELECT i.customer_id, i.invoice_date,
	count(i.invoice_id) OVER (PARTITION BY i.customer_id ORDER BY i.invoice_date) AS numOfInvoices
FROM invoice AS i;



SELECT a.album_id, a.title, count(t.track_id),
	RANK () OVER (ORDER BY count(t.track_id))
FROM album AS a
JOIN track AS t USING (album_id)
GROUP BY a.album_id ;



WITH albumTracks AS (
	SELECT a.album_id, a.title, t.track_id,
		count(t.track_id) OVER (PARTITION BY a.album_id) AS trackCount
	FROM album AS a
	JOIN track AS t USING (album_id)
)
SELECT album_id, title, 
	sum(trackCount) OVER (PARTITION BY album_id ORDER BY track_id),
	RANK () OVER (PARTITION BY album_id ORDER BY trackCount)
FROM albumTracks ;


WITH albumDurationTable AS (
	SELECT a.album_id, a.title,
		avg(t.milliseconds) OVER (PARTITION BY a.album_id) AS avgTrackDuration
	FROM album AS a
	JOIN track AS t USING (album_id)
)
SELECT album_id, title, avgTrackDuration,
	RANK () OVER (ORDER BY avgTrackDuration desc)
FROM albumDurationTable;



SELECT e.employee_id, e.first_name, e.last_name, e.title, e.hire_date,
	RANK () OVER (PARTITION BY e.title ORDER BY e.hire_date)
FROM employee AS e;


SELECT i.billing_country, i.invoice_id, i.total,
	sum(i.total) OVER (PARTITION BY i.billing_country ORDER BY i.total DESC) AS runningTotal
FROM invoice AS i;



WITH countrySales AS (
	SELECT DISTINCT i.billing_country, 
		sum(i.total) OVER (PARTITION BY i.billing_country) AS countrySales
	FROM invoice AS i
)
SELECT c.customer_id, c.first_name, c.last_name, i.invoice_id , c.country ,
	 i.total / cs.countrySales * 100 AS percentageSales
FROM invoice AS i
JOIN customer AS c using(customer_id)
JOIN countrySales AS cs ON c.country = cs.billing_country
ORDER BY c.country;
	

SELECT t.track_id, t.name, g.name, t.unit_price,
	avg(t.unit_price) OVER (PARTITION BY g.genre_id ORDER BY t.track_id)
FROM track AS t
JOIN genre AS g USING (genre_id)
ORDER BY t.track_id;



SELECT DISTINCT art.artist_id, art.name, count(al.album_id) ,
	RANK () OVER ( ORDER BY count(al.album_id) DESC)  AS artistRank
FROM artist AS art
JOIN album AS al USING (artist_id)
GROUP BY art.artist_id , art."name"
ORDER BY artistRank;



WITH artistAlbums AS (
	SELECT DISTINCT art.artist_id, art.name,
		count(al.album_id) OVER (PARTITION BY art.artist_id)  AS artistAlbums
	FROM artist AS art
	JOIN album AS al USING (artist_id)
)
SELECT artist_id, name, artistAlbums,
	RANK () OVER (ORDER BY artistAlbums DESC)
FROM artistAlbums;



 SELECT artist_id, album_id, title, count(track_id) AS trackCount,
 	RANK () OVER (ORDER BY count(album_id) DESC) AS artistRank,
 	RANK () OVER (PARTITION BY artist_id ORDER BY count(track_id) DESC) AS albumTrackRank
 FROM album AS a
 JOIN track AS t USING (album_id)
 GROUP BY artist_id, album_id, title;



SELECT DISTINCT i.customer_id, 
	max(i.total) OVER (PARTITION BY i.customer_id) - 
	min(i.total) OVER (PARTITION BY i.customer_id) AS diff
FROM invoice AS i;



SELECT e.employee_id, e.first_name, e.last_name, i.total, i.invoice_date,
	avg(i.total) OVER (PARTITION BY e.employee_id ORDER BY i.invoice_date)
FROM employee AS e
JOIN customer AS c ON c.support_rep_id = e.employee_id
JOIN invoice AS i ON i.customer_id = c.customer_id;



