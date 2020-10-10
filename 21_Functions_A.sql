-- TYPE OF FUNCTION IS SQL:


-- A. SYSTEM DEFINED FUNCTION 

/*		1.) AGGREGATE
		2.) CONVERSION
		3.) DATE
		4.) NUMERIC
		5.) CHARACTER / TEXT / STRING FUNCTIONS */

/* 

-- B.) USÉR DEFINED FUNCTION ALSO CALLED STORED FUNCTIONS IN TSQL
-- TYPES:

1.) SCALAR VALUED FUNCTIONS

2.) TABLE VALUED FUNCTIONS 

		a.) INLINE TABLE-VALUED FUNCTIONS
		b.) MULTI-STATEMENT TABLE-VALUED FUNCTIONS 


-- C. WINDOWS (& OVER CLAUSE) --> SYSTEM DEFINED FUNCTION WITH 'OVER BY' CLAUSE ARE CALLED WINDOWS FUNCTION.
				  THESE FUNCTIONS ARE SUSED AS COLUMNS WITH SELECT COMMAND.
				  EXAMPLE: SELECT COL1, COL2, SYSTEM DEFINED FUNCTION 'OVER'(CONDITION COL3) FROM TABLE */
USE MOVIES
GO


-- A. SYSTEM DEFINED FUNCTION


--  AGGREGATE FUNCTIONS

-- TYPES:
-- A.) Convenient Aggregate Functions
-- B.) Statistical Aggregate Functions
-- C.) Other Aggregate Functions


-- A.) Convenient Aggregate Functions

SELECT
	SUM([FilmRunTimeMinutes]) AS SUM_RunTime
	,AVG([FilmRunTimeMinutes]) AS AVG_RunTime
	,MAX([FilmRunTimeMinutes]) AS MAX_RunTime
	,MIN([FilmRunTimeMinutes]) AS MIN_RunTime
	,COUNT(*) AS COUNT_RunTime
FROM
	[dbo].[tblFilm]

-- AVG, SUM, STDEV, STDEVP, VAR and VARP functions cannot operate on BIT data types.
-- They can operate on all other numeric data types.

-- B.) Statistical Aggregate Functions
-- https://blog.sqlauthority.com/2008/01/20/sql-server-introduction-to-statistical-functions-var-stdevp-stdev-varp/

SELECT 
	VAR([FilmRunTimeMinutes]) 'Variance',
	STDEVP([FilmRunTimeMinutes]) 'Standard Deviation',
	STDEV([FilmRunTimeMinutes]) 'Standard Deviation',
	VARP([FilmRunTimeMinutes]) 'Variance for the Population'
FROM [dbo].[tblFilm]
GO

-- All the functions returns result as datatype float. 
-- VAR and VARP can only be applied to numeric well all other can be applied to all numeric data type except INT datatypes.

-- VAR VS VARP
-- In SQL Server, VAR and VARP calculate the VARIANCE of a dataset. VAR is a common mathematical function that measures the variance of a sample data set.
-- VARP measures the variance against a population. This function is used when you’re working with the entire data set, rather than just a sample set.


-- C.) Other Aggregate Functions

-- APPROX_COUNT_DISTINCT
SELECT COUNT (DISTINCT [FilmDirectorID]) FROM [dbo].[tblFilm]

-- CHECKSUM_AGG
SELECT 
	CHECKSUM_AGG( CAST([FilmDirectorID] AS INT)) AS [DIRECTOR]
FROM [dbo].[tblFilm]

-- CHECKSUM_AGG WITH DISTINCT
SELECT 
	CHECKSUM_AGG(DISTINCT CAST([FilmDirectorID] AS INT)) AS [DIRECTOR]
FROM [dbo].[tblFilm]

/*
-- COUNT_BIG

In SQL Server, the COUNT_BIG() function and the COUNT() do essentially the same thing: return the number of items found in a group. Basically, you can use these functions to find out how many rows are in a table or result set.
In many cases, you’ll be able to choose whichever one you prefer. However, there’s a difference between these two functions that might dictate that you to use one over the other.
The difference is that COUNT() returns its result as an int, whereas COUNT_BIG() returns its result as a bigint.
In other words, you’ll need to use COUNT_BIG() if you expect its results to be larger than 2,147,483,647 (i.e. if the query returns more than 2,147,483,647 rows).
https://database.guide/count-vs-count_big-in-sql-server-whats-the-difference/
*/

/*
-- GROUPING & GROUPING_ID
-- https://codingsight.com/understanding-grouping-and-grouping_id-functions-in-sql-server/
*/


-- STRING_AGG
-- The STRING_AGG() is an aggregate function that concatenates rows of strings into a single string, separated by a specified separator. 
-- It does not add the separator at the end of the result string.
-- https://www.sqlservertutorial.net/sql-server-string-functions/sql-server-string_agg-function/

SELECT
    STRING_AGG([FilmName],' - IS THE BEST MOVIE NAME') AS NAME
FROM
    [dbo].[tblFilm]
GROUP BY
    [FilmDirectorID];


-- SUPER AGGREGATE FUNCTIONS (ROLL UP & CUBE)

-- ROLL UP

-- Example 1

SELECT
	[FilmCountryID] AS CountryID --THIS HAS TO GO IN GROUP BY
	,SUM([FilmRunTimeMinutes]) AS SUM_RunTime
	,AVG([FilmRunTimeMinutes]) AS AVG_RunTime
	,MAX([FilmRunTimeMinutes]) AS MAX_RunTime
	,MIN([FilmRunTimeMinutes]) AS MIN_RunTime
	,COUNT(*) AS COUNT_RunTime
FROM
	[dbo].[tblFilm]
GROUP BY 
	[FilmCountryID] WITH ROLLUP


-- Example 2

SELECT
    [FilmCountryID]
    ,COUNT(*)
FROM
    [dbo].[tblFilm]
GROUP BY
    [FilmCountryID] WITH ROLLUP


-- CUBE

SELECT
    [FilmCountryID],
	[FilmLanguageID],
    COUNT(*)
FROM
    [dbo].[tblFilm]
GROUP BY CUBE
    ([FilmCountryID],
	[FilmLanguageID])


-- CONVERSION FUNCTIONS

-- CONVERT & CAST

DECLARE @VAL9 VARCHAR(15)
SET @VAL9='PAGE NUMBER '
DECLARE @NUM9 INT
SET @NUM9=2
PRINT (@VAL9 + @NUM9) 
-- OBSERVE THE ERROR
--Overall expression will be converted to int type because of preference
-- Integer has more prference over string
-- Error occured because by design @val9 + @num9 will be converted to INT (NOT STRING)

-- CONVERT

DECLARE @VAL1 VARCHAR(15)
SET @VAL1='PAGE NUMBER '
DECLARE @NUM8 INT
SET @NUM8=2
PRINT(@VAL1 + CONVERT(VARCHAR,@NUM8)) --NOW + WILL ACT AS CONCATENATE

-- CAST

DECLARE @VAL11 VARCHAR(15)
SET @VAL11='PAGE NUMBER '
DECLARE @NUM80 INT
SET @NUM80=2
PRINT(@VAL11 + CAST(@NUM80 AS VARCHAR)) --NOW + WILL ACT AS CONCATENATE


-- OVER CLAUSE


-- RANKING FUNCTIONS

-- ROW_NUMBER()

-- RANK()

-- DENSE_RANK()

-- NTILE()



-- DATE FUNCTIONS
-- https://www.mssqltips.com/sqlservertip/5993/sql-server-date-and-time-functions-with-examples/

-- HIGHER PRECISION FUNCTIONS 
SELECT SYSDATETIME()       AS 'DATEANDTIME';        -- RETURN DATETIME2(7)       
SELECT SYSDATETIMEOFFSET() AS 'DATEANDTIME+OFFSET'; -- DATETIMEOFFSET(7)
SELECT SYSUTCDATETIME()    AS 'DATEANDTIMEINUTC';   -- RETURNS DATETIME2(7)

/*
SYSDATETIME – returns the date and time of the machine the SQL Server is running on
SYSDATETIMEOFFSET – returns the date and time of the machine the SQL Server is running on plus the offset from UTC
SYSUTCDATETIME - returns the date and time of the machine the SQL Server is running on as UTC
*/

-- LESSER PRECISION FUNCTIONS - RETURNS DATETIME
SELECT CURRENT_TIMESTAMP AS 'DATEANDTIME'; -- NOTE: NO PARENTHESES   
SELECT GETDATE()         AS 'DATEANDTIME';    
SELECT GETUTCDATE()      AS 'DATEANDTIMEUTC'; 

/*
CURRENT_TIMESTAMP - returns the date and time of the machine the SQL Server is running on
GETDATE() - returns the date and time of the machine the SQL Server is running on
GETUTCDATE() - returns the date and time of the machine the SQL Server is running on as UTC
*/


-- DATENAME – returns a string corresponding to the datepart specified

-- DATE AND TIME PARTS - RETURNS NVARCHAR 
SELECT DATENAME(YEAR, GETDATE())        AS 'YEAR';        
SELECT DATENAME(QUARTER, GETDATE())     AS 'QUARTER';     
SELECT DATENAME(MONTH, GETDATE())       AS 'MONTH';       
SELECT DATENAME(DAYOFYEAR, GETDATE())   AS 'DAYOFYEAR';   
SELECT DATENAME(DAY, GETDATE())         AS 'DAY';         
SELECT DATENAME(WEEK, GETDATE())        AS 'WEEK';        
SELECT DATENAME(WEEKDAY, GETDATE())     AS 'WEEKDAY';     
SELECT DATENAME(HOUR, GETDATE())        AS 'HOUR';        
SELECT DATENAME(MINUTE, GETDATE())      AS 'MINUTE';      
SELECT DATENAME(SECOND, GETDATE())      AS 'SECOND';      
SELECT DATENAME(MILLISECOND, GETDATE()) AS 'MILLISECOND'; 
SELECT DATENAME(MICROSECOND, GETDATE()) AS 'MICROSECOND'; 
SELECT DATENAME(NANOSECOND, GETDATE())  AS 'NANOSECOND';  
SELECT DATENAME(ISO_WEEK, GETDATE())    AS 'WEEK'; 




-- DATEPART -- returns an integer corresponding to the datepart specified

-- DATE AND TIME PARTS - RETURNS INT
SELECT DATEPART(YEAR, GETDATE())        AS 'YEAR';        
SELECT DATEPART(QUARTER, GETDATE())     AS 'QUARTER';     
SELECT DATEPART(MONTH, GETDATE())       AS 'MONTH';       
SELECT DATEPART(DAYOFYEAR, GETDATE())   AS 'DAYOFYEAR';   
SELECT DATEPART(DAY, GETDATE())         AS 'DAY';         
SELECT DATEPART(WEEK, GETDATE())        AS 'WEEK';        
SELECT DATEPART(WEEKDAY, GETDATE())     AS 'WEEKDAY';     
SELECT DATEPART(HOUR, GETDATE())        AS 'HOUR';        
SELECT DATEPART(MINUTE, GETDATE())      AS 'MINUTE';      
SELECT DATEPART(SECOND, GETDATE())      AS 'SECOND';      
SELECT DATEPART(MILLISECOND, GETDATE()) AS 'MILLISECOND'; 
SELECT DATEPART(MICROSECOND, GETDATE()) AS 'MICROSECOND'; 
SELECT DATEPART(NANOSECOND, GETDATE())  AS 'NANOSECOND';  
SELECT DATEPART(ISO_WEEK, GETDATE())    AS 'WEEK'; 


/*
DAY – returns an integer corresponding to the day specified
MONTH– returns an integer corresponding to the month specified
YEAR– returns an integer corresponding to the year specified
*/

SELECT DAY(GETDATE())   AS 'DAY';                            
SELECT MONTH(GETDATE()) AS 'MONTH';                       
SELECT YEAR(GETDATE())  AS 'YEAR';

/*
DATEFROMPARTS – returns a date from the date specified
DATETIME2FROMPARTS – returns a datetime2 from part specified
DATETIMEFROMPARTS – returns a datetime from part specified
DATETIMEOFFSETFROMPARTS - returns a datetimeoffset from part specified
SMALLDATETIMEFROMPARTS - returns a smalldatetime from part specified
TIMEFROMPARTS - returns a time from part specified
*/

-- DATE AND TIME FROM PARTS
SELECT DATEFROMPARTS(2019,1,1)                         AS 'DATE';          -- RETURNS DATE
SELECT DATETIME2FROMPARTS(2019,1,1,6,0,0,0,1)          AS 'DATETIME2';     -- RETURNS DATETIME2
SELECT DATETIMEFROMPARTS(2019,1,1,6,0,0,0)             AS 'DATETIME';      -- RETURNS DATETIME
SELECT DATETIMEOFFSETFROMPARTS(2019,1,1,6,0,0,0,0,0,0) AS 'OFFSET';        -- RETURNS DATETIMEOFFSET
SELECT SMALLDATETIMEFROMPARTS(2019,1,1,6,0)            AS 'SMALLDATETIME'; -- RETURNS SMALLDATETIME
SELECT TIMEFROMPARTS(6,0,0,0,0)                        AS 'TIME';          -- RETURNS TIME


/*
SQL Server DATEDIFF and DATEDIFF_BIG Functions
DATEDIFF - returns the number of date or time datepart boundaries crossed between specified dates as an int
DATEDIFF_BIG - returns the number of date or time datepart boundaries crossed between specified dates as a bigint
*/

--DATE AND TIME DIFFERENCE
SELECT DATEDIFF(DAY, 2019-31-01, 2019-01-01)      AS 'DATEDIF'    -- RETURNS INT
SELECT DATEDIFF_BIG(DAY, 2019-31-01, 2019-01-01)  AS 'DATEDIFBIG' -- RETURNS BIGINT

/*
SQL Server DATEADD, EOMONTH, SWITCHOFFSET and TODATETIMEOFFSET Functions
DATEADD - returns datepart with added interval as a datetime
EOMONTH – returns last day of month of offset as type of start_date
SWITCHOFFSET - returns date and time offset and time zone offset
TODATETIMEOFFSET - returns date and time with time zone offset
*/

-- MODIFY DATE AND TIME
SELECT DATEADD(DAY,1,GETDATE())        AS 'DATEPLUS1';          -- RETURNS DATA TYPE OF THE DATE ARGUMENT
SELECT EOMONTH(GETDATE(),1)            AS 'LASTDAYOFNEXTMONTH'; -- RETURNS START_DATE ARGUMENT OR DATE
SELECT SWITCHOFFSET(GETDATE(), -6)     AS 'NOWMINUS6';          -- RETURNS DATETIMEOFFSET
SELECT TODATETIMEOFFSET(GETDATE(), -2) AS 'OFFSET';             -- RETURNS DATETIMEOFFSET


/*
SQL Server ISDATE Function to Validate Date and Time Values
ISDATE – returns int - Returns 1 if a valid datetime type and 0 if not
*/

-- VALIDATE DATE AND TIME - RETURNS INT
SELECT ISDATE(GETDATE()) AS 'ISDATE'; 
SELECT ISDATE(NULL) AS 'ISDATE';

-- EXAMPLES OF DATE FUNCTION

-- 1
SELECT
[FilmID] AS ID,
CONVERT(CHAR(8),[FilmReleaseDate],3) AS DATE_UK,
CONVERT(CHAR(10),[FilmReleaseDate],103) AS DATE_UK_YEAR,
DATENAME(DW,[FilmReleaseDate]) + ' '+
DATENAME(DD,[FilmReleaseDate]) + ' '+
DATENAME(MM,[FilmReleaseDate]) + ' '+
DATENAME(YY,[FilmReleaseDate]) AS CUSTOM_DATE
FROM
[dbo].tblFilm

--2
SELECT
[FilmID],
[FilmReleaseDate],
DATEDIFF(DD,[FilmReleaseDate],GETDATE()),
DATEDIFF(YY,[FilmReleaseDate],GETDATE()),
DATEADD(YY,DATEDIFF(YY,[FilmReleaseDate],GETDATE()),[FilmReleaseDate]),
CASE
	WHEN DATEADD(YY,DATEDIFF(YY,[FilmReleaseDate],GETDATE()),[FilmReleaseDate]) > 
		 GETDATE()
	THEN DATEDIFF(YY,[FilmReleaseDate],GETDATE()) - 1
	ELSE DATEDIFF(YY,[FilmReleaseDate],GETDATE()) 
END
FROM
[dbo].tblFilm


-- MATH/NUMERIC FUNCTIONS
-- https://www.w3schools.com/SQl/sql_ref_sqlserver.asp

--Return the absolute value of a number:
SELECT ABS(-243.5) AS ABSNUM;

--Return the arc cosine of a number:
SELECT ACOS(0.25);

--Return the arc sine of a number:
SELECT ASIN(0.25);

--Return the arc tan of a number:
SELECT ATAN(2.5);

--Return the arc tangent of two values:
SELECT ATN2(0.50, 1);

--AVG
SELECT
	AVG([FilmRunTimeMinutes]) AS AVG_RunTime
FROM
	[dbo].[tblFilm]

--CEILING() Function
--Return the smallest integer value that is greater than or equal to a number:
SELECT CEILING(25.75) AS CeilValue;

--FLOOR() Function
--Return the largest integer value that is equal to or less than 25.75:
SELECT FLOOR(25.75) AS FloorValue;

--COUNT
SELECT
	COUNT([FilmRunTimeMinutes]) AS AVG_RunTime
FROM
	[dbo].[tblFilm]

--COS
--Return the cosine of a number:
SELECT COS(2);

--DEGREES() Function
--Convert a radian value into degrees:
SELECT DEGREES(1.5);

--EXP() Function
--Return e raised to the power of 1:
SELECT EXP(1);

--LOG() Function
--Return the natural logarithm of 2:
SELECT LOG(2);

--LOG10() Function
--Return the base-10 logarithm of 2:
SELECT LOG10(2);

--PI() Function
SELECT PI();

--POWER() Function
SELECT POWER(4, 2);

--RADIANS() Function
--Convert a degree value into radians:
SELECT RADIANS(180);

--RAND() Function
--Return a random decimal number (no seed value - so it returns a completely random number >= 0 and <1):
SELECT RAND();

--ROUND() Function
--Round the number to 2 decimal places:
SELECT ROUND(235.415, 2) AS RoundValue;

--SIGN() Function
--Return the sign of a number:
SELECT SIGN(255.5);

--SQRT() Function
SELECT SQRT(64);

--SQUARE() Function
SELECT SQUARE(64);


-- CHARACTER / TEXT / STRING FUNCTIONS
-- https://www.w3schools.com/SQl/sql_ref_sqlserver.asp

--ASCII() Function
--Return the ASCII value of the first character in 'DDD'
SELECT ASCII('DDD')

--CHAR() Function
--Return the character based on the number code 65:
SELECT CHAR(65) AS CodeToCharacter;

--CHARINDEX() Function
--Search for "t" in string "Customer", and return position:
SELECT CHARINDEX('t', 'Customer') AS MatchPosition;

--CONCAT() Function
--Add two strings together:
SELECT CONCAT('DHEERAJ', ' TUTEJA');
--OR
SELECT 'DHEERAJ' + ' TUTEJA'

--CONCAT_WS (WITH SEPARATOR)
--CONCAT_WS(separator, string1, string2, ...., string_n)
SELECT CONCAT_WS(', ', 'AMAR', 'AKBAR', 'ANTHONY');

--DATALENGTH()
--The DATALENGTH() function returns the number of bytes used to represent an expression.
SELECT DATALENGTH('DHEERAJ');

--DIFFERENCE() Function
/* The DIFFERENCE() function compares two SOUNDEX values, and returns an integer. 
The integer value indicates the match for the two SOUNDEX values, from 0 to 4.
0 indicates weak or no similarity between the SOUNDEX values. 
4 indicates strong similarity or identically SOUNDEX values. */

SELECT DIFFERENCE('Juice', 'Jucy');

--SOUNDEX() Function
--Evaluate the similarity of two strings, and return a four-character code:
SELECT SOUNDEX('Juice'), SOUNDEX('Jucy');

--FORMAT() Function
--FORMAT(value, format, culture)
DECLARE @d DATETIME = '12/01/2018';
SELECT FORMAT (@d, 'd', 'en-US') AS 'US English Result',
               FORMAT (@d, 'd', 'no') AS 'Norwegian Result',
               FORMAT (@d, 'd', 'zu') AS 'Zulu Result';


-- LEFT() Function
SELECT LEFT('MY TEST', 2) AS ExtractString;

-- RIGHT() Function
SELECT RIGHT('MY TEST', 4) AS ExtractString;

-- LEN() Function
SELECT LEN('DHEERAJ');

-- LOWER() Function
SELECT LOWER('DHEERAJ TUTEJA');

-- UPPER() Function
SELECT UPPER('dheeraj tuteja');

--LTRIM() Function
--Remove leading spaces from a string:
SELECT LTRIM('     DHEERAJ TUTEJA') AS LEFT_TRIMMEDSTRING;

--RTRIM() Function
--Remove leading spaces from a string:
SELECT RTRIM('DHEERAJ TUTEJA    ') AS RIGHT_TRIMMEDSTRING;

--TRIM() Function
--Remove leading spaces from a string:
SELECT TRIM('        DHEERAJ TUTEJA           ') AS TRIM_MEDSTRING;

--NCHAR() Function
--Return the Unicode character based on the number code 65:
SELECT NCHAR(65) AS NumberCodeToUnicode;

--REPLACE() Function
SELECT REPLACE('SUNNY', 'S', 'B');

--REPLICATE() Function
SELECT REPLICATE('SUNNY ', 5);

--REVERSE() Function
SELECT REVERSE('SUNNY');

--SPACE() Function
SELECT 'DHEERAJ' + SPACE(10) + 'TUTEJA'

--STR() Function
--Return a number as a string:
SELECT STR(185);

--STUFF() Function
--STUFF(string, start, length, new_string)
-- string --> Required. The string to be modified
-- start --> Required. The position in string to start to delete some characters
-- length --> Required. The number of characters to delete from string
-- new_string --> Required. The new string to insert into string at the start position
SELECT STUFF('MY NAME IS DHEERAJ', 4, 4, 'FIRST NAME');

--SUBSTRING() Function
SELECT SUBSTRING('MY NAME IS DHEERAJ', 1, 10) AS ExtractString;

-- EXAMPLES OF TEXT FUNCTIONS

--CONCATENATION
SELECT
CAST(FilmID AS varchar (3)) + '*' + CAST(FilmDirectorID AS varchar(3)) + '*' + CAST(FilmLanguageID AS varchar(3))+ '*' + CAST(FilmCountryID AS varchar(3)) + '*' + CAST(FilmStudioID AS varchar(3))
FROM
[dbo].tblFilm


--SPLIT NAME INTO FIRST NAME & LAST NAME
SELECT
LEFT(ACTORNAME,CHARINDEX(' ',ACTORNAME)-1) AS FIRST_NAME,
RIGHT(ACTORNAME,(LEN(ACTORNAME)-CHARINDEX(' ',ACTORNAME))) AS LAST_NAME,
RIGHT(ACTORNAME,(LEN(ACTORNAME)-CHARINDEX(' ',ACTORNAME))) + ', ' + LEFT(ACTORNAME,CHARINDEX(' ',ACTORNAME)-1) AS REVERSE_NAME
FROM
[dbo].[tblActor]