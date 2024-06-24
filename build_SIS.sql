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


/* instructor & instructor_course */
CREATE TABLE sis_instructor 
(
    instructorid NUMBER,
    firstname VARCHAR2(50) NOT NULL,
    lastname VARCHAR2(50) NOT NULL,
    address VARCHAR2(100) NOT NULL,
    city VARCHAR2(40) NOT NULL,
    prov CHAR(2) NOT NULL,
    postal_code CHAR(6) NOT NULL,
    phonenumber CHAR(12) NOT NULL,
    email VARCHAR2(100) NOT NULL
);

ALTER TABLE sis_instructor
ADD CONSTRAINT sis_instructor_instructorid_pk PRIMARY KEY (instructorid);

ALTER TABLE sis_instructor
ADD CONSTRAINT sis_instructor_prov_ck CHECK (REGEXP_LIKE(prov, '[A-Z]{2}'));

ALTER TABLE sis_instructor
ADD CONSTRAINT sis_instructor_postal_code_ck CHECK (REGEXP_LIKE(postal_code, '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'));

ALTER TABLE sis_instructor
ADD CONSTRAINT sis_instructor_phone_ck CHECK (REGEXP_LIKE(phonenumber, '[0-9]{3}\.[0-9]{3}\.[0-9]{4}'));

ALTER TABLE sis_instructor
ADD CONSTRAINT sis_instructor_email_ck CHECK (REGEXP_LIKE(email, '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'));


CREATE TABLE sis_instructor_course 
(
    crn NUMBER(5),
    semester_code CHAR(7),
    instructorid NUMBER
);

ALTER TABLE sis_instructor_course
ADD CONSTRAINT sis_instructor_course_crn_semester_code_instructorid_pk PRIMARY KEY (crn, semester_code, instructorid);

ALTER TABLE sis_instructor_course
ADD CONSTRAINT sis_instructor_course_crn_fk FOREIGN KEY (crn) REFERENCES sis_scheduled_course(crn);

ALTER TABLE sis_instructor_course
ADD CONSTRAINT sis_instructor_course_semester_code_fk FOREIGN KEY(semester_code) REFERENCES sis_scheduled_course(semester_code);

ALTER TABLE sis_instructor_course
ADD CONSTRAINT sis_instructor_course_instructor_fk FOREIGN KEY (instructorid) REFERENCES sis_instructor(instructorid);

CREATE TABLE sis_student_course_record
(
    crn NUMBER(5),
    semester_code CHAR(7),
    studentid NUMBER,
    credential# NUMBER NOT NULL,
    course_code CHAR(7) NOT NULL,
    letter_grade VARCHAR2(2)
);
 
ALTER TABLE sis_student_course_record
ADD CONSTRAINT sis_student_course_record_crn_semester_code_studentid_pk PRIMARY KEY (crn, semester_code, studentid);
 
ALTER TABLE sis_student_course_record
ADD CONSTRAINT sis_student_course_record_crn_fk FOREIGN KEY (crn) REFERENCES sis_scheduled_course(crn);
 
ALTER TABLE sis_student_course_record
ADD CONSTRAINT sis_student_course_record_studentid_fk FOREIGN KEY (studentid) REFERENCES sis_student(studentid);
 
ALTER TABLE sis_student_course_record
ADD CONSTRAINT sis_student_course_record_credential#_fk FOREIGN KEY (credential#) REFERENCES sis_credential(credential#);

ALTER TABLE sis_student_course_record
ADD CONSTRAINT sis_student_course_record_semester_code_fk FOREIGN KEY (semester_code) REFERENCES sis_scheduled_course(semester_code);
 
ALTER TABLE sis_student_course_record
ADD CONSTRAINT sis_student_course_record_letter_grade_ck CHECK (letter_grade IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D',  'D-', 'F', 'i'));


CREATE TABLE sis_student
(
    studentid NUMBER,
    firstname VARCHAR2(50) NOT NULL,
    lastname VARCHAR2(50) NOT NULL,
    status VARCHAR2(2) NOT NULL,
    status_date DATE NOT NULL,
    phone CHAR(12) NOT NULL,
    email VARCHAR2(100) NOT NULL
);
 
ALTER TABLE sis_student
ADD CONSTRAINT sis_student_studentid_pk PRIMARY KEY (studentID);
 
ALTER TABLE sis_student
ADD CONSTRAINT sis_student_status_ck CHECK (status IN ('A', 'AP', 'S', 'E'));
 
ALTER TABLE sis_student
ADD CONSTRAINT sis_student_phone_ck CHECK (REGEXP_LIKE(phone, '[0-9]{3}\.[0-9]{3}\.[0-9]{4}'));
 
ALTER TABLE sis_student
ADD CONSTRAINT sis_student_email_ck CHECK (REGEXP_LIKE(email, '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'));

COMMIT;
