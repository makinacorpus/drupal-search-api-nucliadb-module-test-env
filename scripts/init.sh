cd /var/www/html/

# Install drupal dependencies
composer install

# Create files directory
mkdir -p /var/www/html/www/sites/default/files && chmod -R 777 /var/www/html/www/sites/default/files

# Create settings files
cp scripts/stuff/default.settings.php /var/www/html/www/sites/default/settings.php
chown www-data /var/www/html/www/sites/default/settings.php

# Install site
cd /www
./vendor/bin/drush site-install -v -y \
    --account-mail="${DRUPAL_ACCOUNT_MAIL}" \
    --account-name="${DRUPAL_ACCOUNT_NAME}" \
    --account-pass="${DRUPAL_ACCOUNT_PASS}" \
    --db-url="mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@db:3306/${MYSQL_DATABASE}" \
    --site-mail="${DRUPAL_SITE_MAIL}" \
    --site-name="${DRUPAL_SITE_NAME}" \
    --sites-subdir="default" \
    --debug \
    "${DRUPAL_INSTALL_PROFILE}"
