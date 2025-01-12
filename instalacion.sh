#!/bin/bash

# Salir inmediatamente si ocurre un error
set -e

# Variables
DISK="/dev/sda"	# Cambia esto según el disco donde instalarás Arch Linux
HOSTNAME="archlinux"	# Nombre del sistema (hostname)
USERNAME="user"	# Nombre de usuario que se creará
PASSWORD="password"	# Contraseña del usuario (y del root en este ejemplo)
LOCALE="es_ES.UTF-8"	# Configuración de idioma
KEYMAP="es"	# Distribución del teclado
TIMEZONE="Europe/Madrid"	# Zona horaria (ajústala según tu ubicación)

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
mkfs.fat -F32 "${DISK}1"	# Formatea la partición EFI como FAT32
mkswap "${DISK}2"	# Activa la partición swap
mkfs.ext4 "${DISK}3"	# Formatea la partición raíz como ext4

# Montaje de las particiones
echo "Montando particiones..."
mount "${DISK}3" /mnt	# Monta la partición raíz
swapon "${DISK}2"	# Activa la partición swap
mkdir /mnt/boot	# Crea el directorio de montaje para la partición EFI
mount "${DISK}1" /mnt/boot	# Monta la partición EFI

# Instalación del sistema base
echo "Instalando el sistema base..."
# Instala los paquetes base del sistema, el kernel Zen, y otras utilidades básicas
pacstrap /mnt base base-devel linux-zen linux-firmware networkmanager

# mover la configuracion dentro del sistema
mv ../instalacion /mnt
# Genera el archivo fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Configuración del sistema
echo "Configurando el sistema..."
arch-chroot /mnt bash -c "

	# Definiendo usuarios
	echo root:$PASSWORD | chpasswd  # Establece la contraseña para el usuario root
	useradd -m -G wheel $USERNAME  # Crea un usuario con privilegios de sudo
	echo $USERNAME:$PASSWORD | chpasswd  # Establece la contraseña del nuevo usuario
	echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel  # Habilita sudo para el grupo wheel
	cd /home/$USERNAME
	# instalacion de paquetes con pacman
	pacman -S blender thunderbird bitwarden git sudo grub efibootmgr virtualbox tor firefox libreoffice alacritty ranger lsd bat zathura vlc feh unzip rofi fastfetch gnome qtile picom zsh
	# inatalacion de yay
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	# instalacion de paquetes yay
	yay -S brave-bin wasistlos-appimage
	# Configuracion del sistema
	ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime  # Configura la zona horaria
	hwclock --systohc  # Ajusta el reloj del hardware
	echo '$LOCALE UTF-8' > /etc/locale.gen  # Habilita el locale seleccionado
	locale-gen  # Genera los locales configurados
	echo 'LANG=$LOCALE' > /etc/locale.conf  # Define la variable de idioma del sistema
	echo 'KEYMAP=$KEYMAP' > /etc/vconsole.conf  # Configura el mapa de teclado
	echo '$HOSTNAME' > /etc/hostname  # Establece el nombre de la máquina
	echo '127.0.0.1   localhost' > /etc/hosts  # Configura las entradas básicas de hosts
	echo '::1         localhost' >> /etc/hosts
	echo '127.0.1.1   $HOSTNAME.localdomain $HOSTNAME' >> /etc/hosts
	# Configuracion personalizada
	cp /instalacion/alacritty /home/$USERNAME/.config
	cp /instalacion/nvim /home/$USERNAME/.config
	cp /instalacion/qtile /home/$USERNAME/.config
	cp /instalacion/ranger /home/$USERNAME/.config
	cp /instalacion/rofi /home/$USERNAME/.config
	cp /instalacion/.zshrc /home/$USERNAME
	cp /instalacion/p10k.zsh /home/$USERNAME
	cp /instalacion/fonts/* /usr/share/fonts
	chown -R $USERNAME /home/$USERNAME
	chsh -s /bin/zsh
	ln -svf /home/$USERNAME/.config /root/.config
	# Habilitando servisios
	systemctl enable gdm # Habilita el entorno de escritorio
	systemctl enable NetworkManager # Habilita el servicio de red
	# Instalación del gestor de arranque
	echo "Instalando el gestor de arranque..."
	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB  # Instala GRUB
	grub-mkconfig -o /boot/grub/grub.cfg  # Genera la configuración de GRUB
"

# Finalización
echo "¡Instalación base de Arch Linux completada! El eqipo se reiniciara."

shutdown o
