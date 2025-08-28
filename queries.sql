--Create tables

CREATE TABLE books (
	id SERIAL PRIMARY KEY,
	title VARCHAR(100),
	description TEXT
);

CREATE TABLE notes (
	id SERIAL PRIMARY KEY,
	notes TEXT,
	book_id INT REFERENCES books(id)
);