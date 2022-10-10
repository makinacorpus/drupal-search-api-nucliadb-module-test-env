# See https://www.drupal.org/docs/system-requirements/php-requirements
FROM php:7.4-apache

ARG DRUPAL_CONTAINER_USER_NAME
ARG HOST_WWW_UID
ARG PROJECT_DIR

# Install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
    mariadb-client \
    postgresql-client \
    git \
    vim \
    unzip \
    wget \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		libzip-dev \
	; \
	\
	docker-php-ext-configure gd \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
		gd \
		json \
		pdo \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		sockets \
		zip \
	;

# Set recommended PHP.ini settings
# See https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www/html

RUN bash -c 'set -ex \
    && : "Install drush" \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin -- --filename=composer \
    '

RUN bash -c 'set -ex \
    && : "Install drush" \
    && wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar \
    && chmod +x drush.phar \
    && mv drush.phar /usr/local/bin/drush \
    '

RUN bash -c 'set -ex \
    && : "project user & workdir" \
    && useradd -ms /bin/bash ${DRUPAL_CONTAINER_USER_NAME} --uid ${HOST_WWW_UID} \
    && usermod -a -G ${DRUPAL_CONTAINER_USER_NAME} www-data \
    && chown ${DRUPAL_CONTAINER_USER_NAME}:${DRUPAL_CONTAINER_USER_NAME} ${PROJECT_DIR} \
    '
COPY .docker/drupal/apache.conf /etc/apache2/sites-enabled/000-default.conf



