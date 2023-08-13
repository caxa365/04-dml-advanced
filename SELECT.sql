#1.Количество исполнителей в каждом жанре

select genre_name, count(id_artist_ag) from Genres 
join Artists_Genres on Genres.id_genre = Artists_Genres.id_genre_ag
group by genre_name

#2.Количество треков, вошедших в альбомы 2019-2020 годов

select count(album_name) from Tracks
join albums on Tracks.id_album_t = Albums.id_album
where album_release_year >= '20190101' and album_release_year <= '20201231'

#3.Средняя продолжительность треков по каждому альбому
select album_name, avg(track_duration) from Tracks
join Albums on Tracks.id_album_t = Albums.id_album
group by album_name

#4.Все исполнители, которые не выпустили альбомы в 2020 году
SELECT DISTINCT artist_name FROM Artists
WHERE artist_name != (
	SELECT Artists.artist_name FROM Artists 
	JOIN Artists_Album  ON Artists.id_artist = Artists_Album.id_artist_aa
	JOIN Albums ON Albums.id_album = Artists_Album.id_album_aa 
	WHERE album_release_year BETWEEN '2020-01-01' AND '2020-12-31');

#5.Названия сборников, в которых присутствует конкретный исполнитель (выбрана Taylor Swift)
select collection_title from Collections
join Collection_Tracks on Collection_Tracks.id_collection_ct = Collections.id_collection
join Tracks on Collection_Tracks.id_track_ct = Tracks.id_track
join Albums on Tracks.id_album_t = Albums.id_album
join Artists_Album on Artists_Album.id_album_aa = Albums.id_album
join Artists on Artists_Album.id_artist_aa = Artists.id_artist
where artist_name = 'Taylor Swift'


#6.Название альбомов, в которых присутствуют исполнители более 1 жанра
select album_name, count(genre_name) from Albums 
join Artists_Album on Albums.id_album = Artists_Album.id_album_aa 
join Artists on Artists_Album.id_artist_aa = Artists.id_artist 
join Artists_Genres on Artists.id_artist = Artists_Genres.id_artist_ag 
join Genres on Genres.id_genre = Artists_Genres.id_genre_ag 
group by album_name 
having count(genre_name) > 1

#7.Наименование треков, которые не входят в сборники
select track_name from Tracks
left join Collection_Tracks on Tracks.id_track = Collection_Tracks.id_track_ct
where id_collection_ct is null

#8.Исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько)
select artist_name, track_duration from Tracks
join Albums on Tracks.id_album_t = Albums.id_album
join Artists_Album on Artists_Album.id_album_aa = Albums.id_album
join Artists on Artists_Album.id_artist_aa = Artists.id_artist 
where track_duration = (select min(track_duration) from tracks)


select album_name, count(track_name) from Tracks
join Albums on Tracks.id_album_t = Albums.id_album
group by album_name

#9.Название альбомов, содержащих наименьшее количество треков

SELECT album_name, COUNT(track_name) FROM Tracks
    JOIN Albums  ON Tracks.id_album_t = Albums.id_album
    GROUP BY album_name 
    HAVING count(track_name) in (
        SELECT COUNT (track_name)
        FROM Tracks
        JOIN Albums  ON Tracks.id_album_t = Albums.id_album
        GROUP BY album_name
        ORDER BY count(track_name)\
        LIMIT 1)
