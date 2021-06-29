FROM node:16-alpine AS dependencies

WORKDIR /app
COPY package.json package.json
COPY yarn.lock yarn.lock
RUN SKIP_POSTINSTALL=1 yarn install

FROM node:16-alpine AS dev

WORKDIR /app
COPY package.json package.json
COPY tsconfig.json tsconfig.json
COPY --from=dependencies /app/node_modules node_modules
CMD yarn watch

FROM node:16-alpine AS prod

WORKDIR /app
COPY package.json package.json
COPY tsconfig.json tsconfig.json
COPY keystone.ts keystone.ts
COPY --from=dependencies /app/node_modules node_modules
CMD yarn build && yarn start