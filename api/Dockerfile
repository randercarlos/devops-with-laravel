FROM php:8.1-fpm as api

ARG ENV=dev

WORKDIR /usr/src

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libc6 \
    zip \
    unzip \
    supervisor \
    default-mysql-client

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

RUN pecl install redis

COPY --from=composer:2.5.8 /usr/bin/composer /usr/bin/composer

COPY ./api/composer.* /usr/src/
COPY ./deployment/config/php-fpm/php-prod.ini /usr/local/etc/php/conf.d/php.ini
COPY ./deployment/config/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./deployment/bin/update.sh /usr/src/update.sh

RUN /bin/bash -c ' \
    if [ "$ENV" = "dev" ]; then \
        composer install --no-scripts; \
    else \
        composer install --optimize-autoloader --no-dev --no-scripts; \
    fi' \

COPY ./api .

RUN php artisan storage:link --force && \
    chmod +x ./update.sh && \
    chmod +x ./wait-for-it.sh && \
    chown -R www-data:www-data /usr/src && \
    chmod -R 775 ./storage ./bootstrap/cache

USER www-data

EXPOSE 9000
CMD ["php-fpm"]

#RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
#    unzip awscliv2.zip && \
#    ./aws/install
#
FROM api AS worker
COPY ./deployment/config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisor.conf
CMD ["/bin/sh", "-c", "supervisord -c /etc/supervisor/conf.d/supervisor.conf"]
CMD ["/bin/sh", "-c", "nice -n 10 php /usr/src/artisan queue:work --tries=3 --verbose --timeout=30 --sleep=3 --rest=1 --max-jobs=1000 --max-time=3600"]

FROM api AS scheduler
CMD ["/bin/sh", "-c", "nice -n 10 sleep 60 && php /usr/src/artisan schedule:run --verbose --no-interaction"]