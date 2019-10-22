#!/bin/sh

DATE=`date -d today +%a`
DAY=`date -d today +%Y%m%d`
DBNAME="MySQL"
PASS='8tzY9JH-dob$QngBz-ARAr1'
RDIR="/data/172/$DBNAME/dbsql"
backdir=$(date +%F)

if [ ! -d $RDIR ]; then
mkdir -p $RDIR
fi

if [ ! -d $RDIR/$backdir ]; then
mkdir -p $RDIR/$backdir
fi

echo "Start backup $DBNAME database" > $RDIR/$DBNAME"_"$DATE.status
date '+%D%t%T' >> $RDIR/$DBNAME"_"$DATE.status
echo "---------------------BEGIN--------------------" >> $RDIR/$DBNAME"_"$DATE.status
/usr/local/mysql/bin/mysql -uroot -p$PASS >> $RDIR/$DBNAME"_"$DATE.status <<EOF
stop slave;
show slave status\G
EOF


/usr/local/mysql/bin/mysqldump --opt -uroot -p$PASS -A | gzip > $RDIR/$DBNAME"_"$DATE.sql.gz

sleep 1
#分库备份
for n in `/usr/local/mysql/bin/mysql -uroot -p$PASS -e "show databases;"|grep -v "+"|egrep -v "Da|infor|per|test"`
do
   /usr/local/mysql/bin/mysqldump -uroot -p$PASS --event $n -B|gzip >$RDIR/$backdir/$n.sql.gz
done

/usr/local/mysql/bin/mysql -uroot -p$PASS >>$RDIR/$DBNAME"_"$DATE.status <<EOF

start slave;
EOF

echo "----------------------END----------------------" >> $RDIR/$DBNAME"_"$DATE.status
echo "$DBNAME database backup complete!" >> $RDIR/$DBNAME"_"$DATE.status
date '+%D%t%T' >> $RDIR/$DBNAME"_"$DATE.status


