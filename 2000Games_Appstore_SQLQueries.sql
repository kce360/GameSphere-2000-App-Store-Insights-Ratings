SELECT *
FROM GamesAppstore

----Cleaning-----
UPDATE GamesAppstore
SET artistName = TRIM(artistName);

--Checking for non-english characters and removing them
SELECT* FROM GamesAppstore
 WHERE artistName LIKE '%[^ -~]%' COLLATE Latin1_General_BIN;

 DELETE FROM GamesAppstore
 WHERE artistName LIKE '%[^ -~]%' COLLATE Latin1_General_BIN;

 ---Changing data types
ALTER TABLE GamesAppstore
ALTER COLUMN averageUserRating FLOAT;

ALTER TABLE GamesAppstore
ALTER COLUMN averageUserRatingForCurrentVersion FLOAT;

--checkin for non-numeric values
SELECT *
FROM GamesAppstore
WHERE ISNUMERIC(minimumOsVersion) = 0;

--replacing values like x.x.x to x.x and cast them as decimals
UPDATE GamesAppstore
SET minimumOsVersion = CAST(REPLACE(minimumOsVersion, '.', '') AS DECIMAL(10, 1))
WHERE ISNUMERIC(minimumOsVersion) = 0;

ALTER TABLE GamesAppstore
ALTER COLUMN minimumOsVersion DECIMAL(5, 1);

ALTER TABLE GamesAppstore
ALTER COLUMN price DECIMAL(5, 1);

--checking for non-numerical values
SELECT *
FROM GamesAppstore
WHERE ISNUMERIC(price) = 0;

--replacing blanks with 0.0
UPDATE GamesAppstore
SET price = 
    CASE 
        WHEN price = '' THEN '0.0'
        ELSE price
    END
WHERE ISNUMERIC(price) = 0 OR price = '';

 --fixing some values left in a wrong format xxxx.x
UPDATE GamesAppstore
SET minimumOsVersion = minimumOsVersion / 100.0
WHERE minimumOsVersion >= 17;

ALTER TABLE GamesAppstore
ALTER COLUMN fileSizeBytes BIGINT;

ALTER TABLE GamesAppstore
ALTER COLUMN userRatingCount BIGINT;

--formatting date
SELECT FORMAT(CAST(releaseDate AS DATE), 'dd.MM.yyyy') AS formatted_releaseDate
FROM GamesAppstore;

ALTER TABLE GamesAppstore
ADD formatted_releaseDate NVARCHAR(20);

UPDATE GamesAppstore
SET formatted_releaseDate = FORMAT(CAST(releaseDate AS DATE), 'dd.MM.yyyy');

ALTER TABLE GamesAppstore
DROP COLUMN releaseDate;

--checking if Game Center integration tend to have higher user ratings
 SELECT 
    isGameCenterEnabled,
    AVG(averageUserRating) AS avg_user_rating
FROM 
    GamesAppstore
GROUP BY 
    isGameCenterEnabled;

--making bins to calculate the average user rating for games of different sizes 
ALTER TABLE GamesAppstore
ADD fileSizeCategory VARCHAR(50);

UPDATE GamesAppstore
SET fileSizeCategory = 
    CASE
        WHEN fileSizeBytes < 100000000 THEN 'Small'    
        WHEN fileSizeBytes < 3000000000 THEN 'Medium'
        ELSE 'Large'
    END;
--checking if the data is correct
SELECT *
FROM GamesAppstore
ORDER BY
    fileSizeBytes DESC;

SELECT COUNT(*) AS large_count
FROM GamesAppstore
WHERE fileSizeCategory = 'Large';


--calcualting average user rating by artist to check if averageUserRating is correct
ALTER TABLE GamesAppstore
ADD averageUserRatingByArtist Float;

UPDATE GamesAppstore
SET averageUserRatingByArtist = (
    SELECT AVG(averageUserRating)
    FROM GamesAppstore AS innerTable
    WHERE innerTable.artistName = GamesAppstore.artistName
    GROUP BY innerTable.artistName
);
--checking if it is working
SELECT DISTINCT trackName, averageUserRating, averageUserRatingByArtist
FROM GamesAppstore
ORDER BY
    averageUserRatingByArtist DESC;