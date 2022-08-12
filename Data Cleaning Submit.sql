/*

In this project, I will clean data from the ObesityFactors table through the use SQL queries.
The purpose of this is to fix any structural errors that may be present in the data, 
to make future querying and visiualzation efforts easier.

*/

-- First I will add a unique identifier to every row in the table due the table not having any built-in unique identifier column. -- 
-- This will make it easier to reference a specific row, if the need for it arises in future queries. --

ALTER TABLE ObesityFactors 
ADD `UniqueID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

SELECT *
FROM ObesityFactors;

-- There are columns within this table without a clear label as to what they represent. 
-- I will rename these ambiguous columns for easier comprehension. --

ALTER TABLE ObesityFactors
RENAME COLUMN YearStart TO SurveyYearStart
;

ALTER TABLE ObesityFactors
RENAME COLUMN YearEnd TO SurveyYearEnd
;

ALTER TABLE ObesityFactors
RENAME COLUMN LocationAbbr TO StateAbbreviation
;

ALTER TABLE ObesityFactors
RENAME COLUMN LocationDesc TO Location
;

ALTER TABLE ObesityFactors
RENAME COLUMN Low_Confidence_Limit TO LowConfidenceIntervalValue
;

ALTER TABLE ObesityFactors
RENAME COLUMN High_Confidence_Limit TO HighConfidenceIntervalValue
;


-- Now, I will populate empty data. --
-- I will replace data that have empty string values with strings such as "No income reported, no race/ethnicity reported" etc. --
-- This will be done for the following columns - GeoLocation, Age(years), Education, Gender, Race/Ethnicity, and Income.   -- 

SELECT GeoLocation, IF(GeoLocation = '', LocationDesc, GeoLocation)
FROM ObesityFactors
WHERE GeoLocation = '' 
;

UPDATE ObesityFactors
SET GeoLocation = IF(GeoLocation = '', LocationDesc, GeoLocation)
WHERE GeoLocation = ''
;

SELECT `Age(years)`, IF(`Age(years)` = '', "Age not reported", `Age(years)`)
FROM ObesityFactors
;

UPDATE ObesityFactors
SET `Age(years)` = IF(`Age(years)` = '', "Age not reported", `Age(years)`)
WHERE `Age(years)` = ''
;

SELECT Education, IF(Education = '', "Education not reported", Education)
FROM ObesityFactors
;

UPDATE ObesityFactors
SET Education = IF(Education = '', "Education not reported", Education)
WHERE Education = ''
;

SELECT Gender, IF(Gender = '', "Gender not reported", Gender)
FROM ObesityFactors
;

UPDATE ObesityFactors
SET Gender = IF(Gender = '', "Gender not reported", Gender)
WHERE Gender = ''
;

SELECT `Race/Ethnicity`, IF(`Race/Ethnicity` = '', "Race/Ethnicity not reported", `Race/Ethnicity`)
FROM ObesityFactors
;

UPDATE ObesityFactors
SET `Race/Ethnicity` = IF(`Race/Ethnicity` = '', "Race/Ethnicity not reported", `Race/Ethnicity`)
WHERE `Race/Ethnicity` = ''
;

SELECT Income, IF(Income = '', "Data not reported", Income)
FROM ObesityFactors
;

UPDATE ObesityFactors
SET Income = IF(Income = '', "Data not reported", Income)
WHERE Income = ''
;

-- There are some strings of data that have unwanted characters, such as "/" or that have an unclear meaning, such as "National" in
-- the location field. I will rename these data points to remove unwanted characters and improve clarity.
-- Renaming "Obesity / Weight Status" to "Obesity and Weight Status" in the Class field. -- 
-- And renaming "National" to "United States" in the Location field. --

SELECT * FROM ObesityFactors;

SELECT DISTINCT(Class), COUNT(Class)
FROM ObesityFactors
GROUP BY Class
ORDER BY 2
;

SELECT Class,
CASE 
WHEN Class = "Obesity / Weight Status" THEN "Obesity and Weight Status"
ELSE Class
END
FROM ObesityFactors
;

UPDATE ObesityFactors
SET Class = 
CASE 
WHEN Class = "Obesity / Weight Status" THEN "Obesity and Weight Status"
ELSE Class
END
;


SELECT DISTINCT(Location), COUNT(Location)
FROM ObesityFactors
GROUP BY Location
ORDER BY 2
;

SELECT Location,
CASE 
WHEN Location = "National" THEN "United States"
ELSE Location
END
FROM ObesityFactors
;

UPDATE ObesityFactors
SET Location = 
CASE 
WHEN Location = "National" THEN "United States"
ELSE Location
END
;


-- Combining the Data_Value_Footnote_Symbol and Date_Value Footnote into one column. --
-- Since these columns state the same information in two columns, I thought it would be best to combine them into one common column. --
-- Once the columns are combined, I will drop the other two columns. 

SELECT *
FROM ObesityFactors;

SELECT Data_Value_Footnote_Symbol, Data_Value_Footnote,
CONCAT(`Data_Value_Footnote_Symbol`, ' ', `Data_Value_Footnote`) AS "Footnote"
FROM ObesityFactors;

ALTER TABLE ObesityFactors
ADD COLUMN Footnote Nvarchar(255);

UPDATE ObesityFactors
SET Footnote = CONCAT(`Data_Value_Footnote_Symbol`, ' ', `Data_Value_Footnote`);

UPDATE ObesityFactors
SET Footnote = IF(Footnote = '', "No footnote", Footnote);

ALTER TABLE ObesityFactors
DROP COLUMN Data_Value_Footnote_Symbol,
DROP COLUMN Data_Value_Footnote;


-- Removing duplicate rows. --
-- I will use a CTE to determine if there are duplicate rows of data in the table by assigning a row number to the entire table and 
-- deleting any rows with a value greater than 1, which indicates that there is a row with the exact same value for all fields as another row. 
-- If there are duplicate rows of data, I will delete them from the original table.


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY SurveyYearStart, 
			     SurveyYearEnd,
                 StateAbbreviation,
                 Location,
                 Datasource,
                 Class,
                 Topic,
                 Question,
                 Data_Value,
                 LowConfidenceIntervalValue,
                 HighConfidenceIntervalValue,
                 Sample_Size,
                 `Age(years)`, 
                 Education,
                 Gender, 
                 Income, 
                 `Race/Ethnicity`,
                 GeoLocation,
                 ClassID,
                 TopicID,
                 QuestionID,
                 LocationID,
                 Footnote
                 ORDER BY
                 UniqueID
                 ) Row_Num
                 
FROM ObesityFactors
)
SELECT *
FROM RowNumCTE
WHERE Row_Num > 1
ORDER BY UniqueID
;


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY SurveyYearStart, 
			     SurveyYearEnd,
                 StateAbbreviation,
                 Location,
                 Datasource,
                 Class,
                 Topic,
                 Question,
                 Data_Value,
                 LowConfidenceIntervalValue,
                 HighConfidenceIntervalValue,
                 Sample_Size,
                 `Age(years)`, 
                 Education,
                 Gender, 
                 Income, 
                 `Race/Ethnicity`,
                 GeoLocation,
                 ClassID,
                 TopicID,
                 QuestionID,
                 LocationID,
                 Footnote
                 ORDER BY
                 UniqueID
                 ) Row_Num
                 
FROM ObesityFactors
)
DELETE ObesityFactorsCopy
FROM RowNumCTE
JOIN ObesityFactors ObesityFactorsCopy USING (UniqueID)
WHERE row_num > 1
;


-- Deleting unused columns. -- 
-- These columns were either completely filled with empty strings or null values, or were duplicates of other columns in the table. 

SELECT *
FROM ObesityFactors;

ALTER TABLE ObesityFactors
DROP COLUMN Data_Value_Alt,
DROP COLUMN Data_Value_Type,
DROP COLUMN Data_Value_Unit,
DROP COLUMN DataValueTypeID,
DROP COLUMN Stratification1,
DROP COLUMN StratificationCategory1,
DROP COLUMN StratificationCategoryId1,
DROP COLUMN StratificationID1,
DROP COLUMN Topic,
DROP COLUMN Total
;


