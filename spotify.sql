select * from spotify;
#Retrieve the names of all tracks that have more than 1 billion streams.
select track from spotify
where stream>1000000000;
#List all albums along with their respective artists.
select distinct album,artist
from spotify;
#Get the total number of comments for tracks where licensed = TRUE.
select  count(comments)
from spotify
where licensed='true';
#Find all tracks that belong to the album type single.
select track
from spotify
where album_type='single';
#Count the total number of tracks by each artist.
select count(track),artist
from spotify
GROUP by artist
order by 1 desc
#Calculate the average danceability of tracks in each album.
select avg(danceability),album
from spotify
GROUP by album;
Find the top 5 tracks with the highest energy values.
SELECT track, max(energy)
from spotify
group by track
order by 2 desc
limit 5;
#List all tracks along with their views and likes where official_video = TRUE.
select track,sum(views),sum(likes)
from spotify
where official_video='true'
group by track
order by sum(views) desc;
#For each album, calculate the total views of all associated tracks.
select album ,track, sum(views)
from spotify
group by track,album
order by sum(views) desc;
Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from
(select track, most_played_on, coalesce(sum(case when most_played_on='Youtube' then stream end),0) as streamed_on_youtube,
coalesce(sum(case when most_played_on='Spotify' then stream end),0) as streamed_on_spotify
from spotify
group by 1,2) AS t1
where streamed_on_spotify > streamed_on_youtube and 
streamed_on_youtube > 0
#Find the top 3 most-viewed tracks for each artist using window functions.
with cte_1 as(
select artist,track,Sum(views),dense_rank() over (partition by artist order by sum(views) desc) as rnk
from spotify
group by artist,track
order by 1,3 desc)
select * from cte_1
where rnk <=3
#Write a query to find tracks where the liveness score is above the average.
select track,artist,liveness
from spotify
where liveness>(select avg(liveness)from spotify);
#Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
select * from spotify
explain analyze 
with cte_1 as(
select track,album,max(energy) as highest_energy,min(energy) as lowest_energy
from spotify
group by track,album)
select track,album, 
(highest_energy-lowest_energy) as energy_diff
from cte_1
order by 3 desc;
select artist from spotify;
create index arist_index on spotify(artist);

