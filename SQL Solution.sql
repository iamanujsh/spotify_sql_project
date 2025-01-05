
CREATE DATABASE Spotify_db

use Spotify_db
-- create table
DROP TABLE IF EXISTS spotify;

--EDA

select * from spotify

select count(distinct artist) from spotify

select count(album) from spotify

select distinct album_type from spotify

select max(duration_min) from spotify

select MIN(duration_min) from spotify

select * from spotify
where duration_min = 0

delete from spotify
where duration_min = 0

select distinct channel from spotify

select most_playedon from spotify

--1 Retrieve the names of all tracks that have more than 1 billion streams.

select * from 
dbo.spotify
where stream > 1000000000

--2 List all albums along with their respective artists.

select artist, album from dbo.spotify

--3 Get the total number of comments for tracks where licensed = TRUE.


select count(comments) [Total Comments]
from dbo.spotify
where licensed = 1

--4 Find all tracks that belong to the album type single.


select * 
from dbo.spotify 
where album_type = 'single'


--5 Count the total number of tracks by each artist.

select artist , count(track) [total_track]
from dbo.spotify
group by artist

--6 calculate the average danceability of tracks in each album

select album , avg(danceability) [AVG Danceability]
from dbo.spotify
group by album

--7 find the top 5 tracks with the highest energy values

select top 5 track , energy
from dbo.spotify
order by energy desc


-- 8 List all tracks along with their views and likes where official_video = TRUE

select track , views, likes 
from dbo.spotify
where official_video = 1


-- 9 for each album calculate the total views of all associated tracks

select album ,sum(views) as [total View]
from dbo.spotify
group by album
order by album

-- 10 retrive the track names that have been streamed on spotify more than youtube

WITH SeperateStream AS(
select 
track,
COALESCE(sum(case
	when most_playedon = 'spotify' then stream 
end) , 0)  [Spotify_stream],
COALESCE(sum(case 
	when most_playedon = 'youtube' then stream
end
) ,0 ) [Youtube_stream]
from spotify
group by track
)
select * 
from SeperateStream 
where spotify_stream > youtube_stream
	AND Youtube_stream  != 0


-- 11 find the top 3 most viewed tracks for each artist using window function

WITH RankView AS(
select artist, 
track,
views,
ROW_NUMBER() OVER(PARTITION BY artist ORDER BY views desc) [Rank]
from spotify
)
select artist, track , views from RankView
where Rank BETWEEN 1 AND 3

-- 12 Write a query to find track where the liveness score is above the average

select track , liveness
from spotify
where liveness > (select avg(liveness) from spotify)

-- 13 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH Difference AS (
	select album ,
		min(energy) [Min_energy],
		max(energy) [Max_energy]
	from spotify
	group by album
)
select album , Max_energy - Min_energy [Diff] 
from Difference
order by Max_energy - Min_energy desc

-- 14 Find tracks where the energy-to-liveness ratio is greater than 1.2.

select track , energy / liveness [Energy To Liveness Ration]
from dbo.spotify
where energy / liveness > 1.2

-- 15 Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

select 
track ,
views,
sum(views) OVER(ORDER BY Views) [Commulative View]
from spotify





















































