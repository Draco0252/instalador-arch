from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

import os

mod = "mod4"

#Posibles iconos              󰈸         

# Colores

color = {
    "bg" : None,
    "negro" : "#101010",
    "blanco" : "#fdfdfd",
    "rojo"	: "#f02525",
    "verde" : "#25f025",
    "azul" : "#2525f0",
    "amarillo" : "#f8f025",
    "naranja" : "#f5a025",
    "celeste" : "#00ffff",
    "gris" : "#A1A1A1",
    "morado" : "#a020f0",
}
#funciones
def cal(icono, bg, fg):
    if(icono) and True:
        icono = ""
    else :
        icono = ""

    return widget.TextBox(text=icono, background=bg, foreground=fg, fontsize=23, padding=0)

def sin(pasador, bg, fg):
    if pasador == 1:
        pasador = ""
    
    elif pasador == 2:
        pasador = ""

    return widget.TextBox(text=pasador, foreground=fg, background=bg, fontsize=24, padding=3, padding_y=90)

def toggle_widgetbox(widget_name):
    def inner(qtile):
        # Nombres de los WidgetBox definidos
        widgetbox_names = ["Internet", "Rendimiento", "Calendario"]

        # Cierra todos los WidgetBox menos el que se desea abrir
        for box_name in widgetbox_names:
            if box_name != widget_name and qtile.widgets_map.get(box_name):
                qtile.widgets_map[box_name].close()

        # Alterna el estado del WidgetBox seleccionado
        if qtile.widgets_map.get(widget_name):
            qtile.widgets_map[widget_name].toggle()

    return inner

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],"Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn("alacritty"), desc="Launch terminal"),
    #Key([mod], "ç", lazy.spawn("alacritty -e ranger"), desc="Abrir ranger direcctamente"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "z", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control", "shift"], "o", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control", "shift"], "9", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "control", "shift"], "0", lazy.spawn("shutdown 0"), desc="Apagar el equipo"),
    Key([mod, "control", "shift"], "p", lazy.spawn("reboot"), desc="Reiniciar el equipo"),
    Key([mod, "shift"], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # atajos personalizados
    Key([mod], "m", lazy.spawn("rofi -show drun"), desc="Abrir menu"),
    #Key([mod], "s", lazy.spawn("ranger"), desc="Abrir ranger")
    # Manejar las Cajas
    Key([mod], "8", lazy.function(toggle_widgetbox("Internet")), desc="Toggle Internet box"),
    Key([mod], "9", lazy.function(toggle_widgetbox("Rendimiento")), desc="Toggle Performance box"),
    Key([mod], "0", lazy.function(toggle_widgetbox("Calendario")), desc="Toggle Performance box"),

]


__groups = {
    1: Group(""),
    2: Group(""),
    3: Group(""),
    "q": Group(""),
    "w": Group(""),
    "e": Group(""),
    "a": Group(""),
    "s": Group(""),
    "d": Group(""),
}
groups = [__groups[i] for i in __groups]


def get_group_key(name):
    return [k for k, g in __groups.items() if g.name == name][0]


for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], str(get_group_key(i.name)), lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1+shift+letter of group = switch to & move focused window to group
        Key([mod, "shift"], str(get_group_key(i.name)),
            lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Max(),
    layout.Columns(border_focus_stack=color["rojo"], border_width=2, margin=5, single_margin=0),
]

widget_defaults = dict(
    font="hack",
    fontsize=14,
    padding=4,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    active=color["rojo"],
                    fontsize=28,
                    border_width=10,
                    highlight_method='block',
                    this_current_screen_border=color["gris"],
                    inactive=color["gris"],
                    padding=10,
                ),
                widget.Spacer(),
                ######### Cajas ##############
                cal(False, color["negro"], color["morado"]),
                widget.WidgetBox(
                    widgets=[
                        sin("", color["morado"], color["negro"]),
                        widget.Net(
                            interface="wlan0",
                            foreground=color["negro"],
                            background=color["morado"],

                        ),
                        sin(2, color["morado"], color["negro"]),
                        sin("", color["morado"], color["negro"]),
                        widget.Net(
                            interface="enp2s0",
                            foreground=color["negro"],
                            background=color["morado"],

                        ),
                    ],
                    text_closed="",
                    text_open="",
                    foreground=color["negro"],
                    background=color["morado"],
                    fontsize=24,
                    padding=11,
                    name="Internet",
                ),
                cal(False, color["morado"], color["naranja"]),
                widget.WidgetBox(
                    widgets=[
                        widget.ThermalSensor(
                            foreground=color["negro"],
                            background=color["naranja"],
                            tag_sensor="Package id 0",
                            threshold=80,
                            fmt="  : {} |"
                        ),
                        sin("", color["naranja"], color["negro"]),
                        widget.CPU(
                            foreground=color["negro"],
                            background=color["naranja"],
                            fmt=": {} |"
                        ),
                        sin("", color["naranja"], color["negro"]),
                        widget.Memory(
                            foreground=color["negro"],
                            background=color["naranja"],
                            fmt=":{}  "
                        ),
                    ],
                    text_closed="",
                    text_open="",
                    foreground=color["negro"],
                    background=color["naranja"],
                    fontsize=24,
                    padding=11,
                    name="Rendimiento",
                ),
                cal(False, color["naranja"], color["amarillo"]),
                widget.WidgetBox(
                    widgets=[
                        sin("", color["amarillo"], color["negro"]),
                        widget.Clock(format=" %d-%m-%Y %a %I:%M %p", foreground=color["negro"], background=color["amarillo"]),
                        sin(" ", color["amarillo"], color["negro"]),
                    ],
                    text_closed="",
                    text_open="",
                    foreground=color["negro"],
                    background=color["amarillo"],
                    fontsize=24,
                    padding=11,
                    name="Calendario",
                ),
            ],
            29,
            background=color["negro"]
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

cmd = [
    "picom &",
	"feh --bg-fill /home/draco/.config/qtile/logo.png",
	#"xmodmap -e 'pointer = 3 2 1'",
	#"volumeicon &"
]
for x in cmd:
	os.system(x)
