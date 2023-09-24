------------------------------------------------------
-- Parameters: 
​------------------------------------------------------
-- In the SQL document, you may insert externally received parameters as in:
SPOOL &1 out -- we receive in &1 the file name where we spool the info
​​
​------------------------------------------------------
---- COMMIT 
​------------------------------------------------------
-- ALWAYS DO COMMIT AT THE END>>> OTHERWISE NO CHANGES ARE DONE TO THE DB
-- /!\ CAUTION : CREATE and DROP do NOT need COMMIT
-- When it's done, there is NO WAY to do ROLLBACK

​------------------------------------------------------
-- For DELETE, remember to do the COMMIT
​------------------------------------------------------
/*Before deleting:
1. backup of the whole DB
2. export in a file
3. Make a counting with SELECT COUNT etc;
3. execute sentence DELETE FROM TABLE [WHERE CONDITIONS - optional];
4. compare result of the DELETE with the previous counting
5. COMMIT; if everything is OK*/



​------------------------------------------------------
-- BASIC OPERATIONS:
​​------------------------------------------------------

​------------------------------------------------------
---- SELECT ONLY A FEW ROWS
​------------------------------------------------------
SELECT * FROM clientname_member WHERE rownum < 19;

​------------------------------------------------------
-- CREATE
​------------------------------------------------------
CREATE TABLE TABLE_NAME;

​------------------------------------------------------
-- RENAME TABLE
​------------------------------------------------------
ALTER TABLE table_name RENAME TO new_table_name;
​
​------------------------------------------------------
-- DELETE / DROP
​------------------------------------------------------
DROP TABLE tableName;
​
​------------------------------------------------------
-- DUPLICATE TABLE / HOW TO COPY A WHOLE MEMBER TABLE / BACK UP
​------------------------------------------------------
CREATE TABLE tableNameBk AS SELECT * FROM tableName;
​
​

​------------------------------------------------------
-- UNION reminder
​------------------------------------------------------
/*The SQL UNION / UNION ALL operator is used to combine the result sets of 2 or more SELECT statements.

What is the difference between UNION and UNION ALL?
UNION removes duplicate rows.
UNION ALL does NOT remove duplicate rows (all rows are returned).

Each SELECT statement within the UNION / UNION ALL must have the SAME NUMBER OF FIELDS in the result sets with SIMILAR DATA TYPES.*/



​------------------------------------------------------
-- SQL*PLUS
​------------------------------------------------------
-- See below how to connect and execute some command lines
COPY {FROM database | TO database | FROM database TO database} {APPEND|CREATE|INSERT|REPLACE} destination_table [(column, column, column, ...)]  USING query
where database has the following syntax:
username[/password]@connect_identifier
​
COPY FROM user/pwd@dataPodLocation CREATE tableNameBk USING SELECT * FROM schema.tableName;
​
-- SCREENS in SQL*PLUS
-- SQLPLUS: 
-- Connection from DB to Putty:
~]$ sqlplus username/password@connect_identifier
SQL>
-- to execute an sql file just put the name of the file:
SQL> @[filename.sql]
-- Launch a copy:
SQL> COPY FROM user/pwd@dataPodLocation CREATE tableNameBk USING SELECT * FROM schema.tableName;
-- SCREENS in SQL*Plus:
-- 1: Make a screen:
SQL> screen -R mynewscreenname
-- 2: Within the screen, connect:
SQL> sqlplus username/password@connect_identifier
-- 3: Within the screen, launch the command to do a copy:
SQL> COPY FROM user/pwd@dataPodLocation CREATE tableNameBk USING SELECT * FROM schema.tableName;
-- 4: Leave the screen without closing it, doing : (the job is running in the background)
ctrl + a + d
-- 5: see the list of the screens:
SQL> screen -ls 
-- 6: We enter again in a screen we created previously
SQL> screen -r mynewscreenname
-- 7: We close the screen, it will no longer be in the list (it will delete it)
SQL> exit
-- to quit from sqlplus:
SQL> quit
Disconnected from Oracle Database etc

-- REMINDER SCREENs cmd lines
screen -ls
-- > to see the list of screens
​
screen -r nameofmyscreen 
-- > to enter in a screen we created previously
​
ctrl + a + d
-- > to detach the screen (not deleting, just leaving it work in the background)
​
exit 
-- > to exit and delete the screen, from within it
​
​​
​
​​------------------------------------------------------
-- FIELDS / COLUMNS MANAGEMENT
​------------------------------------------------------
​​
​------------------------------------------------------
-- ADD A FIELD / COLUMN CALLED "NEWFIELD1", type NUMBER
​------------------------------------------------------
ALTER TABLE tableName ADD (NEWFIELD1 NUMBER(19));
​
------------------------------------------------------
-- ADD A FIELD / COLUMN CALLED "NEWFIELD1", type NUMBER --> DECIMAL
​------------------------------------------------------
ALTER TABLE tableName  ADD (NEWFIELD1 NUMBER(19));
-- number(p,s)   
-- Where p is the precision and s is the scale.
-- Scale can range from -84 to 127.     
-- Precision can range from 1 to 38.
​-- For example, number(7,2) is a number that has 5 digits before the decimal and 2 digits after the decimal.
​
​------------------------------------------------------
-- ADD A FIELD / COLUMN CALLED "NEWFIELD2", type NVARCHAR2
​------------------------------------------------------
ALTER TABLE tableName  ADD (NEWFIELD2 NVARCHAR2(255));
​
​------------------------------------------------------
-- ADD A FIELD / COLUMN CALLED "NEWFIELD3", type DATE
​------------------------------------------------------
ALTER TABLE tableName ADD (NEWFIELD3 DATE);
​
​------------------------------------------------------
-- ADD MULTIPLE FIELDS
​------------------------------------------------------
ALTER TABLE tableName
  ADD (column_1 column_definition,
       column_2 column_definition,
       ...
       column_n column_definition);

​------------------------------------------------------
-- COUNT THE MAX number of characters contained in a field 
​------------------------------------------------------
-- For example we have a field type number with max length 19 char but perhap the max number has only 13 char, how can we know?
SELECT MAX(LENGTH(column_name)) FROM tableName;
​
​------------------------------------------------------
-- RENAME FIELDS / COLUMNS
​------------------------------------------------------
ALTER TABLE table_name RENAME COLUMN old_name TO new_name;
​
​------------------------------------------------------
-- EMPTY FIELDS / COLUMNS
​------------------------------------------------------
UPDATE [tablename] SET [fieldname] = [value], [field2] = [extra value] etc

​------------------------------------------------------
-- MODIFY FIELDS / COLUMNS
​------------------------------------------------------
ALTER TABLE table_name
  MODIFY column_name column_type;
-- ex:
ALTER TABLE customers
  MODIFY customer_name varchar2(100) NOT NULL;

​------------------------------------------------------
-- MODIFY MULTIPLE FIELDS:
​------------------------------------------------------
ALTER TABLE table_name 
MODIFY (
FIELD1 NUMBER(8,2),
FIELD2 NVARCHAR2(100),
FIELD3 NUMBER(19),
FIELD4 DATE
);
COMMIT;
​
​------------------------------------------------------
-- DROP FIELDS / COLUMNS 
​------------------------------------------------------
ALTER TABLE table_name
DROP COLUMN column_name;
 
-- Physical Delete
/*To physically drop a column you can use one of the following syntaxes, depending on whether you wish to drop a single or multiple columns.*/
-- 1 column
ALTER TABLE table_name DROP COLUMN column_name;
-- many columns
ALTER TABLE table_name DROP (column_name1, column_name2);

​------------------------------------------------------
-- DELETE ROWS
​------------------------------------------------------
DELETE FROM TABLENAME; -- will delete the content of the whole table
DELETE FROM table
[WHERE conditions];
COMMIT;

-- Steps:
-- 1- Back up:
CREATE TABLE TABLENAMEYYYYMMDD
AS
SELECT * FROM TABLENAME;
-- 2- Counting:
SELECT COUNT(*) FROM tablename
WHERE condition;
-- 3- Delete:
DELETE FROM tablename
WHERE condition;
-- 4- After delete, you must check that the nb of deleted rows is the same than the previous counting
-- 5- COMMIT; -- will definitely delete from the table

​------------------------------------------------------
-- COPY DATA FROM A FIELD Column1 TO ANOTHER FIELD Column2 IN THE SAME TABLE
​------------------------------------------------------
UPDATE TableName
SET Column1 = Column2;
UPDATE table
SET column1 = expression1,
    column2 = expression2,
    ...
    column_n = expression_n
[WHERE conditions];

/*
1- copy
>> check the copy is OK
2- drop "old" column
3- rename the new one to the previous name*/

UPDATE TABLE_NAME A SET A.NEW_COLUMN = (SELECT B.OLD_COLUMN FROM TABLE_NAME B WHERE A.ID = B.ID);

-- How do you copy from one column to another in SQL?
-- Simply use an update statement

-- Case 1: If the column is from the same table:
UPDATE TableName1
SET Column1 = Column2
​
-- Case 2: If the column is from a different table:
UPDATE TableName1 as T1
SET Column1 = (SELECT Column2 FROM TableName2 as T2 where T1.CommonColumn1 = T2.CommonColumn1)
​
-- > Both these cases will update the whole table, you can add a where clause if you want to restrict.
UPDATE aTable SETtheNewField = theOldField;
COMMIT;;
-- To do only after the 'COMMIT' is completed:
ALTER aTable DROP COLUMN theOldField;
​
​------------------------------------------------------
-- PROCESS to copy data to a new field
​------------------------------------------------------
/*We:
- rename the "old" field
- create a new field with the name of the "old" field
- update the database setting the data contained in the renamed "old" field in the "new" one
- commit
- verify that the new field has been correctly updated
- drop the "old" field (column) that we no longer need*/
​


​------------------------------------------------------
-- METADATA CHECKS
​------------------------------------------------------

------------------------------------------------------
-- HOW TO LOOK FOR SPECIFIC TABLES, WITH PATTERN ON THE NAME
​------------------------------------------------------
SELECT table_name, owner FROM all_tables WHERE LOWER(table_name) LIKE '%helly%' ORDER BY table_name;
​
​------------------------------------------------------
-- HOW TO KNOW WHEN A TABLE HAS BEEN CREATED
​------------------------------------------------------
-- Use DBA_OBJECTS: it describes all objects in the database.
-- Its columns are the same as those in ALL_OBJECTS.
SELECT created
  FROM dba_objects
WHERE object_name = <<your table name>>
   AND owner = <<owner of the table>>
   AND object_type = 'TABLE';

SELECT *
  FROM dba_objects
WHERE lower(object_name) like lower('%nameIsearch%')
   --AND owner = <<owner of the table>>
   AND object_type = 'TABLE';

​------------------------------------------------------
-- CHECK INDEX
​------------------------------------------------------
-- Use table "ALL_INDEXES" to see if a table has index(es)
SELECT * FROM ALL_INDEXES WHERE LOWER(TABLE_NAME) like LOWER('%yoursearch%');

/*OTHER field to search on: 
- INDEX_NAME
- UNIQUENESS >> values: NONUNIQUE or UNIQUE */
​
​------------------------------------------------------
-- See the associated field(s) to an INDEX
​------------------------------------------------------
-- Table to search in:
DESC all_ind_columns;
-- Use table "ALL_IND_COLUMNS" to check a column is an index
SELECT * FROM ALL_IND_COLUMNS WHERE LOWER(TABLE_NAME) like LOWER('%yoursearch%');

​------------------------------------------------------
-- HOW TO KNOW WHEN A TABLE HAS BEEN CREATED
------------------------------------------------------
desc ALL_TAB_MODIFICATIONS;
-- > describes tables accessible to the current user that have been modified since the last time statistics were gathered on the tables.
desc ALL_TAB_STATISTICS;
-- > displays optimizer statistics for the tables accessible to the current user.

​------------------------------------------------------
-- HOW TO CHECK A CONSTRAINT
​------------------------------------------------------
/*What is a constraint?
A constraint allow to define and reduce the number of entries possibilities.
We can set up a constraint on a field so the field only allows a list of value to be inserted:
for example in a field called COUNTRYCODE, we can set up a constraint so the field only accept values: 'FR','ES','UK','DE' etc
Constraints might be located in this view:
ALL_CONSTRAINTS
So to check all existing constraints, you can do:*/
select * from ALL_CONSTRAINTS;
-- Then, if you have a constraint name, you can do a partial search, like this:
select * from ALL_CONSTRAINTS where CONSTRAINT_NAME like '%yourSearch%';

​------------------------------------------------------
-- HOW TO SEARCH a TRIGGER (oracle piece of program)
​------------------------------------------------------
-- A trigger is a named program unit that is stored in the database and fired (executed) in response to a
-- specified event. The specified event is associated with either a table, a view, a schema,
-- or the database, and it is one of the following:
-- A database manipulation (DML) statement (DELETE, INSERT, or UPDATE)
-- A database definition (DDL) statement (CREATE, ALTER, or DROP)
-- A database operation (SERVERERROR, LOGON, LOGOFF, STARTUP, or SHUTDOWN)
-- The trigger is said to be defined on the table, view, schema, or database.
SELECT * from ALL_TRIGGERS;
SELECT * from ALL_TRIGGERS WHERE lower(trigger_name) LIKE lower('%yourSearch%');
​
​------------------------------------------------------
-- COMPARE A TABLE WITH ITSELF
​------------------------------------------------------
SELECT count(*)
FROM tableNAme a
INNER JOIN tableName b ON upper(t1.email)=upper(t2.email) AND t2.aNumericKey> t1.aNumericKey;
-- > we could have some insights from this search, according to the business contxt of the table etc
​
​------------------------------------------------------
--  HOW TO CHECK IF A FIELD IS EMPTY 
​------------------------------------------------------
select table_name,column_name,nullable,num_distinct,num_nulls from all_tab_columns
where table_name = 'XXXXX'
and num_distinct > 0;
-- The idea is to use the table ALL_TAB_COLUMNS
-- Then make a query on it passing the table name and adding the condition null or not null
-- in this case = 0 or >0



​------------------------------------------------------
-- FUNCTIONS
​------------------------------------------------------

​------------------------------------------------------
-- TRIM()
​------------------------------------------------------
-- RTRIM: right trim -> retrieve characters on the right side of the string (end)
-- LTRIM: right trim -> retrieve characters on the left side of the string (beginning) 
-- BOTH: on both side
-- Examples:
SELECT DISTINCT fieldName FROM tableName 
WHERE (LENGTH(RTRIM(fieldName)) = 2 OR LENGTH(RTRIM(fieldName)) = 5)
  AND LOWER((SUBSTR(RTRIM(fieldName),-2)) = 'de';
-- If we have: NAMEOFFIELD = '  mystring  '
-- this sentence:
SELECT TRIM(BOTH ' ' FROM NAMEOFFIELD), EMAIL  from tableName
WHERE EMAIL = 'myemail@email.com';
-- will retrieve the blank spaces : NAMEOFFIELD='mystring'
-- > the spaces have been retrieved from both sides
SELECT COUNT(*) from tableName 
WHERE TRIM(BOTH ' ' FROM NAMEOFFIELD) in ('VALUE1','VALUE2', etc);

​------------------------------------------------------
-- SUM() + CASE to count
​------------------------------------------------------
SELECT SUM(CASE WHEN myField is null then 0 else 1 end) AS whateverConceptYoureCounting
...
FROM tableName
WHERE TRUNC(aDateField <= trunc(sysdate) -365 ...; -- e.g. last year counting of X activity

------------------------------------------------------
-- TO_DATE()
​------------------------------------------------------
-- Description: The Oracle/PLSQL TO_DATE function converts a string to a date.
-- Syntax: The syntax for the TO_DATE function in Oracle/PLSQL is:
-- TO_DATE( string1 [, format_mask] [, nls_language] )

-- TO_DATE('2003/07/09', 'yyyy/mm/dd')
-- Result: date value of July 9, 2003

-- TO_DATE('070903', 'MMDDYY')
-- Result: date value of July 9, 2003

-- TO_DATE('20020315', 'yyyymmdd')
-- Result: date value of Mar 15, 2002

-- TO_DATE('30/11/2019', 'dd/mm/yyyy')
-- etc.
​
-- Test the TO_DATE function with dual as follows:
SELECT TO_DATE('2015/05/15 8:30:25', 'YYYY/MM/DD HH:MI:SS')
FROM dual;
-- This would convert the string value of 2015/05/15 8:30:25 to a date value.
​
-- HOW TO LOOK FOR A SPECIFIC insert time, assuming you have a datefield (ex 'datejoin') registering this activity
SELECT count(*) 
FROM tableName 
WHERE datejoin > TO_DATE('2019/12/03 15:34:00', 'YYYY/MM/DD HH24:MI:SS');
​
-- SEARCH BY DATE with format parameter
SELECT * 
FROM tableName 
WHERE DATEFIELD = TRUNC(TO_DATE('01-01-1970','DD-MM-YYYY'),'YEAR');

​------------------------------------------------------
-- TO_CHAR()
​------------------------------------------------------
-- Syntax
-- The syntax for the TO_CHAR function in Oracle/PLSQL is:
TO_CHAR( value [, format_mask] [, nls_language] )
/*Examples with Dates
The following is a list of valid parameters when the TO_CHAR function is used to convert a date to a string. These parameters can be used in many combinations.

Parameter	Explanation
YEAR		Year, spelled out
YYYY		4-digit year
YYY
YY
Y			Last 3, 2, or 1 digit(s) of year.
IYY
IY
I			Last 3, 2, or 1 digit(s) of ISO year.
IYYY		4-digit year based on the ISO standard
Q			Quarter of year (1, 2, 3, 4; JAN-MAR = 1).
MM			Month (01-12; JAN = 01).
MON			Abbreviated name of month.
MONTH		Name of month, padded with blanks to length of 9 characters.
RM			Roman numeral month (I-XII; JAN = I).
WW 			Week of year (1-53) where week 1 starts on the first day of the year and continues to the seventh day of the year.
W			Week of month (1-5) where week 1 starts on the first day of the month and ends on the seventh.
IW			Week of year (1-52 or 1-53) based on the ISO standard.
D			Day of week (1-7).
DAY			Name of day.
DD			Day of month (1-31).
DDD			Day of year (1-366).
DY			Abbreviated name of day.
J			Julian day; the number of days since January 1, 4712 BC.
HH			Hour of day (1-12).
HH12		Hour of day (1-12).
HH24		Hour of day (0-23).
MI			Minute (0-59).
SS			Second (0-59).
SSSSS		Seconds past midnight (0-86399).
FF			Fractional seconds.

The following are date examples for the TO_CHAR function.
TO_CHAR(sysdate, 'yyyy/mm/dd')
Result: '2003/07/09'
TO_CHAR(sysdate, 'Month DD, YYYY')
Result: 'July 09, 2003'
TO_CHAR(sysdate, 'FMMonth DD, YYYY')
Result: 'July 9, 2003'
TO_CHAR(sysdate, 'MON DDth, YYYY')
Result: 'JUL 09TH, 2003'
TO_CHAR(sysdate, 'FMMON DDth, YYYY')
Result: 'JUL 9TH, 2003'
TO_CHAR(sysdate, 'FMMon ddth, YYYY')
Result: 'Jul 9th, 2003'

You will notice that in some TO_CHAR function examples, the format_mask parameter begins with "FM". This means that zeros and blanks are suppressed. This can be seen in the examples below.
TO_CHAR(sysdate, 'FMMonth DD, YYYY')
Result: 'July 9, 2003'
TO_CHAR(sysdate, 'FMMON DDth, YYYY')
Result: 'JUL 9TH, 2003'
TO_CHAR(sysdate, 'FMMon ddth, YYYY')
Result: 'Jul 9th, 2003'
TO_CHAR(nameoffield,'YYYY/MM/DD HH:MI:SS')
TO_CHAR(nameoffield,'YYYY/MM/DD HH24:MI:SS')
TO_CHAR(nameoffield,'DD/MM/YYYY HH24:MI:SS')
The zeros have been suppressed so that the day component shows as "9" as opposed to "09". */
​
​------------------------------------------------------
-- ROW_NUMBER()
​------------------------------------------------------
-- > allow to dedup based on a criteria, then keep the 1st row for example of the selection / use nulls first or nulls last 
-- ROW_NUMBER is an analytic function.
-- It assigns a unique number to each row to which it is applied (either each row in the partition or each
-- row returned by the query),
-- in the ordered sequence of rows specified in the order_by_clause, beginning with 1.
-- Example:
SELECT [Fields] 
FROM(
  SELECT
    t.*, 
    ROW_NUMBER () OVER (PARTITION BY lower(aField) ORDER BY t.field1 desc, t.field2 desc [etc]) as rn
  FROM tableName t
  WHERE ... [conditions]
) where rn =  1;

SELECT department_id, last_name, employee_id, ROW_NUMBER()
   OVER (PARTITION BY department_id ORDER BY employee_id) AS emp_id
   FROM employees;

/*
DEPARTMENT_ID LAST_NAME                 EMPLOYEE_ID     EMP_ID
------------- ------------------------- ----------- ----------
           10 Whalen                            200          1
           20 Hartstein                         201          1
           20 Fay                               202          2
           30 Raphaely                          114          1
           30 Khoo                              115          2
           30 Baida                             116          3
           30 Tobias                            117          4
           30 Himuro                            118          5
           30 Colmenares                        119          6
           40 Mavris                            203          1
. . .
          100 Popp                              113          6
          110 Higgins                           205          1
          110 Gietz                             206          2*/

------------------------------------------------------
-- THE NVL() function - best explanation on: https://www.techonthenet.com/oracle/functions/nvl.php
​------------------------------------------------------
-- The Oracle/PLSQL NVL function lets you substitute a value when a null value is encountered.
-- Syntax:
-- The syntax for the NVL function in Oracle/PLSQL is:
-- NVL( string1, replace_with )
-- Parameters or Arguments:
-- string1: The string to test for a null value.
-- replace_with: The value returned if string1 is null.
-- Returns: The NVL function returns a substitute value.
​
-- EXAMPLES
SELECT NVL(supplier_city, 'n/a')
FROM suppliers;
-- >> The SQL statement above would return 'n/a' if the supplier_city field contained a null value. Otherwise, it would return the supplier_city value.
​
-- Another example using the NVL function in Oracle/PLSQL is:
SELECT supplier_id,
NVL(supplier_desc, supplier_name)
FROM suppliers;
-- >> This SQL statement would return the supplier_name field if the supplier_desc contained a null value. Otherwise, it would return the supplier_desc.
​
-- A final example using the NVL function in Oracle/PLSQL is:
SELECT NVL(commission, 0)
FROM sales;
-- >> This SQL statement would return 0 if the commission field contained a null value. Otherwise, it would return the commission field.

​------------------------------------------------------
-- THE NVL2() function - best explanation: https://www.techonthenet.com/oracle/functions/nvl2.php
​------------------------------------------------------
-- The Oracle/PLSQL NVL2 function extends the functionality found in the NVL function.
-- It lets you substitutes a value when a null value is encountered as well as when a non-null value is encountered.
-- Syntax: 
-- The syntax for the NVL2 function in Oracle/PLSQL is:
-- NVL2( string1, value_if_not_null, value_if_null )
-- Parameters or Arguments:
-- string1: The string to test for a null value.
-- value_if_not_null: The value returned if string1 is not null.
-- value_if_null: The value returned if string1 is null.
-- Returns: The NVL2 function returns a substitute value.
​
-- EXAMPLES
select NVL2(supplier_city, 'Completed', 'n/a')
from suppliers;
-- >> The SQL statement above would return 'n/a' if the supplier_city field contained a null value. -- Otherwise, it would return the 'Completed'.

-- Another example using the NVL2 function in Oracle/PLSQL is:
select supplier_id,
NVL2(supplier_desc, supplier_name, supplier_name2)
from suppliers;
-- >> This SQL statement would return the supplier_name2 field if the supplier_desc contained a null value. Otherwise, it would return the supplier_name field.


​
​​------------------------------------------------------
-- ANALYSIS
​​------------------------------------------------------

​------------------------------------------------------
-- CHECK DUPLICATES: the detailed EMAIL example
​------------------------------------------------------
​
-- 1- Count all rows of the table:
SELECT COUNT(*) FROM tableName; -- 4732389 rows

-- 2- Count the duplicates (email AND the duplicate(s)):
SELECT COUNT(*) FROM tableName
WHERE LOWER(EMAIL) IN (
  SELECT LOWER(EMAIL)
  FROM tableName
  GROUP BY LOWER(EMAIL)
  HAVING COUNT(*) > 1
); -- 2879518 rows
​
-- 3- Count the UNIQUE emails (email with NO duplicates in the table)
SELECT COUNT(*) FROM tableName
WHERE LOWER(EMAIL) IN (
  SELECT LOWER(EMAIL)
  FROM tableName
  GROUP BY LOWER(EMAIL)
  HAVING COUNT(*) = 1
); -- 1852871 rows
-- > We see that's OK: 2879518 + 1852871 = 4732389 -> this is the total nb we found at the beginning

-- 4- Count how many rows should be removed to get a clean table with no duplicates on EMAIL field:
SELECT COUNT(DISTINCT LOWER(email)) FROM tableName; -- 2647161 rows
-- Meaning that: 4732389-2647161=2085228
-- > There are 2085228 duplicates that could be deleted to sanitize the db 

​------------------------------------------------------
-- CHECK if a field contains or not a letter REGEXP
​------------------------------------------------------
-- REGEXP_LIKE
SELECT COUNT(*) FROM tableName WHERE REGEXP_LIKE(lower(myField),'[^A-Za-z]');
-- > what X number of lines have a non varchar character on the field myField
​
​------------------------------------------------------
-- CHECK if a field is EMPTY or not
​------------------------------------------------------
SELECT count(*) FROM tablename WHERE fieldname is null; --> how many register HAVE NO VALUE in it
SELECT count(*) FROM tablename WHERE fieldname is not null; --> how many register HAVE VALUE in it
​​
​------------------------------------------------------
-- COMPARE 2 SELECTS: MINUS tool
​------------------------------------------------------
select * from mytable t1 where  t1.code = '100'
MINUS 
select * from mytable t2 where  t2.code = '999';
-- MINUS gives you the rows that are found in the first query and not in the second query by removing from the results all the rows that are found only in the second query
​
​------------------------------------------------------
-- HOW TO IDENTIFY DUPLICATED ROWS
-- based on a NUMERIC field (ex a serial auto increment)
-- using min or max
​------------------------------------------------------
delete 
from table_name
where  numField not in (
  select min(numField )
  from   table_name
  group  by lower(field) -- where field is a solid criteria/key in your table to dedup
); -- we could here keep the oldest records if we consider they are the one to be kept

​​------------------------------------------------------
-- ENCODING - some possible checks
​------------------------------------------------------
SELECT * FROM NLS_DATABASE_PARAMETERS;
-- POSSIBLE ANSWER:
/*NLS_LANGUAGE    AMERICAN
NLS_TERRITORY    AMERICA
NLS_CURRENCY    $
NLS_ISO_CURRENCY    AMERICA
NLS_NUMERIC_CHARACTERS    .,
NLS_CHARACTERSET    WE8DEC
NLS_CALENDAR    GREGORIAN
NLS_DATE_FORMAT    DD-MON-RR
NLS_DATE_LANGUAGE    AMERICAN
NLS_SORT    BINARY
NLS_TIME_FORMAT    HH.MI.SSXFF AM
NLS_TIMESTAMP_FORMAT    DD-MON-RR HH.MI.SSXFF AM
NLS_TIME_TZ_FORMAT    HH.MI.SSXFF AM TZR
NLS_TIMESTAMP_TZ_FORMAT    DD-MON-RR HH.MI.SSXFF AM TZR
NLS_DUAL_CURRENCY    $
NLS_COMP    BINARY
NLS_LENGTH_SEMANTICS    CHAR
NLS_NCHAR_CONV_EXCP    FALSE
NLS_NCHAR_CHARACTERSET    AL16UTF16
NLS_RDBMS_VERSION    11.2.0.3.0*/
​
SELECT USERENV ('language') FROM DUAL;
SELECT * FROM NLS_SESSION_PARAMETERS;
SELECT * FROM NLS_DATABASE_PARAMETERS;
SELECT * FROM NLS_INSTANCE_PARAMETERS;

​------------------------------------------------------
-- NULLS LAST / NULLS FIRST - best explanation: https://learnsql.com/blog/how-to-order-rows-with-null
​------------------------------------------------------
-- Oracle treat NULL values as very large and put them:
-- at the end of an ascending sort order - ORDER BY ... ASC
-- at the beginning of a descending sort order. - ORDER BY ... DESC
-- If the null ordering is not specified, then the handling of the null values is NULLS LAST
​
SELECT * FROM table 
[WHERE...]
ORDER BY <field_name> desc 
NULLSLAST;
​
SELECT * FROM table 
[WHERE...]
ORDER BY <field_name> desc 
NULLS FIRST;
​
​
​
​
​
​
​
