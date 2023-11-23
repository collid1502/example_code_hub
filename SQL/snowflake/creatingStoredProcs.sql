/*
This code is a simple example of creating a stored procedure within Snowflake
*/

-- First, create some dummy data 
-- EMPLOYEES
CREATE TABLE IF NOT EXISTS PUBLIC.EMPLOYEE(
    STAFF_ID INTEGER,
    NAME VARCHAR(200),
    SALARY INTEGER,
    DEPARTMENT_ID INTEGER
);
-- WIPE ANY EXISTING DATA IF TABLE ALREADY EXISTED
TRUNCATE TABLE PUBLIC.EMPLOYEE;
-- INSERT NEW, FAKE DATA
INERST INTO PUBLIC.EMPLOYEE VALUES
(1, 'JOE BLOGGS', 50000, 1001),
(2, 'JANE DOE', 60000, 1001),
(3, 'TIM TALL', 40000, 1002),
(4, 'SALLY SURE', 30000, 1002),
(5, 'TONY STARK', 55000, 1001),
(6, 'STEVE RODGERS', 70000, 1002),
(7, 'NICK FURY', 100000, 1001);

-- DEPARTMENT 
CREATE TABLE IF NOT EXISTS PUBLIC.DEPARTMENT(
    DEPARTMENT_ID INTEGER,
    DEPARTMENT_NAME VARCHAR(200)
);
TRUNCATE TABLE PUBLIC.DEPARTMENT;
INSERT INTO PUBLIC.DEPARTMENT VALUES
(1001, 'FINANCE'),
(1002, 'MARKETING');

-- WORK PROJECT HISTORY
CREATE TABLE IF NOT EXISTS PUBLIC.PROJECT_HISTORY
(
    STAFF_ID INTEGER,
    PROJECT_ID INTEGER,
    PROJECT_NAME VARCHAR(200)
);
TRUNCATE TABLE PUBLIC.PROJECT_HISTORY;
INSERT INTO PUBLIC.PROJECT_HISTORY VALUES
(1, 9000, '2023 ACCOUNTS'),
(1, 8000, '2022 ACCOUNTS'),
(2, 9000, '2023 ACCOUNTS'),
(2, 9001, 'ACCOUNTING SOFTWARE UPGRADE 2023'),
(3, 9245, 'SUMMER SALES 2023'),
(3, 8147, 'WEBSITE REDEVELOPMENT'),
(4, 7568, 'UNI STUDENT PRODUCT LAUNCH'),
(5, 2322, 'EMPLOYEE WELLBEING'),
(6, 2322, 'EMPLOYEE WELLBEING'),
(6, 9245, 'SUMMER SALES 2023'),
(7, 9000, '2023 ACCOUNTS') ;

-- ====================================================================================

-- Now, let's create a stored procedure that when called and provided a project name,
-- returns the number of headcount, per department, that worked on that project

create or replace procedure headcount_per_department_for_project(project_name varchar)
returns table (department_name varchar, headcount integer)
language sql
as declare
    res resultset default (
        select
            d.department_name,
            count(p.staff_id) as headcount
        from public.project_history as p
        left join public.employee as e
            on p.staff_id = e.staff_id 
        left join public.department as d
            on e.department_id = d.department_id
        where p.project_name = :project_name
        group by d.department_name
    );
begin
    return table(res);
end;

-- once that has run, a stored proc is saved and can now be called:
call headcount_per_department_for_project('EMPLOYEE WELLBEING');

/* This would return:

        DEPARTMENT_NAME | HEADCOUNT
        ---------------------------
        FINANCE         |     1
        MARKETING       |     1
*/