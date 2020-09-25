USE MOVIES
GO

-- ALIASES

SELECT
	[DirectorID] ID, --Column name will be changed to ID
	[DirectorDOB] 'D O B', --Column name will be changed to D O B (Incase you have spaces in the text ' ' to be used)
	[DirectorName] [Director Name], --Square Bracket is required if Alias has SPACE. Column name will be changed Director Name
	[DirectorGender]  Gender --Column name will be changed to Gender
FROM
    [dbo].[tblDirector]

--OR Its a good practice to add Aliases with AS

SELECT
	[DirectorID] AS ID, --Column name will be changed to ID
	[DirectorDOB] AS 'D O B', --Column name will be changed to D O B
	[DirectorName] AS [Director Name], --Square Bracket is required if Alias has SPACE. Column name will be changed Director Name
	[DirectorGender]  AS Gender -- Its a good practice to add Aliases with AS
FROM
    [dbo].[tblDirector]

