# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

import subprocess

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from time import sleep
import os

from floating_window_snapping import move_snap_window


mod = "mod4"
# terminal = guess_terminal()
terminal = "kitty"
browser = "google-chrome-stable"
home = os.path.expanduser('~')
script = home + "/script"

keys = [
    # common app
    Key([mod], "d", lazy.spawn("rofi -modi drun -show drun -term kitty"), desc="launch app launcher"),
    Key([mod], "e", lazy.spawn("rofi -show emoji -modi emoji")),
    Key([mod], "c", lazy.spawn("rofi -show calc -modi calc -no-show-match -no-sort")),
    Key([mod], "x", lazy.spawn("rofi-wifi-menu")),
    Key([mod, "shift"], "q", lazy.spawn(home + "/script/powermenu.sh"), desc="Shutdown Qtile"),
    Key(["mod1", "shift"], "q", lazy.shutdown()),
    Key([mod], "o", lazy.spawn("kitty lf"), desc="launch lf"),
    Key([mod, "shift"], "o", lazy.spawn("thunar"), desc="launch lf"),
    Key([mod], "u", lazy.spawn(f"kitty {script}/runspt"), desc="launch spt"),
    Key(
        [mod],
        "w",
        lazy.spawn(browser + " --enable-features=WebUIDarkMode --force-dark-mode -enable-logging --v=1"),
        desc="launch browser",
    ),
    Key(
        [mod, "shift"],
        "d",
        lazy.spawn(
            'rofi -modi drun -show window -linepadding 4 -columns 2 -padding 50 -hide-scrollbar -terminal kitty -show-icons'
        ),
        desc="launch browser",
    ),
    Key([mod], "p", lazy.spawn("discord"), desc="launch discord"),
    Key([mod], "t", lazy.spawn("kitty btop"), desc="launch btop"),
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
    # Key([mod], "[", lazy.layout.swap_left()),
    # Key([mod], "]", lazy.layout.swap_right()),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "n", lazy.layout.normalize(), desc="normalize window size ratios"),
    Key([mod], "m", lazy.layout.maximize(), desc="toggle window between minimum and maximum sizes"),
    Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc="toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="toggle fullscreen"),
    Key([], "XF86MonBrightnessUp", lazy.spawn(f'sh {script}/brightness.sh up')),
    Key([], "XF86MonBrightnessDown", lazy.spawn(f'sh {script}/brightness.sh down')),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(f"sh {script}/volume.sh up")),
    Key([], "XF86AudioLowerVolume", lazy.spawn(f"sh {script}/volume.sh down")),
    Key([], "XF86AudioMute", lazy.spawn(f"sh {script}/volume.sh mute")),
    # Key([mod], "v", lazy.spawn(home + "/.local/bin/rofi-copyq")),
    Key([mod], "v", lazy.spawn("copyq show")),
    Key([], "Print", lazy.spawn("flameshot screen -c")),
    Key([mod], "Print", lazy.spawn("flameshot full -c")),
    Key([mod, "shift"], "s", lazy.spawn("flameshot gui")),
    Key(
        ["shift"],
        "Print",
        lazy.spawn(
            f"scrot -s '{home}/Pictures/screenshot/Screenshot_%F_%H-%M-%S.png' -u -e 'copyq copy image/png - < $f'"
        ),
    ),
    Key([mod, "shift"], "p", lazy.spawn("bwmenu")),
    Key([mod, "control"], "p", lazy.spawn("find-cursor -o 2 -l 6 -w 500")),
    # Key([mod], "-", lazy.screen.prev_group()),
    # Key([mod], "`" lazy.hide_show_bar("top")),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )


def init_border_config():
    config = {
        "border_focus": "#6c71c4",
        "border_normal": "#073642",
        "margin": 5,
        "border_width": 1,
        "grow_amount": 2,
    }
    return config


def init_treetab_config():
    config = {
        "active_bg": "#6c71c4",
        "inactive_bg": "#6272a4",
        "active_fg": "#f8f8f2",
        "inactive_fg": "#f8f8f2",
        "bg_color": "#282a36",
        "padding_left": 0,
        "padding_x": 0,
        "fontsize": 13,
        "font": "IBM Plex Mono",
        "panel_width": 100,
    }
    return config


layouts = [
    layout.Columns(**init_border_config()),
    layout.Floating(**init_border_config()),
    layout.TreeTab(**init_treetab_config()),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    layout.Matrix(**init_border_config()),
    # layout.MonadTall(ratio=0.6, margin=5, border_width=1),
    layout.MonadWide(ratio=0.66, **init_border_config()),
    # layout.RatioTile(),
    # layout.Tile(master_length = 2),
    # layout.VerticalTile(**init_border_config()),
    # layout.Zoomy(**init_border_colors()),
    layout.Max(),
]

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()


def init_widget_list():
    widget_list = [
        widget.CurrentLayoutIcon(),
        widget.GroupBox(this_current_screen_border='#805bb5', rdisable_drag=True),
        widget.Spacer(bar.STRETCH),
        widget.WindowName(max_chars=69),
        # widget.Spacer(bar.STRETCH),
        widget.Systray(),
        # widget.PulseVolume(emoji=False),
        # widget.PulseVolume(emoji=True),
        widget.Net(format='{down} ↓↑ {up}'),
        # widget.Wlan(),
        widget.Clock(format='%d-%m (%b) %a %I:%M %p', padding=10),
        widget.WidgetBox(
            close_button_location='right',
            text_closed='◀ open',
            text_open='─ close',
            widgets=[
                widget.TaskList(),
            ],
        ),
    ]
    return widget_list


def init_widget_screen_vertical():
    widget_list = [
        widget.CurrentLayoutIcon(),
        widget.GroupBox(),
        widget.Spacer(50),
        widget.WindowName(max_chars=30),
        # widget.PulseVolume(emoji=True),
        # widget.PulseVolume(emoji=False, ),
        # widget.Wlan(format = '{essid}'),
        # widget.Battery(format='{percent:2.0%}'),
        # widget.BatteryIcon(),
        widget.Clock(format='%d-%m (%b) %a %I:%M %p'),
    ]
    return widget_list


screens = [
    # Screen(),
    Screen(top=bar.Bar(init_widget_list(), background="#0000004f", opacity=1, size=30)),
    Screen(top=bar.Bar(init_widget_screen_vertical(), background="#0000004f", opacity=1, size=30)),
    Screen(top=bar.Bar(init_widget_screen_vertical(), background="#0000004f", opacity=1, size=30)),
    # Screen(top=bar.Bar(init_widget_screen_vertical(), background="#0000004f", opacity=1, size=30)),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    # Drag([mod], "Button1", move_snap_window(snap_dist=20), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
    Click([mod, "shift"], "Button2", lazy.window.toggle_minimize()),
]


@hook.subscribe.startup_once
def auto_start():
    # subprocess.call([home+ '/script/monitor.sh'])
    # lazy.spawn(home+ '/script/monitor.sh')
    sleep(5)
    subprocess.call([home + '/.config/qtile/autostart.sh'])
    # subprocess.call(['/etc/nixos/autostart.sh'])
    # pass


dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class='confirmreset'),  # gitk
        Match(wm_class='makebranch'),  # gitk
        Match(wm_class='maketag'),  # gitk
        Match(wm_class='ssh-askpass'),  # ssh-askpass
        Match(title='branchdialog'),  # gitk
        Match(title='pinentry'),  # GPG key password entry
        Match(wm_class='PacketTracer'),
        Match(wm_class="zoom"),
        Match(wm_class="copyq"),
    ]
)

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
