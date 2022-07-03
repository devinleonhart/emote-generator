FROM node:16.13-alpine

ENV APP_PATH /app
ENV ASSET_PATH /assets
ENV TEMP_PATH /tmp

RUN apk add --no-cache  \
    python3 \
    g++ \
    build-base \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    musl-dev \
    giflib-dev \
    pixman-dev \
    pangomm-dev \
    libjpeg-turbo-dev \
    freetype-dev

# Copy over both repos at once.
RUN mkdir $APP_PATH
RUN mkdir $ASSET_PATH
RUN mkdir $APP_PATH/public
COPY . $TEMP_PATH

# Switch to the Express App and build it.
WORKDIR $TEMP_PATH/emote-api
RUN npm i && npm run build
RUN cp -r ./node_modules /
RUN cp -r ./dist/* $APP_PATH

# Switch to the React App and build it.
# The destination is the Express App's public folder.
WORKDIR $TEMP_PATH/emote-browser
RUN npm i && npm run build-dl
RUN cp -r ./dist/* $APP_PATH/public

WORKDIR $APP_PATH

CMD ["node", "./app.js"]
