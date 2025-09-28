-- CREATE TABLES

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

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password TEXT NOT NULL,
  image_url TEXT default 'https://cdn-icons-png.flaticon.com/512/147/147144.png'
);

-- INSERT BOOKS / NOTES INTO DB

INSERT INTO books (title, description, isbn, personal_rating)
VALUES('<Title>', '<Description>', <ISBN>, <Personal Rating>)

INSERT INTO notes(notes, book_id)
VALUES ('<Note>', <ID>)

DELETE FROM books
WHERE id = <ID>

-- UPDATE DB (EDIT DATA)

UPDATE books
SET title = $2,
	description = $3,
	isbn = $4,
	personal_rating = $5,
WHERE id = $1

-- Covers search
-- https://covers.openlibrary.org/b/isbn/<isbn>-M.jpg?default=false