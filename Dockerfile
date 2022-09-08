FROM ubuntu/nginx:latest

WORKDIR /app

COPY ./scripts /app
COPY index.html /var/www/html/
COPY data.json /var/www/html/
COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod 777 /app/app.sh

RUN rm /var/www/html/*debian.html

EXPOSE 80

CMD [ "/bin/bash", "/app/app.sh", "start" ]