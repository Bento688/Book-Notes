--Create tables

CREATE TABLE books (
	id SERIAL PRIMARY KEY,
	title VARCHAR(100),
	description TEXT,
	isbn VARCHAR(20),
	personal_rating DECIMAL(3,1)
);

CREATE TABLE notes (
	id SERIAL PRIMARY KEY,
	notes TEXT,
	book_id INT REFERENCES books(id)
);

INSERT INTO books (title, description, isbn, personal_rating)
VALUES('<Title>', '<Description>', <ISBN>, <Personal Rating>)

INSERT INTO notes(notes, book_id)
VALUES ('<Note>', <ID>)

-- Covers search
-- https://covers.openlibrary.org/b/isbn/<isbn>-M.jpg?default=false