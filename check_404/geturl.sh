#! /bin/bash

sitemap="/data/www/wwwroot/sitemap.xml"
work_dir="/usr/local/sbin/geturl/"
channel_dir="/usr/local/sbin/geturl/url"
file="/usr/local/sbin/geturl/url_http"
success=0
failure=0
total=0
code=200

#get url from sitemap
grep "http://" $sitemap | grep -v '_m.html' | cut -f2 -d'>' | cut -f1 -d'<' > $file 
sed -i '/[0-9]\{8\}\/$/d' $file
awk -F/ '$4 ~/^Auto$|^AutoInformations$|^Classicals$|^AutoLife$|^Dazzle$/' $file > $channel_dir/Auto
awk -F/ '$4 ~/^Timepiece$|^NewWatches$|^Prestigious$|^AbiitAetas$/' $file > $channel_dir/Timepiece
awk -F/ '$4 ~/^Jewelry$|^NewArrival$|^Design$|^Interpretation$/' $file > $channel_dir/Jewelry
awk -F/ '$4 ~/^Fashion$|^Accessories$|^Attire$/' $file > $channel_dir/Fashion
awk -F/ '$4 ~/^HealthBeauty$|^ColorCosmetics$|^SkinCare$|^Leisure$|^Health$/' $file > $channel_dir/HealthBeauty
awk -F/ '$4 ~/^Admiration$|^ArtCrafts$|^Collection$/' $file > $channel_dir/Admiration
awk -F/ '$4 ~/^JetYacht$|^Jet$|^Yacht$/' $file > $channel_dir/JetYacht
awk -F/ '$4 ~/^Lifestyle$|^Wines$|^Column$|^Cigars$|^Travel$|^House$|^Hotel$/' $file > $channel_dir/Lifestyle
awk -F/ '$4 ~/^Elite$|^Family$|^Icon$|^Celebrity$/' $file > $channel_dir/Elite
awk -F/ '$4 ~/^Videos$/' $file > $channel_dir/Videos
awk -F/ '$4 ~/^Viewpoint$|^DingZhiFang$|^DingZhiXiang$/' $file > $channel_dir/Viewpoint
awk -F/ '$4 ~/^theTalesofLuxuries$|^BrandNews$/' $file > $channel_dir/theTalesofLuxuries
awk -F/ '$4 ~/^AboutTClub$|^TClubActivity$/' $file > $channel_dir/AboutTClub
awk -F/ '$4 ~/^Activity$/' $file > $channel_dir/Activity

#check http code 200
for url in `cat /usr/local/sbin/geturl/url/*`;do
    total=`expr $total + 1`
    b=`curl -I $url -s | head -1 | awk '{print$2}'`
    if [[ $b -ne $code ]];then
        echo $url >> $work_dir/failure.log
        failure=`expr $failure + 1`
    else
        success=`expr $success + 1`
    fi;
done
echo Total=$total >> $work_dir/info.log
echo Success=$success >> $work_dir/info.log
echo Failure=$failure >> $work_dir/info.log

#delete from url
for file in `ls /usr/local/sbin/geturl/url`;do
    grep -v -f $work_dir/failure.log $channel_dir/$file > $channel_dir/$file.tmp
    cat $channel_dir/$file.tmp > $channel_dir/$file
done
rm -rf $channel_dir/$file.tmp

#copy to server
scp -P 5858 $channel_dir/* www@xxx.xxx.xxx.xxxc:/data/www/wwwroot/xxx/php/interface/tools/geturl/
