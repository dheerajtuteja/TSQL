-- BASIC CONCEPTS:
-- CHAPTER 9 & 10 : https://www.udemy.com/course/sql-server-sql/learn/lecture/
-- https://www.youtube.com/watch?v=WBmE4Utu6P4&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H&index=15
-- https://www.wiseowl.co.uk/blog/s388/dml-triggers.htm


-- TYPES OF TRIGGERS :

-- DML - INSERT / UPDATE / DELETE
-- DDL
-- LOGON

-- WE WILL FOCUS ON DML TRIGGERS FOR NOW

-- DML TRIGGERS
-- TRIGGERS CAN BE ATTACHED TO TABLES OR VIEWS
-- TYPES OF DML TRIGGERS 
		-- AFTER : An AFTER trigger will be executed immediately after the event which triggered it has run successfully.
		-- INSTEAD OF :  An INSTEAD OF trigger replaces the event which originally called the trigger.


-- AFTER TRIGGER
USE MOVIES
GO

CREATE TRIGGER trgActorsChanged
	ON tblActor
	AFTER INSERT,UPDATE,DELETE
	AS
BEGIN
	PRINT 'Something happened to tblActor'
END

-- LETS SEE THR TRIGGER IN ACTION

--Turn off row counts 
SET NOCOUNT ON 

--Add a new record into tblActor 
INSERT INTO tblactor (actorid, actorname) 
VALUES (999,'Test actor') 

--Modify the record that was added 
UPDATE tblactor 
SET    actordob = Getdate() 
WHERE  actorid = 999 

--Delete the record 
DELETE FROM tblactor 
WHERE  actorid = 999 

-- MODIFY A TRIGGER (ALTER TRIGGER)

ALTER TRIGGER trgActorsChanged
	ON tblActor
	AFTER INSERT,UPDATE,DELETE
	AS
BEGIN
	PRINT 'Data is changed in the table tblActor'
END

-- LETS SEE THR TRIGGER IN ACTION AGAIN

--Turn off row counts 
SET NOCOUNT ON 

--Add a new record into tblActor 
INSERT INTO tblactor (actorid, actorname) 
VALUES (999,'Test actor') 

--Modify the record that was added 
UPDATE tblactor 
SET    actordob = Getdate() 
WHERE  actorid = 999 

--Delete the record 
DELETE FROM tblactor 
WHERE  actorid = 999 


-- REMOVE TRIGGER
DROP TRIGGER [trgactorsinserted]
GO

-- DISABLE / ENABLE TRIGGER

--Disable a DML trigger
DISABLE TRIGGER trgActorsInserted ON tblActor
GO

--Enable a DML trigger
ENABLE TRIGGER trgActorsInserted ON tblActor
GO


--INSTEAD OF TRIGGER

CREATE TRIGGER trgactorsinserted 
ON tblactor 
INSTEAD OF INSERT 
AS 
  BEGIN 
      RAISERROR('No more actors can be added',16,1) 
  END 


  -- LETS SEE INSTEAD OF TRIGGER IN ACTION

--Turn off row counts 
SET NOCOUNT ON 

--Add a new record into tblActor 
INSERT INTO tblactor 
            (actorid, 
             actorname) 
VALUES      (999, 
             'Test actor') 

SELECT * FROM tblactor WHERE actorid = 999


-- OBSERVER ERROR:
-- Msg 50000, Level 16, State 1, Procedure trgactorsinserted, Line 6 [Batch Start Line 110]
-- No more actors can be added


-- CONCEPT INSERT/UPDATE TABLE

CREATE TRIGGER trgactorsinserted 
ON tblactor 
AFTER INSERT 
AS 
	BEGIN 
      SELECT * FROM   inserted 
END 

-- LETS SEE THIS IN ACTION

INSERT INTO tblactor 
            (actorid, 
             actorname) 
VALUES      (999, 
             'Test actor') 
--OBSERVE THE RESULT


-- USING INSERTED TABLE FOR VALIDATION

-- DATA PREPARATION

ALTER TABLE [dbo].[tblActor]
ADD ActorDateOfDeath DATETIME;

SELECT * FROM [dbo].[tblActor] 

UPDATE [dbo].[tblActor] 
SET ActorDateOfDeath = '2020-10-01'
WHERE [ActorID]=999

SELECT * FROM [dbo].[tblActor] 

-- VALIDATION EXAMPLE

CREATE TRIGGER trgnewcastmember 
ON tblcast 
after INSERT 
AS 
  BEGIN 
      IF EXISTS (SELECT * 
                 FROM   tblactor AS a 
                        JOIN inserted AS i 
                          ON a.actorid = i.castactorid 
                 WHERE  a.actordateofdeath IS NOT NULL) 
        BEGIN 
            RAISERROR('That actor is no longer alive',16,1) 

            ROLLBACK TRANSACTION 

            RETURN 
        END 
  END 


-- TEST THIS VALIDATION
INSERT INTO [dbo].[tblCast] ([CastID],[CastFilmID],[CastActorID],[CastCharacterName])
VALUES (10000,1, 999,'RANDOM')
-- OBSERVE THE ERROR



-- ADVANCED TOPICS TO BE IGNORED NOW

-- DDL TRIGGERS
-- https://www.sqlservertutorial.net/sql-server-triggers/sql-server-ddl-trigger/#:~:text=SQL%20Server%20DDL%20triggers%20respond,%2C%20REVOKE%20%2C%20or%20UPDATE%20STATISTICS%20.
-- https://www.youtube.com/watch?v=9XCB0y44b1g&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H&index=16
-- https://www.wiseowl.co.uk/blog/s388/sql-triggers.htm

-- LOGON TRIGGERS
-- https://www.sqlshack.com/an-overview-of-logon-triggers-in-sql-server/
-- https://www.wiseowl.co.uk/blog/s388/logon-triggers.htm