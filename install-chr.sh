#!/bin/bash
set -e

CHR_URL="https://download.mikrotik.com/routeros/6.49.10/chr-6.49.10.img.zip"
CHR_ZIP="chr.img.zip"
CHR_IMG="chr.img"
DISK="/dev/vda"

echo "=== MikroTik CHR Installer ==="
echo "Target disk: $DISK"
echo "This will ERASE ALL DATA on the disk!"
sleep 5

# Must be root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

echo "[1/6] Installing dependencies..."
apt update
apt install -y wget unzip

echo "[2/6] Downloading MikroTik CHR..."
wget "$CHR_URL" -O "$CHR_ZIP"

echo "[3/6] Extracting image..."
unzip -o "$CHR_ZIP"

# Rename extracted image to chr.img (no version)
echo "Renaming image to chr.img..."
mv chr-*.img "$CHR_IMG"

echo "[4/6] Enabling SysRq..."
echo 1 > /proc/sys/kernel/sysrq
sync

echo "[5/6] Writing image to $DISK..."
dd if="$CHR_IMG" of="$DISK" bs=100M status=progress conv=fsync
sync

echo "[6/6] Rebooting into MikroTik..."
echo b > /proc/sysrq-trigger
