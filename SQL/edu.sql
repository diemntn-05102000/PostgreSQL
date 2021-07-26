create schema edudb;
CREATE TABLE student(
student_id char(8) NOT NULL,
first_name varchar(20) NOT NULL,
last_name varchar(20) NOT NULL,
dob date NOT NULL,
gender char(1),
address varchar(30),
note text,
clazz_id char(8),
CONSTRAINT pk_student primary key(student_id)
);
CREATE TABLE class(
clazz_id char(8) NOT NULL,
name varchar(20),
lecture_id char(5),
monitor_id char(8),
CONSTRAINT pk_clazz primary key(clazz_id),
CONSTRAINT fk_clazz1 foreign key(monitor_id) references student(student_id)
);
CREATE TABLE subject(
subject_id char(6) NOT NULL,
name varchar(30) NOT NULL,
credit int NOT NULL,
percentage_final_exam int NOT NULL,
CONSTRAINT pk_subject primary key(subject_id)
);
CREATE TABLE lecturer(
lecturer_id char(5) NOT NULL,
first_name varchar(20) NOT NULL,
last_name varchar(20) NOT NULL,
dob date NOT NULL,
gender char(1),
address varchar(30),
email varchar(40),
CONSTRAINT pk_lecturer primary key(lecturer_id)
);
CREATE TABLE teaching(
subject_id char(6) NOT NULL,
lecturer_id char(5) NOT NULL,
CONSTRAINT pk_teaching primary key(subject_id,lecturer_id)
);
CREATE TABLE grade(
code char(1) NOT NULL,
from_score DECIMAl(3,1) NOT NULL,
to_score DECIMAL(3,1) NOT NULL,
percentage_final_exam int NOT NULL,
CONSTRAINT pk_grade primary key(code)
);
CREATE TABLE enrollment(
student_id char(8) NOT NULL,
subject_id char(6) NOT NULL,
semester char(5) NOT NULL,
midterm_score float,
final_score float,
CONSTRAINT pk_enroll primary key(student_id ,subject_id ,semester),
CONSTRAINT fk_enroll1 foreign key(subject_id) references subject(subject_id),
CONSTRAINT fk_enroll2 foreign key(student_id) references student(student_id)
);
alter table student add CONSTRAINT fk_clazzstudent foreign key(clazz_id) references class(clazz_id);
alter table class add CONSTRAINT fk_clazzlecturer foreign key(lecture_id) references lecturer(lecturer_id);
