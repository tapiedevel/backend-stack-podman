FROM php:8.2-apache

# Instalamos las extensiones necesarias para MySQL (PDO)
RUN docker-php-ext-install pdo pdo_mysql

# Opcional: Habilitar mod_rewrite de Apache para URLs amigables (htaccess)
RUN a2enmod rewrite

CMD ["apache2-foreground"]
