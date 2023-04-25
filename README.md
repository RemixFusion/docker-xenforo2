# XenForo 2 with Docker
#### Changes by RemixF with SSL

This is basic docker setup for XenForo 2.

Installed:

- PHP 7.2.x, 8.0.x, 8.1.x (Easily switch between php versions)

  - Mysqli
  - GD
  - Imagick
  - Composer
  - GMP
  - Zip

- Nginx 1.19.6
- Mariadb: 10.6.3

## Structure

Put XenForo source code to folder `/xenforo`. Any new add-ons will be stored in folder `/addons`

- XenForo (internal_data, data) store at `.data/xenforo`
- Mariadb data store to `.data/mariadb`
- Nginx logging store to `.data/nginx`
- XenForo add-ons store at `/addons`

### Installation

This requires open port `10080` make sure the port was allowed in your PC. You can change the port to any other
by edit the file `docker-compose.yml`

Clone this repository to your computer then run
`docker-compose build`

to build images and run `docker-compose up -d` to start web server.

Open browser `http://localhost:10080` and coding...

## Install add-on

To store add-on directories correctly:

- Copy folder `/src/addons/<AddOnId>` to `/addons/<AddOnId>`
- Copy folder `/js/...` to `/xenforo/js/...`
- Copy folder `/styles/...` to `/xenforo/styles/...`

## config.php

Update your XenForo `config.php` with these values.

```php

$config['db']['host'] = 'mariadb';
$config['db']['port'] = '3306';
$config['db']['username'] = $_SERVER['MARIADB_USER'];
$config['db']['password'] = $_SERVER['MARIADB_PASSWORD'];
$config['db']['dbname'] = $_SERVER['MARIADB_DATABASE'];

```
