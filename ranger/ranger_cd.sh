#!/bin/bash

# Abre Ranger y guarda la última carpeta visitada
ranger --choosedir=/tmp/.ranger_cd_file "$@"

# Si el archivo existe, cambia al directorio guardado
if [ -f /tmp/.ranger_cd_file ]; then
    cd "$(cat /tmp/.ranger_cd_file)" || exit
    rm -f /tmp/.ranger_cd_file
fi

