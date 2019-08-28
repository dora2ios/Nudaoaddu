#!/bin/bash
echo "**** Enter Recovery ****"
if [ -e "ibss.signed" ]; then
  rm ibss.signed
fi

if [ -e "ibec.signed" ]; then
  rm ibec.signed
fi

if [ $# -gt 3 ]; then
  echo "[ERROR] Too many arguments"
exit
fi

if [ $# -lt 2 ]; then
  echo "**HOW TO USE"
  echo "./recovery.sh <device> <boardconfig>"
  exit
fi

## A7
if [ $1 = "iPhone6,1" ]&&[ $2 = "n51ap" ];then
echo "iPhone 5s"
dname="iphone6"
url="http://updates-http.cdn-apple.com/2019SummerFCS/fullrestores/041-86553/9E218350-A743-11E9-9805-B896964EA79A/iPhone_4.0_64bit_12.4_16G77_Restore.ipsw"
fi

if [ $1 = "iPhone6,2" ]&&[ $2 = "n53ap" ];then
echo "iPhone 5s"
dname="iphone6"
url="http://updates-http.cdn-apple.com/2019SummerFCS/fullrestores/041-86553/9E218350-A743-11E9-9805-B896964EA79A/iPhone_4.0_64bit_12.4_16G77_Restore.ipsw"
fi

if [ $1 = "iPad4,1" ]&&[ $2 = "j71ap" ];then
echo "iPhone Air"
dname="ipad4"
url="http://updates-http.cdn-apple.com/2019SummerFCS/fullrestores/041-86564/9E3935B8-A743-11E9-92A2-EC2E312C99DC/iPad_64bit_12.4_16G77_Restore.ipsw"
fi

if [ $1 = "iPad4,2" ]&&[ $2 = "j72ap" ];then
echo "iPhone Air"
dname="ipad4"
url="http://updates-http.cdn-apple.com/2019SummerFCS/fullrestores/041-86564/9E3935B8-A743-11E9-92A2-EC2E312C99DC/iPad_64bit_12.4_16G77_Restore.ipsw"
fi

if [ $1 = "iPad4,3" ]&&[ $2 = "j73ap" ];then
echo "iPhone Air"
dname="ipad4"
url="http://updates-http.cdn-apple.com/2019SummerFCS/fullrestores/041-86564/9E3935B8-A743-11E9-92A2-EC2E312C99DC/iPad_64bit_12.4_16G77_Restore.ipsw"
fi

if [ $1 = "iPad4,4" ]&&[ $2 = "j85ap" ];then
echo "iPhone mini 2"
dname="ipad4b"
url="http://updates-http.cdn-apple.com/2019SummerFCS/fullrestores/041-86564/9E3935B8-A743-11E9-92A2-EC2E312C99DC/iPad_64bit_12.4_16G77_Restore.ipsw"
fi

if [ $1 = "iPad4,5" ]&&[ $2 = "j86ap" ];then
echo "iPhone mini 2"
dname="ipad4b"
url="http://updates-http.cdn-apple.com/2019SummerFCS/fullrestores/041-86564/9E3935B8-A743-11E9-92A2-EC2E312C99DC/iPad_64bit_12.4_16G77_Restore.ipsw"
fi

if [ $1 = "iPad4,6" ]&&[ $2 = "j87ap" ];then
echo "iPhone mini 2"
dname="ipad4b"
url="http://updates-http.cdn-apple.com/2019SummerFCS/fullrestores/041-86564/9E3935B8-A743-11E9-92A2-EC2E312C99DC/iPad_64bit_12.4_16G77_Restore.ipsw"
fi

if [ $1 = "iPad4,7" ]&&[ $2 = "j85map" ];then
echo "iPhone mini 3"
dname="ipad4bm"
url="http://updates-http.cdn-apple.com/2019SummerFCS/fullrestores/041-86554/9E08736A-A743-11E9-B479-F4141D08E641/iPad_64bit_TouchID_12.4_16G77_Restore.ipsw"
fi

if [ $1 = "iPad4,8" ]&&[ $2 = "j86map" ];then
echo "iPhone mini 3"
dname="ipad4bm"
url="http://updates-http.cdn-apple.com/2019SummerFCS/fullrestores/041-86554/9E08736A-A743-11E9-B479-F4141D08E641/iPad_64bit_TouchID_12.4_16G77_Restore.ipsw"
fi

if [ $1 = "iPad4,9" ]&&[ $2 = "j87map" ];then
echo "iPhone mini 3"
dname="ipad4bm"
url="http://updates-http.cdn-apple.com/2019SummerFCS/fullrestores/041-86554/9E08736A-A743-11E9-B479-F4141D08E641/iPad_64bit_TouchID_12.4_16G77_Restore.ipsw"
fi

if [ -e "fw/iBEC."$2".RELEASE.im4p" ]&&[ -e "fw/iBSS."$2".RELEASE.im4p" ]; then
  echo "skip"
else
  bin/partialZipBrowser -g Firmware/dfu/iBSS."$dname".RELEASE.im4p $url
  bin/partialZipBrowser -g Firmware/dfu/iBEC."$dname".RELEASE.im4p $url

  mv -v iBSS."$dname".RELEASE.im4p fw/iBSS."$2".RELEASE.im4p
  mv -v iBEC."$dname".RELEASE.im4p fw/iBEC."$2".RELEASE.im4p
  if [ -e "fw/iBEC."$2".RELEASE.im4p" ]&&[ -e "fw/iBSS."$2".RELEASE.im4p" ]; then
    echo "OK"
  else
    echo "[ERROR] Failed firmware download"
    exit
  fi
fi

#igetnonce
ret=$(bin/igetnonce 2>/dev/null | grep ECID)
ecidhex=$(echo $ret | cut -d '=' -f 2 )
ecidhex2=$(echo $ecidhex | tr '[:lower:]' '[:upper:]')
echo $ecidhex2 >/dev/null
ecid=$(echo "obase=10; ibase=16; $ecidhex2" | bc)
echo $ecid #ECID

ret=$(bin/igetnonce 2>/dev/null | grep ApNonce)
nonce=$(echo $ret | cut -d '=' -f 2)
echo $nonce #APNONCE

#sign
bin/img4tool -s shsh2/"$ecid"_"$1"_"$2"_12.4-16G77_"$nonce".shsh2 -c ibss.signed -p fw/iBSS."$2".RELEASE.im4p >/dev/null
bin/img4tool -s shsh2/"$ecid"_"$1"_"$2"_12.4-16G77_"$nonce".shsh2 -c ibec.signed -p fw/iBEC."$2".RELEASE.im4p >/dev/null

echo "Upload 1st stage..."
bin/irecovery -f ibss.signed
sleep 3
echo "Upload 2nd stage..."
bin/irecovery -f ibec.signed
sleep 3

rec="recovery"
reg=$(bin/igetnonce 2>/dev/null | grep Identified | cut -d ' ' -f 7 )
if [ $reg = $rec ]; then
echo "Enter Recovery Mode!!"
bin/irecovery -c "bgcolor 255 0 255" >/dev/null
echo ""
echo "Tickets that your device uses for futurerestore."
echo "SHSH2: \"shsh2/"$ecid"_"$1"_"$2"_12.4-16G77_"$nonce".shsh2\""
fi

rm ibss.signed
rm ibec.signed
