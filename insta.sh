#!/bin/bash

# Sincroniza el reloj del sistema.
timedatectl set-ntp true

# Muestra las unidades de disco disponibles.
lsblk

echo "Selecciona el disco para particionar (por ejemplo, /dev/sda):"
read DISCO

# Crea particiones automáticamente usando fdisk (puedes personalizar el esquema de particiones).
# Este ejemplo asume una partición para EFI y otra para el sistema raíz.
parted $DISCO --script mklabel gpt
parted $DISCO --script mkpart primary fat32 1MiB 512MiB
parted $DISCO --script set 1 esp on
parted $DISCO --script mkpart primary ext4 512MiB 100%

# Formatea las particiones.
mkfs.fat -F32 ${DISCO}1
mkfs.ext4 ${DISCO}2

# Monta las particiones.
mount ${DISCO}2 /mnt
mkdir -p /mnt/boot
mount ${DISCO}1 /mnt/boot

# Selecciona el mejor espejo para la descarga de paquetes.
pacman -Sy --noconfirm reflector
reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

# Instala el sistema base y herramientas esenciales.
pacstrap /mnt base linux linux-firmware

# Genera el archivo fstab para montar las particiones automáticamente.
genfstab -U /mnt >> /mnt/etc/fstab

# Entra al nuevo sistema.
arch-chroot /mnt <<EOF

# Configura el reloj del sistema.
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

# Configura la localización.
echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=es_ES.UTF-8" > /etc/locale.conf

# Establece el nombre del host.
echo "archlinux" > /etc/hostname

# Configura el archivo de hosts.
cat << HOSTS > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   archlinux.localdomain archlinux
HOSTS

# Establece una contraseña de root.
echo "Establece la contraseña de root:"
passwd

# Instala un cargador de arranque (systemd-boot en este ejemplo).
bootctl install

# Crea la configuración del cargador de arranque.
cat << BOOT > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=$(blkid -s PARTUUID -o value ${DISCO}2) rw
BOOT

# Configura el cargador de arranque.
echo "default arch.conf" > /boot/loader/loader.conf
EOF

# Desmonta las particiones y reinicia.
umount -R /mnt
echo "Instalación completada. Reinicia el sistema."
reboot
