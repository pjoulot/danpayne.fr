#!/bin/sh

########## Some default values ##########
FEATURES=0
ALLOW_SSH=1
UPDATE_CONF=0
SITENAME="danpayne"


########## General variables ##########
SYSTEM="Debian"
USER="drupal"
GROUP=10000



########## Drupal variables ##########
DRUPAL_PROFIL="standard"
DRUPAL_LOCALE="fr"
DRUPAL_ADMIN_USER=admin
DRUPAL_ADMIN_PWD=drupal
if [ -z "$DRUPAL_DB_URL" ]
then
    DRUPAL_DB_URL=mysql://$SITENAME:$SITENAME@localhost/$SITENAME
fi
if [ -z "$DRUPAL_ADMIN_MAIL" ]
then
    DRUPAL_ADMIN_MAIL="admin@example.com"
fi

DELIVERY_USER=philippe
DELIVERY_SERVER="193.70.0.251"
DELIVERY_PORT=22
DELIVERY_DIR="/var/www/$SITENAME"

########## Project variables ##########
PROJECT_PATH="/home/drupal/$SITENAME"



########## Environment variables ##########
case "$ENV" in
    dev)
        WWW_PATH="/var/www/$SITENAME/web"
        FEATURES=0
        ALLOW_SSH=0
        UPDATE_CONF=0
        ;;
    prod)
        WWW_PATH="/var/www/$SITENAME/web"
        FEATURES=0
        ALLOW_SSH=0
        UPDATE_CONF=0
        ;;
esac



########## Calculated variables ##########
if [ $SYSTEM = "redhat" ]
then
    APACHE_USER="apache"
    APACHE_SERVICE="httpd"
else
    APACHE_USER="www-data"
    APACHE_SERVICE="apache2"
fi

