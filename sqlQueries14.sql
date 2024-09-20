

CREATE OR REPLACE FUNCTION one() 
RETURNS int
LANGUAGE SQL 
AS $$
    SELECT 1;
$$;


SELECT one();




CREATE OR REPLACE FUNCTION add_num(num1 integer, num2 integer) 
RETURNS float8 
LANGUAGE SQL 
AS $$
    SELECT $1 + $2;
$$;

SELECT add_num(5, 4);




CREATE FUNCTION fetch_first_customer_from_country (cntry varchar(255))
RETURNS varchar(255)
LANGUAGE SQL 
AS $$
	SELECT first_name
	FROM customer AS c
	WHERE c.country = cntry
	LIMIT 1;
$$;

SELECT fetch_first_customer_from_country('Austria');




CREATE OR REPLACE FUNCTION fetch_country_customers (cntry varchar(255))
RETURNS TABLE (customer_id int, first_name varchar(255), last_name varchar(255), country varchar(255))
LANGUAGE sql
AS $$
	SELECT c.customer_id, c.first_name, c.last_name, c.country
	FROM customer as c
	WHERE c.country = cntry;

$$;



DROP FUNCTION fetch_country_customers(character varying)

SELECT * from fetch_country_customers('USA');


SELECT * FROM customer WHERE country = 'USA';




SELECT * FROM employee;

CREATE FUNCTION change_name (name varchar(255), emp_id int) RETURNS varchar(255) AS $$
	UPDATE employee 
	SET first_name = name
	WHERE employee_id = emp_id;

	select first_name from employee where employee_id = emp_id;
$$ LANGUAGE SQL;
	

SELECT change_name('Ram', 2);

SELECT change_name('Nancy', 2);




CREATE OR REPLACE FUNCTION double_num (invoice)
RETURNS float8
LANGUAGE SQL
AS $$
	SELECT $1.total * 2
	FROM invoice
	WHERE invoice_id = 5;
$$;

DROP FUNCTION double_num(invoice);

SELECT invoice_id, total, double_num(invoice.*)
FROM invoice 
WHERE invoice_id = 5;




CREATE FUNCTION add_ten (num int)
RETURNS int
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN ( num + 10 );
END;
$$;

SELECT add_ten(5);



CREATE FUNCTION fetch_country_customers(cntry varchar(255))
RETURNS TABLE (employee_id int, first_name varchar(255), last_name varchar(255), country varchar(255))
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT c.customer_id, c.first_name, c.last_name, c.country
    FROM customer as c
    WHERE c.country = cntry;
END;
$$;


SELECT * from fetch_country_customers('USA');


SELECT * FROM customer WHERE country = 'USA';




CREATE OR REPLACE FUNCTION customer_name (cust_id int)
RETURNS text
LANGUAGE plpgsql
AS $$
	DECLARE 
		f_name text;
		l_name text;
	begin
	
		SELECT first_name, last_name
		INTO f_name, l_name
		FROM customer
		where customer_id = cust_id;
		return f_name || ' ' || l_name;
	end;
$$;


DROP FUNCTION customer_name(integer) 

SELECT customer_name(1);



CREATE OR REPLACE  FUNCTION album_title (album_id int)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
	DECLARE 
		album_title varchar(255);
	BEGIN
		SELECT title
		INTO album_title
		FROM album as a
		WHERE a.album_id = album_title.album_id;
		
		return album_title;
	END
$$;


SELECT album_title(2);


CREATE OR REPLACE FUNCTION total_invoice ()
RETURNS int 
LANGUAGE plpgsql
AS $$
	DECLARE 
		numOfInvoice int;
	BEGIN
		SELECT count(invoice_id)
		INTO numOfInvoice
		FROM invoice;

		RETURN numOfInvoice;
	END;
$$;
	

SELECT total_invoice();

SELECT count(*) FROM invoice;





CREATE OR REPLACE FUNCTION artist_name (album_id int)
RETURNS TEXT 
LANGUAGE plpgsql
AS $$
	DECLARE
		artistName TEXT;
	BEGIN
		SELECT art.name
		INTO artistName
		FROM album AS a
		JOIN artist AS art USING (artist_id)
		WHERE a.album_id = artist_name.album_id;
		
		RETURN artistName;
	END;
$$;
	

SELECT artist_name(12);


SELECT art.name
FROM album AS a
JOIN artist AS art USING (artist_id)
WHERE a.album_id = 2;



CREATE OR REPLACE FUNCTION count_genre_tracks (g_id int)
RETURNS int 
LANGUAGE plpgsql
AS $$
	DECLARE 
		numOfTracks int;
	BEGIN
		SELECT count(track_id)
		INTO numOfTracks
		FROM genre AS g
		JOIN track AS t USING (genre_id)
		WHERE g.genre_id = g_id;
	
		RETURN numOfTracks;
	END;
$$;
	
SELECT count_genre_tracks(2);


