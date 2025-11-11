FROM ubuntu:22.04

# Устанавливаем всё одним махом
RUN apt-get update && apt-get install -y \
    nginx postgresql postgresql-contrib certbot python3-certbot-nginx \
    && rm -rf /var/lib/apt/lists/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

# Nginx конфиг
COPY nginx.conf /etc/nginx/sites-available/api
RUN ln -s /etc/nginx/sites-available/api /etc/nginx/sites-enabled/ \
    && rm -f /etc/nginx/sites-enabled/default

# PostgreSQL — создаём базу и пользователя
COPY init-db.sh /docker-entrypoint-initdb.d/init-db.sh
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# Открываем порты
EXPOSE 80 5432

# Запускаем PostgreSQL и Nginx
CMD service postgresql start && nginx -g 'daemon off;'
