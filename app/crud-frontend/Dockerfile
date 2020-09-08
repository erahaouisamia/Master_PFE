# Stage 2, use the compiled app, ready for production with Nginx
FROM nginx
EXPOSE 80
COPY dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
