Saving iOS 12.4 SHSH2 using DFU apnonce collision at A7 (DFU defect)  
macOS 10.13 (or later)  
  
HOW TO SAVE SHSH2    
Run the following script with the device connected in DFU mode.  

./get.sh [device] [boardconfig]  

Example  
./get.sh iPhone6,1 n51ap  


HOW TO RESTORE DEVICE  
Run the following script with the device connected in DFU mode.  
./recovery [device] [boardconfig]  
  
If the device screen displays purple, you are successful.  
If it does not turn purple, try again from DFU mode. You should succeed after a few attempts.  

Finally, Futurerestore  
fun :)  

Credit  
tihmstar: tsschecker, partialZipBrowser, igetnonce, img4tool  
libimobiledevice: irecovery  
s0uthwest: tsschecker, igetnonce, irecovery  
