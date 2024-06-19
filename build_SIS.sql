DROP TABLE sis_credential CASCADE CONSTRAINTS;
DROP TABLE sis_courses_within_cred CASCADE CONSTRAINTS;
DROP TABLE sis_course CASCADE CONSTRAINTS;
DROP TABLE sis_scheduled_course CASCADE CONSTRAINTS;
DROP TABLE sis_instructor_course CASCADE CONSTRAINTS;
DROP TABLE sis_instructor CASCADE CONSTRAINTS;
DROP TABLE sis_student CASCADE CONSTRAINTS;
DROP TABLE sis_student_course_record CASCADE CONSTRAINTS;
DROP TABLE sis_student_credential CASCADE CONSTRAINTS;


rem set date format for 11g
alter session set NLS_DATE_FORMAT='dd-mon-yy';
rem set language to english to avoid problems with non-english machines
alter session set NLS_LANGUAGE = ENGLISH;

SET ECHO ON
SET FEEDBACK ON

CREATE TABLE sis_course
(
    course_code CHAR(7),
    name VARCHAR2(100) NOT NULL,
    num_of_credits NUMBER(2,1) NOT NULL,
    prereq_course_code CHAR(7)
);

ALTER TABLE sis_course
ADD CONSTRAINT sis_course_course_code_pk PRIMARY KEY(course_code);

ALTER TABLE sis_course
ADD CONSTRAINT sis_course_course_code_ck CHECK (REGEXP_LIKE(course_code, '[A-Z]{4}[0-9]{3}'));

ALTER TABLE sis_course
ADD CONSTRAINT sis_course_prereq_course_code_fk FOREIGN KEY (prereq_course_code)
    REFERENCES sis_course (course_code);

CREATE TABLE sis_courses_within_cred
(
    credential# NUMBER,
    course_code CHAR(7),
    type_flag NUMBER(1) NOT NULL
);

ALTER TABLE sis_courses_within_cred
ADD CONSTRAINT sis_courses_within_cred_pk PRIMARY KEY(credential#, course_code);

ALTER TABLE sis_courses_within_cred
ADD CONSTRAINT sis_courses_within_cred_credential#_fk FOREIGN KEY(credential#)
    REFERENCES sis_Credential (credential#);

ALTER TABLE sis_courses_within_cred
ADD CONSTRAINT sis_courses_within_cred_course_code_fk FOREIGN KEY(course_code)
    REFERENCES sis_course (course_code);

ALTER TABLE sis_courses_within_cred
ADD CONSTRAINT sis_courses_within_cred_type_flag_ck CHECK (type_flag IN (0, 1));


CREATE TABLE sis_scheduled_course
(
    CRN NUMBER(5),
    semester_code CHAR(7),
    course_code CHAR(7) NOT NULL,
    section_code CHAR(1) NOT NULL
);

ALTER TABLE sis_scheduled_course
ADD CONSTRAINT sis_scheduled_course_CRN_semester_code_pk PRIMARY KEY (CRN, semester_code);

ALTER TABLE sis_scheduled_course
ADD CONSTRAINT sis_scheduled_course_semester_code_ck CHECK (REGEXP_LIKE(semester_code, '[A-Z]{4}[0-9]{3}'));

ALTER TABLE sis_scheduled_course
ADD CONSTRAINT sis_scheduled_course_course_code_fk FOREIGN KEY (course_code)
    REFERENCES sis_course (course_code);

ALTER TABLE sis_scheduled_course
ADD CONSTRAINT sis_scheduled_course_section_code_ck CHECK (REGEXP_LIKE(section_code, '[A-Z]'));


/* credential and student_credential */
CREATE TABLE sis_credential
(
    credential# NUMBER,
    school_name VARCHAR2(50) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    type VARCHAR2(2) NOT NULL
);

ALTER TABLE sis_credential
ADD CONSTRAINT sis_credential_credential#_pk PRIMARY KEY(credential#);

ALTER TABLE sis_credential
ADD CONSTRAINT sis_credential_type_ck CHECK (type IN ('MI', 'FT', 'CT', 'DP', 'AD', 'D'));


CREATE TABLE sis_student_credential
(
    studentid NUMBER,
    credential# NUMBER,
    startdate DATE NOT NULL,
    completion_date DATE,
    credential_status CHAR(1) NOT NULL,
    gpa NUMBER(3,2) NOT NULL
);

ALTER TABLE sis_student_credential
ADD CONSTRAINT sis_student_credential_studentid_credential#_pk PRIMARY KEY (studentid, credential#);

ALTER TABLE sis_student_credential
ADD CONSTRAINT sis_student_credential_studentid_fk FOREIGN KEY (studentid) REFERENCES sis_student(studentid);

ALTER TABLE sis_student_credential
ADD CONSTRAINT sis_student_credential_credential#_fk FOREIGN KEY (credential#) REFERENCES sis_credential(credential#);

ALTER TABLE sis_student_credential
ADD CONSTRAINT sis_student_credential_credential_status_ck CHECK (credential_status IN ('A', 'G', 'E'));

COMMIT;
