-- SOURCE : 
-- www.udemy.com/course/ssrs-t-sql-online-video-training/
-- https://www.youtube.com/watch?v=cRkuJ56RgZY
-- https://www.youtube.com/watch?v=j3qNaqqntZw
-- https://www.youtube.com/watch?v=NsjDqFB69c0

USE MOVIES
GO

/*
-- SUB QUERY

TYPES :

1.) NON-CORELATED SUB QUERY

-FIRST INNER QUERY WILL BE EXECUTED AND THEN OUTER QUERY WILL BE EXECUTED.
-RESULTS DEPENDS UPON OPERATION DONE IN INNER QUERY

CLASSIFICATION : 
	A.) WITH WHERE
	B.) AS DERIVED TABLE
	C.) AS COLUMN

2.) CORELATED SUB QUERY

-FIRST OUTER QUERY IS EXECUTED AND LATER INNER QUERY IS EXECUTED.
-RESULT OF INNER QUERY DEPENDS UPON INPUT GIVEN TO INNER QUERY BY THE OUTER QUERY
-WHEN ANY COLUMN OF THE OUTER QUERY IS USED IN THE INNER QUERY, IT IS CALLED CORELATED SUB QUERY

*/

SELECT * FROM [dbo].[tblFilm] 
WHERE [FilmOscarWins]>=5
ORDER BY [FilmRunTimeMinutes] DESC

--WRITE A QUERY TO DISPLAY ALL FILMS WHICH HAS MORE OSCAR WINS THAN FILMID=90
--ASSUMING THIS TABLE IS DYNAMIC AND OSCAR WINS CHANGE EVERY 6 MONTHS.
--OBSERVATION : FILMID=90 HAS 4 OSCAR WINS (BUT MAY CHANGE IN FUTURE)

SELECT * FROM [dbo].[tblFilm] 
WHERE [FilmOscarWins] > 4 -- LETS MAKE THIS 4 DYNAMIC

--SUB QUERY EXAMPLE (WITH WHERE)
SELECT * FROM [dbo].[tblFilm] 
WHERE [FilmOscarWins] > 
(SELECT [FilmOscarWins] FROM [dbo].[tblFilm] WHERE [FilmID] = 90)-- LETS MAKE THIS 4 DYNAMIC


--WRITE A QUERY TO DISPLAY SECOND HIGHEST [FilmRunTimeMinutes] AS WELL AS ENTIRE RECORD
--ASSUMING THIS TABLE IS DYNAMIC AND [FilmRunTimeMinutes] CHANGE EVERY MONTH.

SELECT * FROM [dbo].[tblFilm] ORDER BY [FilmRunTimeMinutes] DESC

--OBSERVATION : SECOND HIGHEST [FilmRunTimeMinutes] = 195 FOR FILMID=188

-- STEP 1:
SELECT ([FilmRunTimeMinutes]) FROM [dbo].[tblFilm] ORDER BY [FilmRunTimeMinutes] DESC 

--STEP 2
(SELECT MAX([FilmRunTimeMinutes]) FROM [dbo].[tblFilm])

--STEP 3
SELECT ([FilmRunTimeMinutes]) FROM [dbo].[tblFilm]
WHERE [FilmRunTimeMinutes] 
<
(SELECT MAX([FilmRunTimeMinutes]) FROM [dbo].[tblFilm])
ORDER BY [FilmRunTimeMinutes] DESC 

--STEP 4
SELECT MAX([FilmRunTimeMinutes]) FROM [dbo].[tblFilm]
WHERE [FilmRunTimeMinutes] 
<
(SELECT MAX([FilmRunTimeMinutes]) FROM [dbo].[tblFilm])

-- STEP 5 -- RETRIVE FULL RECORD (SECOND METHOD)
SELECT * FROM [dbo].[tblFilm]
WHERE [FilmRunTimeMinutes] 
=
(SELECT MAX([FilmRunTimeMinutes]) FROM [dbo].[tblFilm]
WHERE [FilmRunTimeMinutes] 
<
(SELECT MAX([FilmRunTimeMinutes]) FROM [dbo].[tblFilm]))


--WRITE A QUERY TO RETRIVE 4TH HIGHEST [FilmRunTimeMinutes] - JUST VALUE (AS TABLE)

-- STEP 1
SELECT TOP 4 * FROM [dbo].[tblFilm] ORDER BY [FilmRunTimeMinutes] DESC

--STEP 2
SELECT MIN([FilmRunTimeMinutes]) FROM
(SELECT TOP 4 * FROM [dbo].[tblFilm] ORDER BY [FilmRunTimeMinutes] DESC) AS T
--ADDING ALIAS T IS VERY IMPORTANT

-- NOW WE WILL RETRIVE FULL RECORD
-- STEP 1
SELECT * FROM
(SELECT TOP 4 * FROM [dbo].[tblFilm] ORDER BY [FilmRunTimeMinutes] DESC) AS T
ORDER BY T.FilmRunTimeMinutes ASC

-- STEP 2
SELECT TOP(1) * FROM
(SELECT TOP 4 * FROM [dbo].[tblFilm] ORDER BY [FilmRunTimeMinutes] DESC) AS T
ORDER BY T.FilmRunTimeMinutes ASC


-- WRITE A QUERY TO DISPLAY RECORDS WITH HIGHEST TURNOVER / REVENUE IN EACH COUNTRY

-- STEP 1

SELECT F.[FilmID],F.[FilmName],F.FilmCountryID,C.CountryName,F.[FilmBoxOfficeDollars] 
FROM 
	[dbo].[tblFilm]  AS F
INNER JOIN 
	[dbo].[tblCountry] AS C
ON
	F.FilmCountryID=C.CountryID
ORDER BY 
	C.CountryName ASC,
	[FilmBoxOfficeDollars] DESC

-- STEP 2


SELECT F.FilmCountryID,C.CountryName,MAX(F.[FilmBoxOfficeDollars]) AS MAXREVENUE
FROM 
	[dbo].[tblFilm]  AS F
INNER JOIN 
	[dbo].[tblCountry] AS C
ON
	F.FilmCountryID=C.CountryID
GROUP BY 
	F.FilmCountryID,
	C.CountryName

-- STEP 3

SELECT * FROM [dbo].[tblFilm] AS T1

INNER JOIN


(SELECT F.FilmCountryID,C.CountryName,MAX(F.[FilmBoxOfficeDollars]) AS MAXREVENUE
FROM 
	[dbo].[tblFilm]  AS F
INNER JOIN 
	[dbo].[tblCountry] AS C
ON
	F.FilmCountryID=C.CountryID
GROUP BY 
	F.FilmCountryID,
	C.CountryName) AS T2
ON 
	T1.FilmCountryID=T2.FilmCountryID AND
	T1.FilmBoxOfficeDollars=T2.MAXREVENUE


-- SUB QUERY AS COLUMN

-- CHECK NULL IN [FilmBoxOfficeDollars]
SELECT * FROM [dbo].[tblFilm] WHERE 
[FilmBoxOfficeDollars] IS NULL

-- DELETE NULL ROWS FilmBoxOfficeDollars
DELETE FROM [dbo].[tblFilm] WHERE 
[FilmBoxOfficeDollars] IS NULL

SELECT * FROM [dbo].[tblFilm] WHERE 
[FilmBoxOfficeDollars] IS NULL

SELECT * FROM [dbo].[tblFilm] ORDER BY [FilmBoxOfficeDollars] DESC

SELECT AVG(CAST([FilmBoxOfficeDollars] AS DECIMAL)) FROM [dbo].[tblFilm]

SELECT * FROM [dbo].[tblFilm]
SELECT *,'DHTU' FROM [dbo].[tblFilm]
SELECT *,294779167.718253 FROM [dbo].[tblFilm] ---MAKE THIS NUMBER DYNAMIC


SELECT *,
(SELECT AVG(CAST([FilmBoxOfficeDollars] AS DECIMAL)) FROM [dbo].[tblFilm]) 
AS AVGREVENUE,
(SELECT AVG(CAST([FilmBoxOfficeDollars] AS DECIMAL)) FROM [dbo].[tblFilm])-[FilmBoxOfficeDollars] AS DIFFERENCE
FROM [dbo].[tblFilm]

-- SUB QUERY WITH NOT IN
-- LIST OUT DIRECTORS WHO NEVER WORKED ON ANY FLIM

SELECT * FROM [dbo].[tblFilm]
SELECT * FROM [dbo].[tblDirector]

-- STEP 1
SELECT DISTINCT([FilmDirectorID]) FROM [dbo].[tblFilm]

--STEP 2
SELECT * FROM [dbo].[tblDirector] WHERE
[DirectorID] NOT IN 
(SELECT DISTINCT([FilmDirectorID]) FROM [dbo].[tblFilm])


--  ALL,  ANY/SOME CLAUSES 
-- NOTE : ANY & SOME ARE SAME FUNCTIONALLY

SELECT * FROM [dbo].[tblFilm]
SELECT AVG([FilmRunTimeMinutes]) FROM [dbo].[tblFilm]

-- FIND RECORDS WITH FILM RUN TIME MORE THAN AVERAGE OF ALL MOVIES

SELECT * FROM [dbo].[tblFilm] WHERE [FilmRunTimeMinutes]>
(SELECT AVG([FilmRunTimeMinutes]) FROM [dbo].[tblFilm])

--WAQ TO LIST RECORDS WHICH HAS [FilmRunTimeMinutes] > THAN ID = 100 & 202

SELECT * FROM [dbo].[tblFilm] WHERE [FilmRunTimeMinutes] >

(SELECT [FilmRunTimeMinutes] FROM [dbo].[tblFilm] WHERE [FilmID]= 100 OR [FilmID] = 202)

--NOW WE CANNOT PUT > INBETWEEN 2 QUERIES AS COLUMN HAS 2 VALUES (ID = 100 & 202)

SELECT * FROM [dbo].[tblFilm] WHERE [FilmRunTimeMinutes] >

ALL(SELECT [FilmRunTimeMinutes] FROM [dbo].[tblFilm] WHERE [FilmID]= 100 OR [FilmID] = 202)

ORDER BY [FilmRunTimeMinutes] DESC


-- CORELATED SUBQUERY
-- WHEN ANY COLUMN OF THE OUTER QUERY IS USED IN THE INNER QUERY, IT IS CALLED CORELATED SUB QUERY

--DATA PREPARATION
create table mydemo.HumanResource
(
    id int,
	name varchar(40)

)

--The employees of the company
create table mydemo.tblEmployee
(
    id int,
	department varchar(40)

)


--Bonus provided by the company
create table mydemo.tblSales
(
    id int,
	bonus int
)


insert into mydemo.HumanResource values (1,'N1'),(2,'N2'),(3,'N3'),(4,'N4'),(5,'N5')
insert into mydemo.tblEmployee values (2,'D1'),(4,'D4'),(5,'D2')
insert into mydemo.tblSales values (1,1000),(2,2000),(2,3000),(2,4000),(3,4567),(3,2000),(4,2000),(4,4760),(5,7867)
insert into mydemo.tblEmployee values (2,'D2')

select * from mydemo.HumanResource
select * from mydemo.tblEmployee
select * from mydemo.tblSales



-- The list of employees along with the department Name who had got the bonus of 2000 using correlated sudquery

select h.id,h.name,e.department from 
mydemo.HumanResource h inner join mydemo.tblEmployee e on h.id=e.id
where 3000 in
(
     select bonus from mydemo.tblSales s where s.id=e.id
)

-- CO-RELATED SUBQUERY WITH NOT EXISTS

-- DATA PREPARATION

CREATE TABLE MYDEMO.[tblDiscount](
	[ProductID] [int] NULL,
	[Rate] [decimal](5, 3) NULL
) 

CREATE TABLE MYDEMO.[tblProduct](
	[ProductID] [int] NULL,
	[ProductName] [varchar](50) NULL,
	[Price] [int] NULL
) 

INSERT MYDEMO.[tblDiscount] ([ProductID], [Rate]) VALUES (1, CAST(0.010 AS Decimal(5, 3)))
INSERT MYDEMO.[tblDiscount] ([ProductID], [Rate]) VALUES (1, CAST(0.050 AS Decimal(5, 3)))
INSERT MYDEMO.[tblDiscount] ([ProductID], [Rate]) VALUES (3, CAST(0.100 AS Decimal(5, 3)))
INSERT MYDEMO.[tblDiscount] ([ProductID], [Rate]) VALUES (5, CAST(0.090 AS Decimal(5, 3)))
INSERT MYDEMO.[tblDiscount] ([ProductID], [Rate]) VALUES (5, CAST(0.190 AS Decimal(5, 3)))
INSERT MYDEMO.[tblProduct] ([ProductID], [ProductName], [Price]) VALUES (1, 'Prod1', 100)
INSERT MYDEMO.[tblProduct] ([ProductID], [ProductName], [Price]) VALUES (2, 'Prod2', 200)
INSERT MYDEMO.[tblProduct] ([ProductID], [ProductName], [Price]) VALUES (3, 'Prod3', 100)
INSERT MYDEMO.[tblProduct] ([ProductID], [ProductName], [Price]) VALUES (4, 'Prod4', 400)
INSERT MYDEMO.[tblProduct] ([ProductID], [ProductName], [Price]) VALUES (5, 'Prod4', 400)


--EXAMPLE

SELECT * FROM MYDEMO.[tblDiscount]
select * from MYDEMO.tblProduct

select * from MYDEMO.tblProduct p
where not exists
(
     select 1 from MYDEMO.tblDiscount d where  d.ProductID=p.ProductID

)
--CORELATED SUBQUERY IS FASTER THAN LEFT OUTER JOIN
