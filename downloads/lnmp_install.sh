#!/bin/bash

########################
# http://openwares.net #
########################

set -e

#dotdeb source
sudo sed -i '$a\\n#dotdeb for nginx,mysql,php\ndeb http://packages.dotdeb.org squeeze all' /etc/apt/sources.list 

wget http://www.dotdeb.org/dotdeb.gpg
cat dotdeb.gpg | sudo apt-key add -
rm dotdeb.gpg

sudo apt-get update

###install nginx,php5(fastcgi),mysql5###
sudo apt-get -y install nginx-light mysql-server php5-cli php5-fpm php5-mysql

###awstats,perl-fcgi modules###
#sudo apt-get -y install awstats
#sudo apt-get -y install libfcgi-perl libfcgi-procmanager-perl libio-all-perl

#php config file for nginx
sudo sh -c 'echo "#pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000\nlocation ~ \.php$ {\n\tfastcgi_pass\t127.0.0.1:9000;\n\tfastcgi_index\tindex.php;\n\tinclude\t\t\tfastcgi_params;\n}" > /etc/nginx/php-fpm.conf'

#nginx rewrite rules for wordpress
sudo sh -c 'echo "#rewrite rules for wordpress\nlocation / {\n\tif (-d \$request_filename){\n\t\trewrite (.*) /\$1/index.php last;\n\t}\n\tif (!-f \$request_filename){\n\t\trewrite (.*) /index.php?\$1 last;\n\t}\n}" > /etc/nginx/wordpress.conf'

sudo /etc/init.d/nginx start
sudo /etc/init.d/php5-fpm start
