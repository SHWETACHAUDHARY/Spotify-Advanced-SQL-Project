--Create Spotify table 1st and then Import Data from CSV 
DROP table if exists spotify
Create table spotify
(
		Artist varchar(55),	
		Track varchar(250),	
		Album varchar(250),	
		Album_type varchar(50),	
		Danceability Float,	
		Energy Float,	
		Loudness Float,	
		Speechiness Float,	
		Acousticness Float,	
		Instrumentalness Float,	
		Liveness Float,	
		Valence Float,	
		Tempo Float,	
		Duration_min Float,	
		Title varchar(250),	
		Channel varchar(150),	
		Views BigInt,	
		Likes Bigint,	
		Comments Bigint,	
		Licensed Boolean,	
		official_video Boolean,	
		Stream FLOAT,	
		EnergyLiveness FLOAT,	
		most_playedon varchar(15)

)
Select * from spotify
-- Filter null records 
Select * from spotify where 
			Artist is null or 	
			Track is null or	
			Album is null or	
			Album_type is null or	
			Danceability is null or	
			Energy is null or	
			Loudness is null or	
			Speechiness is null or	
			Acousticness is null or	
			Instrumentalness is null or	
			Liveness is null or	
			Valence is null or	
			Tempo is null or	
			Duration_min is null or	
			Title is null or	
			Channel is null or	
			Views is null or	
			Likes is null or	
			Comments is null or	
			Licensed is null or	
			official_video is null or	
			Stream is null or	
			EnergyLiveness is null or	
			most_playedon is null
)
-- delete those 2 identified null records
Delete from spotify where 
( 
			Artist is null or 	
			Track is null or	
			Album is null or	
			Album_type is null or	
			Danceability is null or	
			Energy is null or	
			Loudness is null or	
			Speechiness is null or	
			Acousticness is null or	
			Instrumentalness is null or	
			Liveness is null or	
			Valence is null or	
			Tempo is null or	
			Duration_min is null or	
			Title is null or	
			Channel is null or	
			Views is null or	
			Likes is null or	
			Comments is null or	
			Licensed is null or	
			official_video is null or	
			Stream is null or	
			EnergyLiveness is null or	
			most_playedon is null
)

Select * from spotify
--Now let's start with ssolving the business queries 
--1. Retrieve the names of all tracks that have more than 1 billion streams.

Select track,stream from spotify where spotify.stream>1000000000 order by stream desc

--2. List all albums along with their respective artists.
Select spotify.album,spotify.artist from spotify group by album,artist order by artist
Select distinct spotify.album from spotify 
Select distinct spotify.artist from spotify 

--3. Get the total number of comments for tracks where licensed = TRUE.
Select * from spotify
Select sum(comments) as total_comments from spotify where licensed=True
--4. Find all tracks that belong to the album type single.
Select * from spotify
Select track from spotify where album_type='single'
--5. Count the total number of tracks by each artist.
Select * from spotify
Select distinct spotify.artist from spotify 
Select artist, count(*) as total_track from spotify group by artist order by total_track asc
-- logic: Get sum of all the tracks which was grouped by artist 
With t1 as (
Select artist, count(*) as total_track from spotify group by artist order by total_track asc
) select sum(total_track) as sum_of_tracks from t1


-- **Medium Level**

--1. Calculate the average danceability of tracks in each album.
Select * from spotify 
Select album, round(avg(danceability)::numeric,2)  as avg_danceability from spotify group by album 
--2. Find the top 5 tracks with the highest energy values.
Select * from spotify 
Select track,energyliveness  from spotify order by energyliveness desc limit 5 

--3. List all tracks along with their views and likes where official_video = TRUE.
Select * from spotify 
Select track,views,likes, official_video from spotify where official_video=True

--4. For each album, calculate the total views of all associated tracks.
Select * from spotify 
Select album, sum(views) as total_views from spotify group by album order by total_views desc 

--5. Retrieve the track names that have been streamed on Spotify more than YouTube.
Select * from spotify
Select track,stream,views, most_playedon from spotify  where stream>views

--OR below query, Gives same result 
Select track,stream,views,most_playedon  from spotify  where most_playedon='Spotify'

--**Advanced Level**
--1. Find the top 3 most-viewed tracks for each artist using window functions.
Select * from spotify 
-- logic: 1st add rank to top 3 tracks group by artist and then get only those whose rank<=3 
With t1 as (
	Select artist, track, views, 
		rank() over
		(
		partition by artist 
		order by views desc
		) as rank 
	from spotify)
Select * from t1 where rank<=3 
--2. Write a query to find tracks where the liveness score is above the average.
Select * from spotify 
With t1 as 
(
	Select avg(liveness) as Average_liveness from spotify 
)Select track, liveness from spotify where liveness>(select Average_liveness from t1)

--or using windows function 
Select title, liveness from 
(
	Select *,avg(liveness) over() as Avg_Liveness  from spotify
) where liveness>Avg_Liveness


--3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
Select * from spotify
With t1 as (
Select album,
	max(energy) as track_highenergy, 
	min(energy)as track_lowenergy 
from spotify group by album
)
Select album, track_highenergy,track_lowenergy,track_highenergy-track_lowenergy as diff from t1 

--4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
With t1 as (
Select track, energy,liveness, round((energy/liveness)::numeric,2) as ratio from spotify
) select * from t1  where ratio>1.2

--5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
Select track, views, likes,
sum(likes) over(order by views ) as  cumulative_sum from spotify where views<>0 AND likes<>0



