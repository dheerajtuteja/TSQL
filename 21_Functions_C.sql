/* C. WINDOWS (& OVER CLAUSE)

-- SYSTEM DEFINED FUNCTION WITH 'OVER BY' CLAUSE ARE CALLED WINDOWS FUNCTION.
-- THESE FUNCTIONS ARE SUSED AS COLUMNS WITH SELECT COMMAND.
-- EXAMPLE: SELECT COL1, COL2, SYSTEM DEFINED FUNCTION 'OVER'(CONDITION COL3) FROM TABLE 

-- THERE CAN BE THREE TYPES OF CONDITION IN OVER CLAUSE:

A.) ORDER BY
B.) PARTITION BY
C.) FRAMING CONDITION - ALLOWS USER TO CREATE START AND END BOUNDARIES


-- TYPES OF WINDOWS FUNCTIONS:

A.) RANKING -- OVER (ORDER BY - MANDATORY // PARTITION BY - OPTIONAL)
	TYPES:
	1.) RANK
	2.) DENSE RANK
	3.) ROW NUMBER
	4.) NTILE
B.) AGGREGATE
C.) ANALYTICAL */


-- RANKING WINDOWS FUNSTION

USE MOVIES
GO

CREATE TABLE [DBO].[RANKTEST1](
	[NAME] [VARCHAR](50) NULL,
	[SALES] [INT] NULL,
	[LOCATION] [NCHAR](10) NULL
) 

GO

INSERT INTO [RANKTEST1]
           ([NAME]
           ,[SALES]
           ,[LOCATION])
     VALUES
           ('JOHN',10000,'NORTH'),('MOHIT',12000,'NORTH'),('SAGAR',15000,'SOUTH'),('NITIN',10000,'NORTH'),('POOJA',11000,'SOUTH')
GO


SELECT * FROM RANKTEST1


SELECT NAME,SALES,LOCATION,RANK() OVER (ORDER BY SALES ASC) AS SALESRANK FROM RANKTEST1

SELECT NAME,SALES,LOCATION,DENSE_RANK() OVER (ORDER BY SALES ASC) AS SALESRANK FROM RANKTEST1

SELECT NAME,SALES,LOCATION,RANK() OVER (PARTITION BY LOCATION ORDER BY SALES ASC) AS SALESRANK FROM RANKTEST1

SELECT NAME,SALES,LOCATION,DENSE_RANK() OVER (PARTITION BY LOCATION ORDER BY SALES ASC) AS SALESRANK FROM RANKTEST1

SELECT NAME,SALES,LOCATION,ROW_NUMBER() OVER (PARTITION BY LOCATION ORDER BY SALES ASC) AS ROWNUMBER FROM RANKTEST1

SELECT ROW_NUMBER() OVER (ORDER BY SALES ASC) AS ROWNUMBER,NAME,SALES,LOCATION FROM RANKTEST1

SELECT ROW_NUMBER() OVER (PARTITION BY LOCATION ORDER BY SALES ASC) AS ROWNUMBER,NAME,SALES,LOCATION FROM RANKTEST1

SELECT NTILE(2) OVER (ORDER BY SALES ASC) AS ROWNUMBER,NAME,SALES,LOCATION FROM RANKTEST1

SELECT NTILE(2) OVER (PARTITION BY LOCATION ORDER BY SALES ASC) AS ROWNUMBER,NAME,SALES,LOCATION FROM RANKTEST1



-- AGGREGATE WINDOWS FUNCTION
-- THEY SUPPORT THE ORDER BY SUBCLAUSE BUT OPTIONAL
-- FRAMING IS SUPPORTED BUT OPTIONAL
-- PARTITION BY CLAUSE IS ALWAYS SUPPORTED IN ALL KINDS OF WINDOW FUNCTIONS
 
  CREATE TABLE RegionalSales
  (
    SalesID INT NOT NULL IDENTITY PRIMARY KEY,
	  SalesGroup NVARCHAR(30) NOT NULL,
	    Country NVARCHAR(30) NOT NULL,
		  AnnualSales INT NOT NULL
		  );
		  GO
		   
		   INSERT INTO RegionalSales 
		     (SalesGroup, Country, AnnualSales)
			 VALUES
			   ('North America', 'United States', 22000),
			     ('North America', 'Canada', 32000),
				   ('North America', 'Mexico', 28000),
				     ('Europe', 'France', 19000),
					   ('Europe', 'Germany', 22000),
					     ('Europe', 'Italy', 18000),
						   ('Europe', 'Greece', 16000),
						     ('Europe', 'Spain', 16000),
							   ('Europe', 'United Kingdom', 32000),
							     ('Pacific', 'Australia', 18000),
								   ('Pacific', 'China', 28000),
								     ('Pacific', 'Singapore', 21000),
									   ('Pacific', 'New Zealand', 18000),
									     ('Pacific', 'Thailand', 17000),
										   ('Pacific', 'Malaysia', 19000),
										     ('Pacific', 'Japan', 22000);
											 GO



select * FROM
	 RegionalSales;

	  go

SELECT 
 SalesGroup,
 Country,
 AnnualSales,
   COUNT(AnnualSales) OVER() AS CountryCount,
   SUM(AnnualSales) OVER() AS TotalSales,
   AVG(AnnualSales) OVER() AS AverageSales
FROM
 RegionalSales;

select COUNT(AnnualSales) AS CountryCount,
SUM(AnnualSales) AS TotalSales,
AVG(AnnualSales) AS AverageSales
FROM
	  RegionalSales;

SELECT 
 SalesGroup,
 Country,
 AnnualSales,
   COUNT(AnnualSales) OVER(PARTITION BY SalesGroup) AS CountryCount,
  SUM(AnnualSales) OVER(PARTITION BY SalesGroup) AS TotalSales,
AVG(AnnualSales) OVER(PARTITION BY SalesGroup
   ) AS AverageSales
	FROM
	  RegionalSales;


-- After ORDER BY Subclause Default Framing is applied



SELECT 
 SalesGroup,
 Country,
 AnnualSales,
   COUNT(AnnualSales) OVER(PARTITION BY SalesGroup
ORDER BY AnnualSales DESC) AS CountryCount,
  SUM(AnnualSales) OVER(PARTITION BY SalesGroup
     ORDER BY AnnualSales DESC) AS TotalSales,
AVG(AnnualSales) OVER(PARTITION BY SalesGroup
    ORDER BY AnnualSales DESC) AS AverageSales
	FROM
	  RegionalSales;



	
--Default Framing is RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  

SELECT 
 SalesGroup,
   Country,
 AnnualSales,
   COUNT(AnnualSales) OVER(PARTITION BY SalesGroup
ORDER BY AnnualSales DESC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CountryCount,
  SUM(AnnualSales) OVER(PARTITION BY SalesGroup
      ORDER BY AnnualSales DESC  RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS TotalSales
	FROM
	  RegionalSales;

--ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	  SELECT 
 SalesGroup,
   Country,
 AnnualSales,
   COUNT(AnnualSales) OVER(PARTITION BY SalesGroup
ORDER BY AnnualSales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CountryCount,
  SUM(AnnualSales) OVER(PARTITION BY SalesGroup
      ORDER BY AnnualSales DESC  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS TotalSales
	FROM
	  RegionalSales;




SELECT 
 SalesGroup,
 Country,
 AnnualSales,
 COUNT(AnnualSales) OVER(PARTITION BY SalesGroup 
 ORDER BY AnnualSales DESC rows BETWEEN 2 PRECEDING AND CURRENT ROW) AS CountryCount,
 SUM(AnnualSales) OVER(PARTITION BY SalesGroup
 ORDER BY AnnualSales DESC  rows BETWEEN 2 PRECEDING AND CURRENT ROW) AS TotalSales
FROM
	  RegionalSales;


-- ANALYTICAL FUNCTIONS
-- ONLY TWO ANALYTICAL FUNCTIONS - FIRST_VALUE AND LAST_VALUE CAN USE FRAMING

SELECT 
  SalesGroup,
  Country,
  AnnualSales,
  FIRST_VALUE(AnnualSales) OVER(PARTITION BY SalesGroup
  ORDER BY AnnualSales DESC) AS HighestSales,
  LAST_VALUE(AnnualSales) OVER(PARTITION BY SalesGroup
  ORDER BY AnnualSales DESC) AS LowestSales
FROM
  RegionalSales;



SELECT 
  SalesGroup,
  Country,
  AnnualSales,
  FIRST_VALUE(AnnualSales) OVER(PARTITION BY SalesGroup
  ORDER BY AnnualSales DESC) AS HighestSales,
  LAST_VALUE(AnnualSales) OVER(PARTITION BY SalesGroup
  ORDER BY AnnualSales DESC
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LowestSales
FROM
   RegionalSales;


SELECT 
  SalesGroup,
  Country,
  AnnualSales,
  LAG(AnnualSales, 1) OVER(PARTITION BY SalesGroup
  ORDER BY AnnualSales DESC) AS PreviousSale,
  LEAD(AnnualSales, 1) OVER(PARTITION BY SalesGroup
  ORDER BY AnnualSales DESC) AS NextSale
FROM
   RegionalSales;
				
