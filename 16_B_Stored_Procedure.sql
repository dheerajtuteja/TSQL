USE MOVIES
GO

/*The scripts to create the above tables are already shared. Using these tables you need to
perform the following execises

Exercise 1
You need to create a stored procedure named usp_productsinsert with four input
parameters as
 @id as int
,@productname as varchar(40)
,@suppliercompany as varchar(40)
,@listprice as int
You need to create a stored procedure to insert the data into the products table
For example when you will be going to execute the stored procedure it will be like the following
command
exec usp_productsinsert
@id =6
,@productname = 'Battery'
,@suppliercompany = 'Everready'
,@listprice = '2'


Exercise 2
You need to create a stored procedure named usp_productsdisplaybysupplier with one
input parameter as
@suppliercompany as varchar(40)
You need to create a stored procedure to display the Products based on the suppliercompany
name
For example when you will be going to execute the stored procedure it will be like the following
command
exec usp_productsdisplaybysupplier
@suppliercompany='bajaj'


Exercise 3
You need to create a stored procedure named usp_productsdisplaybysortedlistprice with a
default parameter named @numrows of bigint datatype to display all the products details in the
descending order based on the listprice column.
The parameter @numrows represents how many records you want to display
For example if you execute
exec usp_productsdisplaybysortedlistprice @numrows = 2
then only top two records from the products table should be displayed
and when you execute the following command then
exec usp_productsdisplaybysortedlistprice
all the records from the products table should be displayed.


Exercise 4
You need to create a stored procedure named usp_GetEmployeeDOB with one input parameter
named @emp_no of INT datatype and one output parameter as @dob of char(10) datatype.
You need to show date of birth using the output parameter from the EmployeeDetails table for a
particular emp_no passed using input parameter.


Exercise 5
You need to drop all the stored procedures created so far . But first you need to check whether
they actually exists in the database, if they exists then delete those stored procedures. */


-- DATA PREPARATION

CREATE TABLE [dbo].[EmployeeDetails](
	[Emp_No] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[DOB] [varchar](50) NULL,
	[Gender] [char](10) NULL,
	[Salary] [int] NULL,
	[City] [varchar](20) NULL
) 
GO


CREATE TABLE [dbo].[Products](
	[id] [int] NOT NULL primary key,
	[productname] [varchar](40) NOT NULL,
	[suppliercompany] [varchar](40) NOT NULL,
	[listprice] [int] NULL
)

INSERT [dbo].[EmployeeDetails] ([Emp_No], [Name], [DOB], [Gender], [Salary], [City]) VALUES (100, 'Mahesh', '1965-12-12', 'Male      ', 30000, 'Delhi')
INSERT [dbo].[EmployeeDetails] ([Emp_No], [Name], [DOB], [Gender], [Salary], [City]) VALUES (101, 'Suresh', '1963-11-14', 'Male      ', 34000, 'Delhi')
INSERT [dbo].[EmployeeDetails] ([Emp_No], [Name], [DOB], [Gender], [Salary], [City]) VALUES (102, 'Raju', '1969-12-21', 'Male      ', 23000, 'Shimla')
INSERT [dbo].[EmployeeDetails] ([Emp_No], [Name], [DOB], [Gender], [Salary], [City]) VALUES (103, 'Kalpana', '1961-12-01', 'Female    ', 50000, 'Noida')
INSERT [dbo].[EmployeeDetails] ([Emp_No], [Name], [DOB], [Gender], [Salary], [City]) VALUES (104, 'Neha', '1971-12-01', 'Female    ', 19000, 'Goa')
INSERT [dbo].[EmployeeDetails] ([Emp_No], [Name], [DOB], [Gender], [Salary], [City]) VALUES (105, 'SUNITA', '1958-12-01', 'Female    ', 50000, 'Delhi')
INSERT [dbo].[Products] ([id], [productname], [suppliercompany], [listprice]) VALUES (1, 'Keyboard', 'TVSGold', 3)
INSERT [dbo].[Products] ([id], [productname], [suppliercompany], [listprice]) VALUES (2, 'Monitor', 'LG', 5)
INSERT [dbo].[Products] ([id], [productname], [suppliercompany], [listprice]) VALUES (3, 'AC', 'LG', 400)
INSERT [dbo].[Products] ([id], [productname], [suppliercompany], [listprice]) VALUES (4, 'Bikes', 'Bajaj', 700)
INSERT [dbo].[Products] ([id], [productname], [suppliercompany], [listprice]) VALUES (5, 'Bulb', 'Bajaj', 2)


-- SOLUTIONS

-- Exercise 1
create procedure usp_productsinsert
 @id as int
,@productname as varchar(40)
,@suppliercompany as varchar(40)
,@listprice as int
as
insert into products (id,productname,suppliercompany,listprice) values 
(@id,@productname,@suppliercompany,@listprice)

go


exec usp_productsinsert
 @id =6
,@productname = 'Battery'
,@suppliercompany = 'Everready'
,@listprice = '2'
go

--Exercise 2

create procedure usp_productsdisplaybysupplier
@suppliercompany as varchar(40)
as
select id,productname,suppliercompany,listprice
from products
where suppliercompany = @suppliercompany
go

exec usp_productsdisplaybysupplier
@suppliercompany='bajaj'

-- Exercise 3


create procedure usp_productsdisplaybysortedlistprice
@numrows as bigint = 9223372036854775807 --maximum value for bigint is 9223372036854775807
as
select  top (@numrows) id,productname,suppliercompany,listprice
from products
order by listprice desc;
go


exec usp_productsdisplaybysortedlistprice @numrows = 2
exec usp_productsdisplaybysortedlistprice

-- Exercise 4

create proc usp_getemployeedob
@emp_no as int
,@dob as char(10) output
as
select @dob=dob
from employeedetails
where emp_no=@emp_no
go


declare  @dateofbirth char(10)
exec usp_getemployeedob @emp_no=104 , @dob=@dateofbirth output
select @dateofbirth


-- Exercise 5

if object_id('usp_productsinsert','p') is not null
	drop proc usp_productsinsert
go

if object_id('usp_productsdisplaybysupplier','p') is not null
	drop proc usp_productsdisplaybysupplier
go


if object_id('usp_productsdisplaybysortedlistprice','p') is not null
	drop proc usp_productsdisplaybysortedlistprice;
go

if object_id('usp_getemployeedob','p') is not null 
drop procedure usp_getemployeedob