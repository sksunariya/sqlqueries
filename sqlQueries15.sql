

CREATE OR REPLACE FUNCTION cust_name (cust_id int) 
RETURNS TEXT
LANGUAGE plpgsql
AS $$
	DECLARE 
		cust_first_name varchar(255);
		cust_last_name varchar(255);
	BEGIN
		SELECT first_name, last_name
		INTO cust_first_name, cust_last_name
		FROM customer
		WHERE customer_id = cust_id;
	
		RETURN cust_first_name || cust_last_name;
	END;
$$;
	

SELECT cust_name(1);


CREATE OR REPLACE FUNCTION cust_invoices (cust_id int)
RETURNS int 
LANGUAGE plpgsql
AS $$
	DECLARE 
		cust_invoices int;
	BEGIN
		SELECT count(invoice_id)
		INTO cust_invoices
		FROM invoice
		GROUP BY customer_id;
	
		RETURN cust_invoices;
	END
$$;
	

SELECT cust_invoices(1);


CREATE OR REPLACE FUNCTION track_details(t_id int )
RETURNS TABLE (t_name varchar(255), album_name varchar(255), artist_name varchar(255))
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN query
		SELECT t.name, al.title, art.name
		FROM track AS t
		JOIN album AS al USING (album_id)
		JOIN artist AS art USING (artist_id)
		WHERE track_id = t_id;
	END
$$;

SELECT * FROM track_details(22);


CREATE OR REPLACE FUNCTION playlist_duration (p_id int) 
RETURNS int 
LANGUAGE plpgsql
AS $$
	DECLARE 
		total_duration INT;
	BEGIN
		SELECT sum(t.milliseconds)
		INTO total_duration 
		FROM playlist_track AS pt
		JOIN track AS t USING (track_id)
		where t.milliseconds is not null
		GROUP BY playlist_id
		HAVING playlist_id = p_id ;
	
		RETURN total_duration;
	END;
$$;


SELECT playlist_duration (4);
	

CREATE OR REPLACE FUNCTION sales_in_duration (start_date date, end_date date) 
RETURNS float8
LANGUAGE plpgsql
AS $$
	DECLARE 
		total_sales float8;
	BEGIN
		SELECT sum(total) 
		INTO total_sales 
		FROM invoice
		WHERE invoice_date > start_date AND invoice_date < end_date;
	
		RETURN total_sales;
	END
$$;

SELECT sales_in_duration('2022-02-22', '2024-03-04');
	

SELECT * FROM invoice;



CREATE OR REPLACE FUNCTION buyer_type (cust_id int) 
RETURNS TEXT 
LANGUAGE plpgsql
AS $$
	DECLARE 
		total_invoices int ;
	BEGIN
		SELECT count(invoice_id)
		INTO total_invoices
		FROM invoice
		GROUP BY customer_id
		HAVING customer_id = cust_id;
	
		IF total_invoices >= 7 THEN
			RETURN 'Frequent Buyer';
		ELSE 
			RETURN 'Occasional Buyer';
		END IF;
	END;
$$;
	
SELECT buyer_type (59);

SELECT customer_id, count(invoice_id)
FROM invoice 
GROUP BY customer_id;



CREATE OR REPLACE FUNCTION active_status (cust_id int) 
RETURNS TEXT
LANGUAGE plpgsql
AS $$
	DECLARE 
		isActive boolean;
	BEGIN 
		SELECT 1 
		INTO isActive
		FROM invoice
		WHERE customer_id = cust_id AND invoice_date > current_date - interval '1 month';
	
		IF isActive THEN 
			RETURN 'Active';
		ELSE 
			RETURN 'Inactive';
		END IF;
	END
$$;

SELECT active_status (1);

SELECT active_status(59);


CREATE OR REPLACE FUNCTION employee_status (emp_id int) 
RETURNS TEXT 
LANGUAGE plpgsql
AS $$
	DECLARE 
		emp_sales int;
	BEGIN
		SELECT count(invoice_id) 
		INTO emp_sales 
		FROM invoice AS i
		JOIN customer AS c USING (customer_id)
		JOIN employee AS e ON e.employee_id = c.support_rep_id
		GROUP BY employee_id
		having employee_id = emp_id;
	
		IF emp_sales > 15 THEN
			RETURN 'Good Performer';
		ELSE 
			RETURN 'Bad Performer';
		END IF;
	END
$$;
	

SELECT employee_status(3);

SELECT employee_id, count(invoice_id) 
FROM invoice AS i
JOIN customer AS c USING (customer_id)
JOIN employee AS e ON e.employee_id = c.support_rep_id
GROUP BY employee_id;
	


CREATE OR REPLACE FUNCTION genre_name (g_id int )
RETURNS TEXT 
LANGUAGE plpgsql
AS $$
	DECLARE 
		g_name varchar (255);
	BEGIN
		SELECT name 
		INTO g_name
		FROM genre
		WHERE genre_id = g_id;
	
		IF g_name is not null THEN
			RETURN g_name;
		ELSE 
			RETURN 'Unknown Genre';
		END IF;
	END;
$$;


SELECT genre_name(5);

SELECT genre_id 
FROM genre 
WHERE name IS NULL;


CREATE OR REPLACE FUNCTION album_popularity (a_id int) 
RETURNS TEXT 
LANGUAGE plpgsql
AS $$ 
	DECLARE 
		numOfTracks int;
	BEGIN
		SELECT count(track_id)
		INTO numOfTracks
		FROM track
		GROUP BY album_id
		HAVING album_id = a_id;
	
		IF numOfTracks > 10 THEN
			RETURN 'Popular album';
		ELSE 
			RETURN 'Not popular';
		END IF;
	END
$$;

SELECT album_popularity(15);
	
		
CREATE OR REPLACE FUNCTION avg_track_duration ()
RETURNS float8
LANGUAGE plpgsql
AS $$
	DECLARE 
		avg_duration float8;
	BEGIN
		SELECT avg(t.milliseconds)
		INTO avg_duration
		FROM track AS t;
		
		RETURN avg_duration;
	END
$$;
	

SELECT avg_track_duration();
		
		

CREATE OR REPLACE FUNCTION emp_sales () 
RETURNS TABLE (emp_id int, first_name varchar(255), last_name varchar(255), totalSales numeric)
LANGUAGE plpgsql
AS $$ 
	BEGIN
		RETURN query
		SELECT e.employee_id, e.first_name, e.last_name, sum(i.total)
		FROM invoice AS i
		JOIN customer AS c USING (customer_id)
		JOIN employee AS e ON e.employee_id = c.support_rep_id
		group by e.employee_id, e.first_name, e.last_name;
	END
$$;

DROP FUNCTION emp_sales()


SELECT * FROM emp_sales();


CREATE OR REPLACE FUNCTION avgTrackLength()
RETURNS TABLE (album_id int, name varchar (255), avgTrackLength numeric)
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN query
		SELECT a.album_id, a.title, avg(t.milliseconds)
		FROM album AS a
		JOIN track AS t USING (album_id)
		GROUP BY a.album_id, a.title;
	END
$$;

DROP FUNCTION avgtracklength()

SELECT * FROM avgTrackLength();


CREATE OR REPLACE FUNCTION cust_highest_total()
RETURNS TABLE (customer_id int, first_name varchar(255), last_name varchar(255), highestInvoice NUMERIC)
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN query
		SELECT c.customer_id, c.first_name, c.last_name, max(i.total)
		FROM customer AS c
		JOIN invoice AS i USING (customer_id)
		GROUP BY c.customer_id, c.first_name, c.last_name;
	END
$$;

SELECT * FROM cust_highest_total();



CREATE OR REPLACE FUNCTION avg_invoice ()
RETURNS TABLE (customer_id int, first_name varchar (255), last_name varchar (255), avgInvoice NUMERIC)
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN query
		SELECT c.customer_id, c.first_name, c.last_name, avg(i.total)
		FROM customer AS c
		JOIN invoice AS i USING (customer_id)
		GROUP BY c.customer_id, c.first_name, c.last_name;
	END
$$;
	
SELECT * FROM avg_invoice();



CREATE OR REPLACE FUNCTION most_expensive_track ()
RETURNS TABLE (a_id int, album_title varchar (255), t_id int, track_name varchar(255), trackAmount NUMERIC )
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN query
		WITH albumTrackTable AS (
			SELECT a.album_id, a.title, t.track_id, t.name, t.unit_price,
				RANK() OVER (PARTITION BY a.album_id ORDER BY t.unit_price desc)
			FROM track AS t
			JOIN album AS a USING (album_id)
		) 
		SELECT album_id, title, track_id, name, unit_price
		FROM albumTrackTable
		WHERE RANK = 1;
	END
$$;

SELECT * FROM most_expensive_track();

DROP FUNCTION most_expensive_track()




CREATE OR REPLACE FUNCTION cust_tracks (cust_id INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
	DECLARE 
		totalTracks int ;
	BEGIN
		SELECT sum(quantity)
		INTO totalTracks
		FROM invoice 
		JOIN invoice_line USING (invoice_id)
		GROUP BY customer_id
		HAVING customer_id = cust_id;
	
		RETURN totalTracks;
	END
$$;

SELECT cust_tracks(2);


CREATE OR REPLACE FUNCTION topemployees ()
RETURNS TABLE (e_id int, f_name varchar (255), l_name varchar(255), sales numeric)
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN query
		WITH empSales AS (
			SELECT distinct e.employee_id, e.first_name, e.last_name, 
				sum(i.total) over (partition by e.employee_id) AS totalSales
			FROM employee AS e
			JOIN customer AS c ON e.employee_id = c.support_rep_id
			JOIN invoice AS i USING (customer_id)
		)
		SELECT employee_id, first_name, last_name, totalSales
		FROM empSales
		ORDER BY totalSales
		LIMIT 3;
	END
$$;

SELECT * FROM topemployees();



CREATE OR REPLACE FUNCTION least_expensive_track()
RETURNS TABLE (a_id int, a_title varchar(255), t_id int, t_name varchar (255), t_unit_price NUMERIC)
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN query
		WITH trackRanks AS (
			SELECT a.album_id, a.title, t.track_id, t.name, t.unit_price,
				RANK () OVER (PARTITION BY a.album_id ORDER BY t.unit_price) AS trackRank
			FROM album AS a
			JOIN track AS t USING (album_id)
		)
		SELECT album_id, title, track_id, name, unit_price
		FROM trackRanks
		WHERE trackRank = 1;
	END
$$;

SELECT * FROM least_expensive_track();


CREATE OR REPLACE FUNCTION artist_tracks (artist_name varchar(255)) 
RETURNS int 
LANGUAGE plpgsql
AS $$
	DECLARE 
		totalTracks int;
	BEGIN
		SELECT count(t.track_id)
		INTO totalTracks
		FROM artist AS art
		JOIN album AS a USING (artist_id)
		JOIN track AS t USING (album_id)
		GROUP BY art.name
		HAVING artist_name = art.name;
	
		RETURN totalTracks;
	END
$$;

SELECT artist_tracks('AC/DC');
	

SELECT * FROM artist;


SELECT * FROM customer;

CREATE OR REPLACE PROCEDURE add_cust (cust_id int, f_name varchar (255), l_name varchar(255), email_id TEXT, support_id int)
LANGUAGE plpgsql
AS $$
	BEGIN 
		INSERT INTO customer (customer_id, first_name, last_name, email, support_rep_id)
		VALUES (cust_id, f_name, l_name, email_id, support_id);
	END
$$;
	
CALL add_cust (60, 'Krishan', 'Yadav', 'abc@email.com', 4);

SELECT * FROM customer;



CREATE OR REPLACE PROCEDURE update_contact (cust_id int, contact_number TEXT)
LANGUAGE plpgsql
AS $$
	BEGIN 
		UPDATE customer 
		SET phone = contact_number
		WHERE customer_id = cust_id;
	END
$$;

CALL update_contact(60, '345854503');



CREATE OR REPLACE PROCEDURE delete_cust (cust_id int) 
LANGUAGE plpgsql
AS $$
	BEGIN 
		DELETE FROM customer
		WHERE customer_id = cust_id;
	END
$$;

CALL delete_cust(60);


CREATE OR REPLACE PROCEDURE retrieve_albums (a_id int)
LANGUAGE plpgsql
AS $$
	BEGIN 
		SELECT *
		FROM album
		WHERE artist_id = a_id;
	END
$$;


CALL retrieve_albums (4);


CREATE OR REPLACE PROCEDURE update_cust_name (cust_id int, f_name varchar(255), l_name varchar(255))
LANGUAGE plpgsql
AS $$
	BEGIN 
		BEGIN
			UPDATE customer 
			SET first_name = f_name , last_name = l_name
			WHERE customer_id = cust_id;
			
			COMMIT;
		
			EXCEPTION WHEN OTHERS THEN 
				ROLLBACK;
				RAISE NOTICE 'Error while updating name. %', SQLERRM ;
		END;
	END;
$$;


CALL update_cust_name(60, 'Krishna', 'Yadav');


CREATE OR REPLACE PROCEDURE update_cust_name (cust_id int, f_name varchar(255), l_name varchar(255))
LANGUAGE plpgsql
AS $$
	BEGIN 
		BEGIN
			UPDATE customer 
			SET first_name = f_name , last_name = l_name
			WHERE customer_id = cust_id;
		
			EXCEPTION 
            WHEN OTHERS THEN 
				ROLLBACK;
				RAISE NOTICE 'Error while updating name. %', SQLERRM ;
		END;
        COMMIT;
	END;
$$;


CALL update_cust_name(60, 'Krishna', 'Yadav');


SELECT * FROM customer;
