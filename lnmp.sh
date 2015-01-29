#!/bin/bash
# author:mayiwei
#   date:20130905

nginx_dir="/usr/local/nginx"
php_dir="/usr/local/php"
mysql_dir="/usr/local/mysql"
packages_dir="/usr/local/src" 
mysqlrootpwd="mysql123!@#"

function check_nginx()
{
   if [ -d /usr/local/nginx/ ];then
   	echo "nginx already installed!"
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
yum -y install wget ntp vim-enhanced make setuptool ntsysv system-config-network system-config-keyboard system-config-network-tuigcc gcc-c++ autoconf bison flex re2c  libmhash libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gd gd-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5-devel libidn libidn-devel openssl openssl-devel make libaio libaio-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers perl-CPAN libmcrypt libmcrypt-devel compat-* pam-devel*
       
echo -n "starting download LNMP packages ..."
cat > $packages_dir/list << EOF
nginx-1.4.1.tar.gz
php-5.4.19.tar.gz
libiconv-1.13.1.tar.gz
libmcrypt-2.5.8.tar.gz
mcrypt-2.6.8.tar.gz
memcache-2.2.7.tgz
mhash-0.9.9.tar.gz
mysql-5.5.33-linux2.6-i686.tar.gz
mysql-5.5.33-linux2.6-x86_64.tar.gz
pcre-8.12.tar.gz
PDO_MYSQL-1.0.2.tgz
ImageMagick-6.5.1-2.tar.gz
imagick-3.1.0.tgz
APC-3.1.13.tgz
fcgi.conf
php.ini
php-fpm
nginxd
my.cnf
nginx.conf
php-fpm.conf
logbak.sh
EOF

for i in `cat list`
do
	if [ -s $packages_dir/$i ]; then
		echo "$i [found]"
	else
		echo "Error: $i not found!!!download now......"
		wget http://mayiwei.com/lnmp/$i -P $packages_dir/
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

function install_nginx()
{
check_nginx
cp $packages_dir/nginxd /etc/init.d/
chkconfig --add nginxd
chmod 755 /etc/init.d/nginxd
cp $packages_dir/logbak.sh /usr/local/sbin/
chmod +x /usr/local/sbin/logbak.sh

cd $packages_dir/
tar zxf pcre-8.12.tar.gz && cd pcre-*
./configure 
make && make install 
cd ..

tar zxf nginx-1.4.1.tar.gz && cd nginx-1.4.1
./configure --prefix=${nginx_dir} --user=www --group=www --with-http_stub_status_module   
make && make install
cd .. 
rm -rf /usr/local/nginx/conf/nginx.conf
cp nginx.conf /usr/local/nginx/conf/
cp fcgi.conf /usr/local/nginx/conf/
mkdir -p /data/logs/nginx
echo "hello world" >> /data/www/wwwroot/index.html
service nginxd start
echo "nginx installed sucussfully!"
echo "nginx installed sucussfully!"
echo "nginx installed sucussfully!"
echo "nginx installed sucussfully!"
echo "nginx installed sucussfully!"
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
cp $packages_dir/php-fpm /etc/init.d/
chmod 755 /etc/init.d/php-fpm
chkconfig --add php-fpm

cd $packages_dir/
tar zxf libiconv-1.13.1.tar.gz && cd libiconv-1.13.1/
./configure --prefix=/usr/local
make && make install
cd ../

tar zxf libmcrypt-2.5.8.tar.gz && cd libmcrypt-2.5.8/
./configure
make && make install
/sbin/ldconfig
cd libltdl/
./configure --enable-ltdl-install
make && make install
cd ../../

tar zxf mhash-0.9.9.tar.gz && cd mhash-0.9.9/
./configure
make && make install
cd ../

for i in `uname -m`
do
	if [[ $i == i686 ]];then
		ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
		ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
		ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
		ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
		ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
		ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
		ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
		ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
		ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
		ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config
		ln -s /usr/local/mysql/lib/libmysqlclient.so.18  /usr/lib/libmysqlclient.so.18
	else [[ $i == x86_64 ]]
		ln -s /usr/local/lib/libmcrypt.la /usr/lib64/libmcrypt.la
		ln -s /usr/local/lib/libmcrypt.so /usr/lib64/libmcrypt.so
		ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib64/libmcrypt.so.4
		ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib64/libmcrypt.so.4.4.8
		ln -s /usr/local/lib/libmhash.a /usr/lib64/libmhash.a
		ln -s /usr/local/lib/libmhash.la /usr/lib64/libmhash.la
		ln -s /usr/local/lib/libmhash.so /usr/lib64/libmhash.so
		ln -s /usr/local/lib/libmhash.so.2 /usr/lib64/libmhash.so.2
		ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib64/libmhash.so.2.0.1
		ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config
		cp -frp /usr/lib64/libldap* /usr/lib/
		ln -s /usr/local/mysql/lib/libmysqlclient.so.18  /usr/lib64/libmysqlclient.so.18
	fi
done

tar zxf mcrypt-2.6.8.tar.gz && cd mcrypt-2.6.8/
/sbin/ldconfig
./configure
make && make install
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
make ZEND_EXTRA_LIBS='-liconv'
make install
cd ..
cp php.ini /usr/local/php/etc/
cp php-fpm.conf /usr/local/php/etc/
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

service php-fpm start

echo "php extension installed successfully!"
echo "php extension installed successfully!"
echo "php extension installed successfully!"
echo "php extension installed successfully!"
echo "php extension installed successfully!"
}

cat << EOF
-* 1  install nginx  *-
-* 2  install mysql  *-
-* 3  install php    *-
-* 4  install LNMP *-
EOF

read -p "Your arch is $i,select the top option to install LNMP...1|2|3|4:" selectopt
case "$selectopt" in
	"1")
		init
		install_nginx
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
		install_nginx
	;;
	*)
		echo "$0 nginx_php"
	;;
esac