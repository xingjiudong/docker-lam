FROM php:5.6-apache

MAINTAINER mengzhaopeng <qiuranke@gmail.com>

ENV LAM_PACKAGE ldap-account-manager-5.6

# Install the software that lam environment requires
RUN apt-get update && apt-get install -y \
        bzip2 \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libldap2-dev \
        libmagickwand-dev \
        libpng12-dev --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
           --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install gettext gd ldap zip

RUN pecl install imagick && docker-php-ext-enable imagick

ENV LDAP_URL localhost
ENV LDAP_PORT 389
ENV LDAP_DN example.com

# Install ldap-account-manager package
RUN curl https://nchc.dl.sourceforge.net/project/lam/LAM/5.6/${LAM_PACKAGE}.tar.bz2 \
        -o ${LAM_PACKAGE}.tar.bz2 \
    && bzip2 -d ${LAM_PACKAGE}.tar.bz2 \
    && tar xf ${LAM_PACKAGE}.tar -C /var/www/html \
    && rm -f ${LAM_PACKAGE}.tar \
    && mv /var/www/html/${LAM_PACKAGE} /var/www/html/lam

COPY lam.conf.default /var/www/html/lam/config/lam.conf
COPY setup.sh /usr/local/bin/setup.sh

RUN chown -R www-data:www-data /var/www/html/lam

VOLUME /var/www/html/lam/config

CMD ["setup.sh"]