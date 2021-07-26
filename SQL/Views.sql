--1
create view student_shortinfos as
select s.student_id, s.first_name, s.last_name, s.gender, s.dob, s.clazz_id
from student s

update student_shortinfos set clazz_id = '20162102' where  student_id= '20160028' ;
INSERT INTO student_shortinfos(student_id, first_name, last_name, gender,dob, clazz_id) VALUES ('20160028', 'Minh', 'Hoàng','M', '1987-05-21', '20162101');
delete from student_shortinfos where student_id = '20160028';

select ss.student_id, ss.first_name, ss.clazz_id ,c.name from student_shortinfos ss ,clazz c where ss.clazz_id = c.clazz_id

select c.clazz_id , c.name , count(student_id) as number_student from student_shortinfos ss right join  clazz c  
on ss.clazz_id = c.clazz_id
group by c.clazz_id

--3
create view class_shortinfos as
select c.clazz_id, c.name,count(student_id) as number_student 
from clazz c left join student s on s.clazz_id = c.clazz_id
group by c.clazz_id

select * from class_shortinfos

insert into class_shortinfos values('20201120','VN K63.2',0) --ko insert dc, cach giai quyet:

CREATE OR REPLACE FUNCTION insert_class_view_func() RETURNS trigger AS
$$ 
BEGIN
insert into clazz (clazz_id,name) values (NEW.clazz_id, NEW.name);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER insert_class_view
INSTEAD OF INSERT ON class_shortinfos
FOR EACH ROW
EXECUTE PROCEDURE insert_class_view_func();


update class_shortinfos set name = 'VN K63.1'  where  clazz_id= '20162102' ;--ko update dc, cach giai quyet:

CREATE OR REPLACE FUNCTION update_class_view_func() RETURNS trigger AS
$$ 
BEGIN
--IF (OLD.clazz_id = NEW.clazz_id) THEN
update clazz set name = NEW.name where clazz_id = OLD.clazz_id;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER update_class_view
INSTEAD OF UPDATE ON class_shortinfos  -- chi update tren name
FOR EACH ROW
--WHEN (NEW.name <> OLD.name AND OLD.clazz_id == NEW.clazz_id) 
--WHEN (NEW.name IS DISTINCT FROM OLD.name)
EXECUTE PROCEDURE update_class_view_func();


