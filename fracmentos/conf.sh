DISK="/dev/sda"  # Cambia esto según el disco donde instalarás Arch Linux
HOSTNAME="archlinux"  # Nombre del sistema (hostname)
LOCALE="es_ES.UTF-8"  # Configuración de idioma
KEYMAP="es"  # Distribución del teclado
TIMEZONE="Europe/Madrid"  # Zona horaria (ajústala según tu ubicación)
######################################################
echo root:$PASSWORD | chpasswd  # Establece la contraseña para el usuario root
useradd -m -G wheel $USERNAME  # Crea un usuario con privilegios de sudo
echo $USERNAME:$PASSWORD | chpasswd  # Establece la contraseña del nuevo usuario
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel  # Habilita sudo para el grupo wheel
# Instalación de paquetes con pacman
pacman -S --noconfirm blender thunderbird bitwarden git sudo grub efibootmgr virtualbox tor firefox libreoffice alacritty ranger lsd bat zathura vlc feh unzip rofi fastfetch gnome qtile picom zsh
# Instalación de yay
cd /home/$USERNAME
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

# Instalación de paquetes con yay
yay -S --noconfirm brave-bin wasistlos-appimage

# Configuración del sistema
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo '$LOCALE UTF-8' > /etc/locale.gen
locale-gen
echo 'LANG=$LOCALE' > /etc/locale.conf
echo 'KEYMAP=$KEYMAP' > /etc/vconsole.conf
echo '$HOSTNAME' > /etc/hostname
echo '127.0.0.1   localhost' > /etc/hosts
echo '::1         localhost' >> /etc/hosts
echo '127.0.1.1   $HOSTNAME.localdomain $HOSTNAME' >> /etc/hosts
# Configuración personalizada
cp /instalador-arch/alacritty /home/$USERNAME/.config
cp /instalador-arch/nvim /home/$USERNAME/.config
cp /instalador-arch/qtile /home/$USERNAME/.config
cp /instalador-arch/ranger /home/$USERNAME/.config
cp /instalador-arch/rofi /home/$USERNAME/.config
cp /instalador-arch/.zshrc /home/$USERNAME
cp /instalador-arch/p10k.zsh /home/$USERNAME
#cp /instalador-arch/fonts/* /usr/share/fonts
chown -R $USERNAME:$USERNAME /home/$USERNAME
chsh -s /bin/zsh $USERNAME
ln -svf /home/$USERNAME/.config /root/.config

# Habilitación de servicios
systemctl enable gdm
systemctl enable NetworkManager

# Instalación del gestor de arranque
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
