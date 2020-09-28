-- SOURCE : www.udemy.com/course/ssrs-t-sql-online-video-training/

https://www.youtube.com/watch?v=cRkuJ56RgZY
https://www.youtube.com/watch?v=j3qNaqqntZw
https://www.youtube.com/watch?v=NsjDqFB69c0

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