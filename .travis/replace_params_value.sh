#!/bin/bash

echo "Start replace the plugin's paramter"

## replace the paramter's values
sed -e 's/Your LiveReId/'$LiveReId'/g' \
-e 's/Your RevolverMapId/'$RevolverMapId'/g' \
-e 's/Your LCAppId/'$LCAppId'/g' \
-e 's/Your LCAppKey/'$LCAppKey'/g' \
-e 's|Your LCServer|'$LCServer'|g' \
-e 's/Your CNNZSiteId/'$CNNZSiteId'/g' \
-e 's/Your BaiduSiteId/'$BaiduSiteId'/g' \
-e 's/Your GoogleSiteId/'$GoogleSiteId'/g' \
-e 's/Your DaoVoiceId/'$DaoVoiceId'/g' \
-e 's/Your AddthisPubid/'$AddthisPubid'/g' \
-e 's|Your WalineSerURL|'$WalineSerURL'|g' config/_default/params.toml

echo "Replace the plugin's paramter is success."