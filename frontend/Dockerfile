# Use the official Nginx image as the base
FROM nginx:alpine

# Copy the built React app to the Nginx HTML directory
COPY .* /usr/share/nginx/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
