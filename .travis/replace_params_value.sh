#!/bin/bash

echo "Start replace the theme's paramter"

## replace the paramter's valuesw
sed -i '
s/Your AddthisPubid/'$AddthisPubid'/g
s/Your BaiduSiteId/'$BaiduSiteId'/g
s/Your CNNZSiteId/'$CNNZSiteId'/g
s/Your DaoVoiceId/'$DaoVoiceId'/g
s/Your GoogleSiteId/'$GoogleSiteId'/g
s/Your LaSiteId/'$LaSiteId'/g
s/Your LCAppId/'$LCAppId'/g
s/Your LCAppKey/'$LCAppKey'/g
s|Your LCServer|'$LCServer'|g
s/Your LiveReId/'$LiveReId'/g
s/Your RevolverMapId/'$RevolverMapId'/g
s|Your WalineSerURL|'$WalineSerURL'|g
' config/_default/params.toml 

echo "Replace the theme's paramter is success."