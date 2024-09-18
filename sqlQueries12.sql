
SELECT t.genre_id, t.track_id, t.name, t.unit_price,
	RANK () OVER (PARTITION BY t.genre_id ORDER BY t.unit_price)
FROM track AS t



SELECT t.composer, t.name, 
	count(t.track_id) OVER (PARTITION BY t.composer ORDER BY t.name)
FROM track AS t;



SELECT t.genre_id, t.track_id, t.name, t.milliseconds, 
	abs(t.milliseconds - avg(t.milliseconds) OVER (PARTITION BY t.genre_id)) AS diff
FROM track AS t



WITH employeeInvoices AS (
	SELECT DISTINCT c.support_rep_id, 
		count(i.invoice_id) OVER (PARTITION BY c.support_rep_id) AS numOfInvoice
	FROM customer AS c
	JOIN invoice AS i USING (customer_id)
)
SELECT e.employee_id, e.first_name, e.last_name, numOfInvoice,
	RANK () OVER (ORDER BY numOfInvoice DESC)
FROM employee AS e
JOIN employeeInvoices AS ei ON ei.support_rep_id = e.employee_id ;



SELECT c.customer_id, c.first_name, c.last_name, i.invoice_date, i.total,
	sum(i.total) OVER (PARTITION BY c.customer_id ORDER BY i.invoice_date) AS cumulativeSales
FROM customer AS c
JOIN invoice AS i USING (customer_id);



WITH avgCustomerTotal AS (
	SELECT DISTINCT i.customer_id, 
		avg(i.total) OVER (PARTITION BY i.customer_id) AS avgTotal
	FROM invoice AS i
)
SELECT c.customer_id, c.first_name, c.last_name, avgTotal,
	RANK () OVER (ORDER BY avgTotal DESC)
FROM customer AS c
JOIN avgCustomerTotal AS act USING (customer_id)



SELECT t.genre_id, t.track_id, t.name, t.unit_price,
	t.unit_price / sum(t.unit_price) OVER (PARTITION BY t.genre_id) * 100 AS percentageContribution
FROM track AS t



SELECT t.album_id, t.track_id, t.name, t.milliseconds,
	sum(t.milliseconds) OVER (PARTITION BY t.album_id ORDER BY t.milliseconds) AS runningTotal
FROM track AS t;


WITH albumSalesTable AS (
	SELECT  t.album_id, t.track_id, il.unit_price, il.quantity, i.invoice_date,
		sum(il.unit_price * il.quantity) OVER (PARTITION BY t.album_id ORDER BY i.invoice_date) AS albumSales
	FROM track AS t
	JOIN invoice_line AS il USING (track_id)
	JOIN invoice AS i USING (invoice_id)
)
SELECT album_id, track_id, albumSales,
	RANK () OVER (ORDER BY albumSales DESC)
FROM albumSalesTable;



SELECT i.billing_country, i.invoice_id, i.invoice_date,
	count(i.invoice_id) OVER (PARTITION BY i.billing_country ORDER BY i.invoice_date) AS cumulativeInvoices
FROM invoice AS i



WITH composerTracks AS (
	SELECT t.composer,
		count(t.track_id) OVER (PARTITION BY t.composer) AS numOfTracks
	FROM track AS t
	WHERE t.composer IS NOT NULL
)
SELECT composer, numOfTracks,
	RANK () OVER (ORDER BY numOfTracks DESC)
FROM composerTracks;



SELECT DISTINCT t.album_id, a.title, 
	count(t.track_id) OVER (PARTITION BY t.album_id) AS numOfTracks
FROM album AS a
JOIN track AS t USING (album_id)
ORDER BY numOfTracks DESC
LIMIT 5


SELECT i.billing_country, i.invoice_id, i.invoice_date,
	sum(i.total) OVER (PARTITION BY i.billing_country ORDER BY i.invoice_date) AS cumulativeSum
FROM invoice AS i


SELECT t.album_id, t.track_id, t.name, t.milliseconds,
	sum (t.milliseconds) OVER (PARTITION BY t.album_id ORDER BY t.milliseconds) AS cumulativeSum,
	RANK () OVER (PARTITION BY t.album_id ORDER BY t.milliseconds) AS trackRank
FROM track AS t;


WITH employeeSalesTable AS (
	SELECT DISTINCT e.employee_id, e.first_name, e.last_name, 
		sum(i.total) OVER (PARTITION BY e.employee_id) AS employeesales
	FROM employee AS e
	JOIN customer AS c ON c.support_rep_id = e.employee_id
	JOIN invoice AS i USING (customer_id)
)
SELECT employee_id, first_name, last_name, employeeSales,
	RANK () OVER (ORDER BY employeeSales DESC)
FROM employeeSalesTable;





CREATE OR REPLACE PROCEDURE say_nothing()
LANGUAGE plpgsql
AS $$
BEGIN 
	RAISE NOTICE 'nothing';
END
$$;

CALL say_nothing()





CREATE OR REPLACE PROCEDURE update_name()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer
	SET first_name = 'Ram'
	WHERE customer_id = 6;
END
$$;

CALL update_name();


SELECT * 
FROM customer 
WHERE customer_id = 6;




CREATE OR REPLACE PROCEDURE retrieve_name (IN emp_id INT) 
LANGUAGE plpgsql
AS $$
DECLARE 
	name varchar;
BEGIN 
	SELECT first_name
	INTO name
	FROM employee
	WHERE emp_id = emp_id;

	RAISE NOTICE '%', name;
END;
$$;

CALL retrieve_name(3)


SELECT * 
FROM employee 
WHERE employee_id = 3;





CREATE OR REPLACE PROCEDURE update_employee (IN emp_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
	name varchar;
BEGIN
	SELECT first_name 
	INTO name
	FROM employee
	WHERE employee_id = 7;

	UPDATE employee
	SET last_name = name 
	WHERE employee_id = emp_id;
END
$$;

CALL update_employee(3);


SELECT * 
FROM employee 
WHERE employee_id = 3;




CREATE OR REPLACE PROCEDURE retrieve_employee_name (IN emp_id INT) 
LANGUAGE plpgsql
AS $$
DECLARE 
	emp_exists bool;
	emp_name varchar;
BEGIN
	SELECT 1, first_name
	INTO emp_exists, emp_name
	FROM employee
	WHERE employee_id = emp_id;

	IF emp_exists THEN
		RAISE NOTICE '%', emp_name;
	ELSE
		RAISE NOTICE 'Employee doesn''t exist';
	END IF;
END
$$;

CALL retrieve_employee_name(10);


SELECT *
FROM employee
WHERE employee_id = 3;


