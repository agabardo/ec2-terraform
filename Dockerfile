# Use the official Node.js 18 image as the base image
FROM node:18

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY ./app/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code into the container
COPY ./app .

# Expose port 3000 to the outside world
EXPOSE 3000

# Command to run the application
CMD ["node", "index.js"]
