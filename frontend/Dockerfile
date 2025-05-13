# Use official NGINX image
FROM nginx:alpine

# Remove the default NGINX config
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom nginx config
COPY nginx.conf /etc/nginx/conf.d/

# Copy static files (HTML, CSS, JS) into the HTML directory
COPY . /usr/share/nginx/html/frontend/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
