FROM debian:jessie

MAINTAINER mengzhaopeng <qiuranke@gmail.com>

ENV LAM_PACKAGE ldap-account-manager_5.5-1_all.deb

# Install apache2 php5 and so on
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install curl apache2 php5 php5-ldap php5-gd php5-imagick \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install lam
RUN curl https://www.ldap-account-manager.org/static/debian-packages/${LAM_PACKAGE} > ${LAM_PACKAGE} && dpkg -i ${LAM_PACKAGE} \
    && rm -f ${LAM_PACKAGE} && rm /etc/apache2/sites-enabled/*default*

ENV LDAP_URL localhost
ENV LDAP_PORT 389
ENV LDAP_DN example.com

COPY apache2.sh /usr/local/bin/run

VOLUME /var/lib/ldap-account-manager/config

EXPOSE 80

CMD ["/usr/local/bin/run"]
