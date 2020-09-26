--OPERATORS

/*

--ARITHMATIC OPERATORS

1.) +
2.) -
3.) *
4.) /
5.) %

*/

SELECT 20+5
SELECT 20-5
SELECT 20*5
SELECT 20/5
SELECT 20%5 --MOD (REMAINDER AS OUTPUT)

/*

--ASSIGNMENT OPERATOR
1.) =

*/

SELECT * FROM  [dbo].[tblCast] WHERE [CastActorID]=5

/*
--COMPARISON OPERATORS

1.) >
2.) <
3.) >=
4.) <=
5.) != / <>
6.) !>
7.) !<

*/

SELECT * FROM [dbo].[tblFilm] WHERE [FilmRunTimeMinutes] > 100 --B
SELECT * FROM [dbo].[tblFilm] WHERE [FilmRunTimeMinutes] < 100 --A
SELECT * FROM [dbo].[tblFilm] WHERE [FilmRunTimeMinutes] >= 200
SELECT * FROM [dbo].[tblFilm] WHERE [FilmRunTimeMinutes] <= 90
SELECT * FROM [dbo].[tblFilm] WHERE [FilmRunTimeMinutes] <> 150

SELECT * FROM [dbo].[tblFilm] WHERE [FilmRunTimeMinutes] !> 100 --A
SELECT * FROM [dbo].[tblFilm] WHERE [FilmRunTimeMinutes] !< 100 --B

/*
--LOGICAL OPERATORES

1.) AND
2.) OR
3.) NOT
4.) IN
5.) BETWEEN AND
6.) LIKE
7.) IS NULL
8.) ANY
9.) EXIST
10.) SOME

*/

SELECT * FROM [dbo].[tblFilm] WHERE [FilmCountryID]=241 AND [FilmRunTimeMinutes] > 100
SELECT * FROM [dbo].[tblFilm] WHERE [FilmCountryID]=241 OR [FilmCountryID]=240
SELECT * FROM [dbo].[tblFilm] WHERE NOT [FilmCountryID]=241 AND NOT [FilmCountryID]=240
SELECT * FROM [dbo].[tblFilm] WHERE [FilmCountryID] IN (240,241)
SELECT * FROM [dbo].[tblFilm] WHERE [FilmRunTimeMinutes] BETWEEN 100 AND 200

SELECT * FROM [dbo].[tblFilm] WHERE [FilmName] LIKE '%LETHAL%'
/* 
IT IS IMPORTANT TO UNDERSTAND WILDCARDS HERE:
SOURCE : https://www.w3schools.com/sql/sql_like.asp
% - means multiple characters
_ - means single characters
'a%'- Finds any values that start with "a"
'%a' -Finds any values that end with "a"
'%or%' - Finds any values that have "or" in any position
'_r%' - Finds any values that have "r" in the second position
'a_%' - Finds any values that start with "a" and are at least 2 characters in length
'a__%' - Finds any values that start with "a" and are at least 3 characters in length
'a%o' - Finds any values that start with "a" and ends with "o"
*/

/*
--SET OPERATORS
https://www.youtube.com/watch?v=MX9xK-BXLj0&list=PLd3UqWTnYXOkDmQvCVKsXeoGeocusMP4i&index=42
https://www.youtube.com/watch?v=R8DxXBEE53w&list=PLd3UqWTnYXOkDmQvCVKsXeoGeocusMP4i&index=43
https://sql-programmers.com/set-operators-in-sql-server-union-union-all-intersect-except

1.) UNION			(WITHOUT DUPLICATE)
2.) UNION ALL		(WITH DUPLICATE)
3.) INTERSECT		(RETURNS COMMON VALUES IN BOTH SOURCE & DESTINATION)
4.) EXCEPT			(RETURNS ALL VALUES FROM LHS TABLE WHICH ARE NOT FOUND IN RHS TABLE)

PRE-CONDITION FOR SET OPERATORS:

A.) NUMBER OF THE COLUMNS SHOULD BE SAME IN BOTH SOURCE & DESTINATION
B.) ORDER OF COLUMN MUST BE SAME IN BOTH SOURCE & DESTINATION
C.) DATA TYPE OF COLUMN MUST BE SAME IN BOTH SOURCE & DESTINATION

*/

--DATA PREPARATION FOR DEMO OF SET OPERATORS
SELECT * INTO DEMOFILM1 FROM [dbo].[tblFilm] WHERE [FilmCountryID]<>241
SELECT * INTO DEMOFILM2 FROM [dbo].[tblFilm] WHERE [FilmCountryID]=241
SELECT * INTO DEMOFILMFULL FROM [dbo].[tblFilm]

SELECT * FROM DEMOFILM1 -- 50 ROWS
SELECT * FROM DEMOFILM2 -- 210 ROWS
SELECT * FROM DEMOFILMFULL --260 ROWS
SELECT * FROM [dbo].[tblFilm] --260 ROWS

-- UNION (WITHOUT DUPLICATE)
-- RESULT WILL HAVE 260 ROWS

SELECT * FROM DEMOFILM1
UNION
SELECT * FROM DEMOFILMFULL

-- UNION ALL (WITH DUPLICATE)
-- RESULT WILL HAVE 310 ROWS

SELECT * FROM DEMOFILM1
UNION ALL
SELECT * FROM DEMOFILMFULL

--INTERSECT (RETURNS COMMON VALUES IN BOTH SOURCE & DESTINATION)
--RESULT WILL HAVE ZERO ROWS AS BOTH TABLES HAVE UNIQUE ROWS
SELECT * FROM DEMOFILM1
INTERSECT
SELECT * FROM DEMOFILM2

SELECT * FROM DEMOFILM1
INTERSECT
SELECT * FROM DEMOFILMFULL
--RESULT WILL HAVE 50 ROWS AS DEMOFILM1 (COMMON VALUES)

SELECT * FROM DEMOFILM2
INTERSECT
SELECT * FROM DEMOFILMFULL
--RESULT WILL HAVE 210 ROWS AS DEMOFILM1 (COMMON VALUES)

--EXCEPT
SELECT * FROM DEMOFILM2
EXCEPT
SELECT * FROM DEMOFILMFULL
--RESULT WILL HAVE ZERO ROWS AS ALL RECORDS IN TABLE 1 ARE PRESENT IN TABLE 2
--NOW MANUALLY ADD ONE ROW IN DEMOFILM2

INSERT INTO DEMOFILM2 ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins]) VALUES (999, N'Munna Bhai', CAST(0x00008DE000000000 AS DateTime), 39, 1, 241, 6, N'My Test', 136, 5, 65000000, 456500000, 4, 4)

SELECT * FROM DEMOFILM2
EXCEPT
SELECT * FROM DEMOFILMFULL