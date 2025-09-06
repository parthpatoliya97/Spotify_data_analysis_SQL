## SQL Project - Spotify Data Analysis

![spotify image](https://web-mind.io/aa-media/fi/spotify-ai-dj-183-fi-800x.jpg)

#### 🎵 Project Overview
This project analyzes Spotify's music streaming data to understand track popularity, audio features, and platform performance metrics. The analysis provides insights into what makes songs successful across different platforms and how audio characteristics influence listener engagement.

#### Key Objectives
- Identify ultra-popular tracks with billion+ streams
- Analyze album and artist relationships
- Compare platform performance (Spotify vs YouTube)
- Examine audio features like danceability, energy, and liveness
- Track engagement metrics (views, likes, comments)




#### 1️.Retrieve the names of all tracks that have more than 1 billion streams.
```sql
SELECT track 
FROM spotify_data
WHERE streams > 1000000000;
```

#### 2️.List all albums along with their respective artists.
```sql
SELECT DISTINCT album, artist
FROM spotify_data;
```

#### 3️.Get the total number of comments for tracks where licensed = TRUE.
```sql
SELECT SUM(comments) AS total_comments
FROM spotify_data
WHERE licensed = 'TRUE';
```

#### 4️.Find all tracks that belong to the album type Single.
```sql
SELECT track, album_type
FROM spotify_data
WHERE album_type = 'Single';
```

#### 5️.Count the total number of tracks by each artist.
```sql
SELECT artist, COUNT(DISTINCT track) AS total_tracks
FROM spotify_data
GROUP BY artist;
```

#### 6️.Calculate the average danceability of tracks in each album.
```sql
SELECT album, ROUND(AVG(danceability), 2) AS avg_danceability
FROM spotify_data
GROUP BY album
ORDER BY avg_danceability DESC;
```

#### 7️.Find the top 5 tracks with the highest energy values.
```sql
SELECT track, MAX(energy) AS max_energy
FROM spotify_data
GROUP BY track
ORDER BY max_energy DESC
LIMIT 5;
```

#### 8️.List all tracks along with their views and likes where official_video = TRUE.
```sql
SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes
FROM spotify_data
WHERE official_video = 'TRUE'
GROUP BY track;
```

#### 9️.For each album, calculate the total views of all associated tracks.
```sql
SELECT album, SUM(views) AS total_views
FROM spotify_data
GROUP BY album;
```

#### 10.Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
WITH cte AS (
    SELECT 
        track,
        SUM(CASE WHEN most_played_on = 'Spotify' THEN streams ELSE 0 END) AS spotify_streams,
        SUM(CASE WHEN most_played_on = 'Youtube' THEN streams ELSE 0 END) AS youtube_streams
    FROM spotify_data
    GROUP BY track
)
SELECT track, spotify_streams, youtube_streams
FROM cte
WHERE spotify_streams > youtube_streams
  AND youtube_streams <> 0;
```

#### 11.Find the top 3 most-viewed tracks for each artist using window functions.
```sql
WITH cte AS (
    SELECT 
        artist,
        track,
        SUM(views) AS total_views,
        DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rnk
    FROM spotify_data
    GROUP BY artist, track
)
SELECT artist, track, total_views
FROM cte
WHERE rnk <= 3;
```

#### 1️2️.Find tracks where the liveness score is above the average.

- If no duplicate tracks exist:
```sql
SELECT track, artist, energy_liveness
FROM spotify_data
WHERE energy_liveness > (SELECT AVG(energy_liveness) FROM spotify_data);
```

- If duplicate tracks exist:
```sql
WITH cte AS (
    SELECT track, artist, AVG(energy_liveness) AS avg_energy
    FROM spotify_data
    GROUP BY track, artist
)
SELECT track, artist, avg_energy
FROM cte
WHERE avg_energy > (SELECT AVG(avg_energy) FROM cte);
```

#### 1️3️.Calculate the difference between the highest and lowest energy values for tracks in each album.
```sql
WITH cte AS (
    SELECT album, MAX(energy) AS max_energy, MIN(energy) AS min_energy
    FROM spotify_data
    GROUP BY album
)
SELECT album, (max_energy - min_energy) AS energy_diff
FROM cte;
```

#### 1️4️.Find tracks where the energy-to-liveness ratio is greater than 1.2.
```sql
WITH cte AS (
    SELECT 
        track,
        energy,
        energy_liveness,
        (energy / energy_liveness) AS energy_ratio
    FROM spotify_data
)
SELECT track, energy, energy_liveness, energy_ratio
FROM cte
WHERE energy_ratio > 1.2;
```

#### 1️5️.Calculate the cumulative sum of likes for tracks ordered by views, using window functions.
```sql
WITH track_stats AS (
    SELECT 
        artist,
        track,
        SUM(likes) AS total_likes,
        SUM(views) AS total_views
    FROM spotify_data
    GROUP BY artist, track
)
SELECT 
    artist,
    track,
    total_views,
    total_likes,
    SUM(total_likes) OVER (
        PARTITION BY artist 
        ORDER BY total_views DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_likes
FROM track_stats;
```

