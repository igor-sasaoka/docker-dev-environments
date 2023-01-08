# PHP 7.4 | Apache | MySQL | Node

Dev environment used in a Laravel project.
Xdebug configured to run on cli (`IDE_KEY` is set in `./config/php.ini`).

Might have to change root dir in apache's `./config/custom.conf` and in `docker-compose.yml` to fit different projects.

Apache's `serverName` might require a valid host registered in `/etc/hosts` file.
