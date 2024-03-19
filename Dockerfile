#ARG ALPINE_VERSION=3.9.4 
# ${ALPINE_VERSION}

FROM node:11-alpine AS builder
LABEL  maintainer="<ed@reanimate.io>"

WORKDIR /build-stage
COPY package*.json ./
RUN npm i

COPY . ./
RUN npm i -g yarn && yarn build

FROM nginx:alpine as production-build
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stahg 1
COPY --from=builder /build-stage/dist /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
