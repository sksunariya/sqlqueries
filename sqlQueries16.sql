

CREATE OR REPLACE FUNCTION t_fun()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		RAISE NOTICE 't_fun was called.';
		RETURN NEW;
	END
$$;

DROP FUNCTION t_fun() CASCADE 



CREATE TRIGGER newTrigger 
AFTER INSERT OR UPDATE OR DELETE 
ON customer
FOR EACH ROW 
EXECUTE FUNCTION t_fun();

DROP FUNCTION t_fun() CASCADE;

UPDATE customer 
SET last_name = 'noName'
WHERE customer_id = 60;


SELECT * FROM customer;




CREATE OR REPLACE FUNCTION logging_fun()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		RAISE NOTICE 'Value inserted: %, %, %, %', NEW.invoice_id, NEW.customer_id, now(), 4.3;
		
		RETURN NEW;
	END
$$;

CREATE OR REPLACE TRIGGER log_invoice
AFTER INSERT ON invoice
FOR EACH ROW 
EXECUTE FUNCTION logging_fun();
	
INSERT INTO invoice (invoice_id, customer_id, invoice_date, total)
	VALUES (421, 60, now(), 5.4);
	

SELECT * FROM invoice WHERE invoice_id = 420;

ALTER TABLE customer ADD COLUMN last_update timestamp DEFAULT NULL;

SELECT * FROM customer;

CREATE OR REPLACE FUNCTION last_update_fun ()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		NEW.last_update := now();
		raise notice 'last_update_fun was called.';
		RETURN NEW;
	END
$$;

CREATE OR REPLACE TRIGGER last_update_trigger
BEFORE UPDATE ON customer
FOR EACH ROW 
EXECUTE FUNCTION last_update_fun();


UPDATE customer 
SET last_name = 'noName'
WHERE customer_id = 60;



CREATE OR REPLACE FUNCTION prevent_future_date()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		IF NEW.invoice_date > now() - interval '1 day' THEN 
			RAISE NOTICE 'Can''t insert future date.';
			RAISE EXCEPTION 'Date can''t be a future date.';
		END IF;
		RETURN NEW;
	END;
$$;

CREATE OR REPLACE TRIGGER prevent_future_date_trigger
BEFORE INSERT OR UPDATE ON invoice
FOR EACH ROW 
EXECUTE FUNCTION prevent_future_date();

UPDATE invoice 
SET invoice_date = now() - INTERVAL '1 day'
WHERE invoice_id = 421;


SELECT * FROM invoice;



CREATE OR REPLACE FUNCTION log_promotions()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
	BEGIN
		IF OLD.title <> NEW.title THEN 
			RAISE NOTICE 'Job title was changed.';
		ELSE
			RAISE NOTICE 'Job title not changed.';
		END IF;
		
		RETURN NEW;
	END
$$;

CREATE OR REPLACE TRIGGER log_trigger
AFTER UPDATE ON employee 
FOR EACH ROW 
EXECUTE FUNCTION log_promotions();

UPDATE employee 
SET first_name = 'Nancy', title = 'Sales Manager 2'
WHERE employee_id = 2;


SELECT * FROM employee;



CREATE OR REPLACE FUNCTION inc_total ()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	DECLARE 
		total_invoices NUMERIC;
	BEGIN 
		SELECT count(invoice_id)
		INTO total_invoices
		FROM invoice
		GROUP BY customer_id
		HAVING customer_id = NEW.customer_id;
		
		IF total_invoices > 5 then 
			NEW.total = NEW.total * 1.1;
			raise notice 'total raised.';
		else 
			raise notice 'total not raised';
		end if;
	
		RETURN NEW;
	END
$$;

CREATE OR REPLACE TRIGGER inc_trigger
BEFORE UPDATE OR INSERT ON invoice
FOR EACH ROW 
EXECUTE FUNCTION inc_total();

INSERT INTO invoice (invoice_id, customer_id, invoice_date, total)
	VALUES (427, 7, now()-INTERVAL '1 year', 5);


SELECT customer_id, count (invoice_id) 
FROM invoice 
GROUP BY customer_id;


SELECT * FROM invoice;



CREATE OR REPLACE FUNCTION log_deleted ()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		RAISE NOTICE 'Deleted row: %, %, %, %', OLD.invoice_id, OLD.customer_id, OLD.invoice_date, OLD.total;
	
		return old;
	END
$$;

DROP FUNCTION log_deleted() CASCADE;

CREATE OR REPLACE TRIGGER delete_invoice_trigger
BEFORE DELETE ON invoice
FOR EACH ROW 
EXECUTE FUNCTION log_deleted();


DELETE FROM invoice WHERE invoice_id = 427;

SELECT * FROM invoice;



CREATE OR REPLACE FUNCTION prevent_deletion ()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	DECLARE 
		cust_invoices int;
	BEGIN 
		SELECT count(invoice_id) 
		INTO cust_invoices
		FROM invoice
		WHERE customer_id = OLD.customer_id;
	
		IF cust_invoices > 0 THEN
			RAISE EXCEPTION 'Can''t delete. Customer has an associated invoice.';
		ELSE 
			RAISE NOTICE 'Customer deleted';
		END IF;
	
		RETURN OLD;
	END
$$;


CREATE OR REPLACE TRIGGER prevent_del_trigger
BEFORE DELETE ON customer
FOR EACH ROW 
EXECUTE FUNCTION prevent_deletion();


DELETE FROM customer WHERE customer_id = 61;


INSERT INTO customer (customer_id, first_name, last_name, email)
	VALUES (61, 'john', 'doe', 'john@email.com');

SELECT * FROM customer;



CREATE OR REPLACE FUNCTION print_invoice ()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN
		RAISE NOTICE 'invoice to be deleted: %, %, %, %', OLD.invoice_id, OLD.customer_id, OLD.invoice_date, OLD.total;
		
		RETURN NULL;
	END
$$;

CREATE OR REPLACE TRIGGER delete_invoice_trigger
BEFORE DELETE ON invoice 
FOR EACH ROW 
EXECUTE FUNCTION print_invoice();


DELETE FROM invoice WHERE invoice_id = 424;

SELECT * FROM invoice;



CREATE OR REPLACE FUNCTION set_support_fun()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		IF NEW.support_rep_id IS NULL THEN 
			NEW .support_rep_id = 4;
			RAISE NOTICE 'support_rep_id is set to 4';
		ELSE
			RAISE NOTICE 'support rep id is already there.';
		END IF;
		
		RETURN NEW;
	END
$$;


CREATE OR REPLACE TRIGGER set_support_trigger
BEFORE INSERT ON customer
FOR EACH ROW 
EXECUTE FUNCTION set_support_fun();


INSERT INTO customer (customer_id, first_name, last_name, email)
	VALUES (62, 'new', 'customer', 'new@email.com');


SELECT * FROM customer;



CREATE OR REPLACE FUNCTION check_email_format()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		IF NOT NEW.email LIKE '%@%' THEN 
			RAISE EXCEPTION 'email is not valid.';
		ELSE 
			RAISE NOTICE 'email is valid';
		END IF;
	
		RETURN NEW;
	END
$$;

CREATE OR REPLACE FUNCTION notify_cust()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
	BEGIN 
		RAISE NOTICE 'New customer added. %, % %', NEW.customer_id, NEW.first_name, NEW.last_name;
		
		RETURN NEW;
	END
$$;
	

CREATE OR REPLACE TRIGGER check_trigger
BEFORE INSERT ON customer
FOR EACH ROW 
EXECUTE FUNCTION check_email_format();


CREATE OR REPLACE TRIGGER notify_trigger
AFTER INSERT ON customer
FOR EACH ROW 
EXECUTE FUNCTION notify_cust();

INSERT INTO customer (customer_id, first_name, last_name, email)
	VALUES (63, 'neww', 'customerr', 'newww@email.com');


SELECT * FROM customer;



CREATE OR REPLACE FUNCTION avoid_insertion ()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
	DECLARE 
		track_exist boolean;
		track_price numeric;
	BEGIN
		SELECT 1, unit_price
		INTO track_exist, track_price
		FROM track
		WHERE track_id = NEW.track_id;
	
		IF track_exist = TRUE THEN
			NEW.unit_price = track_price;
			RAISE NOTICE 'track id is valid.';
		ELSE
			RAISE EXCEPTION 'track id is not valid';
		END IF;
		
		RETURN NEW;
	END
$$;


CREATE OR REPLACE TRIGGER avoid_insertion_trigger
BEFORE INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION avoid_insertion();


INSERT INTO invoice_line (invoice_line_id, invoice_id, track_id, unit_price, quantity)
	VALUES (3000,424, 3503, 5, 3);


SELECT * FROM invoice_line;

SELECT * FROM track;

SELECT * FROM invoice;

