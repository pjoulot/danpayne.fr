#!/bin/sh

cd /home/drupal/danpayne/
composer update
cd web
drush cr drush
drush updatedb -y
drush cr drush
drush fra -y
drush entity-updates -y
drush locale-check
drush locale-update
drush cr
