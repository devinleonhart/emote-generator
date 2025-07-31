FROM node:24.4.1-slim AS builder

ENV APP_PATH=/app

# Install required build dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    g++ \
    build-essential \
    libcairo2-dev \
    libjpeg-dev \
    libpango1.0-dev \
    libgif-dev \
    libpixman-1-dev \
    libpangomm-1.4-dev \
    libjpeg-turbo-progs \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR $APP_PATH

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Rebuild canvas module for the current architecture
RUN npm rebuild canvas

# Copy source code and config
COPY src/ ./src/
COPY config/ ./config/
COPY tsconfig.json ./
COPY nodemon.json ./

# Build the application
RUN npm run build

# Frontend builder stage
FROM node:24.4.1-slim AS frontend-builder

ENV FRONTEND_PATH=/frontend

# Create frontend directory
WORKDIR $FRONTEND_PATH

# Copy frontend package files
COPY generator/package*.json ./

# Install frontend dependencies
RUN npm install

# Copy frontend source and config
COPY generator/src/ ./src/
COPY generator/public/ ./public/
COPY generator/types/ ./types/
COPY generator/index.html ./
COPY generator/vite.config.ts ./
COPY generator/tsconfig.json ./
COPY generator/eslint.config.js ./
COPY config/ ./../config/

# Build the frontend
RUN npm run build

# Production stage
FROM node:24.4.1-slim AS production

ENV APP_PATH=/app
ENV NODE_ENV=production

# Install runtime dependencies for canvas
RUN apt-get update && apt-get install -y \
    libcairo2 \
    libjpeg62-turbo \
    libpango-1.0-0 \
    libgif7 \
    libpixman-1-0 \
    libpangomm-1.4-1v5 \
    libfreetype6 \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR $APP_PATH

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Rebuild canvas module for the current architecture
RUN npm rebuild canvas

# Copy built application from builder stage
COPY --from=builder /app/dist ./dist

# Copy built frontend from frontend-builder stage
COPY --from=frontend-builder /frontend/dist ./public

# Create assets directory structure (for CI where assets might not exist)
RUN mkdir -p assets/emotes/cache

# Expose port
EXPOSE 4000

# Start the production server
CMD ["npm", "start"]
