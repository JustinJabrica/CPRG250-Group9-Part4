DROP TABLE sis_Credential CASCADE CONSTRAINTS;
DROP TABLE sis_courses_within_cred CASCADE CONSTRAINTS;
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
      CONSTRAINT sis_course_course_code_pk PRIMARY KEY(course_code),
      CONSTRAINT sis_course_course_code_ck
          CHECK (REGEXP_LIKE(course_code, '[A-Z]{4}[0-9]{3}')),
      CONSTRAINT sis_course_prereq_course_code_fk FOREIGN KEY (prereq_course_code)
          REFERENCES (sis_course (course_code));    
);

CREATE TABLE sis_courses_within_cred
(
    credential# NUMBER;
    course_code CHAR(7);
    type_flag NUMBER(1) NOT NULL;
        CONSTRAINT sis_courses_within_cred_credential#_pk PRIMARY KEY(credential#),
        CONSTRAINT sis_courses_within_cred_credential#_fk FOREIGN KEY(credential#)
            REFERENCES (sis_Credential (credential#)),
        CONSTRAINT sis_courses_within_cred_course_code_pk PRIMARY KEY(course_code),
        CONSTRAINT sis_courses_within_cred_course_code_fk FOREIGN KEY(course_code)
            REFERENCES (sis_course (course_code)),
        CONSTRAINT  sis_courses_within_cred_type_flag_ck
            CHECK (type_flag IN (0, 1));    
);

CREATE TABLE sis_scheduled_course
(
    CRN NUMBER(5);
    semester_code CHAR(7);
    course_code CHAR(7) NOT NULL;
    section_code CHAR(1) NOT NULL;
        CONSTRAINT sis_scheduled_course_CRN_pk PRIMARY KEY (CRN),
        CONSTRAINT sis_scheduled_course_semester_code_pk PRIMARY KEY (semester_code),
        CONSTRAINT sis_scheduled_course_semester_code_ck
            CHECK (REGEXP_LIKE(semester_code, '[A-Z]{4}[0-9]{3}')),    
        CONSTRAINT sis_scheduled_course_course_code_fk FOREIGN KEY (CRN)
            REFERENCES (sis_course (course_code)),
        CONSTRAINT sis_scheduled_course_section_code_ck
            CHECK (REGEXP_LIKE(section_code, '[A-Z]'));
);

CREATE TABLE sis_instructor
(
    instructorid NUMBER();
    firstname NVARCHAR2(50) NOT NULL;
    lastname NVARCHAR2(50) NOT NULL;
    address NVARCHAR2(100) NOT NULL;
    city NVARCHAR2(40) NOT NULL;
    prov NCHAR(2) NOT NULL;
    postal_code NCHAR(6) NOT NULL;
    phonenumber NCHAR(12) NOT NULL;
    email NVCHAR2(100) NOT NULL;
        CONSTRAINT sis_instructor_instructorid_pk PRIMARY KEY (instructorid),
        CONSTRAINT sis_instructor_prov_ck
            CHECK (REGEXP_LIKE(prov, 'AB' 'BC' 'SK' 'ON' 'MB' 'QC' 'NS' 'PE' 'NL' 'NB' 'YT' 'NT' 'NU')),
        CONSTRAINT sis_instructor_postal_code_ck
            CHECK (REGEXP_LIKE(postal_code, '[A-Z][0-9][A-Z].[0-9][A-Z][0-9]'));
        CONSTRAINT sis_instructor_phonenumber_ck
            CHECK (REGEXP_LIKE(phonenumber, '[0-9]{3}.[0-9]{3}.[0-9]{4}'))
        CONSTRAINT  sis_instructor_email_ck
            CHECK (REGEXP_LIKE(email, '[]'))

);

CREATE TABLE sis_instructor_course
(
    CRN NUMBER(5);
    semester_code NCHAR(7);
    instructorid NUMBER();
)