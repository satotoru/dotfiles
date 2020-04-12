#include %A_ScriptDir%
#Include virtual_desktop.ahk
#Include alt-ime-ahk.ahk
;;
;; An autohotkey script that provides emacs-like keybinding on Windows
;;
#InstallKeybdHook
#UseHook

; The following line is a contribution of NTEmacs wiki http://www49.atwiki.jp/ntemacs/pages/20.html
SetKeyDelay 0

; emacsキーバインドを無効にしたいアプリケーション
; (Please comment out applications you don't use)
is_target()
{
;  IfWinActive,ahk_class ConsoleWindowClass ; Cygwin
;    Return 1
;  IfWinActive,ahk_class MEADOW ; Meadow
;    Return 1
;  IfWinActive,ahk_class cygwin/x X rl-xterm-XTerm-0
;    Return 1
;  IfWinActive,ahk_class MozillaUIWindowClass ; keysnail on Firefox
;    Return 1
;  ; Avoid VMwareUnity with AutoHotkey
;  IfWinActive,ahk_class VMwareUnityHostWndClass
;    Return 1
;  IfWinActive,ahk_class Vim ; GVIM
;    Return 1
;  IfWinActive,ahk_class SWT_Window0 ; Eclipse
;    Return 1
;   IfWinActive,ahk_class Xming X
;     Return 1
;   IfWinActive,ahk_class SunAwtFrame
;     Return 1
;   IfWinActive,ahk_class Emacs ; NTEmacs
;     Return 1
;   IfWinActive,ahk_class XEmacs ; XEmacs on Cygwin
;     Return 1
  Return 0
}

; Keyboad Actions
delete_char()
{
  Send {Del}
  Return
}
delete_backward_char()
{
  Send {BS}
  Return
}
esc()
{
  Send {ESC}
  Return
}
quit()
{
  Send !{F4}
  Return
}
move_beginning_of_line()
{
  Send {HOME}
  Return
}
move_end_of_line()
{
  Send {END}
  Return
}
previous_line()
{
  Send {Up}
  Return
}
next_line()
{
  Send {Down}
  Return
}
forward_char()
{
  Send {Right}
  Return
}
backward_char()
{
  Send {Left}
  Return
}
yank()
{
  Send ^v
  Return
}


; Key Mappings
;; CapsLockを常にOff
SetCapsLockState, AlwaysOff

;; 入れ替え
#IfWinActive, ahk_exe WindowsTerminal.exe
F13::LCtrl
#IfWinNotActive, ahk_exe WindowsTerminal.exe
F13::RCtrl

;; カーソル移動

>^f::
  If is_target()
    Send {%A_ThisHotkey%}
  Else
    forward_char()
  Return
>^b::
  If is_target()
    Send {%A_ThisHotkey%}
  Else
    backward_char()
  Return
>^p::
  If is_target()
    Send {%A_ThisHotkey%}
  Else
    previous_line()
  Return
>^n::
  If is_target()
    Send {%A_ThisHotkey%}
  Else
    next_line()
  Return
>^a::
  If is_target()
    Send {%A_ThisHotkey%}
  Else
    move_beginning_of_line()
  Return
>^e::
  If is_target()
    Send {%A_ThisHotkey%}
  Else
    move_end_of_line()
  Return

;; bs/del
>^d::
  If is_target()
    Send {%A_ThisHotkey%}
  Else
    delete_char()
  Return
>^h::
  If is_target()
    Send {%A_ThisHotkey%}
  Else
    delete_backward_char()
  Return

;; esc
>^[::
  esc()
  Return
