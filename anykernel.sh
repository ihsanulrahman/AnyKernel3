### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Zenith Kernel
kernel.compiler=AOSP CLANG 20
kernel.made=iHSAN
kernel.version=4.14.336
message.word=Thank you for installing Zenith Kernel
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=miatoll
device.name2=curtana
device.name3=excalibur
device.name4=gram
device.name5=joyeuse
supported.versions=11.0-15.0
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
block=/dev/block/bootdevice/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

if mountpoint -q /data; then
	ui_print " ";
	ui_print "[+] Backing up boot & DTBO . . .";

	dd if=/dev/block/by-name/boot of=/sdcard/backup_boot.img;
	dd if=/dev/block/by-name/dtbo of=/sdcard/backup_dtbo.img;
	if [ $? != 0 ]; then
		ui_print "[!] Backup failed; proceeding anyway . . .";
	else
		ui_print "[+] Done";
	fi
fi

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;
. tools/ak3-custom.sh;

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

check_ksu;

write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
## end boot install

## AnyKernel install
split_boot;

# begin ramdisk changes
# end ramdisk changes

flash_boot;
flash_dtbo;
## end install
