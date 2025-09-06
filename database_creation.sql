create database spotify;
use spotify;


CREATE TABLE spotify_data (
	artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability DECIMAL(5,3),
    energy DECIMAL(5,3),
    loudness DECIMAL(6,3),
    speechiness DECIMAL(6,5),
    acousticness DECIMAL(6,5),
    instrumentalness DECIMAL(6,5),
    liveness DECIMAL(5,3),
    valence DECIMAL(5,3),
    tempo DECIMAL(6,3),
    duration_min DECIMAL(6,3),
    title VARCHAR(255),
    channel VARCHAR(255),
    views BIGINT,
    likes BIGINT,
    comments BIGINT,
    licensed VARCHAR(5),       
    official_video VARCHAR(5),   
    streams BIGINT,
    energy_liveness DECIMAL(6,3),
    most_played_on VARCHAR(50)
);
