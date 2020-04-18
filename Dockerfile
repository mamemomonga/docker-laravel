FROM php:7.4-fpm-buster

RUN set -xe && \
	rm -f /etc/localtime && \
	ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
	echo 'Asia/Tokyo' > /etc/timezone

RUN set -xe && \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		gosu libicu-dev libonig-dev libzip-dev

RUN set -xe && \
	docker-php-ext-install intl pdo_mysql mbstring zip bcmath

COPY --from=dockage/confd:latest /usr/bin/confd /usr/local/bin/confd

RUN set -xe && \
	mkdir -p /var/log/php && \
	ln -s /dev/stderr /var/log/php/php-error.log

RUN set -xe && \
	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
	composer config -g process-timeout 3600 && \
	composer config -g repos.packagist composer https://packagist.jp

ENV COMPOSER_HOME /var/composer
RUN set -xe && \
	mkdir -p /app && \
	chown www-data:www-data /app && \
	mkdir -p /var/composer && \
	chown www-data:www-data /var/composer

USER www-data
RUN set -xe && \
	cd /app && \
	composer create-project --prefer-dist "laravel/laravel=7.0.*" .
USER root

ADD confd /etc/confd
ADD entrypoint.sh /entrypoint.sh
WORKDIR "/app"
ENTRYPOINT ["/entrypoint.sh"]

