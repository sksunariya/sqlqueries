

SELECT c.customer_id, c.first_name, c.last_name
FROM customer AS c
WHERE EXISTS (
	SELECT 1
	FROM invoice AS i
	WHERE c.customer_id = i.customer_id
);



SELECT c.customer_id, c.first_name, c.last_name
FROM customer AS c
WHERE NOT EXISTS (
	SELECT 1
	FROM invoice AS i
	WHERE i.customer_id = c.customer_id 
);



SELECT c.customer_id, c.first_name, c.last_name
FROM customer AS c
WHERE c.customer_id NOT IN (
	SELECT i.customer_id
	FROM invoice AS i
);



SELECT t.track_id, t.name
FROM track AS t
WHERE t.unit_price > ANY (
	SELECT trk.unit_price 
	FROM track AS trk
	JOIN genre AS g USING (genre_id)
	WHERE g.name = 'Pop'
);



SELECT *
FROM album AS a
WHERE 0.99 < ALL (
	SELECT t.unit_price
	FROM track AS t
	WHERE a.album_id = t.album_id
)


SELECT * FROM album



SELECT pt.track_id 
FROM playlist_track AS pt
WHERE NOT EXISTS (
	SELECT 1
	FROM invoice_line
	WHERE invoice_id = NULL 
);



SELECT t.track_id, t.name
FROM track AS t
WHERE EXISTS ( 
	SELECT 1
	FROM playlist_track AS pt
	WHERE pt.track_id = t.track_id 
)
AND NOT EXISTS (
	SELECT 1 
	FROM invoice_line AS il
	WHERE il.track_id = t.track_id AND il.invoice_id IS NOT NULL 
); 




WITH usaCustomerSpents AS (
	SELECT customer_id, i.billing_country, sum(i.total) AS spents
	FROM invoice AS i
	GROUP BY i.customer_id, billing_country
	HAVING billing_country = 'USA'
)
SELECT c.customer_id, c.first_name, c.last_name, sum(i.total)
FROM customer AS c
JOIN invoice AS i USING (customer_id)
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING sum(i.total) > ANY (
	SELECT spents
	FROM usaCustomerSpents
);



SELECT e.employee_id, e.first_name ,e.last_name 
FROM employee AS e
WHERE EXISTS (
	SELECT 1 
	FROM employee AS e2
	WHERE e.employee_id = e2.reports_to
);



SELECT t.track_id, t.name
FROM track AS t
WHERE milliseconds > ALL (
	SELECT t2.milliseconds
	FROM track AS t2
	JOIN genre AS g USING (genre_id)
	WHERE g.name = 'Rock'
);



SELECT e.employee_id, e.first_name, e.last_name
FROM employee AS e
WHERE NOT EXISTS (
	SELECT 1
	FROM customer AS c
	JOIN invoice AS i USING (customer_id)
	WHERE c.support_rep_id = e.employee_id 
);



SELECT t.track_id, t.name
FROM track AS t
WHERE EXISTS (
	SELECT 1
	FROM invoice_line AS il
	WHERE t.track_id = il.track_id AND invoice_id IS NOT NULL 
)
AND t.unit_price > ALL (
	SELECT t2.unit_price 
	FROM track AS t2
	WHERE t2.genre_id = (
		SELECT genre_id 
		FROM genre AS g
		WHERE g.name = 'Classical'
	)
);



WITH trackGenres AS (
	SELECT t.track_id, t.album_id, sum(genre_id) AS numOfGenres
	FROM track AS t
	JOIN genre AS g USING (genre_id)
	GROUP BY t.track_id, album_id 
)
SELECT DISTINCT a.album_id, a.title
FROM album AS a
JOIN trackGenres AS tg ON tg.album_id = a.album_id 
WHERE tg.numOfGenres > 5;


	
WITH employeeSales AS (
	SELECT c.support_rep_id AS employeeID, sum(i.total) AS sales
	FROM customer AS c
	JOIN invoice AS i USING (customer_id)
	GROUP BY c.support_rep_id
)
SELECT e.employee_id, e.first_name, e.last_name
FROM employee AS e
WHERE (
	SELECT sales
	FROM employeeSales
	WHERE employeeID = e.employee_id 
) > ANY (
	SELECT sales 
	FROM employeeSales
);


SELECT * FROM employee;

SELECT count(*) FROM track

SELECT playlist_id, count(track_id)
FROM playlist_track pt 
GROUP BY playlist_id ;


SELECT * FROM playlist p 

WITH plWithNumOfTracks AS (
	SELECT pl.playlist_id, count(track_id) AS numOfTracks
	FROM playlist_track AS pl
	GROUP BY pl.playlist_id
)
SELECT DISTINCT t.track_id, t.name
FROM track AS t
JOIN playlist_track AS pt USING (track_id)
JOIN plWithNumOfTracks AS pst ON pst.playlist_id = pt.playlist_id
WHERE numOfTracks > 5;