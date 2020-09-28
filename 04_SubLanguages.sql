USE MOVIES
GO

--https://www.youtube.com/watch?v=-juirLxfuqs&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=8
--https://www.youtube.com/watch?v=uWdAP3kIhic&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=9
--https://www.youtube.com/watch?v=YoyduG2iEl8&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=10
--https://www.youtube.com/watch?v=MqgW7PIEJ3g&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=11


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
GO

-- SP_RENAME (SYNTAX : sp_RENAME 'TableName.[OldColumnName]' , '[NewColumnName]', 'COLUMN')

SP_RENAME 'MYDEMO.CustomerDetails_New.[CustomerID]','[Customer_ID]', 'COLUMN'
GO


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

/* 3.) DATA QUERY LANGUAGE or DATA RETRIEVING LANGUAGE

	- SELECT - READ OR RETRIEVE OR DISPLAY DATA            
	- TYPES OF RETRIEVAL METHODS : 
			-PROJECTION - Data retrieval WITHOUT ANY condition 
			-SELECTION - Data retrieval WITH condition 
			-JOINS - PROJECTION & SELECTION are applicable to retrieve information from SINGLE table.
				   - JOINS are applicable to retrieve information from MULTIPLE table.
*/

--PROJECTION
SELECT * FROM [MYDEMO].[CustomerDetails_New]

--SELECTION
SELECT * FROM [MYDEMO].[CustomerDetails_New]
WHERE [PostalCode]=2800

-- JOINS - Separate topic to be done later.


/*
4.) TRANSACTION CONTROL LANGUAGE (TCL)

	-BEGIN TRANSACTION
	-COMMIT - ONCE THE OPERATION IS COMMIT, WE CANNOT ROLLBACK.
	-ROLLBACK
	-SAVEPOINT

	https://www.youtube.com/watch?v=-KbbPH3Y_GI&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=19
	https://www.youtube.com/watch?v=9I8k2DwF12g&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=20
	https://www.youtube.com/watch?v=4d43UR9E8Fc&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=21
*/

SELECT * FROM [dbo].[tblCast]
UPDATE [dbo].[tblCast] SET [CastCharacterName] = 'Ray Ferrier Jr.' WHERE [CastID] = 1
--Now how do we go back to the original table condition where  [CastCharacterName] = 'Ray Ferrier'
--SIMILAR BUSINESS CASES FOR INSERT & DELETE AS WELL. HOW DO GO BACK TO ORIGINAL TABLE AFTER INSERT OR DELETE?
--BY DEFAULT, INSERT/UPDATE/DELETE ARE AUTO COMMIT OPERATIONS.

-- EXAMPLE HOW TO GO GO TO THE INITIAL TABLE CONDITION

BEGIN TRANSACTION
UPDATE [dbo].[tblCast] SET [CastCharacterName] = 'Ray Ferrier Sr.' WHERE [CastID] = 1

SELECT * FROM [dbo].[tblCast]

BEGIN TRANSACTION
ROLLBACK

SELECT * FROM [dbo].[tblCast]

-- HOW TO COMMIT CHANGES

BEGIN TRANSACTION
UPDATE [dbo].[tblCast] SET [CastCharacterName] = 'Ray Ferrier' WHERE [CastID] = 1

SELECT * FROM [dbo].[tblCast]

BEGIN TRANSACTION
COMMIT

SELECT * FROM [dbo].[tblCast]

-- SAVEPOINT - IT IS USED TO CREATE A TEMPORARY MEMORYFOR STORING THE VALUES WHICH WE WANT TO CONDITIONALLY CANCEL.

SELECT * FROM [dbo].[tblCast]

INSERT INTO [dbo].[tblCast] ([CastID],[CastFilmID],[CastActorID],[CastCharacterName])
VALUES (846,155,1,'MYTEST') --DUMMY RECORD ADDDED

SELECT * FROM [dbo].[tblCast]

BEGIN TRANSACTION
DELETE FROM [dbo].[tblCast] WHERE [CastID]=846
SAVE TRANSACTION MYPOINTER -- OBSERVE 846 IS NOT STORED IN THE POINTER AND CANNOT BE ROLL BACK
DELETE FROM [dbo].[tblCast] WHERE [CastID]=844 -- 844 IS STORED IN POINTER SO CAN BE ROLLED BACK
--EVERYTHING AFTER SAVE TRANSACTION POINTER WILL BE PRESERVED

SELECT * FROM [dbo].[tblCast]

BEGIN TRANSACTION
ROLLBACK TRANSACTION MYPOINTER

SELECT * FROM [dbo].[tblCast]

/*
5.) DATA CONTROL LANGUAGE

	-GRANT
	-REVOKE
	-Source : https://beginner-sql-tutorial.com/sql-grant-revoke-privileges-roles.htm#:~:text=SQL%20GRANT%20REVOKE%20Commands,privileges%20on%20a%20database%20object.
	-Ignore as its part of DBA journey.

*/
