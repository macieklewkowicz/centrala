FROM php:7.3-apache

RUN a2enmod rewrite

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    git \
    unzip \
    ; \
    rm -rf /var/lib/apt/lists/*;

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

RUN touch .env

COPY composer.json composer.json
COPY composer.lock composer.lock

RUN composer install --no-progress --no-dev

COPY app app
COPY public public
