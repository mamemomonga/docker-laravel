# Example

	$ docker run --rm mamemomonga/laravel:7.0 tar cC / app | tar xv
	$ bin/configure.sh
	$ docker-compose up -d

	$ docker-compose exec -u www-data laravel bash
	$ docker-compose exec -u www-data laravel composer install
	$ docker-compose exec -u www-data laravel php artisan migrate

	$ docker-compose down --volume