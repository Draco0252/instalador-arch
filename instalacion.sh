#!/bin/bash

# Salir inmediatamente si ocurre un error
set -ex

# Solicita el nombre de usuario y la contraseña durante la ejecución
read -p "Introduce el nombre de usuario: " USERNAME
read -sp "Introduce la contraseña para $USERNAME: " PASSWORD
echo

# Variables
read -p "Introduce el nombre del disco (ej. /dev/sda): " DISK
HOSTNAME="archlinux"  # Nombre del sistema (hostname)
LOCALE="es_ES.UTF-8"  # Configuración de idioma
KEYMAP="es"  # Distribución del teclado
TIMEZONE="Europe/Madrid"  # Zona horaria

# Particiones
EFI_PART="${DISK}1"
SWAP_PART="${DISK}2"
ROOT_PART="${DISK}3"

# Actualiza el reloj del sistema
timedatectl set-ntp true

# Particionado del disco
echo "Particionando el disco..."
parted $DISK --script mklabel gpt \
  mkpart primary fat32 1MiB 512MiB \
  set 1 esp on \
  mkpart primary linux-swap 512MiB 2.5GiB \
  mkpart primary ext4 2.5GiB 100%

# Formateo de las particiones
echo "Formateando particiones..."
mkfs.fat -F32 "$EFI_PART"
mkswap "$SWAP_PART"
mkfs.ext4 "$ROOT_PART"

# Montaje de las particiones
echo "Montando particiones..."
mount "$ROOT_PART" /mnt
swapon "$SWAP_PART"
mkdir /mnt/boot
mount "$EFI_PART" /mnt/boot

# Instalación del sistema base
echo "Instalando el sistema base..."
pacstrap /mnt base base-devel linux-zen linux-firmware networkmanager

# Genera el archivo fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Configuración del sistema
echo "Configurando el sistema..."
arch-chroot /mnt <<EOF
  echo root:${PASSWORD} | chpasswd
  useradd -m -G wheel ${USERNAME}
  echo ${USERNAME}:${PASSWORD} | chpasswd
  echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

  #pacman -S --noconfirm blender thunderbird bitwarden virtualbox tor libreoffice 
  pacman -S --noconfirm git sudo grub efibootmgr firefox alacritty ranger lsd bat zathura vlc feh unzip rofi fastfetch gnome qtile picom zsh

  cd /home/${USERNAME}
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  yay -S --noconfirm brave-bin wasistlos-appimage

  ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
  hwclock --systohc
  echo '${LOCALE} UTF-8' > /etc/locale.gen
  locale-gen
  echo "LANG=${LOCALE}" > /etc/locale.conf
  echo "KEYMAP=${KEYMAP}" > /etc/vconsole.conf
  echo "${HOSTNAME}" > /etc/hostname
  echo '127.0.0.1   localhost' > /etc/hosts
  echo '::1         localhost' >> /etc/hosts
  echo "127.0.1.1   ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts

  cp -r alacritty /home/${USERNAME}/.config
  cp -r nvim /home/${USERNAME}/.config
  cp -r qtile /home/${USERNAME}/.config
  cp -r ranger /home/${USERNAME}/.config
  cp -r rofi /home/${USERNAME}/.config
  cp .zshrc /home/${USERNAME}
  cp p10k.zsh /home/${USERNAME}
  chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}
  chsh -s /bin/zsh ${USERNAME}
  ln -svf /home/${USERNAME}/.config /root/.config

  systemctl enable gdm
  systemctl enable NetworkManager

  grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
  grub-mkconfig -o /boot/grub/grub.cfg
EOF

# Finalización
echo "¡Instalación base de Arch Linux completada! El equipo se reiniciará."
shutdown 0

