FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
        apache2 \
        software-properties-common \
        supervisor \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/*

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y --no-install-recommends \
        php7.2 \
        php7.2-cli \
        php7.2-dev \
        php7.2-intl \
        php7.2-curl \
        php7.2-json \
        php7.2-mysql \
        php7.2-gd \
        php7.2-sqlite3 \
        php7.2-ldap \
        php7.2-opcache \
        php7.2-soap \
        php7.2-zip \
        php7.2-mbstring \
        php7.2-bcmath \
        php7.2-xml \
        php7.2-xmlrpc \
        php7.2-xsl \
        php7.2-bz2 \
        php-mcrypt \
        php-apcu \
        php-pear \
        php-xdebug \
        php-redis \
        php-memcached \
        libapache2-mod-php7.2 \
        curl \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/*

RUN \
    a2enmod actions ssl rewrite headers expires \
    && phpenmod mcrypt

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

VOLUME [ "/var/www/html" ]
WORKDIR /var/www/html

EXPOSE 80 443

ENTRYPOINT [ "/usr/sbin/apache2" ]
CMD ["-D", "FOREGROUND"]
