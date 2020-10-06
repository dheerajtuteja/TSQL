--Pagination in SQL Server
-- CTRL + SHIFT + U --> UPPER CASE
-- CTRL + SHIFT + L --> LOWER CASE

USE MOVIES
GO
--The following command will drop the dbo.Employee table if it exists

IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL 
  DROP TABLE dbo.Employee; 

CREATE TABLE EMPLOYEE
(
ID INT,
NAME VARCHAR(20)
)

GO

 
 --Inerting the data into employee table
DECLARE @I INT
SET @I=1
WHILE (@I<=100)
BEGIN
INSERT INTO EMPLOYEE VALUES (@I,'NAME '+CONVERT(VARCHAR(3),@I))
SET @I=@I+1
END
 

 go


select * from EMPLOYEE
go


SELECT * FROM EMPLOYEE
ORDER BY ID
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;  --or OFFSET 10 ROWS FETCH FIRST 5 ROWS ONLY; (Same thing)

go

--VARIABLES CAN BE USED INSIDE OFFSET

DECLARE @I INT =5
DECLARE @J INT =10
SELECT * FROM EMPLOYEE
ORDER BY ID
OFFSET @I ROWS FETCH NEXT @J ROWS ONLY

GO

--Using Stored Procedure


create proc usp_Paging
@i int,
@j int
as
begin try
SELECT * FROM EMPLOYEE
ORDER BY ID
OFFSET @i ROWS FETCH NEXT @j ROWS ONLY
end try
begin catch
--Write your logging code here
end catch

go
--Executing Stored Procedure

exec usp_Paging 4,6