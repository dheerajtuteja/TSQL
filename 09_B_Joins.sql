/*
SOURCE:

https://www.youtube.com/watch?v=MJv6ZQlK_ek&list=PL6EDEB03D20332309&index=6
https://www.youtube.com/watch?v=8Pu0OcqtZU4&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=15
https://www.youtube.com/watch?v=Dr3tdD8DaUY&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=16
https://www.youtube.com/watch?v=pmfATg5ciWQ&list=PLVlQHNRLflP8WFEvFvANnUsD2y8HJIJh1&index=35

JOINS - ARE NEEDED TO RETRIVE DATA FROM MORE THAN ONE TABLE.

TYPES OF JOINS:

1.) ANSI FORMAT : IT COMPRISES "ON" KEYWORD JOIN CONDITION. ALSO CALLED NEW STYLE JOIN FORMAT.

TYPES OF ANSI FORMAT JOINS:

	A.) INNER JOIN

	B.) OUTER JOIN
				- LEFT OUTER JOIN
				- RIGHT OUTER JOIN
				- FULL OUTER JOIN

	C.) CROSS JOIN

	D.) NATURAL JOIN



2.) NON-ANSI FORMAT : IT COMPRISES "WHERE" KEYWORD JOIN CONDITION. ALSO CALLED OLD STYLE JOIN FORMAT.

TYPES OF NON-ANSI FORMAT JOINS:

	A.) NON-EQUI JOIN

	B.) EQUI JOIN

	C.) SELF JOIN JOIN

REFER : https://github.com/dheerajtuteja/TSQL/blob/master/9_A_Joins.png

*/

-- 1.) ANSI FORMAT

-- INNER JOIN
-- RETRIEVES DATA FROM MULTIPLE TABLES BASED ON AN EQUALITY CONDITION.
-- COMMON COLUMN DATA TYPE MUST BE SAME.
-- RETRIEVES ONLY MATCHING / COMMON ROWS IN BOTH THE TABLES.
-- BASICALLY IT IS INTERSECTION ARE IN VENN DIAGRAM

USE MOVIES
GO

-- EXAMPLE 1 (ONE INNER JOIN)
SELECT F.[FilmID],F.FilmName, C.CountryName
FROM [dbo].[tblFilm] AS F
INNER JOIN [dbo].[tblCountry] AS C
ON F.FilmCountryID=C.[CountryID]
ORDER BY F.FilmID

-- EXAMPLE 2 (TWO INNER JOIN)
SELECT F.[FilmID],F.FilmName, C.CountryName,D.DirectorName
FROM [dbo].[tblFilm] AS F
INNER JOIN [dbo].[tblCountry] AS C
ON F.FilmCountryID=C.[CountryID]
INNER JOIN [dbo].[tblDirector] AS D
ON F.FilmDirectorID=D.DirectorID
ORDER BY F.FilmID

-- EXAMPLE 3 (MULTIPLE INNER JOIN)
SELECT F.[FilmID],F.FilmName,F.FilmReleaseDate,D.DirectorName,L.LanguageName,C.CountryName,S.StudioName,F.FilmSynopsis,F.FilmRunTimeMinutes,CR.CertificateName,F.FilmBudgetDollars,F.FilmBoxOfficeDollars,F.FilmOscarNominations,F.FilmOscarWins
FROM [dbo].[tblFilm] AS F

INNER JOIN [dbo].[tblDirector] AS D
ON F.FilmDirectorID=D.DirectorID

INNER JOIN [dbo].[tblLanguage] AS L
ON F.FilmLanguageID=L.LanguageID

INNER JOIN [dbo].[tblCountry] AS C
ON F.FilmCountryID=C.[CountryID]

INNER JOIN [dbo].[tblStudio] AS S
ON F.FilmStudioID=S.StudioID

INNER JOIN [dbo].[tblCertificate] AS CR
ON F.FilmCertificateID=CR.CertificateID

ORDER BY F.FilmID

-- EXAMPLE 4A (INNER JOIN A WITH B) - 260 ROWS

SELECT * FROM [dbo].[tblFilm] -- 260 ROWS
SELECT * FROM [dbo].[tblDirector] --121 ROWS

SELECT
	D.DirectorID,
	D.DirectorName,
	F.FilmName,
	F.FilmDirectorID
FROM
	[dbo].[tblDirector] AS D
	INNER JOIN [dbo].tblFilm AS F
	ON D.DirectorID = F.FilmDirectorID

-- EXAMPLE 4B (INNER JOIN B WITH A) - 260 ROWS
SELECT

	F.FilmName,
	F.FilmDirectorID,
	D.DirectorID,
	D.DirectorName
FROM
	[dbo].tblFilm AS F
	INNER JOIN [dbo].[tblDirector] AS D
	ON F.FilmDirectorID=D.DirectorID


-- OUTER JOIN
-- IN INNER JOIN, ONLY MATCHING DATA IS RETRIEVED BASIS LHS TABLE.
-- IN OUTER JOIN, UNMATCHING RECORDS CAN ALSO BE RETRIEVED


-- LEFT JOIN / LEFT OUTER JOIN
-- The LEFT JOIN keyword returns all records from the left table (table1), and the matched records from the right table (table2). 
-- The result is NULL from the right side, if there is no match.
-- BASICALLY IT IS LEFT + INSERSECT AREA IN VENN DIAGRAM.

SELECT * FROM [dbo].[tblFilm] -- 260 ROWS
SELECT * FROM [dbo].[tblDirector] --121 ROWS
SELECT * FROM [dbo].[tblDirector] WHERE DirectorDOB IS  NULL -- 10 ROWS

-- EXAMPLE 1A (LEFT OUTER JOIN A WITH B) - TABLE A + COMMON ROWS TABLE B - 265 ROWS

SELECT * FROM [dbo].[tblFilm] -- 260 ROWS
SELECT * FROM [dbo].[tblDirector] --121 ROWS

-- RESULT HAS 265 ROWS
-- 5 EXTRA ROWS BECAUSE 5 DIRECTORS ARE PRESENT IN [tblDirector] BUT NOT IN [tblFilm]

SELECT
	D.DirectorID,
	D.DirectorName,
	F.FilmName,
	F.FilmDirectorID
FROM
	[dbo].[tblDirector] AS D
	LEFT OUTER JOIN [dbo].tblFilm AS F
	ON D.DirectorID = F.FilmDirectorID

-- EXAMPLE 1B (LEFT OUTER JOIN A WITH B) - TABLE A + COMMON ROWS TABLE B - 260 ROWS
-- LEFT WITHOUT INTERSECTION IN VENN DIAGRAM
-- 260 ROWS

SELECT
	D.DirectorID,
	D.DirectorName,
	F.FilmName,
	F.FilmDirectorID
FROM
	[dbo].[tblDirector] AS D
	LEFT OUTER JOIN [dbo].tblFilm AS F
	ON D.DirectorID = F.FilmDirectorID
WHERE
	F.FilmDirectorID IS NOT NULL



-- RIGHT OUTER JOIN
-- CONSIDER A SITUATION WHEREIN WE NEED TO EVALUATE ARE ACTORS ALSO DIRECTORS? OR VICE VERSA?
-- WE WILL EVALUATE THIS BY NAME+DOB+GENDER AS BOTH TABLES ARE NOT LINKED

SELECT * FROM [dbo].[tblActor] -- 338 ROWS
SELECT * FROM [dbo].[tblDirector] --121 ROWS

--PEOPLE ARE ACTORS AS WELL AS DIRECTORS
SELECT A.[ActorID],A.[ActorName],A.[ActorDOB],A.[ActorGender],D.[DirectorID] 
FROM [dbo].[tblActor] AS A
INNER JOIN [dbo].[tblDirector] AS D
ON A.ActorName=D.DirectorName AND 
   A.ActorDOB=D.DirectorDOB AND 
   A.ActorGender=D.DirectorGender

--DISPLAY ALL ACTORS AND SEE WHO ALL ACTORS ARE ALSO DIRECTORS
SELECT A.[ActorID],A.[ActorName],A.[ActorDOB],A.[ActorGender],D.[DirectorID], D.DirectorName
FROM [dbo].[tblActor] AS A
LEFT OUTER JOIN [dbo].[tblDirector] AS D
ON A.ActorName=D.DirectorName AND 
   A.ActorDOB=D.DirectorDOB AND 
   A.ActorGender=D.DirectorGender

--DISPLAY ALL ACTORS AND SEE WHO ALL ACTORS ARE ALSO DIRECTORS WHERE [DirectorID] IS NOT NULL
SELECT A.[ActorID],A.[ActorName],A.[ActorDOB],A.[ActorGender],D.[DirectorID], D.DirectorName
FROM [dbo].[tblActor] AS A
LEFT OUTER JOIN [dbo].[tblDirector] AS D
ON A.ActorName=D.DirectorName AND 
   A.ActorDOB=D.DirectorDOB AND 
   A.ActorGender=D.DirectorGender
WHERE D.[DirectorID] IS NOT NULL

--DISPLAY ALL DIRECTORS AND SEE WHO ALL DIRECTORS ARE ALSO ACTORS
SELECT A.[ActorID],A.[ActorName],A.[ActorDOB],A.[ActorGender],D.[DirectorID], D.DirectorName
FROM [dbo].[tblActor] AS A
RIGHT OUTER JOIN [dbo].[tblDirector] AS D --RIGHT SIDE OF THE VENN DIAGRAM + INTERSECTION
ON A.ActorName=D.DirectorName AND 
   A.ActorDOB=D.DirectorDOB AND 
   A.ActorGender=D.DirectorGender
--RESULT HAS 121 ROWS

SELECT A.[ActorID],A.[ActorName],A.[ActorDOB],A.[ActorGender],D.[DirectorID], D.DirectorName
FROM [dbo].[tblActor] AS A
FULL OUTER JOIN [dbo].[tblDirector] AS D --ALL ROWS OF BOTH TABLE --> 2 FULL CIRCLES IN VENN DIAGRAM 
ON A.ActorName=D.DirectorName AND 
   A.ActorDOB=D.DirectorDOB AND 
   A.ActorGender=D.DirectorGender

--RESULT HAS 452 ROWS
--SELECT * FROM [dbo].[tblActor] HAS 338 ROWS
--SELECT * FROM [dbo].[tblDirector] HAS 121 ROWS
--INTERSECTION HAS 7 ROWS
--452 = 338-7+ 121-7 + 7 = 331 + 114 + 7

SELECT A.[ActorID],A.[ActorName],A.[ActorDOB],A.[ActorGender],D.[DirectorID], D.DirectorName
FROM [dbo].[tblActor] AS A
FULL OUTER JOIN [dbo].[tblDirector] AS D 
ON A.ActorName=D.DirectorName AND 
   A.ActorDOB=D.DirectorDOB AND 
   A.ActorGender=D.DirectorGender
WHERE 
   A.ActorID IS NULL
--A.ActorID - COMMON ROWS = 121-7 = 114 ROWS


-- CROSS JOIN (M X N ROWS)

-- TABLE 1 - M ROWS
-- TABLE 2 - N ROWS
-- RESULT WILL HAVE M x N ROWS
-- NO COMMON COLUMN REQUIRED

SELECT * FROM [dbo].[tblActor] -- 338 ROWS
SELECT * FROM [dbo].[tblDirector] -- 121 ROWS

SELECT * FROM [dbo].[tblActor] CROSS JOIN [dbo].[tblDirector] --338 X 121 = 40898 ROWS

-- NATURAL JOIN - DOESN'T EXIST IN SQL SERVER. BUT IT EXISTS IN ORACLE.
-- IGNORE THIS FOR NOW

-- CARTESIAN PRODUCT RESULT ( THIS IS NOT JOIN)

SELECT * FROM [dbo].[tblActor],[dbo].[tblDirector] --338 X 121 = 40898 ROWS



/* 2.) NON-ANSI FORMAT

A.) SELF JOIN
- JOINS A TABLE WITH ITSELF
- ALIAS NAMES ARE USED TO DEFINE TABLE NAMES
- EXAMPLE : WRITE A QUERY TO DISPLAY FILM DETAILS WITH SAME RUN-TIME AS [FilmID]= 56
*/
SELECT * FROM [dbo].[tblFilm]
ORDER BY FilmRunTimeMinutes DESC

SELECT * FROM [dbo].[tblFilm] AS T1, [dbo].[tblFilm] AS T2
WHERE T1.FilmRunTimeMinutes=T2.FilmRunTimeMinutes
AND T1.[FilmID]= 56

/*
B.) EQUI JOIN 
-- RETRIEVING DATA FROM MULTIPLE TABLES WITH THE USE OF EQUALITY CONDITION (=)
-- IN THIS JOIN WE CANNOT USE OPERATORS - >,<,>=,<=,!>,!<,!=



C.) NON EQUI JOINS
-- RETRIEVING DATA FROM MULTIPLE TABLES WITH THE USE OF ANY CONDITION EXCEPT EQUALITY CONDITION
-- IN THIS JOIN WE CANNOT USE OPERATORS - '='

*/

-- DATA PREPARATION
USE MOVIES
GO

SELECT * INTO NEWCOUNTRY FROM [dbo].[tblCountry]
SELECT * FROM [dbo].[tblFilm]
SELECT [FilmID],[FilmName],[FilmCountryID] INTO NEWMOVIES FROM [dbo].[tblFilm]

SELECT * FROM NEWMOVIES -- 260 ROWS
SELECT * FROM NEWCOUNTRY -- 8 ROWS

-- EQUI JOIN

SELECT * FROM NEWMOVIES, NEWCOUNTRY WHERE NEWMOVIES.FilmCountryID=NEWCOUNTRY.CountryID
-- ONLY MATCHING ROWS RETRIEVED FROM BOTH TABLES


-- NON EQUI JOIN
SELECT * FROM NEWMOVIES, NEWCOUNTRY WHERE NEWMOVIES.FilmCountryID>NEWCOUNTRY.CountryID ORDER BY NEWMOVIES.FilmID
-- RETRIVES MATCH & UNMATCHED RECORDS FROM BOTH THE TABLES
