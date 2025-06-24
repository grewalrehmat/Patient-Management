FROM node:18-alpine

WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm ci --production

COPY . .

# on start: run our init script, then exit
CMD ["node", "init.js"]
