FROM php:5.6-cli

ENV XDEBUG_VERSION=2.5.5

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        git \
        zip \
        unzip

RUN pecl channel-update pecl.php.net && \
    pecl install xdebug-${XDEBUG_VERSION} && \
    docker-php-ext-enable xdebug

RUN docker-php-ext-install \
    pdo \
    pdo_mysql

RUN php -r "readfile('http://getcomposer.org/installer');" | \
    php -- --install-dir=/usr/local/bin/ --filename=composer

RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && \
    chmod a+x /usr/local/bin/symfony

RUN curl -LsS https://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -o /usr/local/bin/php-cs-fixer && \
    chmod a+x /usr/local/bin/php-cs-fixer

WORKDIR /var/www/app

EXPOSE 8000

ADD ./ /var/www/app
ADD ./php.ini /usr/local/etc/php/php.ini

CMD [ "php", "bin/console", "server:run", "0.0.0.0:8000" ]
