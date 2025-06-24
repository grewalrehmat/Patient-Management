FROM node:20-alpine

# Create app directory
WORKDIR /usr/src/app

# Install dependencies
COPY package*.json ./
RUN npm install
RUN npm install nodemon

# Copy app files
COPY . .

# Expose port
EXPOSE 8080

# Run the app
CMD [ "npm", "run", "start" ]
