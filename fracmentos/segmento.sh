#!/bin/bash

# Salir si hay errores
set -ex

# Solicitar entrada de usuario
read -p "Introduce el nombre de usuario: " USERNAME
read -sp "Introduce la contraseña para $USERNAME: " PASSWORD
echo

# Variables
read -p "Introduce el nombre del disco (ej. /dev/sda): " DISK
HOSTNAME="archlinux"
LOCALE="es_ES.UTF-8"
KEYMAP="es"
TIMEZONE="Europe/Madrid"

# Particionar y formatear
parted $DISK --script mklabel gpt \
  mkpart primary fat32 1MiB 512MiB \
  set 1 esp on \
  mkpart primary linux-swap 512MiB 2.5GiB \
  mkpart primary ext4 2.5GiB 100%

mkfs.fat -F32 "${DISK}1"
mkswap "${DISK}2"
mkfs.ext4 "${DISK}3"

mount "${DISK}3" /mnt
swapon "${DISK}2"
mkdir /mnt/boot
mount "${DISK}1" /mnt/boot

pacstrap /mnt base base-devel linux-zen linux-firmware networkmanager
genfstab -U /mnt >> /mnt/etc/fstab

# Crear script temporal para el entorno chroot
cat <<EOF > /mnt/chroot-setup.sh
#!/bin/bash
echo "Configurando el sistema..."
echo root:${PASSWORD} | chpasswd
useradd -m -G wheel ${USERNAME}
echo ${USERNAME}:${PASSWORD} | chpasswd
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc
echo '${LOCALE} UTF-8' > /etc/locale.gen
locale-gen
echo "LANG=${LOCALE}" > /etc/locale.conf
echo "KEYMAP=${KEYMAP}" > /etc/vconsole.conf
echo "${HOSTNAME}" > /etc/hostname
cat <<HOSTS > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${HOSTNAME}.localdomain ${HOSTNAME}
HOSTS

# Más configuraciones aquí, como instalación de paquetes
systemctl enable NetworkManager
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
EOF

chmod +x /mnt/chroot-setup.sh
arch-chroot /mnt /chroot-setup.sh
rm /mnt/chroot-setup.sh

# Finalizar
echo "¡Instalación completada! Reiniciando..."
shutdown 0
