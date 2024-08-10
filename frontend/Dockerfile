FROM node:14.21.3-alpine AS base

WORKDIR /usr/src

COPY ./frontend/package.* ./
RUN npm install
COPY ./frontend .
COPY ./deployment/bin/wait-for-it.sh ./

FROM base AS dev
EXPOSE 80
CMD ["npm", "run", "serve"]

FROM base AS build
RUN npm run build

FROM nginx:1.25.1-alpine AS prod
COPY --from=build /usr/src/dist /usr/share/nginx/html
COPY ./deployment/config/nginx-frontend.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
