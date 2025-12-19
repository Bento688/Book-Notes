# Use official Node.js image (using 20 to be safe, matches your likely local version)
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the rest of the application
COPY . .

# Expose the port (Cloud Run expects this)
EXPOSE 3000

# Start command
CMD ["npm", "start"]