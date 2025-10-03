#!/bin/bash

# Kernel Backup Script for AnyKernel3

# Generate backup names
generate_backup_name() {
    local device=$(getprop ro.product.device)
    local android_version=$(getprop ro.build.version.release)
    local build_date=$(date +%Y%m%d)
    
    echo "kernel_backup_${device}_${android_version}_${build_date}"
}

# Verify backup
verify_backup() {
    local backup_file=$1
    if [ -f "$backup_file" ] && [ $(stat -c%s "$backup_file") -gt 10000000 ]; then
        ui_print "✓ Backup verified: $(basename $backup_file)"
        return 0
    else
        ui_print "✗ Backup failed or file too small"
        rm -f "$backup_file"
        return 1
    fi
}

# Backup
backup_kernel_complete() {
    ui_print " "
    ui_print "=== KERNEL BACKUP ==="
    
    # Create backup directory
    BACKUP_DIR="/sdcard/KernelBackups"
    mkdir -p "$BACKUP_DIR"
    
    # Generate backup name prefix
    BACKUP_PREFIX="$BACKUP_DIR/$(generate_backup_name)"
    
    ui_print "Backup prefix: $(basename $BACKUP_PREFIX)"
    ui_print " "
    
    # Backup boot 
    if [ -n "$block" ] && [ -e "$block" ]; then
        ui_print "Backing up boot image..."
        BOOT_BACKUP="${BACKUP_PREFIX}_boot.img"
        if dd if="$block" of="$BOOT_BACKUP" bs=4096; then
            if verify_backup "$BOOT_BACKUP"; then
                ui_print "✓ Boot backup: $(basename $BOOT_BACKUP)"
                ui_print "  Size: $(du -h "$BOOT_BACKUP" | cut -f1)"
            fi
        else
            ui_print "✗ Boot backup failed"
        fi
    else
        ui_print "✗ Boot partition not found"
    fi
    
    ui_print " "
    
    # Backup dtbo 
    if [ -n "$DTBO" ] && [ -e "$DTBO" ]; then
        ui_print "Backing up dtbo image..."
        DTBO_BACKUP="${BACKUP_PREFIX}_dtbo.img"
        if dd if="$DTBO" of="$DTBO_BACKUP" bs=4096; then
            if verify_backup "$DTBO_BACKUP"; then
                ui_print "✓ DTBO backup: $(basename $DTBO_BACKUP)"
                ui_print "  Size: $(du -h "$DTBO_BACKUP" | cut -f1)"
            fi
        else
            ui_print "✗ DTBO backup failed"
        fi
    else
        ui_print "ℹ DTBO partition not found or not needed"
    fi
    
    ui_print " "
    ui_print "📍 Backup location: $BACKUP_DIR"
    ui_print " "
}

# Clean old backups
clean_old_backups() {
    local backups=$(ls -t /sdcard/KernelBackups/kernel_backup_*.img 2>/dev/null)
    local count=0
    for backup in $backups; do
        count=$((count + 1))
        if [ $count -gt 5 ]; then
            ui_print "Cleaning old backup: $(basename $backup)"
            rm -f "$backup"
        fi
    done
}

backup_main() {
    backup_kernel_complete
    clean_old_backups
}