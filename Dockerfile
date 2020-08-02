# Baixa a imagem do ubuntu
FROM ubuntu:14.04.5
# Labels
LABEL Description="Novo SGA 1.5"
LABEL Version="1.0"
LABEL Maintainer="José Rodrigues Filho"
# Variáveis
ENV DATABASE_HOST="192.168.0.162" \
    DATABASE_PORT="3306" \
    DATABASE_USER="novosga" \
    DATABASE_PASSWORD="sga123" \
    DATABASE_NAME="novosga" 
# Instalação dos pacotes
RUN apt-get update && apt-get install -y \
apache2 \
php5 \
php5-mysql \
curl \
php5-mcrypt \
php5-ldap \
unzip \
wget \
&& apt-get clean && apt-get autoclean && apt-get autoremove \
&& rm -rf /var/lib/apt/lists/*
# Instalação do novosga 1.5
RUN curl -sS https://getcomposer.org/installer | php \
&& php composer.phar create-project novosga/novosga /var/www/html/novosga "1.*" \
&& chown -R www-data:www-data /var/www/html/novosga/ \
# Painel web
&& wget -q -O /tmp/tmp.zip https://github.com/novosga/panel-app/archive/v1.3.0.zip \
&& unzip /tmp/tmp.zip -d /var/www/html/novosga/public/ \
&& mv /var/www/html/novosga/public/panel-app-1.3.0 /var/www/html/novosga/public/painel-web/ \
&& rm /tmp/tmp.zip \
# Painel touch
&& wget -q -O /tmp/tmp.zip https://github.com/novosga/triage-app/archive/v1.4.0.zip \
&& unzip /tmp/tmp.zip -d /var/www/html/novosga/public/ \
&& mv /var/www/html/novosga/public/triage-app-1.4.0 /var/www/html/novosga/public/triagem-touch/ \
&& rm /tmp/tmp.zip \
# Configuração BD
&& echo '<?php \n\
return array( \n\
    "driver" => "pdo_mysql", \n\
    "host" => getenv("DATABASE_HOST"), \n\
    "port" => getenv("DATABASE_PORT"), \n\
    "user" => getenv("DATABASE_USER"), \n\
    "password" => getenv("DATABASE_PASSWORD"), \n\
    "dbname" => getenv("DATABASE_NAME"), \n\
    "charset" => "utf8", \n\
); '\
> /var/www/html/novosga/config/database.php \
# Configurações 
&& sed -i 's|Directory /var/www/|Directory /var/www/novosga/public/|i' /etc/apache2/apache2.conf \
&& sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/novosga/public/|i' /etc/apache2/sites-available/000-default.conf \
&& sed -i '30i\# Novosga' /etc/apache2/sites-available/000-default.conf \
&& sed -i '31i\<Directory "/var/www/">' /etc/apache2/sites-available/000-default.conf \
&& sed -i '32i\AllowOverride All' /etc/apache2/sites-available/000-default.conf \
&& sed -i '33i\Require all granted' /etc/apache2/sites-available/000-default.conf \
&& sed -i '34i\</Directory>' /etc/apache2/sites-available/000-default.conf 
# Habilitando nmods
RUN a2enmod rewrite \
&& php5enmod mcrypt 
# Add crontab file in the cron directory and execution rights on the cron job
ADD crontab /etc/cron.d/novosga-cron
RUN chmod 0644 /etc/cron.d/novosga-cron

WORKDIR /var/www/html/novosga

COPY novosga-foreground.sh /usr/bin/
RUN chmod +x /usr/bin/novosga-foreground.sh

CMD ["/usr/bin/novosga-foreground.sh"]
