ALTER TABLE clazz ADD number_student integer

DROP FUNCTION number_student(character) 
CREATE OR REPLACE FUNCTION number_student(IN v_clazz_id character, OUT result int4) AS
$$
BEGIN
select count(*) into result from student where clazz_id = v_clazz_id;
END;
$$
STABLE
SECURITY DEFINER
LANGUAGE plpgsql;
 select number_student('20162101');
update clazz set number_student = number_student(clazz_id)
select * from clazz

CREATE OR REPLACE FUNCTION update_number_student() RETURNS void AS
$$
DECLARE clazz_row clazz%rowtype
BEGIN
update clazz set number_student = number_student(clazz_id);
/*
for clazz_row in select * from clazz loop
       update clazz
	   set num_students2=num(clazz_row.clazz_id)
	   where clazz_id=clazz_row.clazz_id;
  end loop;
*/
END;
$$
SECURITY DEFINER
LANGUAGE plpgsql;
update clazz set number_student = 0;
 select update_number_student();
