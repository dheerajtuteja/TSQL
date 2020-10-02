-- SOURCE: WHITEOWL YOUTUBE
-- https://www.youtube.com/watch?v=JvpFp7E9iFE&list=PL6EDEB03D20332309&index=4 
-- https://www.youtube.com/watch?v=zlgrhj2D63E&list=PL6EDEB03D20332309&index=5
-- https://www.wiseowl.co.uk/blog/s330/case-when.htm
-- https://www.wiseowl.co.uk/blog/s330/case-when.htm

USE MOVIES
GO

--CALCULATED COLUMN
SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmBudgetDollars] AS BUDGET,
	[FilmBoxOfficeDollars] AS REVENUE,
	[FilmBoxOfficeDollars]-[FilmBudgetDollars] AS MARGIN
FROM
	[dbo].[tblFilm]


--CALCULATED COLUMN WITH ORDER BY
SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmBudgetDollars] AS BUDGET,
	[FilmBoxOfficeDollars] AS REVENUE,
	[FilmBoxOfficeDollars]-[FilmBudgetDollars] AS MARGIN
FROM
	[dbo].[tblFilm]
ORDER BY
	MARGIN DESC

--CALCULATED COLUMN WITH WHERE AND ORDER BY
SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmBudgetDollars] AS BUDGET,
	[FilmBoxOfficeDollars] AS REVENUE,
	[FilmBoxOfficeDollars]-[FilmBudgetDollars] AS MARGIN
FROM
	[dbo].[tblFilm]
WHERE
	[FilmBoxOfficeDollars]-[FilmBudgetDollars]>0
ORDER BY
	MARGIN DESC

--CALCULATED COLUMN WITH DATATYPE
SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmBudgetDollars] AS BUDGET,
	[FilmBoxOfficeDollars] AS REVENUE,
	[FilmRunTimeMinutes] AS DURATION_IN_MINUTES,
	[FilmRunTimeMinutes]/60.0 AS DURATION_IN_HOURS --CHANGE 60 TO 60.0
FROM
	[dbo].[tblFilm]

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmBudgetDollars] AS BUDGET,
	[FilmBoxOfficeDollars] AS REVENUE,
	[FilmRunTimeMinutes] AS TOTAL_DURATION_IN_MINUTES,
	[FilmRunTimeMinutes]/60 AS DURATION_IN_HOURS,
	[FilmRunTimeMinutes]%60 AS DURATION_IN_MIN --% MEANS MOD (RETURNS REMAINDER)
FROM
	[dbo].[tblFilm]


-- CASE STATEMENT

SELECT
	FilmName,
	FilmOscarWins,
CASE FilmOscarWins
	WHEN 0 THEN 'Not a winner'
	WHEN 1 THEN 'Single Oscar'
	WHEN 2 THEN 'Double'
	ELSE 'Lots'
END AS Oscars
FROM tblFilm

-- NESTED CASE 

-- Divide actors up into male/female, and by age
SELECT
	ActorName,
	ActorGender,
	CONVERT(char(10),ActorDob,103) AS Dob,
	-- male or female
	CASE ActorGender
	WHEN 'Male' THEN
		CASE
			WHEN Year(ActorDob) < 1980 THEN 'Man'
			ELSE 'Boy'
		END
	WHEN 'Female' THEN
		CASE
			WHEN Year(ActorDob) < 1980 THEN 'Woman'
			ELSE 'Girl'
		END
	ELSE 'Other'
	END AS Category
FROM tblActor


--CASE STATEMENT - IT HAS TO TREATED AS A CALCULATED COLUMN

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmBudgetDollars] AS BUDGET,
	[FilmBoxOfficeDollars] AS REVENUE,
	[FilmRunTimeMinutes] AS DURATION_IN_MINUTES,
	[FilmRunTimeMinutes]/60.0 AS DURATION_IN_HOURS, --CHANGE 60 TO 60.0
	CASE
		WHEN [FilmRunTimeMinutes]/60.0 >2.5 THEN 'VERY LONG MOVIE'
		WHEN [FilmRunTimeMinutes]/60.0 BETWEEN 2 AND 2.5 THEN 'LONG MOVIE'
		WHEN [FilmRunTimeMinutes]/60.0 BETWEEN 1.5 AND 2 THEN 'MID LENGTH MOVIE'
		WHEN [FilmRunTimeMinutes]/60.0 < 1.5 THEN 'SHORT MOVIE'
		ELSE 'SUPER SHORT MOVIE'
	END AS MOVIE_DURATION_GRADE--ADD ALIAS HERE FOR CASE
FROM
	[dbo].[tblFilm]
ORDER BY
	[FilmRunTimeMinutes] DESC



--CASE STATEMENT WITH WHERE

SELECT 
	[FilmID] AS ID,
	[FilmName] AS NAME,
	[FilmBudgetDollars] AS BUDGET,
	[FilmBoxOfficeDollars] AS REVENUE,
	[FilmRunTimeMinutes] AS DURATION_IN_MINUTES,
	[FilmRunTimeMinutes]/60.0 AS DURATION_IN_HOURS, --CHANGE 60 TO 60.0
	CASE
		WHEN [FilmRunTimeMinutes]/60.0 >2.5 THEN 'VERY LONG MOVIE'
		WHEN [FilmRunTimeMinutes]/60.0 BETWEEN 2 AND 2.5 THEN 'LONG MOVIE'
		WHEN [FilmRunTimeMinutes]/60.0 BETWEEN 1.5 AND 2 THEN 'MID LENGTH MOVIE'
		WHEN [FilmRunTimeMinutes]/60.0 < 1.5 THEN 'SHORT MOVIE'
		ELSE 'SUPER SHORT MOVIE'
	END AS MOVIE_DURATION_GRADE--ADD ALIAS HERE FOR CASE
FROM
	[dbo].[tblFilm]
WHERE -- SINCE WHERE DOESN'T ALLOW ALIASES, THEREFORE COMPLETE CASE HAS TO MENTION
	CASE
		WHEN [FilmRunTimeMinutes]/60.0 >2.5 THEN 'VERY LONG MOVIE'
		WHEN [FilmRunTimeMinutes]/60.0 BETWEEN 2 AND 2.5 THEN 'LONG MOVIE'
		WHEN [FilmRunTimeMinutes]/60.0 BETWEEN 1.5 AND 2 THEN 'MID LENGTH MOVIE'
		WHEN [FilmRunTimeMinutes]/60.0 < 1.5 THEN 'SHORT MOVIE'
		ELSE 'SUPER SHORT MOVIE'
	END = 'VERY LONG MOVIE' --(WHERE MOVIE_DURATION_GRADE = 'VERY LONG MOVIE')
ORDER BY
	[FilmRunTimeMinutes] DESC