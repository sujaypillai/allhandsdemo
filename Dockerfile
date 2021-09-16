# syntax=docker/dockerfile:experimental
FROM node:16.9.1-alpine as build
WORKDIR /app
COPY package.json yarn.lock ./
RUN --mount=target=/app/node_modules,type=cache yarn install --production
COPY . .
RUN --mount=target=/app/node_modules,type=cache yarn build

FROM nginx
EXPOSE 3000
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html