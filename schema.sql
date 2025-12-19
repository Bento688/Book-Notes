-- 1. Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Create Users Table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password TEXT NOT NULL,
  image_url TEXT DEFAULT 'https://cdn-icons-png.flaticon.com/512/147/147144.png',
  fname TEXT,
  lname TEXT
);

-- 3. Create Books Table
CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  title VARCHAR(100),
  description TEXT,
  isbn VARCHAR(20),
  personal_rating DECIMAL(3,1),
  author_name VARCHAR(100)
);

-- 4. Create Notes Table (With display_order)
CREATE TABLE notes (
  id SERIAL PRIMARY KEY,
  notes TEXT,
  book_id INT REFERENCES books(id) ON DELETE CASCADE,
  display_order INTEGER DEFAULT 0
);

-- 5. Create Comments Table
CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  comment TEXT,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  book_id INT REFERENCES books(id) ON DELETE CASCADE
);

-- 6. Create Session Table (Required for login)
CREATE TABLE "session" (
  "sid" varchar NOT NULL COLLATE "default",
  "sess" json NOT NULL,
  "expire" timestamp(6) NOT NULL
);
ALTER TABLE "session" ADD CONSTRAINT "session_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;
CREATE INDEX "IDX_session_expire" ON "session" ("expire");

--tt