-- PIVOT
-- https://www.wiseowl.co.uk/blog/s417/sql-pivot-operator.htm
-- https://www.youtube.com/watch?v=C37-SKZDsdU&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H&index=17

USE MOVIES
GO

SELECT
   COUNTRYNAME,
   COUNT(FILMID) AS [COUNT OF FILMS] 
FROM
   TBLFILM AS F 
   INNER JOIN
      TBLCOUNTRY AS C 
      ON C.COUNTRYID = F.FILMCOUNTRYID 
GROUP BY
   COUNTRYNAME

-- STEP 1 : USE CTE
-- STEP 2 : ADD PIVOT OPERATOR

-- EXAMPLE 1

--create a CTE
;WITH BaseData AS 
(
   SELECT
      CountryName,
      FilmID 
   FROM
      tblFilm AS f 
      INNER JOIN
         tblCountry AS c 
         ON c.CountryID = f.FilmCountryID 
)
--Select everything from the CTE
SELECT
   * 
FROM
   BaseData 	
--pivot the data
PIVOT ( COUNT(FilmID) --pivot this column
FOR CountryName --convert these values into column names
IN 
(
   [China] , [France] , [Germany] , [Japan] , [New Zealand] , [Russia] , [United Kingdom] , [United States] 
)
) AS PivotTable




-- EXAMPLE 2

--create a CTE
;WITH BaseData AS 
(
   SELECT
      CountryName 		--Include this extra column
,
      YEAR(FilmReleaseDate) AS [FilmYear],
      FilmID 
   FROM
      tblFilm AS f 
      INNER JOIN
         tblCountry AS c 
         ON c.CountryID = f.FilmCountryID 
)
--Select everything from the CTE
SELECT
   * 
FROM
   BaseData 	--Pivot the data
   PIVOT ( COUNT(FilmID) 	--Pivot on this column
   FOR CountryName 	--Convert these values into column names
   IN 
   (
      [China],
      [France],
      [Germany],
      [Japan],
      [New Zealand],
      [Russia],
      [United Kingdom],
      [United States] 
   )
) AS PivotTable 	--Optionally, sort the results
ORDER BY
   FilmYear DESC


-- DYNAMIC PIVOT : https://www.wiseowl.co.uk/blog/s417/sql-dynamic-pivot.htm