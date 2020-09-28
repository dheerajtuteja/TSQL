USE Movies
GO

/* CONSTRAINS IN SQL SERVER
Udemy : https://www.udemy.com/course/ssrs-t-sql-online-video-training/
Theory:https://www.w3schools.com/sql/sql_constraints.asp
The following constraints are commonly used in SQL:

NOT NULL - Ensures that a column cannot have a NULL value
UNIQUE - Ensures that all values in a column are different but one NULL value is allowed
PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Uniquely identifies each row in a table
FOREIGN KEY - Uniquely identifies a row/record in another table
CHECK - Ensures that all values in a column satisfies a specific condition
DEFAULT - Sets a default value for a column when no value is specified
INDEX - Used to create and retrieve data from the database very quickly

*/

CREATE TABLE CustomerDetails
(
CustomerID     int   IDENTITY   PRIMARY KEY,
C_Name   varchar(50)      NOT NULL,
C_Address       varchar(50)      NOT NULL,
City           varchar(50)      NOT NULL,
C_State          varchar(50)          NOT NULL,
PostalCode     varchar(20)      NOT NULL,
Phone          varchar(25)         NOT NULL UNIQUE,
DateModified   datetime    NOT NULL DEFAULT GETDATE ()
)


insert into  CustomerDetails(C_Name,C_Address,City,C_State,PostalCode ,Phone,DateModified)  values
('Arjun','Address1','New Delhi','Delhi',110027,445564321,'2017-12-12')


insert into  CustomerDetails(C_Name,C_Address,City,C_State,PostalCode ,Phone )  values
('Arjun','Address1','New Delhi','Delhi',110027,987654321)

select * from CustomerDetails --Observer DEFAULT

-- FOREIGN KEY

CREATE TABLE Sales
(
	SalesID      int   IDENTITY  PRIMARY KEY,
	CustomerID   int  NOT NULL
	FOREIGN KEY REFERENCES CustomerDetails(CustomerID),
	SalesDatetime    datetime    NOT NULL,
	empid   int              NOT NULL
)

insert into Sales (CustomerID,SalesDatetime,empid) values(1,getdate(),1)
insert into Sales (CustomerID,SalesDatetime,empid) values(2,getdate(),2)

select * from Sales

--ADDING CONSTRAINS AFTER TABLE IS CREATED

create table employeetable
(
    empid int ,
    empname varchar(30) Not Null,
    gender char(1) Not Null,
    telnumber varchar(15) Not Null,
	empaddress varchar(40) Not NULL
);

alter table employeetable
alter column empid int not null 


alter table employeetable
alter column gender char(6) 

alter table employeetable
add constraint pk_empid
primary key (empid)

exec sp_helpconstraint 'employeetable'

alter table employeetable
add 
constraint DF_employeetable
default 'UNKNOWN' for empaddress

exec sp_helpconstraint 'employeetable'

alter table employeetable
add constraint uk_employeetabletelnumber
unique (telnumber)


select * from Sales
select * from employeetable


alter table employeetable
drop constraint pk_empid

delete from sales

alter table sales
add constraint FK_employeetablesales
foreign key (empid) references employeetable(empid)

exec sp_helpconstraint 'sales'


--CHECK CONSTRAINT

CREATE TABLE [student]
(
	[id] [int] NULL,
	[Name] [varchar](50) NULL,
	[Gender] [char](6) NULL
) 

INSERT INTO [student]
           ([id]
           ,[Name]
           ,[Gender])
     VALUES
           (15,'Amit1','Male'), (16,'Anna1','Female')
GO


select * from [student]

alter table student with nocheck --nocheck means it doesnt check data already filled in table but will impose restrictions on future data insert
add constraint cn_gender
check(gender in ('Male','Female'))

alter table [student] with nocheck 
add constraint chk_V check([name] like 'V%')

INSERT INTO [student]
           ([id]
           ,[Name]
           ,[Gender])
     VALUES
           (15,'Vijay','Male')
GO

INSERT INTO [student]
           ([id]
           ,[Name]
           ,[Gender])
     VALUES
           (15,'Dijay','Mael') --Observe TWO errors
GO
alter table [student] nocheck constraint chk_V   --Disabling the check constraint
alter table [student] with nocheck check constraint chk_V
