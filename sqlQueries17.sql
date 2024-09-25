
CREATE OR REPLACE FUNCTION check_price()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		IF NEW.unit_price > 4 THEN 
			RAISE EXCEPTION 'Price cannot be more than 4.';
		END IF;
		
	
		RETURN NEW;
	END
$$;

CREATE OR REPLACE TRIGGER check_price_trigger
BEFORE INSERT ON invoice_line
FOR EACH ROW 
EXECUTE FUNCTION check_price();


INSERT INTO invoice_line (invoice_line_id, invoice_id, track_id, unit_price, quantity)
	VALUES (3001, 424, 3503, 1, 4);


INSERT INTO invoice_line (invoice_line_id, invoice_id, track_id, unit_price, quantity)
	VALUES (3003, 424, 3503, 5, 4);
	
SELECT * FROM invoice_line;

SELECT * FROM invoice;
SELECT * FROM track;



CREATE OR REPLACE FUNCTION cascade_delete()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		
		DELETE FROM invoice 
		WHERE customer_id = OLD.customer_id;
	
		RETURN OLD;
	END
$$;

CREATE OR REPLACE TRIGGER cascade_delete_trigger
BEFORE DELETE ON customer
FOR EACH ROW 
EXECUTE FUNCTION cascade_delete();


DELETE FROM customer
WHERE customer_id = 60;



ALTER TABLE album
ADD COLUMN release_year int DEFAULT 2020;


CREATE OR REPLACE FUNCTION update_release_year_fun()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		UPDATE album 
		SET release_year = 2023
		WHERE album_id = NEW.album_id;
	
		RETURN NEW;
	END
$$;

CREATE OR REPLACE TRIGGER release_year_trigger
AFTER INSERT ON album
FOR EACH ROW 
EXECUTE FUNCTION update_release_year_fun();


INSERT INTO album (album_id, title, artist_id)
	VALUES (400, 'noTitle', 257);

SELECT * FROM album;



ALTER TABLE customer 
ADD COLUMN balance NUMERIC DEFAULT FLOOR(RANDOM() * 100) + 1;


SELECT * FROM customer;


CREATE OR REPLACE FUNCTION check_bal()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		IF (SELECT balance 
			FROM customer
			WHERE customer_id = NEW.customer_id
			) > 50 THEN 
			RAISE EXCEPTION 'Can''t place order. Balance is greater than 50.';
		END IF;
	
		RETURN NEW;
	END
$$;

CREATE OR REPLACE TRIGGER check_bal_trigger
BEFORE INSERT ON invoice
FOR EACH ROW 
EXECUTE FUNCTION check_bal();


INSERT INTO invoice (invoice_id, customer_id, invoice_date, total)
	VALUES (417, 14, now()-INTERVAL '2 year', 5);


SELECT * FROM invoice;


CREATE OR REPLACE FUNCTION log_changes()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		IF OLD.city != NEW.city AND OLD.country != NEW.country THEN 
			RAISE NOTICE 'both city and country of address was changed.';
		END IF;
	
		RETURN NEW;
	END
$$;

CREATE OR REPLACE TRIGGER cust_changes_trigger
AFTER UPDATE ON customer
FOR EACH ROW 
EXECUTE FUNCTION log_changes();


UPDATE customer 
SET city = 'new_delhi', country = 'bharat'
WHERE customer_id = 59;


UPDATE customer 
SET city = 'delhi', country = 'india'
WHERE customer_id = 59;


CREATE TABLE invoice_summary (
	invoice_summary_id serial PRIMARY KEY,
	customer_id int,
	total_amount NUMERIC,
	invoice_date date
)

INSERT INTO invoice_summary (customer_id, total_amount, invoice_date)
	VALUES (1, 5, now());

SELECT * FROM invoice_summary;



CREATE OR REPLACE FUNCTION group_invoices()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	DECLARE 
		total_amnt NUMERIC;
	BEGIN 
		SELECT sum(total)
		INTO total_amnt
		FROM invoice
		WHERE customer_id = NEW.customer_id AND date(invoice_date) = date(NEW.invoice_date);

		raise notice 'customer total amount on % is %', new.invoice_date, total_amnt;
	
		INSERT INTO invoice_summary (customer_id, total_amount, invoice_date)
			VALUES (NEW.customer_id, total_amnt, NEW.invoice_date);

		return new;
	END
$$;

CREATE OR REPLACE TRIGGER group_trigger
AFTER INSERT ON invoice
FOR EACH ROW 
EXECUTE FUNCTION group_invoices();


INSERT INTO invoice (invoice_id, customer_id, invoice_date, total)
	VALUES (419, 14, now() - INTERVAL '2 year', 20);


SELECT * FROM invoice ;



CREATE TABLE track_audit (
	track_audit_id serial PRIMARY KEY,
	old_price NUMERIC,
	new_price NUMERIC
)


CREATE OR REPLACE FUNCTION audit_change()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		IF NEW.unit_price >= OLD.unit_price * 1.2 THEN 
			INSERT INTO track_audit (old_price, new_price)
				VALUES (OLD.unit_price, NEW.unit_price);
			RAISE NOTICE 'Price change is more than 20 percent.';
		ELSE
			RAISE NOTICE 'Price change is less than 20 percent.';
		END IF;
	
		RETURN NEW;
	END
$$;

CREATE OR REPLACE TRIGGER price_trigger
AFTER UPDATE ON track
FOR EACH ROW 
EXECUTE FUNCTION audit_change();


UPDATE track 
SET unit_price = 1
WHERE track_id = 1;


UPDATE track 
SET unit_price = 1.2
WHERE track_id = 2;


SELECT * FROM track;


SELECT * FROM track_audit;



CREATE TABLE genre_summary (
	genre_summary_id serial PRIMARY KEY,
	genre_id int,
	avg_track_length NUMERIC
);


DROP TABLE genre_summary;


INSERT INTO genre_summary (genre_id, avg_track_length)
SELECT genre_id, avg(milliseconds)
FROM 
track
GROUP BY genre_id;


SELECT * FROM genre_summary;



CREATE OR REPLACE FUNCTION update_avg()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	DECLARE 
		new_avg NUMERIC;
	BEGIN 
		SELECT avg(milliseconds)
		INTO new_avg
		FROM track
		GROUP BY genre_id
		HAVING genre_id = NEW.genre_id;
		
		UPDATE genre_summary
		SET avg_track_length = new_avg
		where genre_id = new.genre_id;
	
		RETURN NEW;
	END
$$;

CREATE OR REPLACE TRIGGER update_avg_trigger
AFTER INSERT ON track
FOR EACH ROW 
EXECUTE FUNCTION update_avg();


INSERT INTO track (track_id, name, media_type_id, genre_id, milliseconds, unit_price)
	VALUES (3600, 'no Name',2, 9, 10000000, 5);


SELECT * FROM track;


SELECT * FROM genre_summary;



ALTER TABLE employee 
ADD COLUMN emp_rank int;


WITH emp_ranks AS (
	SELECT employee_id, 
		RANK () OVER (ORDER BY hire_date) AS employee_rank
	FROM employee
)
UPDATE employee AS e1
SET emp_rank = (
	SELECT employee_rank
	FROM emp_ranks
	WHERE e1.employee_id = emp_ranks.employee_id
);

SELECT * FROM employee;


CREATE OR REPLACE FUNCTION check_rank()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		IF OLD.emp_rank < NEW.emp_rank THEN 
			RAISE EXCEPTION 'Demotion is not permitted.';
		ELSE
			RAISE NOTICE 'Rank changed.';
		END IF;
	
		RETURN NEW;
	END
$$;

CREATE OR REPLACE TRIGGER rank_trigger
BEFORE UPDATE ON employee
FOR EACH ROW 
EXECUTE FUNCTION check_rank();



UPDATE employee 
SET emp_rank = 5
WHERE employee_id = 7;

SELECT * FROM employee;





