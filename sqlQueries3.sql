


SELECT cust.customer_id, cust.first_name , t.genre_id 
FROM customer AS cust
INNER JOIN invoice AS i ON cust.customer_id = i.customer_id
INNER JOIN invoice_line AS il ON il.invoice_id = i.invoice_id 
INNER JOIN track AS t ON t.track_id = il.track_id 
WHERE  t.genre_id = (SELECT genre_id FROM genre WHERE name = 'Metal');


SELECT * FROM customer;



SELECT cust.customer_id, cust.first_name, sum(total) AS amountSpent
FROM customer AS cust
LEFT JOIN invoice AS i ON i.customer_id = cust.customer_id 
GROUP BY cust.customer_id , cust.first_name ;



SELECT customer_id 
FROM customer 
WHERE customer_id NOT IN (
	SELECT customer_id
	FROM invoice
);



SELECT i.invoice_id 
FROM invoice_line AS il
RIGHT JOIN invoice AS i ON i.invoice_id = il.invoice_id 
WHERE il.invoice_id IS NULL;


SELECT count(*) FROM invoice;


SELECT *
FROM invoice 
WHERE invoice_id NOT IN ( 
	SELECT invoice_id 
	FROM invoice_line 
);



-- TO SHOW ALL THE TABLES IN THE DATABASE
SELECT *
FROM pg_catalog.pg_tables;


-- TO SHOW ATTRIBUTES IN A SPECIFIC TABLE
SELECT * 
FROM information_schema.columns 
WHERE table_name = 'employee'
ORDER BY ordinal_position ;



SELECT p.playlist_id, p.name, count(pt.track_id) AS numOfTracks 
FROM playlist AS p
FULL JOIN playlist_track AS pt ON p.playlist_id = pt.playlist_id 
GROUP BY p.playlist_id ,p.name ;

SELECT * FROM playlist_track WHERE playlist_id = 2;

SELECT * 
FROM artist
NATURAL JOIN album;




SELECT al.album_id, al.title, sum(il.unit_price * il.quantity) AS totalSales
FROM album AS al
JOIN track AS t ON al.album_id = t.album_id 
JOIN invoice_line AS il ON il.track_id = t.track_id
GROUP BY al.album_id, al.title
ORDER BY totalSales DESC;



SELECT e1.employee_id, e1.first_name, e2.employee_id AS manager_id, e2.first_name AS manager_name
FROM employee AS e1
LEFT JOIN employee AS e2 ON e2.employee_id = e1.reports_to;

SELECT * FROM employee



SELECT c.customer_id, c.first_name, sum(quantity) AS totalPurchase
FROM customer AS c
INNER JOIN invoice AS i ON i.customer_id = c.customer_id 
INNER JOIN invoice_line AS il ON il.invoice_id = i.invoice_id 
GROUP BY c.customer_id , c.first_name 
HAVING sum(quantity) > 5
ORDER BY totalPurchase;



SELECT track_id, name
FROM track
WHERE track_id IN (
	SELECT track_id
	FROM (
		SELECT track_id , count(playlist_id)
		FROM playlist_track
		GROUP BY track_id 
		HAVING count(playlist_id) > 3
	)
)


SELECT count(track_id)
FROM track;



SELECT e.first_name, e.last_name, sum(total) AS totalSales
FROM employee AS e
LEFT JOIN customer AS c ON c.support_rep_id = e.employee_id 
LEFT JOIN invoice AS i ON i.customer_id = c.customer_id 
GROUP BY e.first_name, e.last_name 
ORDER BY sum(total);

SELECT * FROM employee;



SELECT artist_id, name
FROM artist 
WHERE artist_id NOT IN (
	SELECT artist_id 
	FROM album
);

SELECT artist.artist_id, artist.name 
FROM artist
LEFT JOIN album ON artist.artist_id = album.artist_id 
WHERE album_id IS NULL
ORDER BY artist_id ;



SELECT track_id, name 
FROM track
WHERE track_id NOT IN (
	SELECT track_id 
	FROM invoice_line
)

SELECT t.track_id, t.name 
FROM track AS t
LEFT JOIN invoice_line AS il ON t.track_id = il.track_id 
WHERE invoice_line_id IS NULL
ORDER BY t.track_id;



SELECT cust.customer_id , cust.first_name , cust.last_name 
FROM customer AS cust
LEFT JOIN (
	SELECT c.customer_id, sum(total) AS spentAmount
	FROM customer AS c
	LEFT JOIN invoice AS i ON i.customer_id = c.customer_id 
	GROUP BY c.customer_id
) AS newTable ON newTable.customer_id = cust.customer_id 
WHERE newTable.spentAmount > ( 
	SELECT avg(total)
	FROM invoice
);

