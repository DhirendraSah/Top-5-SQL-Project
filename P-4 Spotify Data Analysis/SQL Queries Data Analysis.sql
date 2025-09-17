-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

select * from spotify
limit 100

--EDA
select count(*) from spotify;

select distinct artist from spotify;

select distinct album from spotify;

select distinct album_type from spotify;

select max(duration_min) from spotify;

select min(duration_min) from spotify;

delete from spotify
where duration_min = 0;

select * from spotify
where duration_min = 0;

select distinct channel from spotify;

select distinct most_played_on from spotify;

----------------------------
--Easy Level
----------------------------
--Retrieve the names of all tracks that have more than 1 billion streams.
select * from spotify;
select track,stream from spotify
where stream > 1000000000
order by 2;

--List all albums along with their respective artists.
select album,artist from spotify;

--Get the total number of comments for tracks where licensed = TRUE.

select distinct track,comments
from spotify
where licensed = 'true'
order by 2 desc;


--Find all tracks that belong to the album type single.
select * from spotify
where album_type = 'single';

--Count the total number of tracks by each artist.
select distinct artist, count(track)
from spotify
group by 1;

-------------------------------
Medium Level
-------------------------------
--Calculate the average danceability of tracks in each album.
select * from spotify
select album,
	avg(danceability) as avg_Danceability
from spotify
group by 1
order by 2 desc;

--Find the top 5 tracks with the highest energy values.
select track,max(energy) from spotify
group by 1
order by 2 desc
limit 5;

--List all tracks along with their views and likes where official_video = TRUE.
select distinct track,
	sum(views) as t_views,sum(likes) as total_likes
from spotify
where official_video = 'true'
group by 1;

--For each album, calculate the total views of all associated tracks.
select distinct album,track,sum(views)
from spotify
group by 1,2

--Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from(
select track ,
	coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as Stream_on_Youtube,
	coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as Stream_on_Spotify
from spotify
group by 1) as t1 
where Stream_on_Spotify > Stream_on_Youtube
and Stream_on_Youtube <> 0;

-----------------------------
--Advanced Level
-----------------------------
--Find the top 3 most-viewed tracks for each artist using window functions.
with ranking_artist
as (
select artist,track,sum(views),
	dense_rank() over(partition by artist order by sum(views) desc) as rank
from spotify
group by 1,2
order by 1,3 desc)

select * from ranking_artist
where rank<=3;

--Write a query to find tracks where the liveness score is above the average.
select track,artist,liveness
from spotify
where liveness>(select(avg(liveness)) from spotify);

--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC
	