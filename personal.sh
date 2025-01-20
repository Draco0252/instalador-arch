#! /bin/bash
pacman -S --noconfirm blender thunderbird bitwarden git sudo grub efibootmgr virtualbox tor firefox libreoffice alacritty ranger lsd bat zathura vlc feh unzip rofi fastfetch gnome qtile picom zsh

# Instalación de yay
cd /home/a
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

# Instalación de paquetes con yay
yay -S --noconfirm brave-bin wasistlos-appimage

# Configuración personalizada
cp alacritty /home/a/.config
cp nvim /home/a/.config
cp qtile /home/a/.config
cp ranger /home/a/.config
cp rofi /home/a/.config
cp zshrc /home/a
cp p10k.zsh /home/a
chown -R a:a /home/a
chsh -s /bin/zsh a
ln -svf /home/a/.config /root/.config
