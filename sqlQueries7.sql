SELECT e.employee_id, e.first_name, e.last_name, e.hire_date
FROM employee AS e
WHERE EXTRACT (YEAR FROM hire_date) = 2004;


SELECT *
FROM invoice 
WHERE invoice_date > now() - INTERVAL '30 day';


SELECT c.customer_id, c.first_name, c.last_name, length(last_name)
FROM customer AS c
ORDER BY length(last_name)
LIMIT 1;


SELECT e.employee_id, e.first_name, e.last_name, e.hire_date
FROM  employee e 
WHERE e.hire_date < '2003-01-01'



SELECT c.first_name, c.last_name, length(first_name), length(last_name)
FROM customer AS c
WHERE length(first_name) = 5 AND length(last_name) = 5;


SELECT t.track_id, t.name
FROM track AS t
WHERE composer IS NOT NULL
AND composer LIKE '%John%';



SELECT i.invoice_id, i.invoice_date, i.customer_id 
FROM invoice AS i
WHERE EXTRACT (MONTH FROM i.invoice_date) = 6;


SELECT e.employee_id, e.first_name, e.last_name
FROM employee AS e
WHERE last_name LIKE '%n';


SELECT t.track_id, t.name, t.composer, t.milliseconds
FROM track AS t
WHERE t.composer IS NULL 
AND t.milliseconds > 300000;


SELECT c.customer_id, c.first_name, c.last_name
FROM customer AS c
JOIN invoice AS i ON c.customer_id = i.customer_id 
WHERE i.invoice_date + INTERVAL '1 year' < now();


SELECT t.track_id, t.name, length(t.name)
FROM track AS t
WHERE length(t.name) > 20;


SELECT c.customer_id, c.first_name, c.last_name, c.phone, c.fax
FROM customer AS c
WHERE c.phone IS NULL
OR c.fax IS NULL;



SELECT * 
FROM employee e 
ORDER BY hire_date ASC
LIMIT 5;



SELECT EXTRACT (YEAR FROM invoice_date) AS yr, EXTRACT (MONTH FROM invoice_date) AS mon, count(*) AS numOfInvoice
FROM invoice 
GROUP BY yr, mon 
ORDER BY yr, mon;


SELECT i.invoice_id, i.customer_id, i.invoice_date
FROM invoice AS i
WHERE i.invoice_date = (
	SELECT max(i2.invoice_date)
	FROM invoice AS i2
	WHERE i.customer_id = i2.customer_id 
)


SELECT a.album_id, a.title
FROM album AS a
WHERE lower(a.title) LIKE '%live%' OR lower(a.title) LIKE '%remix%';


SELECT t.track_id, t.name
FROM track AS t
WHERE composer IS NULL 
AND lower(t.name) LIKE '%unknown%';


SELECT count(track_id)
FROM track 
WHERE length(name) > (
	SELECT avg(length(t2.name))
	FROM track AS t2
)

SELECT count(*) FROM track;

SELECT now();

SELECT now() + INTERVAL '1 day';

SELECT now() + INTERVAL '1 month';

SELECT now() + INTERVAL '1 year';

SELECT now() + INTERVAL '1 hour';

SELECT now() + INTERVAL '1 minute';

SELECT now(), now() + INTERVAL '1 second';

SELECT now() - INTERVAL '1 day';

SELECT now() - INTERVAL '1 month';

SELECT now() - INTERVAL '1 year';

SELECT now() - INTERVAL '1 hour';

SELECT now() - INTERVAL '1 minute';

SELECT now(), now() - INTERVAL '1 second';

SELECT now() + INTERVAL '1 day' - INTERVAL '1 month';

SELECT now() 


SELECT current_date + INTERVAL '1 day';

SELECT current_timestamp + INTERVAL '5 hour' - INTERVAL '30 minute';

SELECT current_date;

SELECT current_date - date '1023-07-11'

SELECT to_char(current_date, 'dd/mm/yyyy');

SELECT to_char (current_date, 'month dd/yyyy');

SELECT to_char (current_date, 'day month dd/yyyy');

SELECT to_char( now() + INTERVAL '5 hour', 'hh12:mm:ss am')

SELECT to_date ('2024-11-5', 'yyyy-dd-mm')

SELECT EXTRACT (MONTH FROM  to_date ('2024-11-5', 'yyyy-dd-mm'))




