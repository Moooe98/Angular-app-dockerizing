# Build stage
FROM node:alpine3.20 AS build
WORKDIR /app
COPY package.json /app/
RUN npm install
COPY . .
RUN npm run build --prod

# Runtime stage
FROM nginx:alpine

# Copy the built Angular app to Nginx's html directory
COPY --from=build /app/dist/helpdisk /usr/share/nginx/html

# Copy the custom Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the relevant port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]