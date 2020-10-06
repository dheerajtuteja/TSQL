use MOVIES
go

-- BEGIN & COMMIT WORK FINE WHEN SET XACT_ABORT ON
-- BEGIN & COMMIT NOT ALWAYS SOLVE THE PROBLEM
-- THEREFORE TRY & CATCH IS USED.


CREATE TABLE dbo.SimpleOrders(

orderid int IDENTITY(1,1) NOT NULL PRIMARY KEY,

custid int NOT NULL ,

empid int NOT NULL ,

orderdate datetime NOT NULL

);

GO

 
CREATE TABLE dbo.SimpleOrderDetails(

orderid int NOT NULL FOREIGN KEY REFERENCES dbo.SimpleOrders(orderid),

productid int NOT NULL ,

unitprice money NOT NULL,

qty smallint NOT NULL,

CONSTRAINT PK_OrderDetails PRIMARY KEY (orderid, productid)

);

GO



BEGIN TRANSACTION

    INSERT INTO dbo.SimpleOrders(custid, empid, orderdate)
    VALUES (68,9,'2006-07-15');

    INSERT INTO dbo.SimpleOrderDetails(orderid,productid,unitprice,qty)
    VALUES (99999,2,15.20,20);  --This command will fail

COMMIT TRANSACTION

go

select * from SimpleOrders
go

delete from SimpleOrders
go


BEGIN TRY

   BEGIN TRANSACTION

       INSERT INTO dbo.SimpleOrders(custid, empid, orderdate)
       VALUES (68,9,'2006-07-15');

       INSERT INTO dbo.SimpleOrderDetails(orderid,productid,unitprice,qty)
       VALUES (99999, 2,15.20,20);

   COMMIT TRANSACTION

END TRY

BEGIN CATCH

    ROLLBACK TRANSACTION
	--INSERT INTO LOGTABLE
	SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 
    --You may log this data into ErrorLog Table for reviewing the error later

	--SP_SEND_DBMAIL   to send the email among database team to inform about the error

END CATCH;
 
go

 select * from SimpleOrders
go
