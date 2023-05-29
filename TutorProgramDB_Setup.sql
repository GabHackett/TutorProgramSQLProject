CREATE DATABASE TutorProgramDB

USE TutorProgramDB

CREATE TABLE Feedback(
	feedback_id varchar(255) NOT NULL PRIMARY KEY,
	reason varchar (255)
	)

CREATE TABLE Tutor(
	tutor_id varchar(255) NOT NULL PRIMARY KEY,
	tutor_name varchar(255),
	tutor_gender varchar (255),
	tutor_exp int,
	tutor_status varchar (255),
	tutor_lang varchar (255)
	)

CREATE TABLE Colleges(
	college_id varchar(255) NOT NULL PRIMARY KEY,
	college_abbrev varchar(255),
	college_name varchar(255),
	degree varchar(255),
	[type] varchar(255),
	housing_opt varchar(255),
	accept_rate float,
	grad_rate float,
	est_tuition money,
	est_roomboard money,
	req_GPA decimal(3,2),
	req_SAT float,
	req_ACT float,
	faculty_ratio decimal(12,2)
	)

CREATE TABLE CollegePrograms(
	ref_id varchar(255)NOT NULL PRIMARY KEY,
	collegeprog_id varchar(255), 
	college_id varchar(255),
	college_abbrev varchar(255),
	college_prog varchar(255),
	prog_rank int
	)

CREATE TABLE CollegeProgRef(
	collegeprog_id varchar(255) NOT NULL PRIMARY KEY,
	college_prog varchar(255),
	)

CREATE TABLE StudentInfo(
	student_id varchar(255) NOT NULL PRIMARY KEY,
	student_hs varchar(255),
	student_firstname varchar(255),
	student_lastname varchar(255),
	student_gender varchar(255),
	race varchar(255),
	ethnicity varchar(255),
	primary_lang varchar(255),
	college_interest varchar(255),
	collegeprog_id varchar(255)
)

CREATE TABLE Outcomes(
	student_id varchar(255) NOT NULL PRIMARY KEY,
	enroll_date date,
	exit_date date,
	days_between int,
	tot_sessions int,
	prog_status varchar(255),
	feedback_id varchar(255),
	grad_status varchar(255),
	SAT_math int,
	SAT_rw int,
	SAT_comp int,
	ACT_comp int,
	enroll_GPA decimal(3,2),
	end_GPA decimal (3,2),
	pre_self int,
	post_self int,
	pre_assess float,
	post_assess float,
	learn_method varchar(255),
	tutor_name varchar(255),
	tutor_id varchar(255)
)

