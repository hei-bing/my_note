#!/bin/bash
#create by jihu
#date 2014.09.05
#for CombinedService
DBUSER=root
DBPASS='8tzY9JH-dob$QngBz-ARAr1'
BAKDIR=/root/$(date +%F)

[ ! -d "$BAKDIR" ]&& mkdir $BAKDIR
echo "########################"
echo "###开始进行数据库备份###"
echo "########################"


#全库备份
echo "####Step 1 全库备份####"
echo "备份中，请稍后......"
mysqldump -u"$DBUSER" -p"$DBPASS" -A -B|gzip >$BAKDIR/ALL.$(date +%F).sql.gz
sleep 1
echo "全库备份结束"


#备份需要的库
echo "####Step 2 分库备份####"
for n in CardSNS_1024 CardSNS_1025 
do
echo "备份中，请稍后......"
echo "####正在备份$n####"
mysqldump -u"$DBUSER" -p"$DBPASS" $n -B|gzip >$BAKDIR/$n.$(date +%F).sql.gz
echo "$n备份结束"
done
sleep 1

echo ""
#备份邮件表
echo "####Step 3 邮件备份####"
for n in CardSNS_1024 CardSNS_1025  
do
echo "备份中，请稍后......"
echo "正在备份$n的邮件"
mysqldump -u"$DBUSER" -p"$DBPASS"  $n message |gzip >$BAKDIR/$n-message.$(date +%F).sql.gz
done
echo ""

echo "########################"
echo "#####数据库备份结束#####"
echo "########################"
