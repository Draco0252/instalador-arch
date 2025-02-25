# Archivo .p10k.zsh básico para Powerlevel10k

# Colores personalizados
negro="#101010"           # Fondo negro
blanco="#ffffff"          # Blanco
rojo="#f02525"            # Rojo
verde="#25f025"           # Verde
azul="#2525f0"            # Azul
amarillo="#f8f025"        # Amarillo
naranja="#f5a025"         # Naranja
celeste="#00ffff"         # Celeste
gris="#A1A1A1"            # Gris
morado="#a020f0"          # Morado

# Estilo de fuente de iconos
POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL='░▒▓'
# Configuración del prompt
# Habilitar prompt en múltiples líneas
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# Personalización del prompt izquierdo
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon              # Icono del sistema operativo
  user
  dir                  # Directorio actual
  vcs                  # Estado del sistema de control de versiones (Git)
)

# Personalización del prompt derecho
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

# Iconos personalizados
POWERLEVEL9K_USER_ICON=''                     # Icono del sistema operativo
POWERLEVEL9K_DIR_ICON=''                    # Icono del directorio
POWERLEVEL9K_VCS_ICON=''                    # Icono del sistema de control de versiones (Git)

# Colores del prompt
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$negro
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=$rojo

typeset -g POWERLEVEL9K_USER_FOREGROUND=$negro
typeset -g POWERLEVEL9K_USER_BACKGROUND=$rojo

typeset -g POWERLEVEL9K_DIR_FOREGROUND=$rojo
typeset -g POWERLEVEL9K_DIR_BACKGROUND=$negro

typeset -g POWERLEVEL9K_VCS_FOREGROUND=$gris
typeset -g POWERLEVEL9K_VCS_BACKGROUND=$negro

# Configuración avanzada del VCS (Git)
typeset -g POWERLEVEL9K_VCS_SHOW_UPSTREAM=true     # Mostrar rama upstream
typeset -g POWERLEVEL9K_VCS_SHOW_STAGED=true       # Mostrar cambios en staged
typeset -g POWERLEVEL9K_VCS_SHOW_UNTRACKED=true    # Mostrar archivos no rastreados

# Configuración del prompt de múltiples líneas
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='' # Sin prefijo al inicio
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='❯' # Símbolo al final

# Personalización del prompt de comandos
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76

# Configuración adicional
POWERLEVEL9K_READONLY=true # Modo de solo lectura opcional
POWERLEVEL9K_SSH_ICON='󰣀'  # Icono para conexión SSH

# Fin del archivo
