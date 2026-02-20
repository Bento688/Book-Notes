## Book Notes Project

This project acts as a personal repository for the notes of books read. It helps you store the important
bits of information from your favorite books without having to memorize them. You can always come back to
this website and retrieve whatever key points you want to re-visit from the books that you read.

### HOW TO RUN THE PROJECT LOCALLY

You can easily spin up the entire application (web server and database) using Docker.

1. **Clone the repository**

```bash
git clone https://github.com/Bento688/Book-Notes#
cd book-notes
```

2. **Configure environment variables**

Create a `.env` file in the root directory by copying the provided example:

```bash
cp .env.example .env
```

Open your new .env file and review the settings. The default database variables are already configured to work seamlessly with Docker, but you will need to update a few specific keys:

- **Google OAuth (Required for login)**: Replace the `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` placeholders with your own credentials from the Google Cloud Console.
- **App Secrets**: Change the `SESSION_SECRET` to a secure random string.
- **Ports (Optional)**: If port `3000` or `5433` are already being used on your machine, you can safely change `PORT` or `LOCAL_DB_PORT` without breaking the internal Docker network.

3. **Run the application**

Run the following command in the root directory:

```bash
docker-compose up --build
```

(Note: On the first run, Docker will automatically initialize the database and inject the seed data from `init.sql`).

4. **Access the app**

Open your browser and navigate to `http://localhost:3000`

5. **Stopping and Resetting**

To stop the application, run

```bash
docker-compose down
```

If you ever need to completely wipe the database and start fresh with the original seed data, you can destroy the database volume by running:

```bash
docker-compose down -v
```
