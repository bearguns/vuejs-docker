# develop stage
FROM node:lts-alpine as develop-stage
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package*.json ./
RUN yarn
RUN yarn global add @vue/cli@3.7.0
COPY . .
CMD ["yarn", "run", "serve"]

# build stage
FROM develop-stage as build-stage
RUN yarn build

# production stage
FROM nginx:latest as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
