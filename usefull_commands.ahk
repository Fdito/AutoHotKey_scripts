#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#^space::
WinGetPos, X, Y, Width, Height, A
WinSet, Style, ^0xC00000, A
WinMove, A, , X, Y, Width, Height-1
WinMove, A, , X, Y, Width, Height
return