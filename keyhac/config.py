import sys
import os
import datetime

import pyauto
from keyhac import *

def configure(keymap):

    # --------------------------------------------------------------------
    # Text editer setting for editting config.py file

    # Setting with program file path (Simple usage)
    keymap.editor = "Code.exe"

    # --------------------------------------------------------------------
    # Customizing the display

    # Font
    # keymap.setFont( "MS Gothic", 12 )

    # Theme
    # keymap.setTheme("black")

    # --------------------------------------------------------------------

    # Key Swap
    keymap.replaceKey(VK_F13, "RCtrl")

    # ime
    def ime_switch(is_on):
        keymap.wnd.setImeStatus(is_on)

    ime_keymap = keymap.defineWindowKeymap()
    ime_keymap["LAlt-Space"] = lambda : ime_switch(False)
    ime_keymap["RAlt-Space"] = lambda :ime_switch(True)

    # Emacs Bindings
    # 左右どちらの Ctrlキーを使うかを指定する（"L": 左、"R": 右）
    side_of_ctrl_key = "R"
    # 左右どちらの Altキーを使うかを指定する（"L": 左、"R": 右）
    side_of_alt_key = "L"

    # Emacs のキーバインドに“したくない”アプリケーションソフトを指定する
    # （Keyhac のメニューから「内部ログ」を ON にすると processname や classname を確認することができます）
    not_emacs_target     = ["bash.exe",               # WSL
                            "ubuntu.exe",             # WSL
                            "ubuntu1604.exe",         # WSL
                            "ubuntu1804.exe",         # WSL
                            "ubuntu2004.exe",         # WSL
                            "debian.exe",             # WSL
                            "kali.exe",               # WSL
                            "SLES-12.exe",            # WSL
                            "openSUSE-42.exe",        # WSL
                            "openSUSE-Leap-15-1.exe", # WSL
                            "WindowsTerminal.exe",    # Windows Terminal
                            # "mstsc.exe",              # Remote Desktop
                            # "mintty.exe",             # mintty
                            # "Cmder.exe",              # Cmder
                            # "ConEmu.exe",             # ConEmu
                            # "ConEmu64.exe",           # ConEmu
                            # "emacs.exe",              # Emacs
                            # "emacs-X11.exe",          # Emacs
                            # "emacs-w32.exe",          # Emacs
                            # "gvim.exe",               # GVim
                            # "Code.exe",               # VSCode
                            # "xyzzy.exe",              # xyzzy
                            # "VirtualBox.exe",         # VirtualBox
                            # "XWin.exe",               # Cygwin/X
                            # "XWin_MobaX.exe",         # MobaXterm/X
                            # "Xming.exe",              # Xming
                            # "vcxsrv.exe",             # VcXsrv
                            # "X410.exe",               # X410
                            # "putty.exe",              # PuTTY
                            # "ttermpro.exe",           # TeraTerm
                            # "MobaXterm.exe",          # MobaXterm
                            # "TurboVNC.exe",           # TurboVNC
                            # "vncviewer.exe",          # UltraVNC
                            # "vncviewer64.exe",        # UltraVNC
                           ]

    def is_emacs_target(window):
        if window.getProcessName() in not_emacs_target:
            return False
        else:
            return True

    # カーソル移動
    def backward_char(modifier = ""):
        self_insert_command(modifier + "Left")()

    def forward_char(modifier = ""):
        self_insert_command(modifier + "Right")()

    def previous_line(modifier = ""):
        self_insert_command(modifier + "Up")()

    def next_line(modifier = ""):
        self_insert_command(modifier + "Down")()

    def move_beginning_of_line():
        self_insert_command("Home")()

    def move_end_of_line():
        self_insert_command("End")()

    ## Kill/Yank
    def delete_backward_char():
        self_insert_command("Back")()

    def delete_char():
        self_insert_command("Delete")()

    def kill_line():
        self_insert_command("S-End")()
        self_insert_command("C-x")()

    def yank():
        self_insert_command("C-v")()

    ## esc
    def esc():
        self_insert_command("Esc")()

    # 共通関数

    def self_insert_command(*keys):
        return keymap.InputKeyCommand(*list(map(addSideOfModifierKey, keys)))

    def addSideOfModifierKey(key):
        key = key.replace("C-", side_of_ctrl_key + "C-")
        key = key.replace("A-", side_of_alt_key + "A-")
        return key

    def kbd(keys):
        if keys:
            keys_lists = [keys.split()]
            for keys_list in keys_lists:
                keys_list[0] = addSideOfModifierKey(keys_list[0])
        else:
            keys_lists = []
        return keys_lists

    def define_key(keymap, keys, command):
        for keys_list in kbd(keys):
            if len(keys_list) == 1:
                keymap[keys_list[0]] = command
            else:
                keymap[keys_list[0]][keys_list[1]] = command

    # キーバインド設定

    keymap_emacs = keymap.defineWindowKeymap(check_func=is_emacs_target)
    ## 「カーソル移動」のキー設定
    define_key(keymap_emacs, "C-b", backward_char)
    define_key(keymap_emacs, "C-f", forward_char)
    define_key(keymap_emacs, "C-p", previous_line)
    define_key(keymap_emacs, "C-n", next_line)
    define_key(keymap_emacs, "C-a", move_beginning_of_line)
    define_key(keymap_emacs, "C-e", move_end_of_line)

    ### Shift/Alt
    def withModifier(modifier, func):
        return lambda: func(modifier=modifier)

    define_key(keymap_emacs, "S-C-b", withModifier("S-", backward_char))
    define_key(keymap_emacs, "S-C-f", withModifier("S-", forward_char))
    define_key(keymap_emacs, "S-C-p", withModifier("S-", previous_line))
    define_key(keymap_emacs, "S-C-n", withModifier("S-", next_line))

    define_key(keymap_emacs, "A-C-b", withModifier("A-", backward_char))
    define_key(keymap_emacs, "A-C-f", withModifier("A-", forward_char))
    define_key(keymap_emacs, "A-C-p", withModifier("A-", previous_line))
    define_key(keymap_emacs, "A-C-n", withModifier("A-", next_line))

    ## 「カット / コピー / 削除 / アンドゥ」のキー設定
    define_key(keymap_emacs, "C-h", delete_backward_char)
    define_key(keymap_emacs, "C-d", delete_char)
    define_key(keymap_emacs, "C-k", kill_line)
    define_key(keymap_emacs, "C-y", yank)

    ## esc
    define_key(keymap_emacs, "C-OpenBracket", esc)

