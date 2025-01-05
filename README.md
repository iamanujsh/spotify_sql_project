# Spotify Dataset Analysis

This project focuses on analyzing Spotify's dataset to uncover key insights using SQL. The dataset contains detailed information about tracks, artists, albums, and their characteristics, including duration, danceability, energy, and more.

-- Exploratory Data Analysis (EDA)
SELECT * FROM spotify;

SELECT COUNT(DISTINCT artist) AS [Distinct Artists] FROM spotify;

SELECT COUNT(album) AS [Total Albums] FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) AS [Max Duration] FROM spotify;

SELECT MIN(duration_min) AS [Min Duration] FROM spotify;

SELECT * 
FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;

SELECT DISTINCT channel FROM spotify;

SELECT most_playedon FROM spotify;

-- 1. Retrieve the Names of All Tracks That Have More Than 1 Billion Streams
SELECT * 
FROM dbo.spotify
WHERE stream > 1000000000;

-- 2. List All Albums Along with Their Respective Artists
SELECT artist, album 
FROM dbo.spotify;

-- 3. Get the Total Number of Comments for Tracks Where Licensed = TRUE
SELECT COUNT(comments) AS [Total Comments]
FROM dbo.spotify
WHERE licensed = 1;

-- 4. Find All Tracks That Belong to the Album Type 'Single'
SELECT * 
FROM dbo.spotify 
WHERE album_type = 'single';

-- 5. Count the Total Number of Tracks by Each Artist
SELECT artist, COUNT(track) AS [Total Tracks]
FROM dbo.spotify
GROUP BY artist;

-- 6. Calculate the Average Danceability of Tracks in Each Album
SELECT album, AVG(danceability) AS [Avg Danceability]
FROM dbo.spotify
GROUP BY album;

-- 7. Find the Top 5 Tracks with the Highest Energy Values
SELECT TOP 5 track, energy
FROM dbo.spotify
ORDER BY energy DESC;

-- 8. List All Tracks Along with Their Views and Likes Where official_video = TRUE
SELECT track, views, likes 
FROM dbo.spotify
WHERE official_video = 1;

-- 9. For Each Album, Calculate the Total Views of All Associated Tracks
SELECT album, SUM(views) AS [Total Views]
FROM dbo.spotify
GROUP BY album
ORDER BY album;

-- 10. Retrieve the Track Names That Have Been Streamed on Spotify More Than on YouTube
WITH SeparateStream AS (
    SELECT track,
           COALESCE(SUM(CASE WHEN most_playedon = 'spotify' THEN stream END), 0) AS [Spotify_Stream],
           COALESCE(SUM(CASE WHEN most_playedon = 'youtube' THEN stream END), 0) AS [YouTube_Stream]
    FROM spotify
    GROUP BY track
)
SELECT *
FROM SeparateStream 
WHERE Spotify_Stream > YouTube_Stream 
  AND YouTube_Stream != 0;

-- 11. Find the Top 3 Most Viewed Tracks for Each Artist Using a Window Function
WITH RankView AS (
    SELECT artist, 
           track,
           views,
           ROW_NUMBER() OVER (PARTITION BY artist ORDER BY views DESC) AS [Rank]
    FROM spotify
)
SELECT artist, track, views 
FROM RankView
WHERE [Rank] BETWEEN 1 AND 3;

-- 12. Write a Query to Find Tracks Where the Liveness Score is Above the Average
SELECT track, liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

-- 13. Calculate the Difference Between the Highest and Lowest Energy Values for Tracks in Each Album
WITH Difference AS (
    SELECT album,
           MIN(energy) AS [Min_Energy],
           MAX(energy) AS [Max_Energy]
    FROM spotify
    GROUP BY album
)
SELECT album, Max_Energy - Min_Energy AS [Difference] 
FROM Difference
ORDER BY [Difference] DESC;

-- 14. Find Tracks Where the Energy-to-Liveness Ratio is Greater Than 1.2
SELECT track, 
       energy / liveness AS [Energy_To_Liveness_Ratio]
FROM dbo.spotify
WHERE energy / liveness > 1.2;

-- 15. Calculate the Cumulative Sum of Views for Tracks Ordered by the Number of Views Using Window Functions
SELECT track,
       views,
       SUM(views) OVER (ORDER BY views) AS [Cumulative Views]
FROM spotify;
