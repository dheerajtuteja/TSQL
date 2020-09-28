-- www.udemy.com/course/ssrs-t-sql-online-video-training/

USE MOVIES
GO

/*
SCHEMAS - It is a container which contains OBJECTS.

OBJECTS in TSQL --> TABLE, VIEW, STORED PROCEDURE, TRIGGER, FUNCTION etc.

Default schema is 'dbo'. No need to write dbo in query.
Advantage of creating schema:
1.) Logically separates the SQL objects. Example : HR Schema will have all HR tables.
Select * from HR.Emp

2.) Its easier for DBA to grant or revoke access from Schema instead of individual TSQL object.


Example 1:

DB1 --> Schema1 --> Tab1
DB2 --> dbo --> Tab2

UNION:

SELECT * FROM Schema1.Tab1
UNION
SELECT * FROM DB2.dbo.Tab2


Example 2:

SERVER1 --> DB1 --> Schema1 --> Tab1
SERVER2 --> DB2 --> dbo --> Tab2

Assumption:
1.) SERVER 2 & SERVER 1 ARE LINKED
2.) Currently you are logged in to Server 2
3.) You have all necesscary access to both Server & DB.

UNION:

SELECT * FROM dbo.Tab2
UNION
SELECT * FROM SERVER1.DB1.Schema1.Tab1

*/


-- 1.) How to create schema?

SELECT * FROM SYS.SCHEMAS

SELECT * FROM SYS.TABLES

SELECT * FROM SYS.VIEWS

SELECT * FROM SYS.OBJECTS

CREATE SCHEMA MYDEMO

CREATE TABLE MYDEMO.TABLE_TEST(
ID INT,
S_NAME VARCHAR (50)

)

SELECT OBJECT_ID('MYDEMO.TABLE_TEST')


-- 2.) How to change schema of a object

ALTER SCHEMA MYDEMO TRANSFER [dbo].[CustomerDetails]
ALTER SCHEMA MYDEMO TRANSFER [dbo].[DateDemo]
ALTER SCHEMA MYDEMO TRANSFER [dbo].[DateDemo_New]
ALTER SCHEMA MYDEMO TRANSFER [dbo].[DecimalDemo]
ALTER SCHEMA MYDEMO TRANSFER [dbo].[employeetable]
ALTER SCHEMA MYDEMO TRANSFER [dbo].[MyTable]
ALTER SCHEMA MYDEMO TRANSFER [dbo].[Sales]
ALTER SCHEMA MYDEMO TRANSFER [dbo].[student]
ALTER SCHEMA MYDEMO TRANSFER [dbo].[UnicodeDemo]

-- CREATE TABLE IN SSMS. ONCE DONE --> PRESS F4 & CHANGE SCHEMA NAME MANUALLY

-- 3.) How to copy data from one table to another belonging to different schema

-- FIRST COPE A TABLE OF THE MOVIES DB (DBO SCHEMA)
SELECT * INTO NEWACTOR FROM [dbo].[tblActor]
SELECT * FROM NEWACTOR

--CREATE DESTINATION TABLE IN THE MYDEMO SCHEMA
CREATE TABLE [MYDEMO].[NEWACTOR](
	[ActorID] [int] NOT NULL,
	[ActorName] [nvarchar](255) NULL,
) 

--Now transfer this NEWACTOR (2 Columns - ActorID & ActorName) from DBO  to MYDEMO
INSERT INTO [MYDEMO].[NEWACTOR]([ActorID],[ActorName])
SELECT [ActorID],[ActorName] FROM [dbo].[tblActor]

SELECT * FROM [MYDEMO].[NEWACTOR] 

--4.) List all tables in the SCHEMA MYDEMO


SELECT * FROM SYS.SCHEMAS

SELECT * FROM SYS.TABLES

SELECT T.NAME FROM SYS.TABLES AS  T
INNER JOIN
SYS.SCHEMAS AS S
ON T.schema_id = S.schema_id
WHERE S.name='MYDEMO'


