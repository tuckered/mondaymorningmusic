CREATE DATABASE mondaymusic;

CREATE TABLE songs(
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(400),
  artist VARCHAR(400),
  album VARCHAR(400),
  song_url VARCHAR(500),
  artwork_url VARCHAR(500)
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT
);


CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  username VARCHAR(20), 
  password_digest VARCHAR(400),
  active BOOLEAN
);


CREATE TABLE comments(
  id SERIAL4 PRIMARY KEY,
  content TEXT NOT NULL,
  song_id INTEGER NOT NULL,
  FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE RESTRICT
);


ALTER TABLE comments ADD COLUMN user_id INTEGER

ALTER TABLE comments ADD COLUMN username VARCHAR(100)






INSERT INTO songs (title, artist, album, song_url, artwork_url) VALUES ('Breaking English', 'Rafiq Bhatia', 'Breaking English', 'https://rafiqbhatia.bandcamp.com/track/breaking-english', 'https://f4.bcbits.com/img/a3807931633_16.jpg');