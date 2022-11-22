# stage1 - build react app first 
FROM node:16.13-alpine as build

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY ./package.json /app/
COPY ./yarn.lock /app/

RUN apk add --no-cache git
RUN yarn --silent
COPY . /app
RUN yarn build

# stage 2 - build the final image and copy the react build files

FROM nginx:1.17.8-alpine

COPY --from=build /app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 80

WORKDIR /usr/share/nginx/html

# Add bash
RUN apk add --no-cache bash

CMD ["/bin/bash", "-c", "nginx -g \"daemon off;\""]