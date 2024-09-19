
SELECT 
CAST ('5' AS integer);


SELECT 
CAST (5.56 AS integer);


SELECT 
CAST ('a' AS integer);


SELECT 
CAST ('true' AS boolean);


SELECT 
CAST (5 AS float);



SELECT track_id, name, composer,
	COALESCE (composer, 'No composer mentioned')
FROM track;



SELECT track_id, name, composer,
	NULLIF (composer, 'AC/DC')
FROM track;



SELECT (
	CASE 
		WHEN employee_id = 2 THEN first_name
		WHEN employee_id = 4 THEN last_name
		ELSE 'nothing'
	END
)
FROM employee;




SELECT (
	CASE employee_id 
		WHEN 2 THEN first_name
		WHEN 4 THEN last_name
		ELSE 'nothing'
	END
)
FROM employee;




DO $$
DECLARE 
	x integer := 5.49;
	y integer := 6;
BEGIN
	IF x > y THEN
		RAISE NOTICE 'x is greater';
	ELSE 
		IF y > x THEN
			RAISE NOTICE 'y is greater';
		ELSE 
			RAISE NOTICE 'both are equal';
		END IF;
	END IF;
END
$$;




DO $$
DECLARE 
	n int := 5;
BEGIN
	loop 
		IF n < 0 THEN 
			EXIT;
		END IF;
		
		RAISE NOTICE '%', n;
	
		n := n - 1;
	end loop;
END;
$$;




DO $$
DECLARE 
	n int := 5;
BEGIN
	WHILE n > 0 LOOP 
		RAISE NOTICE '%', n;
		n := n - 1;
	END LOOP;
END;
$$;




DO $$
<<block1>>
DECLARE 
	n int := 5;
	m int := 10;

BEGIN

	<<block2>>
	BEGIN
		IF n < 10 THEN
			RAISE NOTICE '%', n;
			EXIT block2;
		END IF;
	END;

	RAISE NOTICE '%', n;
	n := n - 1;

	IF n > 0 THEN
		EXIT block1;
	END IF;

	RAISE NOTICE 'End of block1';

END;
$$;





DO $$
<<block1>>
DECLARE 
	n int := 5;
	m int := 10;

BEGIN

	<<block2>>
	BEGIN

		IF n < 10 THEN
			RAISE NOTICE 'inside first if statement';
			EXIT block1;
		END IF;

	END;

	RAISE NOTICE '%', n;
	n := n - 1;

	IF n > 0 THEN
		EXIT block1;
	END IF;

	RAISE NOTICE 'End of block1';

END;
$$;





DO $$
DECLARE 
	n int := 5;

BEGIN

	LOOP 

		IF n = 3 THEN
			n := n - 1;
			CONTINUE;
		END IF;

		IF n < 0 THEN
			EXIT;
		END IF;

		RAISE NOTICE 'value: %', n;
		n := n - 1;

	END LOOP;
	
	RAISE NOTICE 'End';
END;
$$;






DO $$

DECLARE 
	n int := 5;
	m int := 10;

BEGIN
	
	<<loop1>>
	LOOP 
		
		RAISE NOTICE 'Inside loop 1';
		m := m + 1;
		RAISE NOTICE 'm_value: %', m;
	
		<<loop2>>
		LOOP 
			RAISE NOTICE 'Inside loop 2';
		
			IF n = 3 THEN
				n := n - 1;
				m := m + 1;
				CONTINUE loop1;
			END IF;
		
			IF n < 0 THEN
				EXIT loop2;
			END IF;
		
			RAISE NOTICE 'n_value: %', n;
		
			n := n - 1;
		
			RAISE NOTICE 'end of loop 2';
		END LOOP;
	
	
		IF m = 13 THEN
			EXIT;
		END IF;
			
		RAISE NOTICE 'end of loop 1';

	END LOOP;

	
	RAISE NOTICE 'End';

END;
$$;




BEGIN;
	UPDATE employee
	SET first_name = 'Ram'
	WHERE employee_id = 2;
ROLLBACK;


SELECT * FROM employee WHERE employee_id = 2;


BEGIN;
	UPDATE employee
	SET first_name = 'Nancy'
	WHERE employee_id = 2;
COMMIT;



BEGIN;
	UPDATE customer 
	SET last_name = 'Ram'
	WHERE customer_id = 3;
END TRANSACTION;


SELECT * FROM customer WHERE customer_id = 3;

ROLLBACK;

BEGIN;
	UPDATE customer 
	SET last_name = 'Trembley'
	WHERE customer_id = 3;
END TRANSACTION;
