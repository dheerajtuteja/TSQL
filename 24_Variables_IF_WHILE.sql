-- VARIABLES:
-- https://www.guru99.com/sql-server-variable.html

DECLARE @COURSE_ID as INT, @COURSE_NAME AS VARCHAR(5)
SET @COURSE_ID = 5
SET @COURSE_NAME = 'UNIX'
PRINT @COURSE_ID
PRINT @COURSE_NAME

DECLARE @COURSE_ID as INT, @COURSE_NAME AS VARCHAR(5)
SELECT @COURSE_ID = 5, @COURSE_NAME = 'UNIX'
PRINT @COURSE_ID
PRINT @COURSE_NAME

/*
Local variable:

-A user declares the local variable.
-By default, a local variable starts with @.
-Every local variable scope has the restriction to the current batch or procedure within any given session.

Global variable:

-The system maintains the global variable. A user cannot declare them.
-The global variable starts with @@
-It stores session related information.

Variable Declaration Syntax:
DECLARE  { @LOCAL_VARIABLE[AS] data_type  [ = value ] } 
*/

-- IF STATEMENT
-- https://www.wiseowl.co.uk/blog/s340/if-else.htm

/*
SYNTAX:

-- SIGLE

-- test if a condition is true
IF (condition is true)
BEGIN
	DO ONE THING
	DO ANOTHER THING
END

-- MULTIPLE

-- test if a condition is true
IF (condition is true)
BEGIN
	DO THING A
	DO THING B
END
ELSE
BEGIN
	DO THING C
	DO THING D
	DO THING E
END
*/

-- EXAMPLE:

-- print different messages according to

-- the day of the week

IF DATEPART(WEEKDAY,GETDATE()) IN (1,7) -- SATURDAY IS 7 , SUNDAY IS 1
	PRINT 'IT''S THE WEEKEND!'
ELSE
	IF DATEPART(WEEKDAY,GETDATE()) = 6
		PRINT 'IT''S FRIDAY ...'
	ELSE
		BEGIN
			PRINT 'IT''S A WEEKDAY ...'
			PRINT 'TIME TO WORK ...'
END



-- WHILE STATEMENT
-- https://www.sqlshack.com/sql-while-loop-with-simple-examples/
-- https://www.youtube.com/watch?v=gWnhFn0ugoM&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H&index=6

-- SYNTAX:
WHILE condition
BEGIN
   {...statements...}
END


-- EXAMPLE 

DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 10)
BEGIN
    PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
    SET @Counter  = @Counter  + 1
END

-- BREAK STATEMENT

DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 10)
BEGIN
  PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
  IF @Counter >=7
	BEGIN
	BREAK
  END
    SET @Counter  = @Counter  + 1
END

-- CONTINUE STATEMENT

DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 20)
BEGIN
 
  IF @Counter % 2 =1
	BEGIN
	SET @Counter  = @Counter  + 1
	CONTINUE
  END
    
  PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
  SET @Counter  = @Counter  + 1
END