#SingleInstance, force

; 2011-02-21
KeyIsDown = 0
UpperDelay = 1000
UpperDelay *= -1

;Menu Tray, Icon, %A_ScriptDir%\HalfKeyboard.ico
Menu Tray, Tip, HalfKeyboard emulator
Menu Tray, Add, E&xit, MenuExit
Menu Tray, NoStandard


original := "``" . "12345qwertasdfgzxcvb"   ; split up string for better
mirrored := "'"  . "09876poiuyñlkjh-.,mn"   ; human readability


; Now define all hotkeys
Loop % StrLen(original)
{
	c1 := SubStr(original, A_Index, 1)
	c2 := SubStr(mirrored, A_Index, 1)
	Hotkey Space & %c1%, DoHotkey
	Hotkey Space & %c2%, DoHotkey
	Hotkey %c1%, KeyDown
	Hotkey %c1% UP, KeyUP
	Hotkey %c2%, KeyDown ; see post by guest below seems to improve the script haven't tried this myself so comment these two lines if it doesn't work
	Hotkey %c2% UP, KeyUP ;
}

return


; This key may help, as the space-on-up may get annoying, especially if you type fast.
Control & Space::Suspend

; Not exactly mirror but as close as we can get, Capslock enter, Tab backspace.
Space & CapsLock::Send {Enter}
Space & Tab::Send {Backspace}

; If spacebar didn't modify anything, send a real space keystroke upon release.
+Space::Send {Space}
Space::Send +{Space}

; Define special key combos here (took them from RG's mod):
^1::Send {Home}
^2::Send {End}
^3::Send {Del}

CapsLock & w::Send {Up}
CapsLock & s::Send {Down}
CapsLock & a::Send {Left}
CapsLock & d::Send {Right}

DoHotkey:
StartTime := A_TickCount
StringRight ThisKey, A_ThisHotkey, 1
i1 := InStr(original, ThisKey)
i2 := InStr(mirrored, ThisKey)
If (i1+i2 = 0) {
	MirrorKey := ThisKey
} Else If (i1 > 0) {
	MirrorKey := SubStr(mirrored, i1, 1)
} Else {
	MirrorKey := SubStr(original, i2, 1)
}

Modifiers := ""
If (GetKeyState("LWin") || GetKeyState("RWin")) {
	Modifiers .= "#"
}
If (GetKeyState("Control")) {
	Modifiers .= "^"
}
If (GetKeyState("Alt")) {
	Modifiers .= "!"
}
If (GetKeyState("Shift") + GetKeyState("CapsLock", "T") = 1) {
	Modifiers .= "+"
}


If (KeyIsDown < 1 or ThisKey <> LastKey)
{
	KeyIsDown := True
	LastKey := ThisKey
	Send %Modifiers%{%MirrorKey%}
}

Return

MenuExit:
ExitApp
Return

KeyDown:
Key:=A_ThisHotkey
Send %Key%
Return

KeyUp:
Key:=A_ThisHotkey
KeyIsDown := False
Return
