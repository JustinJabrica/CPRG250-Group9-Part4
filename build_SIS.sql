DROP TABLE sis_Credential CASCADE CONSTRAINTS;
DROP TABLE sis_course_within_cred CASCADE CONSTRAINTS;
DROP TABLE sis_course CASCADE CONSTRAINTS;
DROP TABLE sis_scheduled_course CASCADE CONSTRAINTS;
DROP TABLE sis_instructor_course CASCADE CONSTRAINTS;
DROP TABLE sis_instructor CASCADE CONSTRAINTS;
DROP TABLE sis_student CASCADE CONSTRAINTS;
DROP TABLE sis_student_course_record CASCADE CONSTRAINTS;
DROP TABLE sis_student_Student_Credential CASCADE CONSTRAINTS;


rem set date format for 11g
alter session set NLS_DATE_FORMAT='dd-mon-yy';
rem set language to english to avoid problems with non-english machines
alter session set NLS_LANGUAGE = ENGLISH;

SET ECHO ON
SET FEEDBACK ON

CREATE TABLE sis_course
(
    course_code CHAR(7);
    name VARCHAR2(100) NOT NULL;
    num_of_credits NUMBER(2,1) NOT NULL;
    prereq_course_code CHAR(7);
      CONSTRAINT customers_customer#_pk PRIMARY KEY(customer#),
      CONSTRAINT customers_region_ck
                CHECK (region IN ('N', 'NW', 'NE', 'S', 'SE', 'SW', 'W', 'E'))
    
);
