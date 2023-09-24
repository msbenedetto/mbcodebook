MySQL memo:

​

​------------------------------------------------------
-- Check MySQL version
​------------------------------------------------------
SELECT @@version;
SHOW VARIABLES WHERE VARIABLE_NAME= 'version';

​

​------------------------------------------------------
-- Check a table definition:
​------------------------------------------------------
SHOW CREATE TABLE tablename;
-- > output: 
CREATE TABLE `tablename` (   `actor_id` smallint unsigned NOT NULL AUTO_INCREMENT,   `first_name` varchar(45) NOT NULL,   `last_name` varchar(45) NOT NULL,   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,   PRIMARY KEY (`actor_id`),   KEY `idx_actor_last_name` (`last_name`) ) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


​
​------------------------------------------------------
-- DATE
​------------------------------------------------------
-- Possible error on date formatting 
-- /!\ Issue in comparison of 2 dates because of the FORMAT chosen (tested in 5 and 8)
SELECT

    CASE WHEN DATE_FORMAT(STR_TO_DATE('27.12.2022','%d.%m.%Y'),'%d.%m.%Y') > DATE_FORMAT(STR_TO_DATE('21.03.2023','%d.%m.%Y'),'%d.%m.%Y')

        THEN 'Ok, true'

        ELSE 'Error, false'

    END AS Comparison
FROM DUAL;-- WRONG output 'Ok, true'

-- It will be OK if you use another date format, like below:
SELECT
    CASE

        WHEN DATE_FORMAT(STR_TO_DATE('27/12/2022','%d/%m/%Y'),'%d/%m/%Y') > DATE_FORMAT(STR_TO_DATE('21/03/2023','%d/%m/%Y'),'%d/%m/%Y')
        THEN 'Ok, true'
        ELSE 'Error, false'
    END AS Comparison
FROM DUAL;-- CORRECT  output 'Error, false'

------------------------------------------------------
-- Only Date of today, no time:
-- CURDATE(): 
SELECT CURDATE(); -- 2023-09-15

-- DATE(date): 
SELECT DATE(SYSDATE()) FROM dual; -- 2023-09-16
------------------------------------------------------
​
------------------------------------------------------
-- Date of today + time:
-- SYSDATE(): 
SELECT SYSDATE() FROM DUAL; -- 2023-09-15 19:39:46

-- NOW():
SELECT NOW() FROM DUAL; -- 2023-09-15 19:41:34
------------------------------------------------------

​------------------------------------------------------
-- FORMAT: DATE_FORMAT()+ SYSDATE(): Date + time format of today:
SELECT DATE_FORMAT(SYSDATE(), '%Y/%m/%d %H:%i:%s') as Datetime; -- 2023-09-15 18:00:16

------------------------------------------------------
-- INTERVAL: NOW() function combined with interval to calculate today minus X days:

SELECT NOW() - INTERVAL 1 DAY; -- 2023-09-14 18:01:26

------------------------------------------------------
-- Date range:

-- How to query WITHIN a date range:

SELECT ...

FROM ...

WHERE mydatefield BETWEEN CURDATE() - interval 30 day

  AND CURDATE() + interval 30 day;

-- How to query easily OUT OF a date range:

SELECT ...

FROM ...

WHERE mydatefield NOT BETWEEN CURDATE() - interval 30 day

  AND CURDATE() + interval 30 day;

------------------------------------------------------
-- TO_DAYS() is used to CONVERT the DATE into NUMERIC number of days since year 0 after Christ.

-- Syntax:
select to_days(date);  
Parameter 'date': a date to be converted into number of days.

-- Example 1
select to_Days('2018-10-03'); -- 737335

-- Example 2
select to_Days('1995-02-11'); -- 728700

-- Example 3:

select to_Days('0-02-11'); -- 42

​------------------------------------------------------

​

​

​
------------------------------------------------------
-- CAST() Function:
------------------------------------------------------

/*
The CAST() function in MySQL is used to convert a value from one data type to another data type specified in the expression. 
It is mostly used with WHERE, HAVING, and JOIN clauses. This function is similar to the CONVERT() function in MySQL.

​

The following are the datatypes to which this function works perfectly:

​

Datatype    Descriptions
DATE: It converts the value into DATE datatype in the "YYYY-MM-DD" format. It supports the range of DATE in '1000-01-01' to '9999-12-31'.
DATETIME: It converts the value into the DATETIME data type in the "YYYY-MM-DD HH:MM:SS" format. It support the range in '1000-01-01 00:00:00' to '9999-12-31 23:59:59'.
TIME: It converts the value into TIME data type in the "HH:MM:SS" format. It supports the range of time in '-838:59:59' to '838:59:59'.
CHAR: It converts a value to the CHAR data type that contains the fixed-length string.
DECIMAL: It converts a value to the DECIMAL data type that contains a decimal string.
SIGNED: It converts a value to SIGNED datatype that contains the signed 64-bit integer.
UNSIGNED: It converts a value to the UNSIGNED datatype that contains the unsigned 64-bit integer.
BINARY: It converts a value to the BINARY data type that contains the binary string.



Syntax:
The following are the syntax of CAST() function in MySQL:
CAST(expression AS datatype); */

​

-- Example:

SELECT CAST(SYSDATE() AS DATE) FROM DUAL;

------------------------------------------------------
-- TO_DAYS(): used to CONVERT the DATE into NUMERIC number of days

-- You can CALCULATE the number of days between 2 dates

select to_Days('0-01-03'); -- 3

select to_Days('2023-09-03') - to_Days('2023-08-03'); -- 31

select to_days(cast(pastsysdatefield as date)) - to_days(curdate()) from table; -- negative value

select to_days(cast(futuresysdatefield as date)) - to_days(curdate()) from table; -- positive value

------------------------------------------------------
-- OTHER DATE functions:
select year(curdate()) from dual;
select month(curdate()) from dual;
select day(curdate()) from dual;

​------------------------------------------------------

​

​

​
------------------------------------------------------
-- LEFT JOIN:
------------------------------------------------------
-- Best explanation from: https://www.mysqltutorial.org/mysql-left-join.aspx

SELECT 
    select_list
FROM
    t1
LEFT JOIN t2 ON 
    join_condition;
/* 

When you use the LEFT JOIN clause, the concepts of the left table and the right table are introduced.
In the above syntax, t1 is the left table and t2 is the right table.
The LEFT JOIN clause selects data starting from the left table (t1). It matches each row from the left table (t1) with every row from the right table(t2) based on the join_condition.
If the rows from both tables cause the join condition evaluates to true, the LEFT JOIN combine columns of rows from both tables to a new row and includes this new row in the result rows.
In case the row from the left table (t1) does not match with any row from the right table(t2), the LEFT JOIN still combines columns of rows from both tables into a new row and includes the new row in the result rows. 
However, it uses NULL for all the columns of the row from the right table.
In other words, LEFT JOIN returns all rows from the left table regardless of whether a row from the left table has a matching row from the right table or not.
If there is no match, the columns of the row from the right table will contain NULL.

*/

​

​

​
------------------------------------------------------
-- COUNTINGS: count(), sum()
------------------------------------------------------
-- How many rows are reported in the table?

SELECT count(1) FROM tableName;

-- OR:

SELECT count(*) FROM table;

​

-- Count how many rows have the value 'x' in field 'myfield':

SELECT SUM(CASE WHEN myfield='value' THEN 1 ELSE NULL END) FROM table;

​

SELECT

  SUM(CASE WHEN first_name='ADAM' THEN 1 ELSE NULL END) AS Adam_firstname_number

FROM sakila.actor; -- 2

​

-- Count per concept, example here how many times a first_name is reported in the table

-- (group by first_name)

SELECT first_name, count(first_name)
FROM sakila.actor
GROUP BY first_name;

​

-- Classify per number of times, more complex logic:

SELECT first_name, 
   CASE
        WHEN (count(first_name)=1) THEN '1 time'
        WHEN (count(first_name)=2) THEN '2 times'
        WHEN (count(first_name)>2) THEN '> 3 times'
       -- ELSE 'No output'
    END AS NumberOfTimesFirstNameAppears
FROM sakila.actor
GROUP BY first_name;

​

-- Calculations possible with sum on NUMERIC fields.

-- We calculate first how many time we find a specific numeric value (for ex we know we only have NULL, 0 or 1 in the numeric field)

-- Query structure:

SELECT

    CASE
        WHEN (SUM(CASE WHEN (myNumericField = 1) THEN 1 ELSE NULL END)) <2 THEN '0 or 1 time'
        WHEN (SUM(CASE WHEN (myNumericField  = 1) THEN 1 ELSE NULL END)) =2 THEN '2 times'
        WHEN (SUM(CASE WHEN (myNumericField  = 1) THEN 1 ELSE NULL END)) =3 THEN '3 times'
        WHEN (SUM(CASE WHEN (myNumericField  = 1) THEN 1 ELSE NULL END)) >3 THEN 'More than 3 times'
        ELSE 'No Reactive'
    END AS myResult

FROM Table ... ;

​

------------------------------------------------------
-- DISTINCT
------------------------------------------------------

SELECT distinct first_name
FROM sakila.actor; -- output all the different first names


SELECT count(distinct first_name)
FROM sakila.actor;-- counts the nb of different names: 128 (out of 200 rows)



-- JOIN the table you need

SELECT Field1, Field2, count(distinct Field3) as 'Nb of whatever concept'
FROM Table A
JOIN Table B on A.key = B.key 
WHERE 1=1
  AND [Condition1]
  AND [Condition2]
GROUP BY Field1,Field2
ORDER BY Field1;


------------------------------------------------------
-- EXISTS() | NOT EXISTS()
------------------------------------------------------
-- Best explanation from: https://www.javatpoint.com/mysql-exists

SELECT col_names  
FROM tab_name  
WHERE [NOT] EXISTS (  
    SELECT col_names   
    FROM tab_name   
    WHERE condition  
); 

-- EXISTS returns true if there are records in the SUBQUERY, false if not

​

​

​
------------------------------------------------------
-- OPERATIONS:
------------------------------------------------------
-- RENAME TABLE
------------------------------------------------------

ALTER TABLE table_name RENAME TO new_table_name;

​

------------------------------------------------------
-- COPY A TABLE
------------------------------------------------------

CREATE TABLE sakila.actor20230918
AS
SELECT * FROM sakila.actor;

​

------------------------------------------------------
-- INSERT with AUTOINCREMENT on key
------------------------------------------------------
-- With auto increment, no need to specify anything on the field chosen as main key of the table (id)

-- when inserting new rows

INSERT INTO `sakila`.`actor20230918` (`first_name`,`last_name`,`last_update`)
VALUES ('Daniel','Dafoe',CURRENT_TIMESTAMP);



------------------------------------------------------
-- DELETE
------------------------------------------------------

DELETE FROM table_name WHERE condition;

​

------------------------------------------------------
-- LEFT() and RIGHT() functions
------------------------------------------------------

You can EXTRACT beginning from the LEFT of the string, X characters:

SELECT LEFT('CustomerName', 5) AS ExtractString
FROM dual;
-- Result: Custo


SELECT RIGHT('CustomerName', 5) AS ExtractString
FROM dual;
-- Result: rName

​

-- How to use that in a search:

SELECT DISTINCT LEFT(stringField,6)
FROM table a
WHERE a.stringField like ('whatyouaresearching%');




--------------------------------------------------------------------------------------------
-- Check what is NOT reported in another table when comparing the same data between COPIES:
--------------------------------------------------------------------------------------------
-- You have tableA and tableB, where tableB is an old copy with MORE rows than tableA​
-- Look who's guilty like this:

SELECT b.* from tableB b
left join tableA a on a.key = b.key 
where a.key is null;-- we find what is NOT reported in tableA

SELECT tb.* from sakila.actor20230918 tb
left join sakila.actor ta on ta.actor_id = tb.actor_id
where ta.actor_id is null; -- 201;Daniel;Dafoe;2023-09-18 11:38:05



--------------------------------------------------------------------------------------------
-- Check Processes that are running - use admin rights
--------------------------------------------------------------------------------------------

select * from information_schema.PROCESSLIST p where p.COMMAND <> 'Sleep';

select * from information_schema.PROCESSLIST where INFO IS NOT NULL;

select * from information_schema.PROCESSLIST p where DB='${theDB}' and COMMAND <> 'Sleep';

KILL 3788467; -- where 3788467 is the process Id you got in previous SQL query

​

​





​

​

​
