### AnyKernel custom methods
## dereference23@github.com
## Karan-Frost@github.com
## ihsanulrahman@github.com


backup_old() {
if mountpoint -q /data; then
	ui_print "[+] Backing up boot & DTBO . . .";

	dd if=/dev/block/by-name/boot of=/sdcard/backup_boot.img;
	dd if=/dev/block/by-name/dtbo of=/sdcard/backup_dtbo.img;
	if [ $? != 0 ]; then
		ui_print "[!] Backup failed; proceeding anyway . . .";
	else
		ui_print "[+] Done";
	fi
fi
}

check_ksu() {
  if [ -e $AKHOME/KSU_UNLOCK ]; then
    ui_print " " "Flashing KernelSU version...";
    ui_print "This is not secure!";
    7za x $AKHOME/Images.7z -o"$AKHOME/";
    rm -rf $AKHOME/Image;
    gzip $AKHOME/Image_KSU;
    mv $AKHOME/Image_KSU.gz $AKHOME/Image.gz;
  else
    7za x $AKHOME/Images.7z -o"$AKHOME/";
    rm -rf $AKHOME/Image_KSU;
    gzip $AKHOME/Image;
  fi
}
