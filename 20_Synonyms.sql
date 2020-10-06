--Create a table with wrong spellings
Use DBase
go

CREATE TABLE [dbo].[SlaesTerritory](
	[SaleID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[PurchaseOrderNumber] [varchar](20) NULL,
	[SoldWhen] [datetime2](7) NULL DEFAULT (sysdatetime()),

)

go


--Synonym is an alternate name or an alias given to an object in SQL Server. 
--Here objects means tables, views, stored procedures and functions etc



exec sp_rename 'SlaesTerritory','SalesTerritory'   --RENAME THE TABLE
go

create synonym SlaesTerritory for SalesTerritory--CREATE SYNONYM WITH OLD TABLE NAME
go

--In the following code i keep both the commands in the transaction so that both the
--commands get executed together or nothing executes

Use DBase
go

begin try
    begin transaction
        exec sp_rename 'SlaesTerritory','SalesTerritory'
        create synonym SlaesTerritory for SalesTerritory
    commit transaction
end try

begin catch
     rollback transaction
end catch