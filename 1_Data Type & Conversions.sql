-- DATA TYPES IN SQL - Data Types defines the attribute of the data
-- Udemy: https://www.udemy.com/course/ssrs-t-sql-online-video-training/
-- Read theory about data types - https://www.sqlservertutorial.net/sql-server-basics/sql-server-data-types/
 

USE Movies
GO

CREATE TABLE DecimalDemo (
Salary Decimal (6,2) -- 6 Maximum number of digits INCLUDING Decimal / 2 is decimal places
,Credited Bit --Bit stores 0,1,NULL
)

Insert into DecimalDemo values (200.00,1)
Insert into DecimalDemo values (260.00,1)
Insert into DecimalDemo values (2234.00,0)
Insert into DecimalDemo values (2874.00,Null)
Insert into DecimalDemo values (287488.00,Null) --Observer error

Select * From DecimalDemo

-- Avoid SMALL MONEY & MONEY Datatypes - USE DECIMAL Instead.
-- REAL & FLOAT are called APPROXIMATE Data types and are used to store fractional data.
-- Use REAL or FLOAT for scietific data values such as PI, Gravity etc.
-- But normally in development, avoid REAL/FLOAT. Use DECIMAL instead.

/* DIFFERENCE BETWEEN CHAR & VARCHAR

CHAR(SIZE)					VARCHAR(SIZE) / VARCHAR(MAX)

1 Character will take 1 Byte (IN BOTH)
CHAR(10) will use 10 Bytes abd size is fixed and cannot go beyond 10 bytes)	
Static Data type
CHAR(10)='Hello' means 5 bytes will be wasted 

VARCHAR(10) = 'Hello' means:
5 bytes will be used 
5 bytes will be free
2 Bytes always used fo internal processing

CHAR(10)='Australia' will use 10 bytes.
VARCHAR(10) ='Australia' will use 9 bytes + 2 Bytes Internal = 11 Bytes 

Example: For a Blood Group column in a database, Char(3) is more memmory efficient.
Because if we use VarChar(3) --> 2 additional bytes required for internal processing.  

For Name or Address, where length of characater is unpredictable, use VARCHAR.
VARCHAR frees up the space after required input is done.


NCHAR vs NVARCHAR (Used for NON ENGLISH language)
N - means UNICODE data
It can store data in all languages in the world
Char & Varchar doesnt support - æ,ø,å etc.
In NCHAR vs NVARCHAR, 1 Character will take 2 Byte

*/

CREATE TABLE [dbo].[UnicodeDemo](
	[Greetings1] [CHAR](10),
	[[Greetings2] [NCHAR](10) 
) 

insert into [dbo].[UnicodeDemo] values 
('Hello',N'Hello') --N denotes Unicode
,('Hello',N'Hej')
,('नमस्ते',N'नमस्ते')

Select * from [dbo].[UnicodeDemo] --Observe ???

/* DATE DATATYPE

DATE - '2020-06-15'
TIME - '10:45:1234567' - 7 DIGIT MICRO SECONDS
	 -	TIME (3) - '10:45:123' - 3 DIGIT MICRO SECONDS
DATETIME - '2020-06-15 10:45:123' - 3 DIGIT MICRO SECONDS
DATETIME2 - '2020-06-15 10:45:1234567' - 7 DIGIT MICRO SECONDS
DATETIMEOFFSET - It can store GMT values

Always prefer DATETIME2 or DATETIMEOFFSET (New Data Types)

You machine time can be fetched by - getdate()
*/

Select getdate()

CREATE TABLE [dbo].[DateDemo](
	[id] [int]  ,
	[datecol] [datetime]  
) 

Insert into [DateDemo] values(1,getdate())
Select * from [DateDemo]

CREATE TABLE [dbo].[DateDemo_New]
(
	[id] [int]  ,
	[datecol] [datetime2]  
) 

Insert Into DateDemo_New Values(1,getdate())

Select * From DateDemo_New

Declare @MyVar datetimeoffset
SET @MyVar='2019-02-02 21:49:09.1333333 +05:30'
print @MyVar

Declare @MyVar1 datetime2 -- It will ignore Time Zone value
SET @MyVar1='2019-02-02 21:49:09.1333333 +05:30'
print @MyVar1

Declare @MyVar2 datetime -- It will give error
SET @MyVar2='2019-02-02 21:49:09.1333333 +05:30'
print @MyVar2

-- DATA TYPE CONVERSION
/*
Conversion of Data type from one type to another is called Type Casting

Types:
1.) Implicit - That happens on its own (Automatic)

2.) Explicit - With the help of the function. This process is called TYPE CASTING.
	Two functions - CAST & CONVERT

*/

--Implicit Conversion

declare @num tinyint --1 BYTE
set @num=25
declare @num1 smallint --2 BYTE
set @num1=@num -- BIGGER DATA TYPE CAN HOLD SMALLER DATA TYPE. IMPLICIT CONVERSION
Print @num1

declare @num2 smallint --2 BYTE
set @num2=25
declare @num3 tinyint --1 BYTE - CAN STORE 0 TO 255
set @num3=@num2 -- SMALLER DATA TYPE CANNOT HOLD SMALLER DATA TYPE. 
Print @num3 --IMPLICIT CONVERSION DIDN'T FAILED BECAUSE @num2 IS LESS THAN 256

declare @num4 smallint --2 BYTE
set @num4=256 -- EXCEEDS TINYINT CAPACITY
declare @num5 tinyint --1 BYTE - CAN STORE 0 TO 255
set @num5=@num4 -- SMALLER DATA TYPE CANNOT HOLD SMALLER DATA TYPE. IMPLICIT CONVERSION FAILED
Print @num5 --IMPLICIT CONVERSION FAILED "Arithmetic overflow error"

-- EXPLICIT CONVERSION
--Cast in ANSI standard Convert is used in SqlServer for explicit conversion
-- Data type precedence - https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-type-precedence-transact-sql?view=sql-server-ver15

--Precedence order of int is greater than varchar
--Sql Server is trying to convert overall expression to integer

declare @myvariable1 varchar(15)
set @myvariable1='12'
declare @myvariable2 int
set @myvariable2=2
Print (@myvariable1 + @myvariable2) --Implicit Conversion

declare @val varchar(15)
set @val='Page Number '
declare @num7 varchar(15)
set @num7='Two'
Print (@val + @num7) -- + used to concatenate the text  


declare @val9 varchar(15)
set @val9='Page Number '
declare @num9 int
set @num9=2
Print (@val9 + @num9) --Overall expression will be converted to int type because of preference
-- Integer has more prference over string
-- Error occured because by design @val9 + @num9 will be converted to INT (NOT STRING)


declare @val1 varchar(15)
set @val1='Page Number '
declare @num8 int
set @num8=2
Print(@val1 + convert(varchar,@num8)) --Now + will act as concatenate

declare @val11 varchar(15)
set @val11='Page Number '
declare @num80 int
set @num80=2
Print(@val11 + cast(@num80 as varchar)) --Now + will act as concatenate



declare @val5 varchar(10)
set @val5='12'
declare @num6 tinyint
set @num6=CAST(@val5 as int) * 10
print @num6


declare @val32 varchar(10)
set @val32='12'
declare @num60 tinyint
set @num60=CONVERT(int, @val32) * 10
Print @num60



/* CAST VS CONVERT

CAST IS AS PER ISO STANDARD.
Meaning this function is available in other tools like Oracle etc.

CONVERT IS DESIGNED BY MS FOR SQL SERVER

CONVERT IS MORE POWERFUL FUNCTION THAN CAST


*/

select getdate()
select convert(varchar(20),getdate(),103) --103 IS STYLING OPTION
select cast(getdate() as varchar(20)) --NO STYLING OPTIONS

-- CAST & CONVERT - https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15
