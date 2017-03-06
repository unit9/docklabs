FROM php:5.6-apache

RUN apt-get update \
    && apt-get install -y \
        rrdtool \
        git \
    && rm -rf /var/cache/apt /var/lib/apt/lists/*

RUN git clone https://github.com/pommi/CGP /var/www/html \
    && a2enmod rewrite
