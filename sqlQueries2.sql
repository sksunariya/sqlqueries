

SELECT * FROM playlist;


SELECT p.name, sum(t.milliseconds) AS toalDuration
FROM playlist AS p
JOIN playlist_track AS pt ON p.playlist_id  = pt.playlist_id 
JOIN track AS t ON pt.track_id  = t.track_id 
GROUP BY p.name 
ORDER BY sum(t.milliseconds) DESC;



SELECT *
FROM customer
WHERE customer_id NOT IN (
SELECT customer_id FROM invoice);



SELECT g.genre_id, g.name, avg(t.unit_price) AS averageUnitPrice 
FROM track AS t
JOIN genre AS g ON t.genre_id = g.genre_id
GROUP BY g.genre_id , g.name
ORDER BY averageUnitPrice DESC;



SELECT a.name
FROM artist AS a
JOIN album AS alb ON alb.artist_id = a.artist_id 
GROUP BY a.name 
HAVING count(*) > 5;



SELECT i.invoice_id , sum(il.quantity)
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
GROUP BY i.invoice_id;



SELECT a.name, count(t.track_id) AS totalTracks
FROM artist AS a
JOIN album AS alb ON alb.artist_id = a.artist_id 
JOIN track AS t ON alb.album_id = t.album_id 
GROUP BY a.name
ORDER BY totalTracks DESC
LIMIT 1;


SELECT * FROM playlist_track pt ;

SELECT p.name, count(pt.track_id) AS numberOfTracks
FROM playlist AS p
JOIN playlist_track AS pt ON p.playlist_id = pt.playlist_id 
GROUP BY p.name 
HAVING count(pt.track_id) > 50;


SELECT * FROM customer;



SELECT c.customer_id, c.first_name, c.last_name, sum(i.total) AS amountSpent, count(i.invoice_id) AS numberOfInvoices
FROM customer AS c
JOIN invoice AS i ON i.customer_id = c.customer_id 
GROUP BY c.customer_id , c.first_name , c.last_name 
ORDER BY c.customer_id;



SELECT name, milliseconds 
FROM track 
ORDER BY milliseconds DESC 
LIMIT 1;

SELECT * FROM album;


SELECT a.title , count(t.track_id) AS totalTracks
FROM album AS a
JOIN track AS t ON a.album_id = t.album_id 
GROUP BY a.title;




SELECT a.title , count(t.track_id) AS totalTracks, sum(il.unit_price * il.quantity) AS trackSales
FROM album AS a
JOIN track AS t ON a.album_id = t.album_id 
JOIN invoice_line AS il ON t.track_id = il.track_id 
GROUP BY a.title;



SELECT employee_id , first_name , last_name 
FROM employee AS e
WHERE employee_id NOT IN (
	SELECT support_rep_id FROM customer
);


SELECT * FROM invoice_line ORDER BY quantity;


SELECT avg(totalQuantity) AS avgTracksPerInvoice FROM (
	SELECT invoice_id, sum(quantity) AS totalQuantity
	FROM invoice_line
	GROUP BY invoice_id 
);



SELECT g.name, sum(total) AS totalSales
FROM genre AS g
JOIN track AS t ON g.genre_id =  t.genre_id
JOIN invoice_line AS il ON il.track_id = t.track_id
JOIN invoice AS i ON il.invoice_id = i.invoice_id
GROUP BY g.name
ORDER BY totalSales DESC
LIMIT 3;



SELECT g.name, sum(il.unit_price * il.quantity) AS totalSales
FROM genre AS g
JOIN track AS t ON g.genre_id =  t.genre_id
JOIN invoice_line AS il ON il.track_id = t.track_id
GROUP BY g.name
ORDER BY totalSales DESC
LIMIT 3;



SELECT newTable.mon, sum(newTable.total)
FROM (
	SELECT EXTRACT(YEAR FROM invoice_date) AS yr, EXTRACT(MONTH FROM invoice_date) AS mon, total
	FROM invoice 
	WHERE EXTRACT(YEAR FROM invoice_date) = 2022
) AS newTable
GROUP BY newTable.mon ;



SELECT invoice_date, total 
FROM invoice;



SELECT billing_country, sum(total) AS totalSales
FROM invoice AS i
GROUP BY billing_country ;











