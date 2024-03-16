# Utiliser l'image PHP officielle
FROM php:8.2-fpm

# Installer les dépendances nécessaires, y compris l'extension MongoDB
RUN apt-get update && apt-get install -y \
    libssl-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && apt-get install -y wget unzip

# Installation de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installation de l'extension PHP pdo_mysql
RUN docker-php-ext-install pdo_mysql

# Installation de l'extension PHP opcache
RUN docker-php-ext-install opcache

# Installation de l'extension PHP mysqli
RUN docker-php-ext-install mysqli

# Ajouter l'extension MongoDB à php.ini
RUN echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini

# Installation de Doctrine/MongoDB
RUN composer require doctrine/mongodb-odm
RUN composer require doctrine/mongodb-odm-bundle

# Ajouter le fichier opcache.ini au répertoire de configuration PHP
ADD opcache.ini $PHP_INI_DIR/conf.d/

# Démarrez votre application
CMD ["php-fpm"]
