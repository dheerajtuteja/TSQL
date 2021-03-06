-- SOURCE : 
-- https://www.youtube.com/watch?v=GHc9OhNch5E&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=25
-- https://www.youtube.com/watch?v=NV5aYqU8COU&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=34
-- B. USER DEFINED FUNCTION

/* 

-- US�R DEFINED FUNCTION ALSO CALLED STORED FUNCTIONS IN TSQL
-- TYPES:

A.) SCALAR VALUED FUNCTIONS - FUNCTIONS WILL RETURN A SINGLE VALUE OR A SINGLE COLUMN VALUE

B.) TABLE VALUED FUNCTIONS - FUNCTION RETURNS MORE THANK ONE VALUE OR MORE THAN ONE COLUMN VALUE

		1.) INLINE TABLE-VALUED FUNCTIONS
		2.) MULTI-STATEMENT TABLE-VALUED FUNCTIONS 


*/


--A.) SCALAR VALUED FUNCTIONS - FUNCTIONS WILL RETURN A SINGLE VALUE OR A SINGLE COLUMN VALUE
--SYNTAX:
/*
CREATE (OR ALTER) FUNCTION <FUNCTION NAME> (@PARAMETER1<DATATYPE>[SIZE],@PARAMETER2<DATATYPE>[SIZE],....)
RETURNS < RETURNS PARAMETER / ATTRIBUTE / VARIABLE DATATYPE>
AS
BEGIN
<FUNCTION BODY/ STATEMENTS>
RETURNS < RETURNS PARAMETER / ATTRIBUTE / VARIABLE DATATYPE>
END

-- HOW TO CALL SCALAR VALUED FUNCTION:

SELECT <SCHEMA>.<FUNCTION NAME> (VALUE, VALUES)
*/

-- SCALAR FUNCTION EXAMPLE TO EXTRACT FIRST NAME OF THE ACTORS

CREATE FUNCTION fnFirstName
(@FullName AS VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN

--Code goes here!

DECLARE @SpacePosition AS INT
DECLARE @Answer AS VARCHAR(MAX)
SET @SpacePosition = CHARINDEX(' ',@FullName)
 
IF @SpacePosition = 0
	SET @Answer = @FullName
ELSE
	SET @Answer = LEFT(@FullName,@SpacePosition - 1)

RETURN @Answer

END


-- CALLING SCALAR FUNCTION
SELECT 
	[ActorName],
	DBO.fnFirstName([ActorName]) AS SCALAR_RESULT
FROM [dbo].[tblActor]
ORDER BY [ActorName] ASC

--https://www.wiseowl.co.uk/blog/s344/complex-udfs.htm


/* B.) TABLE VALUED FUNCTIONS - FUNCTION RETURNS MORE THANK ONE VALUE OR MORE THAN ONE COLUMN VALUE


*/

-- THERE ARE TWO TYPES OF TABLE-VALUED FUNCTIONS (OR TVFS) IN SQL: 
-- IN-LINE TABLE-VALUED FUNCTIONS, AND MULTI-STATEMENT TABLE-VALUED FUNCTIONS. 

-- 1.) IN-LINE TABLE-VALUED FUNCTIONS
/*
--SYNTAX:
CREATE (OR ALTER) FUNCTION <FUNCTION NAME> (@PARAMETER1<DATATYPE>[SIZE],@PARAMETER2<DATATYPE>[SIZE],....)
RETURNS TABLE
AS
RETURN (SELECT QUERY)
END
*/
-- CALLING IN-LINE TABLE FUNCTOION
SELECT * FROM <FUNCTION NAME> (VALUE, VALUES);
-- EXAMPLE :

CREATE FUNCTION FNFILMSBYDURATION(@DURATION INT)
RETURNS TABLE
AS
-- FUNCTION TO RETURN ALL FILMS LASTING
-- MORE THAN N MINUTES
RETURN
SELECT
	FILMID,
	FILMNAME,
	FILMRUNTIMEMINUTES
FROM
	TBLFILM
WHERE
	FILMRUNTIMEMINUTES >= @DURATION

-- CALLING TABLE VALUED FUNCTION

SELECT * FROM DBO.FNFILMSBYDURATION(100)
ORDER BY FILMRUNTIMEMINUTES ASC

-- https://www.wiseowl.co.uk/blog/s347/in-line.htm

/*
--2.) MULTI-STATEMENT TABLE-VALUED FUNCTIONS
A  multi-statement table-valued function (which I wall call from now on the equally unmemorable MSTVF) is a function which returns a table of data, 
but only after some additional processing.

SYNTAX MULTI-STATEMENT TABLE-VALUED FUNCTIONS:

CREATE FUNCTION fnName(
-- can have 0, 1, 2 or more parameters
@param1 datatype,
@param2 datatype, ...
)

-- define table to return
RETURNS @TableName TABLE (
Column1 datatype,
Column2 datatype,
...
Columnn datatype,
)
AS
BEGIN
-- typically insert rows into this table
-- eventually, return the results
RETURN

END

*/

-- EXAMPLE:
CREATE FUNCTION FNPEOPLEBORNYEAR(@BIRTHYEAR INT)

RETURNS @PEOPLE TABLE 
	(PERSONNAME VARCHAR(50),
	PERSONROLE VARCHAR(50),
	DOB DATETIME)
AS
-- ALL CODE LIES IN A BEGIN / END BLOCK
BEGIN
-- INSERT THE ACTORS BORN IN THIS YEAR INTO TABLE
INSERT INTO @PEOPLE 
	(PERSONNAME,
	PERSONROLE,
	DOB)
SELECT
	ACTORNAME,
	'ACTOR',
	ACTORDOB
FROM
TBLACTOR
WHERE
YEAR(ACTORDOB) = @BIRTHYEAR

-- NOW ADD THE DIRECTORS BORN IN THIS YEAR
INSERT INTO @PEOPLE 
	(PERSONNAME,
	PERSONROLE,
	DOB)
SELECT
	DIRECTORNAME,
	'DIRECTOR',
	DIRECTORDOB
FROM
	TBLDIRECTOR
WHERE
	YEAR(DIRECTORDOB) = @BIRTHYEAR

-- RETURN THE RESULTS
RETURN
END

-- CALLING FUNCTION

SELECT * FROM DBO.FNPEOPLEBORNYEAR(1950)

-- https://www.wiseowl.co.uk/blog/s347/multi-statement.htm-- 