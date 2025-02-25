from ranger.gui.colorscheme import ColorScheme  # Importa la clase base para crear esquemas de colores
from ranger.gui.color import *  # Importa constantes para definir colores y atributos

# Clase que define tu tema personalizado
class MyTheme(ColorScheme):
    # Define el color de la barra de progreso (por ejemplo, al copiar/mover archivos)
    progress_bar_color = blue

    # Método principal que aplica los colores según el contexto
    def use(self, context):
        # Valores predeterminados: sin color de texto, fondo o atributos especiales
        fg, bg, attr = default_colors

        # Si se requiere un reinicio del contexto, vuelve a los colores predeterminados
        if context.reset:
            return default_colors

        # Directorios:
        if context.directory:
            fg = red
            attr = bold

        # Archivos seleccionados: 
        if context.selected:
            fg = red
            bg = black

        # Archivos marcados:
        if context.marked:
            fg = magenta
            #bg = red

        # Enlaces simbólicos:
        if context.link:
            fg = green

        # Archivos con problemas (por ejemplo, permisos incorrectos):
        if context.bad:
            fg = black
            bg = red
            attr = bold

        # Retorna los valores de texto (fg), fondo (bg) y atributos (attr) para este contexto
        return fg, bg, attr
