CREATE FUNCTION store.test(IN val1 int4, IN val2 int4, OUT result int4) AS
$$DECLARE vmul int4 := 3;
BEGIN
result := val1*vmul +val2;
END;$$
LANGUAGE plpgsql;
--IMMUTABLE: gia dau vao giong nhau thif dau ra giong nhau
--STABLE: nguoc lai
--SECURITY INVOKER: quyen cua nguoi goi
--SECURITY DEFINER: quyen cua nguoi dinh nghia
select store.test(10,5);

GRANT EXECUTE ON FUNCTION store.test TO duyen; --trao quyen cho Duyen

customervar store."Customer"%ROWTYPE
SELECT INTO customervar * FROM store."Customer" where
"CustomerID" = 'BLU001';
result := customervar."FirstName" || ' ' || customervar."LastName";
CREATE FUNCTION add(integer, integer) RETURNS
integer AS
'select $1 + $2;'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

CREATE OR REPLACE FUNCTION increment (i integer)
RETURNS integer AS
$$ BEGIN RETURN i + 1; END; $$
LANGUAGE plpgsql;

CREATE FUNCTION dup(in int, out f1 int, out f2 text) AS
$$ SELECT $1, CAST($1 AS text) || ' is text' $$
LANGUAGE SQL;
SELECT * FROM dup(42);

CREATE TYPE dup_result AS (f1 int, f2 text);
CREATE FUNCTION dup(int) RETURNS dup_result AS
$$ SELECT $1, CAST($1 AS text) || ' is text' $$
LANGUAGE SQL;
SELECT * FROM dup(42);

CREATE FUNCTION extended_sales(p_itemno int)
RETURNS TABLE(quantity int, total numeric) AS $$
BEGIN
RETURN QUERY SELECT s.quantity, s.quantity * s.price
FROM sales AS s
WHERE s.itemno = p_itemno;
END;
$$ LANGUAGE plpgsql;



