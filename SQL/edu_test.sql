select * from subject;
select * from student;
select * from enrollment;
--1
select * from subject where credit >= 3;
--2
select * from student,clazz where student.clazz_id = clazz.clazz_id  and clazz.name = 'CNTT1.01-K61';
--2
select * from student where clazz_id IN (select clazz_id from clazz where name = 'CNTT1.01-K61');--Cach khac
--3
select * from student,clazz where student.clazz_id = clazz.clazz_id  and clazz.name like '%CNTT2%';
--5
select student.* from student,enrollment, subject 
where student.student_id = enrollment.student_id and enrollment.subject_id = subject.subject_id and (subject.name = 'Mạng máy tính' or subject.name ='Tin học đại cương');
--4
select student.* from student,enrollment, subject 
where student.student_id = enrollment.student_id and enrollment.subject_id = subject.subject_id and (subject.name = 'Mạng máy tính') 
and student.student_id IN (select enrollment.student_id from enrollment, subject where enrollment.subject_id = subject.subject_id and (subject.name ='Tin học đại cương'));
--4 UNION, EXCEPT, INTERSECT
select student.* from student,enrollment, subject 
where student.student_id = enrollment.student_id and enrollment.subject_id = subject.subject_id and (subject.name = 'Mạng máy tính' )
INTERSECT
select student.* from student,enrollment, subject 
where student.student_id = enrollment.student_id and enrollment.subject_id = subject.subject_id and ( subject.name ='Tin học đại cương');
--6
select distinct subject.* from subject 
EXCEPT
select distinct subject.* from enrollment, subject 
where subject.subject_id = enrollment.subject_id ;
--6
select subject.* from subject
where subject_id NOT IN (select subject_id from enrollment);
--6
delete from enrollment where subject_id = 'IT4866';
select su.* from subject su left join enrollment e on su.subject_id = e.subject_id
where e.subject_id is null;
--7
select su.name ,su.credit from student st,enrollment e, subject su
where st.student_id = e.student_id and e.subject_id = su.subject_id and st.first_name = 'Thu Hồng' and st.last_name = 'Trần' and e.semester = '20172';
--13 count(distinct last_name) dem so ban ghi khac nhau
select su.name from subject su, teaching te
where su.subject_id = te.subject_id
group by su.subject_id
having count(lecturer_id) > 1;
--14
select su.name from subject su
EXCEPT
select su.name from subject su, teaching te
where su.subject_id = te.subject_id
group by su.subject_id
having count(lecturer_id) > 1;
--14
select su.name from teaching te right join subject su on su.subject_id = te.subject_id
group by su.subject_id
having count(lecturer_id) <2;
--8
select st.*,e.midterm_score,e.final_score, (e.midterm_score *(100-su.percentage_final_exam) + e.final_score *su.percentage_final_exam)/100.0 as subject_core 
from student st, subject su, enrollment e
where st.student_id = e.student_id and e.subject_id = su.subject_id and su.name = 'Mạng máy tính' and e.semester = '20172';

select e.midterm_score,e.final_score,su.percentage_final_exam
from student st, subject su, enrollment e
where st.student_id = e.student_id and e.subject_id = su.subject_id and su.name = 'Mạng máy tính' and e.semester = '20172';
--9
select st.*,e.midterm_score,e.final_score, (e.midterm_score *(100-su.percentage_final_exam) + e.final_score *su.percentage_final_exam)/100.0 as subject_core 
from student st, subject su, enrollment e
where st.student_id = e.student_id and e.subject_id = su.subject_id and su.subject_id = 'IT1110' and e.semester = '20171' and
(e.midterm_score < 3 or e.final_score < 3 or (e.midterm_score *(100-su.percentage_final_exam) + e.final_score *su.percentage_final_exam)/100.0 <4);

--9 dung WITH
WITH tmp AS ( select st.*,e.midterm_score,e.final_score, (e.midterm_score *(100-su.percentage_final_exam) + e.final_score *su.percentage_final_exam)/100.0 as subject_score 
from student st, subject su, enrollment e 
where st.student_id = e.student_id and e.subject_id = su.subject_id and su.subject_id = 'IT1110' and e.semester = '20171')
select tmp.* from tmp where tmp.midterm_score < 3 or tmp.final_score < 3 or tmp.subject_score <4;

--10 
select min(midterm_score), max(final_score), avg(midterm_score)
from subject su, enrollment e
where  e.subject_id = su.subject_id and su.subject_id = 'IT1110' and e.semester = '20171' ;
--Tung mon hoc
select subject_id, min(midterm_score), max(final_score), avg(midterm_score)
from enrollment e
where e.semester = '20172' 
group by subject_id;

--Sinh vien duoc diem cao nhat
select e.*
from subject su, enrollment e
where  e.subject_id = su.subject_id and su.subject_id = 'IT1110' and e.semester = '20171'
and midterm_score = (select max(midterm_score)from subject su, enrollment ewhere  e.subject_id = su.subject_id and su.subject_id = 'IT1110' and e.semester = '20171') ;

--Sinh vien duoc diem cao nhat dung WITH tich kiem thoi gian hon
WITH tmp AS (select * from enrollment where subject_id = 'IT1110' and semester = '20171')
select s.* from student s, tmp where s.student_id = tmp.student_id and midterm_score = (select max(midterm_score) from tmp);

--18
select s.student_id ,s.first_name, c.name, l.first_name lecturer_name, m.first_name monitor_name from student s, clazz c, lecturer l, student m 
where s.clazz_id = c.clazz_id and  c.lecturer_id = l.lecturer_id and c.monitor_id = m.student_id;

--18 motto yoi(clazz_id = NULL toki)
select s.student_id ,s.last_name||' '||s.first_name as student_name, c.name, l.first_name lecturer_name, m.first_name monitor_name 
from student s left join clazz c on s.clazz_id = c.clazz_id left join lecturer l on c.lecturer_id = l.lecturer_id left join student m on c.monitor_id = m.student_id;

update student set clazz_id = NULL where  student_id= '20160001' or student_id= '20170001';
--11
select s.* from student s where date_part('year', current_date)-date_part('year', dob) < 33;

--12
select s.* from student s where date_part('month', dob) = 5 and date_part('year', dob) = 1987;

--17 lop co sinh vien nhieu nhat
WITH tmp AS (select clazz.name, count(student_id) number_student from clazz, student where clazz.clazz_id = student.clazz_id
group by clazz.clazz_id)
select tmp.* from tmp where tmp.number_student = (select max(tmp.number_student) from tmp); --number_student >= ALL(select number_student from tmp)
--17
WITH tmp AS (select clazz.name, count(student_id) number_student from clazz, student where clazz.clazz_id = student.clazz_id
group by clazz.clazz_id)
select tmp.* from tmp order by number_student asc; --desc






