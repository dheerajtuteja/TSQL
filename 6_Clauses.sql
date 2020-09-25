/*

SOURCE : https://www.youtube.com/watch?v=fofNnSQ6DhE&list=PLd3UqWTnYXOkDmQvCVKsXeoGeocusMP4i&index=6
		 https://www.youtube.com/watch?v=_n_JQlp5UZw&list=PL6EDEB03D20332309&index=3
		 www.udemy.com/course/ssrs-t-sql-online-video-training/
		 WISEOWL SQL - YOUTUBE

CLAUSES IN TSQL - IN CORRECT ORDER:
	-SELECT
	-FROM
	-WHERE - DOES NOT WORK WITH ALIASES. IT IS APPLIED ON THE ORIGINAL TABLE.
	-GROUP BY (Rollup and Cube) - DOES NOT WORK WITH ALIASES. 
	-HAVING - DOES NOT WORK WITH ALIASES. IT IS APPLIED ON THE RESULT SET OBTAINED AFTER GROUP BY
	-ORDERBY - WORK WITH ALIASES
	
	-OFFSET
	-FETCH

OTHER FUNCTIONS CLOSELY USED WITH CLAUSES: 
	-DISTINCT
	-TOP (TOP N / WITH TIES)
	-OFFSET & FETCH

The complete syntax of the SELECT statement looks as following:

SELECT <select_list> FROM <tname>

[ WHERE search_condition ]

[ GROUP BY group_by_expression ]

[ HAVING search_condition ]

[ ORDER BY order_expression [ ASC | DESC ] ]

*/


USE Movies 
GO

--SELECT & FROM
SELECT 
*
FROM
	[dbo].[tblFilm]

-- WHERE (DOESN NOT WORKS WITH ALIASES)

-- Example 1

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] AS Duration,
	[FilmOscarWins] AS [Oscar Wins]
FROM
	[dbo].[tblFilm]
WHERE
	[FilmOscarWins]  <> 0


--EXAMPLE 2

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] AS Duration,
	[FilmOscarWins] AS [Oscar Wins]
FROM
	[dbo].[tblFilm]
WHERE
	[FilmOscarWins]  BETWEEN 7 AND 11


--EXAMPLE 3

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration,
	[FilmOscarWins] as [Oscar Wins]
FROM
	[dbo].[tblFilm]
WHERE
	[FilmOscarWins]  IN (5,7,8)


--EXAMPLE 4 - MULTIPLE WHERE

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration,
	[FilmOscarWins] as [Oscar Wins]
FROM
	[dbo].[tblFilm]
WHERE
	[FilmOscarWins]  <> 0 AND
	[FilmOscarWins] BETWEEN 5 AND 11 AND
	[FilmName] LIKE 'G%'


--EXAMPLE 5 - WHERE + NOT LIKE

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration,
	[FilmOscarWins] as [Oscar Wins]
FROM
	[dbo].[tblFilm]
WHERE
	[FilmName] NOT LIKE '%lethal%' --Total 4 Lethal Weapon Movies to be dropped


--EXAMPLE 6 - WHERE + DATE

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration,
	[FilmOscarWins] as [Oscar Wins]
FROM
	[dbo].[tblFilm]
WHERE
	[FilmReleaseDate] ='2004-07-09' --Dates to be used in 'yyyy-mm-dd' format


--EXAMPLE 7 - WHERE + DATE BETWEEN

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration,
	[FilmOscarWins] as [Oscar Wins]
FROM
	[dbo].[tblFilm]
WHERE
	[FilmReleaseDate] BETWEEN '2000-01-01' AND '2000-12-31' --Dates to be used in 'yyyy-mm-dd' format


--EXAMPLE 8 - WHERE + DATE - YEAR & MONTH

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration,
	[FilmOscarWins] as [Oscar Wins]
FROM
	[dbo].[tblFilm]
WHERE
	YEAR([FilmReleaseDate])>2000 --YEAR, MONTH & DAY Functions



-- GROUP BY
-- https://www.youtube.com/watch?v=oWkvHodS9cA&list=PL6EDEB03D20332309&index=10
-- https://www.youtube.com/watch?v=JxBid7Orq-I (ROLL UP & CUBE)

-- Example 1

SELECT 
	[FilmCountryID], -- THIS HAS TO GO IN GROUP BY
	AVG([FilmRunTimeMinutes]) AS AVG_FilmRunTime
FROM
	[dbo].[tblFilm]
GROUP BY 
	[FilmCountryID] 

-- Example 2

SELECT
	[FilmCountryID] -- THIS HAS TO GO IN GROUP BY
	,SUM([FilmRunTimeMinutes]) AS SUM_RunTime
	,AVG([FilmRunTimeMinutes]) AS AVG_RunTime
	,MAX([FilmRunTimeMinutes]) AS MAX_RunTime
	,MIN([FilmRunTimeMinutes]) AS MIN_RunTime
	,COUNT(*) AS COUNT_RunTime
FROM
	[dbo].[tblFilm]
GROUP BY 
	[FilmCountryID] 

-- Example 3(a) (ROLL UP)

SELECT
	--ISNULL([FilmCountryID],'') AS CountryID -- ISNULL IS NOT APPLICABLE HERE AS ID COL IS INT TYPE
	[FilmCountryID] AS CountryID --THIS HAS TO GO IN GROUP BY
	,SUM([FilmRunTimeMinutes]) AS SUM_RunTime
	,AVG([FilmRunTimeMinutes]) AS AVG_RunTime
	,MAX([FilmRunTimeMinutes]) AS MAX_RunTime
	,MIN([FilmRunTimeMinutes]) AS MIN_RunTime
	,COUNT(*) AS COUNT_RunTime
FROM
	[dbo].[tblFilm]
GROUP BY 
	[FilmCountryID] WITH ROLLUP


-- Example 3(b) (ROLL UP)

SELECT
    [FilmCountryID]
    ,COUNT(*)
FROM
    [dbo].[tblFilm]
GROUP BY
    [FilmCountryID] WITH ROLLUP


-- Example 4 (GROUPBY WITH WHERE)

SELECT
	[FilmCountryID],
	COUNT(*) AS FilmCount
FROM
	[dbo].[tblFilm]
WHERE 
	COUNT(*)>100
GROUP BY 
	[FilmCountryID]

-- IF WHERE IS APPLIED ON THE GROUPBY RESULT, IT GIVES AN ERROR. 
-- AVOID WHERE CONDITION WITH GROUPBY
-- USE HAVING WITH GROUPBY (FOR FILTERING THE RECORDS)


-- Example 5 (CUBE)

SELECT
    [FilmCountryID],
	[FilmLanguageID],
    COUNT(*)
FROM
    [dbo].[tblFilm]
GROUP BY CUBE
    ([FilmCountryID],
	[FilmLanguageID])


--HAVING

SELECT
	[FilmCountryID] AS CountryID --THIS HAS TO GO IN GROUP BY
	,SUM([FilmRunTimeMinutes]) AS SUM_RunTime
	,AVG([FilmRunTimeMinutes]) AS AVG_RunTime
	,MAX([FilmRunTimeMinutes]) AS MAX_RunTime
	,MIN([FilmRunTimeMinutes]) AS MIN_RunTime
	,COUNT(*) AS COUNT_RunTime
FROM
	[dbo].[tblFilm]
GROUP BY 
	[FilmCountryID]
HAVING 
	COUNT(*)>30 --HAVING DOES NOT WORK WITH ALIASES



-- ORDERBY 

-- Example 1

SELECT
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration
FROM
	[dbo].[tblFilm]
ORDER BY
	[FilmRunTimeMinutes] DESC, --ASC is Default option
	NAME ASC /* Same duration films names with be ordered in ascending manner*/

-- Example 2 (ORDER BY ON FIELDS NOT PART OF SELECTION)

SELECT
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration
FROM
	[dbo].[tblFilm]
ORDER BY
	[FilmOscarWins] DESC --[FilmOscarWins] is NOT part of SELECT

-- Example 3

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration,
	[FilmOscarWins] as [Oscar Wins]
FROM
	[dbo].[tblFilm]
WHERE
	[FilmOscarWins]  <> 0
ORDER BY
	[FilmOscarWins] DESC


-- TOP N

-- Example 1

SELECT TOP 10
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration,
	[FilmOscarWins] as [Oscar Wins]
FROM
	[dbo].[tblFilm]
ORDER BY
	[FilmOscarWins] DESC

-- Example 2 (TOP N WITH TIES)

SELECT TOP 10 WITH TIES
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration,
	[FilmOscarWins] as [Oscar Wins]
FROM
	[dbo].[tblFilm]
ORDER BY
	[FilmOscarWins] DESC



-- OFFSET AND FETCH

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmReleaseDate] AS [Date of release],
	[FilmSynopsis] AS Synopsis,
	[FilmRunTimeMinutes] as Duration,
	[FilmOscarWins] as [Oscar Wins]
FROM
	[dbo].[tblFilm]
ORDER BY
	[FilmOscarWins] DESC
OFFSET --SKIP FIRST 5 ROWS
	5 ROWS
FETCH --FETCH NEXT 10 ROWS FROM 6TH ROW
	NEXT 10 ROWS ONLY


-- DISTINCT
SELECT 
	DISTINCT 
		[FilmCountryID] AS COUNTRY_ID,
		[FilmLanguageID] AS LANGUAGE_ID
FROM
	[dbo].[tblFilm]
ORDER BY
	COUNTRY_ID









	