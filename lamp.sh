#!/bin/bash
# author:mayiwei
#   date:20130905

apache_dir="/usr/local/apache2"
php_dir="/usr/local/php"
mysql_dir="/usr/local/mysql"
packages_dir="/usr/local/src" 
mysqlrootpwd="mysql123!@#"

function check_apache()
{
  if [ -d /usr/local/apache2/ ];then
  echo "apache already installed!"
  exit 1     
  fi
}

function check_php()
{
  if [ -d /usr/local/php ];then
    echo "php 5.2.17 already installed!"
    exit 1
  fi
}

function check_mysql()
{
  if [ -d /usr/local/mysql/ ];then
    echo -n "mysql already installed!"
    exit 1
  fi
}

function init()
{
yum -y update
yum -y install wget ntp vim-enhanced make setuptool ntsysv system-config-network system-config-keyboard system-config-network-tuigcc gcc gcc-c++ autoconf libpng libpng-devel libjpeg libjpeg-devel gd gd-devel libxml2 libxml2-devel libmcrypt libmcrypt-devel compat-* pam-devel*
       
echo -n "starting download L.A.M.P packages ..."
cat > $packages_dir/list << EOF
gd-2.0.34.tar.gz
libxml2-2.7.3.tar.gz
libmcrypt-2.5.8.tar.gz
cronolog-1.7.0-beta.tar.gz
mysql-5.5.33-linux2.6-i686.tar.gz
mysql-5.5.33-linux2.6-x86_64.tar.gz
php-5.4.19.tar.gz
APC-3.1.13.tgz
memcache-2.2.7.tgz
php.ini
httpd.conf
EOF

for i in `cat list`
do
  if [ -s $packages_dir/$i ]; then
    echo "$i [found]"
  else
    echo "Error: $i not found!!!download now......"
    wget http://mayiwei.com/lamp/$i -P $packages_dir/
  fi
done

groupadd -g 80 www && useradd www -s /sbin/nologin -g www -u 80
groupadd -g 3306 mysql && useradd mysql -s /sbin/nologin -g mysql -u 3306
echo "www and mysql user && group create!"
mkdir -p /data/www/wwwroot
chown www:www -R /data/www/wwwroot
cat >> /etc/sysctl.conf << EOF
#ADD
net.ipv4.tcp_max_syn_backlog = 65536 
net.core.netdev_max_backlog = 32768  
net.core.somaxconn = 32768           
net.core.wmem_default = 8388608  
net.core.rmem_default = 8388608  
net.core.rmem_max = 16777216     
net.core.wmem_max = 16777216     
net.ipv4.tcp_timestamps = 0     
net.ipv4.tcp_synack_retries = 2  
net.ipv4.tcp_syn_retries = 2     
net.ipv4.tcp_tw_recycle = 1      
#net.ipv4.tcp_tw_len = 1
net.ipv4.tcp_tw_reuse = 1        
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800  
#net.ipv4.tcp_fin_timeout = 30      
#net.ipv4.tcp_keepalive_time = 120  
net.ipv4.ip_local_port_range = 1024  65535
EOF
sysctl -p
echo -e "***********************************"
echo -e "* All of init packages sucussful! *"
echo -e "* All of init packages sucussful! *"
echo -e "* All of init packages sucussful! *"
echo -e "***********************************"
}

function install_apache()
{
check_apache
cd $packages_dir/

tar xzvf cronolog-1.7.0-beta.tar.gz && cd cronolog-1.7.0
./configure --prefix=/usr/local/cronolog
make && make install
cd ../

tar zxf httpd-2.2.25.tar.gz && cd httpd-2.2.25
./configure --prefix=${apache_dir} --with-included-apr --enable-so --enable-deflate=shared --enable-expires=shared --enable-rewrite=shared --enable-static-support --disable-userdir  
make && make install
cd .. 
rm -rf /usr/local/apache2/conf/httpd.conf
cp httpd.conf /usr/local/apache2/conf/
mkdir -p /data/logs/apache
echo "hello world" >> /data/www/wwwroot/index.html
/usr/local/apache2/bin/apachectl start
echo "apache installed sucussfully!"
echo "apache installed sucussfully!"
echo "apache installed sucussfully!"
echo "apache installed sucussfully!"
echo "apache installed sucussfully!"
}

function install_mysql()
{
export PATH=$PATH:/usr/local/mysql/bin
echo "PATH=/usr/local/mysql/bin/:$PATH" >> /etc/profile
source /etc/profile

cd $packages_dir/
for i in `uname -m`
do
  if [[ $i == i686 ]];then
    tar zxf mysql-5.5.33-linux2.6-i686.tar.gz && mv mysql-5.5.33-linux2.6-i686 /usr/local/
    ln -s /usr/local/mysql-5.5.33-linux2.6-i686 /usr/local/mysql
  else [[ $i == x86_64 ]]
    tar zxf mysql-5.5.33-linux2.6-x86_64.tar.gz && mv mysql-5.5.33-linux2.6-x86_64 /usr/local/
    ln -s mysql-5.5.33-linux2.6-x86_64 /usr/local/mysql
  fi
done
mkdir -p /data/mysql/data
/bin/chown -R mysql:root /usr/local/mysql/
/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql/ 
cp /usr/local/mysql/support-*/mysql.server /etc/init.d/mysqld
cp my.cnf /etc/
chown root:root /etc/rc.d/init.d/mysqld
chmod 755 /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig --level 3 mysqld on
mv /usr/local/mysql/data /data/mysql
chown -R mysql:mysql /data/mysql
service mysqld start
/usr/local/mysql/bin/mysql -e "grant all privileges on *.* to root@'127.0.0.1' identified by \"$mysqlrootpwd\" with grant option;"
/usr/local/mysql/bin/mysql -e "grant all privileges on *.* to root@'localhost' identified by \"$mysqlrootpwd\" with grant option;"
/usr/local/mysql/bin/mysql -uroot -p$mysqlrootpwd -e "delete from mysql.user where Password='';"
/usr/local/mysql/bin/mysql -uroot -p$mysqlrootpwd -e "drop database test;"
service mysqld restart
echo "mysql installed successfully!"
echo "mysql installed successfully!"
echo "mysql installed successfully!"
echo "mysql installed successfully!"
echo "mysql installed successfully!"
}

function install_php()
{
check_php

cd $packages_dir/
tar xzvf gd-2.0.34.tar.gz && cd gd-2.0.34
./configure --prefix=/usr/local/gd2
make && make install
cd ../

tar zxvf libxml2-2.7.3.tar.gz && cd libxml2-2.7.3
./configure --prefix=/usr/local/libxml2
make && make install
cd ../

tar xzvf libmcrypt-2.5.8.tar.gz && cd libmcrypt-2.5.8
./configure --prefix=/usr/local/libmcrypt
make && make install
cd ../

cd ../

tar zxf php-5.4.19.tar.gz && cd php-5.4.19/
for m in `cat /proc/meminfo|grep MemTotal|awk -F"       " '{print $2}'|awk '{print $1}'`
do
  if (("$m" < "524288"));then
    ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap --without-pear --disable-fileinfo
  else (("$m" > "524288"))
    ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap --without-pear
  fi
done
make && make install
cd ..
cp php.ini /usr/local/php/etc/
echo -e "<?php \nphpinfo(); \n?>" > /data/www/wwwroot/p.php
echo "php installed successfully!"
echo "php installed successfully!"
echo "php installed successfully!"
echo "php installed successfully!"
echo "php installed successfully!"
}

function install_phpext()
{
cd $packages_dir/
tar zxf memcache-2.2.7.tgz && cd memcache-2.2.7/
${php_dir}/bin/phpize
./configure --with-php-config=${php_dir}/bin/php-config
make && make install
cd ../

tar zxvf APC-3.1.13.tgz && cd APC-3.1.13
${php_dir}/bin/phpize
./configure --enable-apc --enable-apc-mmap --with-php-config=${php_dir}/bin/php-config
make && make install
cd ../

tar zxf ImageMagick-6.5.1-2.tar.gz && cd ImageMagick-6.5.1-2/
./configure
make && make install
cd ../

tar zxf imagick-3.1.0.tgz && cd imagick-3.1.0/
${php_dir}/bin/phpize
./configure --with-php-config=${php_dir}/bin/php-config
make && make install
cd ..

/usr/local/apache2/bin/apachectl restart

echo "php extension installed successfully!"
echo "php extension installed successfully!"
echo "php extension installed successfully!"
echo "php extension installed successfully!"
echo "php extension installed successfully!"
}

cat << EOF
-* 1  install apache *-
-* 2  install mysql  *-
-* 3  install php    *-
-* 4  install LNMP *-
EOF

read -p "Your arch is $i,select the top option to install LNMP...1|2|3|4:" selectopt
case "$selectopt" in
  "1")
    init
    install_apache
  ;;
  "2")
    install_mysql
  ;;
  "3")
    init
    install_php
    install_phpext
  ;;
  "4")
    init
    install_mysql
    install_php
    install_phpext
    install_apache
  ;;
  *)
    echo "$0 apache_php"
  ;;
esac