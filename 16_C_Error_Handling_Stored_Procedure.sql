-- ERROR HANDLING WITH STORED PROCEDURE

--Guidelines to create a stored procedure

Use movies
go
 
create PROCEDURE usp_UpdateSales
  --@Param1 INT = 0,
  --@Param2 varchar(100)
AS
BEGIN
  BEGIN TRY
    --Truncate Table TableName (Command Not in transaction)
	    BEGIN TRANSACTION;
	    --You can write your business Logic Here
        --insert T-SQL commands
		--update T-SQL commands
		--insert T-SQL commands
		COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION;
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorLine INT = ERROR_LINE();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    DECLARE @ProcedureName VARCHAR(400) = ERROR_PROCEDURE ( );
	 --  insert into ERRORLOGTable values  --Logging the errors 
	 --(@ErrorNumber,@ErrorLine,@ErrorMessage,@ErrorSeverity,@ErrorState,@ProcedureName,getdate()) 
	 --EXEC msdb.dbo.sp_send_dbmail  
	 --RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState); 
	 --Throw (Since SQL Server 2012) 
  END CATCH
END;


-- RAISERROR(Message,State,Severity)
raiserror('Error Message',16,1) 

go 

Use movies
go

declare @databaseid int =DB_ID()
declare @databaseName sysname = db_name()
raiserror ('Current Database ID:%d,database name : %s.',16,1,@databaseid,@databaseName)

--Adding Customized Messages

USE movies;
GO

EXEC sp_addmessage 
    @msgnum = 50001, 
    @severity = 16,
    @msgtext = 
        N'This is a test message with one numeric
        parameter (%d), one string parameter (%s), 
        and another string parameter (%s).',
    @lang = 'us_english'
	--,@replace='replace'
	--,@with_log=false;


EXEC sp_addmessage 
    @msgnum = 50001, 
    @severity = 16,
    @msgtext = 
        -- In the localized version of the message,
        -- the parameter order has changed. The 
        -- string parameters are first and second
        -- place in the message, and the numeric 
        -- parameter is third place.
        N'Dies ist eine Testmeldung mit einem 
        Zeichenfolgenparameter (%3!),
        einem weiteren Zeichenfolgenparameter (%2!), 
        und einem numerischen Parameter (%1!).',
    @lang = 'German';
GO  



select * from sys.messages

-- Changing the session language to use the U.S. English
-- version of the error message.
SET LANGUAGE us_english;
GO

RAISERROR(50001,16,16,15,'param1','param2') -- error, severity, state,
GO                                       -- parameters.

-- Changing the session language to use the German
-- version of the error message.
SET LANGUAGE German;
GO

RAISERROR(50001,16,16,15,'param1','param2') -- error, severity, state, 
GO



-- THROW VS RAISE ERROR

--Microsoft is suggesting to start using THROW statement instead of RAISERROR in New Applications.

-- Re-throw the original exception that invoked the CATCH block
use movies
go

BEGIN TRY
  DECLARE @result INT
--Generate divide-by-zero error
  SET @result = 55/0
END TRY
BEGIN CATCH
    --THROW
END CATCH

go

Throw   --Error
go

THROW 60000, 'Test User Defined Message', 1
go   --Proper Syntax

--It always generates new exception and results in the loss of the original exception details

BEGIN TRY
  DECLARE @result INT
--Generate divide-by-zero error
  SET @result = 55/0
END TRY
BEGIN CATCH
--Get the details of the error
--that invoked the CATCH block
 DECLARE
   @ErMessage NVARCHAR(2048),
   @ErSeverity INT,
   @ErState INT
 
 SELECT
   @ErMessage = ERROR_MESSAGE(),
   @ErSeverity = ERROR_SEVERITY(),
   @ErState = ERROR_STATE()
 
 RAISERROR (@ErMessage,
             @ErSeverity,
             @ErState )
END CATCH

go


--Doesn't cause the statement batch to be ended

BEGIN
 PRINT 'BEFORE RAISERROR'
 RAISERROR('RAISERROR TEST',16,1)
 PRINT 'AFTER RAISERROR'
END

go


--Causes the statement batch to be ended

 BEGIN TRY
  DECLARE @RESULT INT = 55/0    
END TRY
BEGIN CATCH
  PRINT 'BEFORE THROW';
  THROW;
  PRINT 'AFTER THROW'
END CATCH
  PRINT 'AFTER CATCH'

  go


  --RAISERROR -  The severity parameter specifies the severity of the exception.
  --THROW -  There is no severity parameter. The exception severity is always set to 16.

  -- THROW--- Requires preceding statement to end with semicolon (;) statement terminator


--RASIERROR CAN RAISE SYSTEM ERROR MESSAGE

RAISERROR (40655,16,1)
go

THROW 40655, 'Database master cannot be restored.', 1
go

--CAN'T RAISE user-defined message with message_id greater than and equal to 50000 which is not defined in SYS.MESSAGES table

RAISERROR (60000, 16, 1)
go

--CAN RAISE user-defined message with message_id greater than and equal to 50000 which is not defined in SYS.MESSAGES table

THROW 60000, 'Test User Defined Message', 1
go

--Now I AM ADDING the Message to SYS.MESSAGES Table

EXEC sys.sp_addmessage 60000, 16, 'Test User Defined Message'
GO

RAISERROR (60000, 16, 1)
go
--RAISERROR Allows substitution parameters in the message parameter

RAISERROR (50001, 16, 1, 1,'Param1', 'Param2')  --50001 created in previous demonstration
go

--THROW DOESN'T Allow substitution parameters in the message parameter

THROW 70000, 'Message with Parameter 1: %d and Parameter 2:%s', 1, 505,'Basavaraj'
go

THROW 58000,'String1' + 'String2',1
go

DECLARE @message VARCHAR(2048)
SET @message = 'String1 ' + 'String2';
THROW 58000, @message, 1
go


select * from sys.messages

-- ERROR HANDLING EXERCISE
/*
You need to create ErrorLogTable which has the following structure
ErrorID is an Identity column and Primary Key in the ErrorLogTable,
ErrorDateandTime has a default constraint value which is getdate()in the ErrorLogTable.
You are required to create a stored procedure named usp_Dividebyzeroerror which will have TRY…CATCH block and you need to generate Divide By Zero Exception in the TRY block and then you need to insert the error information in the ErrorLogTable inside the CATCH block and after this you need to reraise the error
*/


Create table ErrorLogTable 
(
    ErrorID int primary key identity,
    ErrorNumber int,
	ErrorMessage varchar(3000),
	ErrorSeverity tinyint,
	ErrorState int,
	ErrorLineNumber int,
	ErrorProcedure varchar(200),
	ErrorDateandTime datetime default getdate()
)

go

--Create Procedure
CREATE PROCEDURE usp_Dividebyzeroerror 
 AS
 BEGIN TRY
SELECT 1/0
END TRY
BEGIN CATCH
INSERT INTO ERRORLOGTABLE 
(ERRORNUMBER,ERRORMESSAGE,ERRORSEVERITY,ERRORSTATE,ERRORLINENUMBER,ERRORPROCEDURE) 
SELECT ERROR_NUMBER() ,ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_LINE(),NULLIF(ERROR_PROCEDURE(), 'NOT INSIDE PROCEDURE')     
;THROW                      
END CATCH

GO

EXEC usp_DividebyZeroError

SELECT * FROM ErrorLogTable




