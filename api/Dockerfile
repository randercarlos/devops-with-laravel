FROM php:8.1-fpm as api

ARG ENV=dev

WORKDIR /usr/src

RUN apt-get update && apt-get install -y \
    nano \
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

COPY ./api .
COPY ./deployment/config/php-fpm/php-prod.ini /usr/local/etc/php/conf.d/php.ini
COPY ./deployment/config/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./deployment/bin/wait-for-it.sh /usr/src/wait-for-it.sh

# Install dependencies based on the environment
RUN if [ "$ENV" = "dev" ]; then \
        composer install; \
    else \
        composer install --optimize-autoloader --no-dev; \
    fi

RUN chmod +x ./wait-for-it.sh && \
    chown -R www-data:www-data /usr/src && \
    chmod -R 775 /usr/src/storage /usr/src/bootstrap/cache


# allow run "php artisan tinker" inside the container without error
RUN mkdir -p /var/www/.config/psysh && \
        chown -R www-data:www-data /var/www/.config/psysh

# Install or update AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -o awscliv2.zip && \
    ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update && \
    rm awscliv2.zip

USER www-data

EXPOSE 9000
CMD ["php-fpm"]

FROM api AS worker
COPY ./deployment/config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisor.conf
CMD ["/bin/sh", "-c", "supervisord -c /etc/supervisor/conf.d/supervisor.conf"]
CMD ["/bin/sh", "-c", "nice -n 10 php /usr/src/artisan queue:work --tries=3 --verbose --timeout=30 --sleep=3 --rest=1 --max-jobs=1000 --max-time=3600"]

FROM api AS scheduler
CMD ["/bin/sh", "-c", "nice -n 10 sleep 60 && php /usr/src/artisan schedule:run --verbose --no-interaction"]
