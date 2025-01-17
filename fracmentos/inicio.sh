#!/bin/bash

# Salir inmediatamente si ocurre un error
set -ex

# Solicita el nombre de usuario y la contraseña durante la ejecución
read -p "Introduce el nombre de usuario: " USERNAME
read -sp "Introduce la contraseña para $USERNAME: " PASSWORD
echo

# Variables
DISK="/dev/sda"  # Cambia esto según el disco donde instalarás Arch Linux
HOSTNAME="archlinux"  # Nombre del sistema (hostname)
LOCALE="es_ES.UTF-8"  # Configuración de idioma
KEYMAP="es"  # Distribución del teclado
TIMEZONE="Europe/Madrid"  # Zona horaria (ajústala según tu ubicación)

# Actualiza el reloj del sistema
# Asegura que el reloj del sistema esté sincronizado con la hora de Internet
timedatectl set-ntp true

# Particionado del disco
echo "Particionando el disco..."
# Crea una tabla de particiones GPT y tres particiones:
# 1. Partición EFI (fat32) para el gestor de arranque (512 MiB)
# 2. Partición swap (2 GiB)
# 3. Partición raíz (ext4) para el sistema operativo (resto del espacio)
parted $DISK --script mklabel gpt \
  mkpart primary fat32 1MiB 512MiB \
  set 1 esp on \
  mkpart primary linux-swap 512MiB 2.5GiB \
  mkpart primary ext4 2.5GiB 100%

# Formateo de las particiones
echo "Formateando particiones..."
mkfs.fat -F32 "${DISK}1"  # Formatea la partición EFI como FAT32
mkswap "${DISK}2"  # Activa la partición swap
mkfs.ext4 "${DISK}3"  # Formatea la partición raíz como ext4

# Montaje de las particiones
echo "Montando particiones..."
mount "${DISK}3" /mnt  # Monta la partición raíz
swapon "${DISK}2"  # Activa la partición swap
mkdir /mnt/boot  # Crea el directorio de montaje para la partición EFI
mount "${DISK}1" /mnt/boot  # Monta la partición EFI

# Instalación del sistema base
echo "Instalando el sistema base..."
# Instala los paquetes base del sistema, el kernel Zen, y otras utilidades básicas
pacstrap /mnt base base-devel linux-zen linux-firmware networkmanager

# Mover configuraciones adicionales dentro del sistema
cp -r instalador-arch /mnt

# Genera el archivo fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Configuración del sistema
echo "Configurando el sistema..."
arch-chroot /mnt bash -c "
