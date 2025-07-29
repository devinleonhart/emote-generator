FROM node:24.4-slim

ENV APP_PATH=/app
ENV ASSET_PATH=/assets
ENV TEMP_PATH=/tmp

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

# Create required directories
RUN mkdir -p $APP_PATH/public $ASSET_PATH

# Copy full project to temp directory
COPY . $TEMP_PATH

# Build backend
WORKDIR $TEMP_PATH
RUN npm ci && npm run build
RUN cp -r ./dist/* ./package.json ./node_modules $APP_PATH

# Build frontend (Vue app in ./generator)
WORKDIR $TEMP_PATH/generator
RUN npm ci && npm run build
RUN cp -r ./dist/* $APP_PATH/public

# Copy runtime assets (after build step)
COPY ./assets $ASSET_PATH

# Final app location
WORKDIR $APP_PATH
CMD ["node", "./app.js"]
