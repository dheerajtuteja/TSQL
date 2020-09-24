USE MOVIES
GO

--https://www.youtube.com/watch?v=-juirLxfuqs&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=8
--https://www.youtube.com/watch?v=uWdAP3kIhic&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=9
--https://www.youtube.com/watch?v=YoyduG2iEl8&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=10


/* SQL Sub-Languages

1.) DATA DEFINITION LANGUAGE (DDL) -
	
	-CREATE
	-ALTER
	-SP_HELP
	-SP_RENAME
	-TRUNCATE
	-DROP
*/

--CREATE - To create DB & objects

CREATE TABLE MYDEMO.CustomerDetails_New
(
CustomerID     int   IDENTITY   PRIMARY KEY,
C_Name   varchar(50)      NOT NULL,
PostalCode     varchar(20)      NOT NULL,
Phone          varchar(25)         NOT NULL UNIQUE,
)

-- ALTER TABLE - ADD Column

ALTER TABLE MYDEMO.CustomerDetails_New 
ADD GENDER CHAR (6)

ALTER TABLE MYDEMO.CustomerDetails_New 
ADD CHILDREN CHAR (3)

-- ALTER TABLE - DROP COLUMN

ALTER TABLE MYDEMO.CustomerDetails_New 
DROP COLUMN CHILDREN

-- ALTER TABLE - ALTER/MODIFY COLUMN

ALTER TABLE MYDEMO.CustomerDetails_New 
ALTER COLUMN PostalCode CHAR(4)


-- SP_HELP

SP_HELP 'MYDEMO.CustomerDetails_New'

-- SP_RENAME (SYNTAX : sp_RENAME 'TableName.[OldColumnName]' , '[NewColumnName]', 'COLUMN')

SP_RENAME 'MYDEMO.CustomerDetails_New.[CustomerID]','[Customer_ID]', 'COLUMN'



-- TRUNCATE
-- 1.) DELETE ALL ROWSFROM TABLE AT A TIME
-- 2.) WE CANNOT DELETE SPECIFIC ROW FROM A TABLE
-- 3.) IT DOESN'T SUPPORT WHERE KEYWORD

TRUNCATE TABLE MYDEMO.CustomerDetails_New

-- DROP - DELETE ENTIRE TABLE WITH RECORDS (IF ANY)

DROP TABLE MYDEMO.CustomerDetails_New

/*2.) DATA MANIPULATION LANGUAGE (DML)
	
	-INSERT
	-UPDATE - UPDATE ALL ROWS / SPECIFIC ROW DATA IN A TABLE
	-DELETE - DELETE SPECIFIC ROW DATA FROM TABLE
*/

--INSERT
INSERT INTO MYDEMO.CustomerDetails_New  (C_Name,PostalCode,Phone,GENDER)
VALUES('DHEERAJ','2800',99999999,'MALE')

INSERT INTO MYDEMO.CustomerDetails_New  (C_Name,PostalCode,Phone,GENDER)
VALUES('ANUPAMA','2800',8888888,'FEMALE')

--UPDATE

UPDATE MYDEMO.CustomerDetails_New SET C_Name = 'Amit' WHERE [Phone]=8888888
UPDATE MYDEMO.CustomerDetails_New SET C_Name = 'Sumit' WHERE [Phone]=99999999


--DELETE
DELETE FROM MYDEMO.CustomerDetails_New WHERE [C_NAME]='SURESH'

/* 3.) DATA QUERY LANGUAGE

	-SELECT             */

SELECT * FROM MYDEMO.CustomerDetails_New 


/*
4.) TRANSACTION CONTROL LANGUAGE (TCL)

	-COMMIT
	-ROLLBACK
	-SAVEPOINT

5.) DATA CONTROL LANGUAGE

	-GRANT
	-REVOKE

*/