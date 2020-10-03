-- INDEXING IN SQL SERVER
-- Concept _ 
-- https://www.youtube.com/watch?v=fsG1XaZEa78&t=5s

-- Source:
-- https://www.udemy.com/course/sql-server-sql/learn/lecture/13027322#overview

-- IF INDEXES ARE NOT CREATED, SQL DOES TABLE SCAN
-- IF INDEXES ARE CREATED IN SQL, IT PERFORMS B TREE OR BALANCED TREE SCAN
-- ROOT NODE --> INTERMEDIATE NODE --> LEAF NODE

-- DATA PREPARATION
USE [AdventureWorksDW2020]
GO

-- COPY TABLE
-- WHEN COPIED, KEYS AND INDEXES ARE NOT COPIED.
SELECT * INTO MYINDEXDEMO FROM [dbo].[FactInternetSales]

-- CHECK TABLES
SELECT * FROM [dbo].[FactInternetSales] -- IT HAS PK AND HENCE INDEX IS PRESENT
SELECT * FROM MYINDEXDEMO -- NO INDEX IS PRESENT

-- TEST THE IMPACT OF THE INDEX

-- TABLE WITH INDEX
SET STATISTICS IO ON
SELECT * FROM [dbo].[FactInternetSales] WHERE SalesOrderNumber= 'SO43700' 
--Logical Reads 3
-- MESSAGE : Table 'FactInternetSales'. Scan count 1, logical reads 3, physical reads 3, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
-- PRESS THE THIRD RIGHT BUTTON FROM EXECUTE
-- WE WILL SEE "CLUSTERED INDEX"

-- TABLE WITHOUT INDEX

SET STATISTICS IO ON
SELECT * FROM MYINDEXDEMO WHERE SalesOrderNumber= 'SO43700' 
--Logical Reads 798
--MESSAGE : Table 'MYINDEXDEMO'. Scan count 1, logical reads 798, physical reads 0, page server reads 0, read-ahead reads 758, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

EXECUTE sp_spaceused '[AdventureWorksDW2020].[dbo].[MYINDEXDEMO]'

--NON CLUSTERED VS CLUSTERED INDEXES

-- NON CLUSTERED INDEX --> ROOT NODE --> INTERMEDIATE NODE --> LEAF NODE --> DOES NOT HOLDS ACTUAL DATA BUT ACTUALLY IT POINTS TO LEAF NODES OF THE CLUSTERED INDEX AND THEN GETS THE DATA (EXAMPLE IS BOOK INDEX AS LAT PAGE)

-- CLUSTERED INDEX --> ROOT NODE --> INTERMEDIATE NODE --> LEAF NODE --> HOLDS ACTUAL DATA (EXAMPLE MOBILE PHONE BOOK)




-- CREATE INDEX

CREATE NONCLUSTERED INDEX <index_name>
ON <table_name>(<column_name> ASC/DESC)

-- OR EQUIVALENT

CREATE INDEX <index_name> -- BY DEFAULT NON CLUSTERED INDEXES ARE CREATED
ON <table_name>(<column_name> ASC/DESC)

--FILTERED INDEX
--NON CLUSTERED INDEX WITH WHERE CLAUSE IS FILTERED INDEX

CREATE NONCLUSTERED INDEX <index_name>
ON <table_name> (<columns1>,<columns2>)
WHERE <criteria>;
GO

-- UNIQUE INDEX 

/* UNIQUE CLUSTERED INDEX - When you create a PRIMARY KEY constraint, a unique clustered index on the column or columns is automatically created if a clustered index on the table does not already exist and you do not specify a unique nonclustered index. 
 The primary key column cannot allow NULL values. */

/* UNIQUE NON CLUSTERED INDEX / UNIQUE FILTERED INDEX - WHEN YOU DO NOT WANT TO HAVE PK BUT WANT TO HAVE UNIQUE VALUES IN A COLUMN + ALLOW NULL VALUES (NOT ALLOWED IN PK), SUCH INDEXES ARE CALLED UNIQUE NON CLUSTERED INDEX OR UNIQUE FILTERED INDEX.
For example, if we want to make sure that all customers use a unique email address if they have one, but still allow the Email column to be NULL, we can use a UNIQUE filtered index. 

SYNTAX:*/

CREATE UNIQUE NONCLUSTERED INDEX <index_name>
ON <table_name>(EMAIL)
WHERE EMAIL IS NOT NULL
GO

-- NON CLUSTERED INDEX WITH INCLUDE CLAUSE
-- THESE ARE BASICALLY FILTERED INDEX (NON CLUSTERED INDEX) + INCLUDE CLAUSE
-- SYNTAX:

CREATE NONCLUSTERED INDEX <index_name>
ON <DB NAME>.<TABLE NAME>(column1)
INCLUDE (column2)
WHERE (column1) (some condition >,<,=,!=,!<,!>)



-- CLUSTERED INDEX

-- CREATE

CREATE CLUSTERED INDEX <index_name>
ON <table_name>(<column_name> ASC/DESC)

-- NOTE : THERE CAN BE ONLY ONE CLUSTERED INDEX IN A TABLE

-- GET INDEX SIZE

EXECUTE sp_spaceused '<DB NAME>.<TABLE NAME>'

--DROP CONSTRAIN

ALTER TABLE <table_name>
DROP CONSTRAINT <index_name>
GO

-- DISABLE INDEX

ALTER INDEX <index_name> ON <table_name>
DISABLE

--REBUILD INDEX

ALTER INDEX <index_name> ON <table_name> 
REBUILD

-- ADD INDEX AFTER TABLE IS CREATED

ALTER TABLE <table_name> 
ADD INDEX <index_name> (<columns1>,<columns2>)


-- MODIFYING AN ALREADY CREATED INDEX:

ALTER INDEX <index_name> ON
    <table_name>
SET (
    STATISTICS_NORECOMPUTE = ON,
    IGNORE_DUP_KEY = ON,
    ALLOW_PAGE_LOCKS = ON
    )


-- SPARSE COLUMNS (OPTIMISATION OF NULL VALUES)
-- https://www.youtube.com/watch?v=0pR9ofa7VY8
-- https://www.sqlshack.com/optimize-null-values-storage-consumption-using-sql-server-sparse-columns/


-- ADVANCED TOPICS (IGNORE FOR NOW)
-- XML INDEX
-- SPATIAL INDEX
-- COLUMNSTORE INDEX
-- https://www.red-gate.com/simple-talk/sql/database-administration/getting-started-with-xml-indexes/
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-index-transact-sql?view=sql-server-ver15 

-- GOOD LINK:
-- https://www.red-gate.com/simple-talk/sql/performance/introduction-to-sql-server-filtered-indexes/

-- NOTE : DO NOT OVERDO INDEXES BACUSE OF PAGE SPLIT (8KB) 