CREATE TABLE albums (
    album_id BIGINT GENERATED ALWAYS AS IDENTITY,
    catalog_code TEXT,
    title TEXT,
    artist TEXT,
    release_date DATE,
    genre TEXT,
    description TEXT,
    CONSTRAINT album_id_key PRIMARY KEY (album_id)
);


CREATE TABLE songs(
    song_id BIGINT GENERATED ALWAYS AS IDENTITY,
    title TEXT,
    composers TEXT,
    album_id BIGINT REFERENCES albums(album_id),
    CONSTRAINT song_id_key PRIMARY KEY (song_id)
);

CREATE INDEX album_id_idx ON songs (album_id);