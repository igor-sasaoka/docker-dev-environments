FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
    
RUN pecl install redis-5.1.1 \
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable redis xdebug

RUN apt install -y libxml2-dev

RUN apt install -y git

RUN apt install -y unzip
RUN apt install -y libzip-dev
RUN apt install -y zip

RUN docker-php-ext-install bcmath pdo_mysql exif pcntl soap zip

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY ./config/custom.conf /etc/apache2/sites-available/custom.conf
RUN ln -s /etc/apache2/sites-available/custom.conf /etc/apache2/sites-enabled/custom.conf
RUN a2enmod rewrite && service apache2 restart

RUN echo "alias debug='PHP_IDE_CONFIG=serverName=xdebug  php -dxdebug.trigger=1 -dxdebug.session=1 -dxdebug.remote_enable=1 -dxdebug.remote_mode=req -dxdebug.remote_port=9000 -dxdebug.remote_host=host.docker.internal -dxdebug.remote_connect_back=0'" >> ~/.bashrc

COPY --from=node:16-buster /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node:16-buster /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

RUN npm install -g yarn