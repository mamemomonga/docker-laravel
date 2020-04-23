#!/bin/bash
set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
IMAGE_LARAVEL="mamemomonga/laravel:7.0"

rand_chars() {
	openssl rand -base64 64 | perl -E 'local $/; $_=<>; s#\n#_#g;s#/#.#g;s#/#!#g; for my $c(1..'$1') { print substr($_,$c,1_) }; say ""'
}

generate_confd() {
	local confd_file="$BASEDIR/confd.yaml"
	local laravel_key=$( echo 'php artisan key:generate && cat .env' | docker run -i --rm $IMAGE_LARAVEL bash | perl -nlE 'if(/^APP_KEY=(.+)$/) { say $1 }' )
	local DATETIME=$( date +'%Y/%m/%d %H:%M:%S%z' )

	cat > $confd_file << EOS

laravel:
  name: app
  url: http://localhost/
  debug: true
  env: prod
  key: $laravel_key

db:
  host: mysql
  port: 3306
  database: app
  username: app
  password: $DB_PASSWORD

aws:
  access_key_id: AKIAAAAAAAAAAAAAAAAA
  secret_access_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  default_region: ap-northeast-1
  bucket: FIXME

redis:
  host: 127.0.0.1
  password: dummy
  port: 6379

smtp:
  host: dummymail
  port: 10025
  username: ""
  password: ""
  encryption: ""

EOS
	echo "Write: $confd_file"
}

generate_env() {
	local env_file="$BASEDIR/.env"
	cat > $env_file << EOS
MYSQL_DATABASE=app
MYSQL_USER=app
MYSQL_PASSWORD=$DB_PASSWORD
MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD

EXPOSE_WEB=8000
EXPOSE_MYSQL=13306
EXPOSE_MAILHOG=18025
EOS
	echo "Write: $env_file"

}

MYSQL_ROOT_PASSWORD=$( rand_chars 32 )
DB_PASSWORD=$( rand_chars 32 )
DB_ROOT_PASSWORD=$( rand_chars 32 )

generate_confd
generate_env

