# Stage 2, use the compiled app, ready for production with Nginx
FROM nginx
COPY dist/out /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
