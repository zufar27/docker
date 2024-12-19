FROM ubuntu:latest

# Set timezone
RUN apt-get update -y && \
    ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Install Apache
RUN apt-get install git apache2 -y

# Add the PHP repository for PHP 8.1
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update -y

# Install PHP 8.1 and required extensions
RUN apt-get install -y php8.1 libapache2-mod-php8.1 php8.1-pspell php8.1-curl php8.1-gd php8.1-intl \
    php8.1-mysql php8.1-xml php8.1-xmlrpc php8.1-ldap php8.1-zip php8.1-soap php8.1-mbstring \
    graphviz aspell ghostscript clamav

# Add Moodle files
#ADD moodle-latest-39.tgz /var/www/html/
#RUN  git clone -b MOODLE_405_STABLE https://github.com/moodle/moodle.git /var/www/html/moodle

RUN git config --global http.postBuffer 524288000 && \     
    git clone --depth 1 -b MOODLE_405_STABLE https://github.com/moodle/moodle.git /var/www/html/moodle || \ 
   { echo "Retrying..."; sleep 5; git clone --depth 1 -b MOODLE_405_STABLE https://github.com/moodle/moodle.git /var/www/html/moodle; } 

# Create Moodle data directory
RUN mkdir /var/www/html/moodledata

COPY config.php /var/www/html/moodle

# Set permissions for Moodle directories
RUN chown -R www-data:www-data /var/www/html/moodle/ && \
    chmod -R 755 /var/www/html/moodle/ && \
    chown -R www-data /var/www/html/moodledata && \
    chmod -R 755 /var/www/html/moodledata

RUN chown -R www-data:www-data /var/lib/php/sessions

# Copy custom Apache configuration
COPY moodle.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/moodle.conf /etc/apache2/sites-enabled

# Enable Apache modules and Moodle site configuration
RUN a2enmod rewrite && \
    a2ensite moodle.conf && \
    a2dissite 000-default.conf

# Restart Apache
RUN service apache2 restart

# Expose port 80
EXPOSE 80

# Start Apache in foreground
CMD ["apachectl", "-D", "FOREGROUND"]
