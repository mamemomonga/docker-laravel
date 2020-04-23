# Example

expand laravel

	$ docker run --rm mamemomonga/laravel:7.0 tar cC / app | tar xv

change owner:group to www-data

	$ sudo chown -R 33:33 app

create confd.yaml

	$ bin/configure.sh

start containers

	$ docker-compose up -d

login as root

	$ docker-compose exec laravel bash

login as www-data

	$ docker-compose exec -u www-data laravel bash

composer install

	$ docker-compose exec -u www-data laravel composer install

artisan migrate

	$ docker-compose exec -u www-data laravel php artisan migrate

