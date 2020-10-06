Use Movies
go


IF OBJECT_ID('dbo.test', 'U') IS NOT NULL 
  DROP TABLE dbo.test; 


create table test
(id int primary key,
name varchar(30)
)

go

--Batch1 , This complete batch will not execute because of Syntax Error

insert into test values(1,'Vikas')
insert into  values test(2,'Raj')  --Syntax Error 
insert into test values(3,'Amit')

go

--Batch2

insert into test values(4,'Vikas')
insert into test values(5,'Alice')
insert into test values(6,'Adam')

go

-- check

select * from test



--Creating and executing Stored Procedure in one batch 
Create Proc Proc1
as
select 'hello'
exec Proc1

go

--Executing Proc1
exec Proc1
go

-- exec Proc1 become part of the SP create. Thereby this SP is RECURSIVE.
-- Recursive SP excecutes the output 32 times.

--Creating and executing Stored Procedure in different batches 
Create Proc Proc2
as
select 'hello'
go

exec Proc2

go


--No need to write exec Stored Procedure Name if it is the first statement of the batch

sp_helptext 'Proc1'  --To see the definition of Stored Procedure

exec sp_helptext 'Proc2' --Here you need to write exec Stored Procedure Name because it isn't the first statement of the batch




