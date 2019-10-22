#安装必要的库文件
yum -y install gcc gcc-c++ ncurses-devel
#编译安装cmake
tar xf ./cmake-2.8.3.tar.gz
cd cmake-2.8.3
./configure
make && make install
cd ../
#添加用户和组
groupadd mysql
useradd mysql -s /sbin/nologin -g mysql -M
#cmake 编译安装mysql5.5.21
tar zxf ./mysql-5.5.21.tar.gz
cd mysql-5.5.21
cmake . -DCMAKE_BUILD_TYPE:STRING=Release \
-DCMAKE_INSTALL_PREFIX:PATH=/usr/local/mysql \
-DCOMMUNITY_BUILD:BOOL=ON \
-DENABLED_PROFILING:BOOL=ON \
-DENABLE_DEBUG_SYNC:BOOL=OFF \
-DINSTALL_LAYOUT:STRING=STANDALONE \
-DMYSQL_DATADIR:PATH=/data/ifengsite/mysqldata \
-DMYSQL_MAINTAINER_MODE:BOOL=OFF \
-DWITH_EMBEDDED_SERVER:BOOL=ON \
-DWITH_EXTRA_CHARSETS:STRING=all \
-DWITH_SSL:STRING=bundled \
-DWITH_UNIT_TESTS:BOOL=OFF \
-DWITH_ZLIB:STRING=bundled \
-LH
make && make install
#初始化数据库
mkdir -p /data/ifengsite/mysqldata
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/data/ifengsite/mysqldata --user=mysql
cp /usr/local/mysql/support-files/my-small.cnf /etc/my.cnf
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod 700 /etc/init.d/mysqld
