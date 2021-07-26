--Them sv
CREATE TRIGGER af_insert
AFTER INSERT ON student
FOR EACH ROW 
WHEN (NEW.clazz_id IS NOT NULL)
EXECUTE PROCEDURE tf_af_insert();
CREATE OR REPLACE FUNCTION tf_af_insert() RETURNS TRIGGER AS $$
BEGIN
 update clazz
 set number_student = number_student + 1
 where clazz_id = NEW.clazz_id;
 RETURN NEW;
END;
$$LANGUAGE plpgsql;
 INSERT INTO student(student_id, first_name, last_name, dob, gender, address, note, clazz_id) 
 VALUES ('20180001', 'Quang Minh', 'Bùi', '1996-03-18', 'M', '58 Lương Định Của,Đ. Đa, HN',NULL, '20162101');

 
 --Xoa sv
 CREATE TRIGGER af_delete
AFTER DELETE ON student
FOR EACH ROW 
WHEN (OLD.clazz_id IS NOT NULL)
EXECUTE PROCEDURE tf_af_delete();
CREATE OR REPLACE FUNCTION tf_af_delete() RETURNS TRIGGER AS $$
BEGIN
 update clazz
 set number_student = number_student - 1
 where clazz_id = OLD.clazz_id;
 RETURN NEW;
END;
$$LANGUAGE plpgsql;

--Sinh vien chuyen lop
CREATE TRIGGER af_update
AFTER UPDATE ON student
FOR EACH ROW 
WHEN (OLD.clazz_id IS DISTINCT FROM NEW.clazz_id)
EXECUTE PROCEDURE tf_af_update();
CREATE OR REPLACE FUNCTION tf_af_update() RETURNS TRIGGER AS $$
BEGIN
 update clazz
 set number_student = number_student + 1
 where clazz_id = NEW.clazz_id;
 update clazz
 set number_student = number_student - 1
 where clazz_id = OLD.clazz_id;
 RETURN NEW;
END;
$$LANGUAGE plpgsql;
-- Hop nhat, muon chay dung phair xoa 3 trigger phia tren DROP TRIGGER af_update on student
CREATE TRIGGER af_idu_student
AFTER INSERT OR DELETE OR UPDATE ON student
FOR EACH ROW 
EXECUTE PROCEDURE tf_af_idu_student();
CREATE OR REPLACE FUNCTION tf_af_idu_student() RETURNS TRIGGER AS 
$$
BEGIN
 IF (TG_OP = 'UPDATE') AND (OLD.clazz_id IS DISTINCT FROM NEW.clazz_id) THEN
  update clazz
  set number_student = number_student + 1
  where clazz_id = NEW.clazz_id;
  update clazz
  set number_student = number_student - 1
  where clazz_id = OLD.clazz_id;
 ELSE IF (TG_OP = 'DELETE') AND (OLD.clazz_id IS NOT NULL)  THEN
  update clazz
  set number_student = number_student - 1
  where clazz_id = OLD.clazz_id;
 ELSE IF (TG_OP = 'INSERT') AND (NEW.clazz_id IS NOT NULL)  THEN
  update clazz
  set number_student = number_student + 1
  where clazz_id = NEW.clazz_id;
 END IF;
 END IF;
 END IF;
 RETURN NULL;
 
 END;
 $$
 LANGUAGE plpgsql;
delete from student where student_id = '20180001';
--Lam sach du lieu
update clazz set number_student = number_student(clazz_id);

--Dam bao so sinh vien 1 lop ko qua 200 --khong dung lam (-_-)
CREATE TRIGGER number_student_200 
AFTER INSERT OR UPDATE ON enrollment
FOR EACH ROW 

EXECUTE PROCEDURE number_student_enroll_200();

CREATE OR REPLACE FUNCTION number_student_enroll_200() RETURNS TRIGGER AS 
$$
BEGIN
IF (TG_OP = 'UPDATE') AND (OLD.subject_id IS DISTINCT FROM NEW.subject_id)  THEN
 IF(number_student_enroll(NEW.subject_id)>11) THEN
    delete from enrollment where student_id = NEW.student_id AND subject_id = NEW.subject_id AND semester = NEW.semester;
    raise notice 'Lop da day, khong the doi!';
 ELSE  
  update subject
  set number_student_enroll = number_student_enroll + 1
  where subject_id = NEW.subject_id;
  update subject
  set number_student_enroll = number_student_enroll - 1
  where subject_id = OLD.subject_id;
  END IF;
 ELSE IF (TG_OP = 'INSERT') AND (NEW.subject_id IS NOT NULL)   THEN
  IF(number_student_enroll(NEW.subject_id)>11) THEN
    delete from enrollment where student_id = NEW.student_id AND subject_id = NEW.subject_id AND semester = NEW.semester;
    raise notice 'Lop da day, khong the them!';
  ELSE    
  update subject
  set number_student_enroll = number_student_enroll + 1
  where subject_id = NEW.subject_id;
  END IF;
  END IF;
 END IF;
RETURN NEW;
 
 END;
 $$
 LANGUAGE plpgsql;

DROP TRIGGER number_student_200 on enrollment
 
 CREATE OR REPLACE FUNCTION number_student_enroll(IN v_subject_id character, OUT result int4) AS
$$
BEGIN
select count(*) into result from enrollment where subject_id = v_subject_id;
END;
$$
STABLE
SECURITY DEFINER
LANGUAGE plpgsql;
ALTER TABLE subject ADD number_student_enroll int4;

update subject set number_student_enroll = number_student_enroll(subject_id);

INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20170004' , 'IT3090', '20213', 9, 8);



--Check so sinh vien dang ki mon hoc trong 1 hoc ki khong qua 200
CREATE OR REPLACE FUNCTION number_student_enroll(IN v_subject_id character, v_semester character, OUT result int4) AS
$$
BEGIN
select count(*) into result from enrollment where subject_id = v_subject_id and semester = v_semester ;
END;
$$
STABLE
SECURITY DEFINER
LANGUAGE plpgsql;


CREATE TRIGGER number_student_200_yoi 
BEFORE INSERT OR UPDATE  ON enrollment -- UPDATE OF subject_id, semester
FOR EACH ROW 
EXECUTE PROCEDURE number_student_enroll_200();

CREATE OR REPLACE FUNCTION number_student_enroll_200() RETURNS TRIGGER AS 
$$
BEGIN
 IF(number_student_enroll(NEW.subject_id, NEW.semester)>4) THEN --5
    raise notice 'Subject full!';
    RETURN NULL;
 ELSE  
   RETURN NEW;
  END IF;
 

END;
 $$
 LANGUAGE plpgsql;
 INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160004' , 'IT1110', '20202', 0, 0);
 update enrollment set subject_id = 'IT3080'   where student_id = '20160004' and semester = '20202'
select count(*)  from enrollment where subject_id = 'IT3090' and semester = '20182' ;



--Sinh vien khong duoc duoi 10, khong duoc qua 200
CREATE TRIGGER number_student_200_10
BEFORE INSERT OR UPDATE OR DELETE  ON enrollment -- UPDATE OF subject_id, semester
FOR EACH ROW 
EXECUTE PROCEDURE number_student_enroll_200_10();

CREATE OR REPLACE FUNCTION number_student_enroll_200_10() RETURNS TRIGGER AS 
$$
BEGIN
IF (TG_OP = 'INSERT')  THEN
 IF(number_student_enroll(NEW.subject_id, NEW.semester)>4) THEN --5
    raise notice 'NOT INSERT!';
    RETURN NULL;
 ELSE  
   RETURN NEW;
  END IF;
 
ELSE IF (TG_OP = 'DELETE') THEN
  IF(number_student_enroll(OLD.subject_id, OLD.semester)<3) THEN --2
    raise notice 'NOT DELETE!';
    RETURN NULL;
 ELSE  
   RETURN OLD;
  END IF;
ELSE IF (TG_OP = 'UPDATE') THEN  
  IF(number_student_enroll(NEW.subject_id, NEW.semester)>4 OR number_student_enroll(OLD.subject_id, OLD.semester)<3) THEN --5,2
    raise notice 'NOT UPDATE!';
    RETURN NULL;
 ELSE  
   RETURN NEW;
  END IF;
  END IF;
  END IF;
  END IF;
  
END;
 $$
 LANGUAGE plpgsql;
DELETE FROM enrollment where student_id = '20160004' and semester = '20182' and subject_id = 'IT3090' ;
DELETE FROM enrollment where student_id = '20170001' and semester = '20202' and subject_id = 'IT3090' ;
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160005' , 'IT3090', '20202', 0, 0);
update enrollment set subject_id = 'IT3080'   where student_id = '20160004' and semester = '20182' and subject_id = 'IT3090'
