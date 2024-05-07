# ARG
ARG NODE_VERSION=22.0.0
ARG ALPINE_VERSION=3.19

# BASE
FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS base

#ARG DB_HOST
#ARG DB_USER
#ARG DB_PASSWORD
#ARG DB_DB
#
#ENV POSTGRES_HOST=${DB_HOST}
#ENV POSTGRES_USER=${DB_USER}
#ENV POSTGRES_PASSWORD=${DB_PASSWORD}
#ENV POSTGRES_DB=${DB_DB}

# Creates working directory
WORKDIR /usr/src/app

# Copy dependency definitions
COPY package*.json ./

COPY . .

HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1


# TEST STAGE

FROM base as test

RUN npm install

ENTRYPOINT ["npm", "run", "test"]


# DEVELOPMENT STAGE
FROM base as dev


RUN npm install

# Specify whihc port will exposed for app
EXPOSE 3000

# Serve the app
ENTRYPOINT ["npm", "run", "dev"]


# PRODUCTION STAGE

FROM base as production

RUN npm install --only=production

# Specify whihc port will exposed for app
EXPOSE 3000

# Serve the app
ENTRYPOINT ["node","./src/index.js"]