; ESCキーでIME自動オフ設定
; インサートモードからノーマルモードに移行する際にIMEをオフにする

#Include IME.ahk

; ESCキーでIMEを自動的にOFF
~Esc::IME_SET(0)
