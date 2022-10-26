; AHK ScriptWriter 0.3 Alpha
; Parts from Thalon, Skrommel from (www.donationcoders.com/skrommel), and AHKnow.
; Additional parts from Sote

; Special Notes
;`r`n and `n in commands are for formatting of captured info in tooltip, variables, or text.
;SetTimer On or Off might partially or fully correct typing and tooltip problems, where no text shows and tooltip dies.
;SetTimer turns subroutines/functions/labels On and Off, and allow for asynchronous execution of them by interrupting the script's normal linear (top-down) 
;Input command gets keyboard = key/keys
;record input goes to endrecord

record= ; If empty, turns recording keyboard text off.  
;keydelay=10		;xxx Not used at the moment
;windelay=100		;xxx Not used at the moment
;Get informations for abort-condition
StringReplace, endrecord, record, }, %A_Space%Down}
StringLen, length, endrecord ;counts characters

;Initial Start up condition
#SingleInstance,Force
#Persistent
;DetectHiddenText, On
SetTitleMatchMode, Slow
SetBatchLines, -1
PID := DllCall("GetCurrentProcessId")
AutoTrim, Off
CoordMode, Mouse, Relative
modifiers =LCTRL,RCTRL,LALT,RALT,LSHIFT,RSHIFT,LWIN,RWIN,LButton,RButton,MButton,XButton1,XButton2
recording = 0
playing = 0
SendFlag = 0		;Flag for keyboard-recording
ControlSendFlag = 0	;Flag for special record-mode
Stop := ""
SelectedExe := ""
ExeHold := ""
Run = Run,
File := A_Temp . "\TempPlay.ahk" 
ScriptHold := ""
VersionMark := ASWv030 ; identifier and used to preventing program recording itself
FakeSleep = Sleep, 100
ExtraSleep = Sleep, 2000
GoSub, InitStyle
GoSub, Traymenu
GoSub, ShowGUI1
Return

Traymenu: ; Default location of program

Menu, Tray, NoDefault
Menu, Tray, NoStandard
Menu, Tray, Add, &Gui, ShowGUI1
Menu, Tray, Add, E&xit, ProgramExit
Menu, Tray, Add, &Record, ButtonRecord
Menu, Tray, Add, &Stop, ButtonStop
Menu, Tray, Add, &Pause, Pause
Menu, Tray, Add, Play&back, ButtonPlay
Menu, Tray, Add, Re&load, Reload
Return

ShowGUI1: ; GUI that is launched from Traymenu

Gui, Font, s9, 
Gui, Add, Button, x2 y198 w80 h40 +Center, &Clean
Gui, Add, Edit, x92 y38 w350 h20 , 
Gui, Add, Button, x452 y18 w60 h20 , &Browse
Gui, Add, GroupBox, x92 y8 w350 h10 , If "exe" below`, will "run" upon "Record"
Gui, Add, Button, x2 y258 w80 h40 , &Save
Gui, Add, Button, x2 y318 w80 h40 , &Close
Gui, Add, Edit, x92 y78 w420 h280 vScriptEdit, 
Gui, Font, s12, 
Gui, Add, Button, x2 y138 w80 h40 , &Play
Gui, Font, s12, MS sans serif
Gui, Add, Button, x2 y18 w90 h60 , &Record
Gui, Font, s10 w700, Arial
Gui, Add, Button, x452 y48 w60 h20 , &Shortcut
Gui, Add, Button, x2 y88 w80 h40 , &TextRecord
Gui, Add, CheckBox, x92 y368 w90 h30 vToolTipOption gToolTipShow, ToolTip
Gui, Font, S8 CDefault, Bold Verdana
; Generated using SmartGUI Creator 4.0
Gui, Show, x440 y164 h411 w549, AHK ScriptWriter v 030 Alpha
;Gui, Add, ComboBox, x-25 y-81 w41 h89 +Menu, ComboBox

; Create the sub-menus:

;Menu, FileMenu, Add, &Save, FileSave
;Menu, FileMenu, Add, Save &As, FileSaveAs
;Menu, FileMenu, Add  ; Separator line.
;Menu, FileMenu, Add, E&xit, FileExit
Menu, HelpMenu, Add, &AutoHotKey Help, Help
Menu, HelpMenu, Add, &WindowInfoSpy, WindowInfoSpy
Menu, HelpMenu, Add, &Editing Help, EditHelpers
Menu, HelpMenu, Add, &Compile Script, CompileScript

; Menu bar for attaching sub-menus to it:
;Menu, MyMenuBar, Add, &File, :FileMenu
;Menu, MyMenuBar, Add, &About, :HelpAbout
Menu, MyMenuBar, Add, &Help, :HelpMenu

; Attach the menu bar to the window:
Gui, Menu, MyMenuBar

Return

HelpAbout:
Gui, About:+owner1  ; Make the main window (Gui #1) the owner of the "about box".
Gui +Disabled  ; Disable main window.
Gui, About:Add, Text,, Text for about box.
Gui, About:Add, Button, Default, OK
Gui, About:Show

Return

Help:

IfExist, %A_ScriptDir%\AutoHotkey.chm
	Run, %A_ScriptDir%\AutoHotkey.chm
Else		
IfExist, %ProgramFiles%\AutoHotkey\AutoHotkey.chm
	Run, %ProgramFiles%\AutoHotkey\AutoHotkey.chm
Else		
IfExist, C:\Program Files\AutoHotkey\AutoHotkey.chm
	Run, C:\Program Files\AutoHotkey\AutoHotkey.chm
Else
IfNotExist, %ProgramFiles%\AutoHotkey.chm OR %A_ScriptDir%\AutoHotkey.chm
	Run, https://www.autohotkey.com/docs/commands.htm
Else
	MsgBox, No help files could be found

Return

WindowInfoSpy:

IfExist, %A_ScriptDir%\ActiveWindowInfo.ahk
	Run, %A_ScriptDir%\ActiveWindowInfo.ahk
Else		
IfExist,%A_ScriptDir%\AU3_Spy.exe
	Run, %A_ScriptDir%\AU3_Spy.exe
Else		
IfExist, %ProgramFiles%\AutoHotkey\AU3_Spy.exe
	Run, %ProgramFiles%\AutoHotkey\AU3_Spy.exe
Else
IfNotExist, %A_ProgramFiles%\AutoHotkey\AU3_Spy.exe OR %A_ScriptDir%\AU3_Spy.exe
	Run, https://www.autohotkey.com/
Else
	MsgBox, No ActiveWindowInfo or AU3_Spy found.

Return

EditHelpers:

MsgBox, Will launch Context Sensitive Help (F2) & Auto Complete (F4) for script editing.

IfExist, %A_ScriptDir%\AutoCompleteASW_2.ahk
	Run, %A_ScriptDir%\AutoCompleteASW_2.ahk
Else		
	MsgBox, AutoComplete not found.

If !WinExist("AutoHotkey Help")
{
	IfExist, %A_ScriptDir%\AutoHotkey.chm 
		Run, %A_ScriptDir%\AutoHotkey.chm
	Else		
	IfExist, %ProgramFiles%\AutoHotkey\AutoHotkey.chm
		Run, %ProgramFiles%\AutoHotkey\AutoHotkey.chm
	Else		
	IfExist, C:\Program Files\AutoHotkey\AutoHotkey.chm
		Run, C:\Program Files\AutoHotkey\AutoHotkey.chm
	Else		
		MsgBox, AutoHotKey Help not found, so only Auto Complete is active.
}
Sleep, 1500
If WinExist("AutoHotkey Help")
{	
	IfExist, %A_ScriptDir%\AssistHelpASW_2.ahk
		Run, %A_ScriptDir%\AssistHelpASW_2.ahk
	Else		
		MsgBox, AssistHelp not found.
}
WinMinimize, AutoHotkey Help
WinActivate, AHK ScriptWriter v 030 Alpha

Return

CompileScript:

MsgBox, Will compile your present script into .EXE



Return

FileMenu:


ShowGUI2: ; Creates little STOP button in upper left hand corner
Gui, font, s10 w700, Arial
Gui, Add, Button, w45 h20, Stop
Gui, +AlwaysOnTop -SysMenu +Owner -Border
Gui, Color, EEAA99
Gui, +Lastfound ; Make the GUI window the last found window. 
WinSet, TransColor, EEAA99 
Gui, Show, x0 y0, ASWv030 
Return


HelpMenu2:

IfExist, %A_ScriptDir%\AutoHotkey.chm
	Run, %A_ScriptDir%\AutoHotkey.chm
Else		
IfExist, %A_ProgramFiles%\AutoHotkey\AutoHotkey.chm
	Run, %A_ProgramFiles%\AutoHotkey\AutoHotkey.chm
Else
IfNotExist, %A_ProgramFiles%\AutoHotkey\AutoHotkey.chm OR %A_ScriptDir%\AutoHotkey.chm
	Run, https://www.autohotkey.com/docs/commands.
Else
	MsgBox, No help files could be found

Return

ButtonClean: ;Deletes uneeded "Sleep" lines.  Attempt to fix script reliabilty or problems after already recorded.

MsgBox, Delete "Sleep", duplicates, & unneeded lines for possibly better performance?

;IfInString, ScriptUP, ControlClick
;	{
;	ScriptUP := RegExReplace(ScriptUP,"...NA,.*\r\n.*\r\n.*","1")
;	Sleep, 300
;	}
	
IfInString, ScriptUP, UNRS
	{
	ScriptUP := RegExReplace(ScriptUP,".*UNRS.*\r\n")
	Sleep, 300
	}	
	
IfInString, ScriptUP, SpecialButton
	{
;	ScriptUP := RegExReplace(ScriptUP,"...SpecialButton.*\r\n.*\r\n.*", "`nSleep, 2000")
	ScriptUP := RegExReplace(ScriptUP,"....SpecialButton*", "`nSleep, 2000")
	Sleep, 300
	}
	
If ScriptUP != 
	{
	Gosub, RemoveDuplicates
	GuiControl,,ScriptEdit, %ScriptUP%
	}
	
Return

RemoveDuplicates:

Result := ""
Loop Parse, ScriptUP, `n, `r
{
    if (A_LoopField != FoundDuplicate)
    {
        Result .= Result ? "`n" : ""
        Result .= A_LoopField
    }
    FoundDuplicate := A_LoopField
}
ScriptUP := Result

Return

ButtonBrowse: ; This is so you can select an .exe and show its path

FileSelectFile, SelectedExe, 3,, Select .EXE to run, Executables (*.exe) 
Gosub ExeShowBrowseEdit1

ExeShowBrowseEdit1:
    IfExist, %SelectedExe%
    	GuiControl,,Edit1,%SelectedExe%
       
    Else
        MsgBox, You did not select anything or an .EXE file.
		ExeHold = %SelectedExe%  
Return

ExeRunBrowseEdit1: ; This is so you can run an .exe/application file before using the mouse on its window or menus

IfEqual, ExeHold,  ; If ExeHold (SelectedExe) equal empty, then return
{ 
return
}    
IfNotEqual, ExeHold, ; If ExeHold not empty, then run it
{
;Sleep, 500
Run, %ExeHold%
GuiControl,,Edit1,
}   	
return
    
ButtonSave: ; This is so you can save your script

Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window. 
FileSelectFile, SelectedFileName, S16,, Save File, AutoHotkey Script (*.ahk) 
if SelectedFileName =  ; No file selected.
{ 
return
} 
Gosub SaveCurrentFile 
return 

SaveCurrentFile: ; Saves your AutoHotkey script

GuiControlGet, ScriptEdit
FileDelete, %SelectedFileName%.ahk 
FileAppend, %ScriptEdit%, %SelectedFileName%.ahk
return 

ButtonStop: ; Stops the recording

Recording = 0
ToolTipOption = 0
SetTimer, Check_Modifier_Keys, Off
Gui, Destroy
Clipboard = %keys% ;Send recorded data to clipboard
ToolTip, 
Gosub, ShowGUI1
IfEqual, ExeHold, 
{ 
FileAppend, %keys%, %File%
}
Else
{
FileAppend, %Run%%ExeHold%`n%keys%, %File%   ; `r`n needed for proper formatting in Edit2 and File
}
Sleep, 1000
FileRead, ScriptUP, %File%
GoSub, RemoveMark ; No longer needed.  GUI doesn't interfere in recordings anymore.
;ScriptUP = %ScriptUP%Exit ; place holder "Exit" to identify last line
;ScriptUP := RegExReplace(ScriptUP,"\r.*\r.*Exit") ; deletes last recorded line above Exit
ScriptUP = %ScriptUP%`r`nExit ; put the Exit command back
GuiControl,,ScriptEdit, %ScriptUP% ; puts the recorded script on the GUI
FileDelete, %File%
ScriptHold := ""
SelectedExe := ""
ExeHold := ""


Return 

RemoveMark: ; This kills possible self-recorded last line when you press "Stop" in the GUIs

IfInString, ScriptUP, ASWv030
{
ScriptUP := RegExReplace(ScriptUP,".*?ASWv030....*\r\n") ; Finds lines with ASWv030 and removes entire line or multiple lines with it.
return
}
Else
{
return
}

ButtonTextrecord: ;Turns Keyboard recording totally on

ToolTip, Text can now be recorded...
Loop
{
record = {LCtrl} {F12} ; Yes this is weirdness; turns text recording On or Off.  Also for key stoppage, but that not working at the moment.
endrecord = record
}
return

ButtonShortcut: ;Gets .EXE from Desktop Shortcuts.  Makes created Macros more reliable and portable
Gui, Submit, NoHide
ToolTip, Select Desktop Shortcut...
Sleep, 2000
KeyWait, LButton, D	
ControlGet, fileName, List, Selected, SysListView321, ahk_class Progman
fileName := SubStr(fileName,1,InStr(fileName,A_Tab)-1) ".lnk"
FileGetShortCut,% FileExist(A_Desktop "\" fileName)       ? A_Desktop "\" fileName

                 : FileExist(A_DesktopCommon "\" fileName) ? A_DesktopCommon "\" fileName

                 : fileName, WillRun
ToolTip				 
MsgBox, 4, EXE for Shortcut, %WillRun% ; This is the retrieved .EXE that is placed in GUI Edit1
	IfMsgBox Yes
		{
		GuiControl,,Edit1,%WillRun%
		ExeHold = %WillRun%
		return
		}
	else
		{
		MsgBox Select Again
		Gosub, ButtonShortcut
		}

Return

ButtonPlay: ; Play back script shown on GUI and Tooltip.

FileDelete, %File%
GuiControlGet, ScriptEdit ; Gets recorded data and any corrections you made before play
FileAppend, %ScriptEdit%, %File%
Sleep, 1000
Gui, Destroy
RunWait, %File%,, UseErrorLevel
if ErrorLevel = ERROR
{
RunWait, %A_ScriptDir%\AutoHotkey.exe "%File%",, UseErrorLevel
	If ErrorLevel = ERROR
	{
	Msgbox, AutoHotkey NOT found OR you may need to associate .AHK files with AutoHotkey.exe
	}
}
Sleep, 500
Gosub, ShowGUI1
FileRead, ScriptUP, %File%
GuiControl,,ScriptEdit, %ScriptUP%
FileDelete, %File%
return

ButtonRecord:   ; RECORD

; Blanking out these variable are very important, otherwise all kinds of bad results or weirdness.
GuiControl,,ScriptEdit,
ScriptHold := ""
ScriptUP := ""
keys := ""
ElapsedTime := ""
StartTime := ""
FileDelete, %File%
Gui, Destroy

Gosub Record_On
Return


Record_On: ; Part of recording subroutines

Gosub, ShowGUI2
Gosub, ExeRunBrowseEdit1

If recording = 0
{
Recording = 1
  ;Start recording if all modifier-keys are unpressed
	GetKeyState, state, LShift, P
  If state = d
  Loop
  {
    GetKeyState, state, LShift, P
    If state = U
      Break
  }
  GetKeyState, state, LCtrl, P
  If state = d
  Loop
  {
    GetKeyState, state, LCtrl, P
    If state = U
      Break
  }
  GetKeyState, state, LAlt, P
  If state = d
  Loop
  {
    GetKeyState, state, LAlt, P
    If state = U
      Break
  }
  GetKeyState, state, LWin, P
  If state = d
  Loop
  {
    GetKeyState, state, LWin, P
    If state = U
      Break
  }
  
  ;Start Recording
  recording = 1
  ToolTip, Recording... 
;  Process, Priority, %PID%, High	  ;Sets Priority to high, but may cause trouble on older and slower computers
  Gosub, Record_Loop
;  Process, Priority, %PID%, Normal	;Sets Priority to high
  
;  ToolTip, Recording finished
  
;	Send recorded data to clipboard
	Clipboard = %keys%
  
  Sleep, 1000
  ToolTip,
 ; recording = 0 ; strange command after recording = 1
}
Else
{
	recording = 0
	SetTimer, Check_Modifier_Keys, Off
}
Return

Record_Loop: ;Record keyboard and mouse, relative to screen.  ControSsend/ControlClick is preferable for reliability
SetTimer, Check_Modifier_Keys, 30
OldWinID =
keys =
Loop
{
  if recording = 0
  	break
	Input, key, M B C V I L1 T1, {BackSpace}{Space}{WheelDown}{WheelUp}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}{ENTER}{ESCAPE}{TAB}{DELETE}{INSERT}{UP}{DOWN}{LEFT}{RIGHT}{HOME}{END}{PGUP}{PGDN}{CapsLock}{ScrollLock}{NumLock}{APPSKEY}{SLEEP}{Numpad0}{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}{NumpadDot}{NumpadEnter}{NumpadMult}{NumpadDiv}{NumpadAdd}{NumpadSub}{NumpadDel}{NumpadIns}{NumpadClear}{NumpadUp}{NumpadDown}{NumpadLeft}{NumpadRight}{NumpadHome}{NumpadEnd}{NumpadPgUp}{NumpadPgDn}{BROWSER_BACK}{BROWSER_FORWARD}{BROWSER_REFRESH}{BROWSER_STOP}{BROWSER_SEARCH}{BROWSER_FAVORITES}{BROWSER_HOME}{VOLUME_MUTE}{VOLUME_DOWN}{VOLUME_UP}{MEDIA_NEXT}{MEDIA_PREV}{MEDIA_STOP}{MEDIA_PLAY_PAUSE}{LAUNCH_MAIL}{LAUNCH_MEDIA}{LAUNCH_APP1}{LAUNCH_APP2}{PRINTSCREEN}{CTRLBREAK}{PAUSE}
  endkey = %ErrorLevel%
	if (key = "" AND Errorlevel = "Timeout") ;No key pressed
  	Continue
  
	GoSub, CheckWindow		;Check window-changes before key-record

  IfInString, endkey, EndKey:
  {
    StringTrimLeft, key, endkey, 7
    key = {%key%}
  } 
  GoSub, Start_Send
  
 ;IfNotInString, Controlname, Button ; Special rules to stop double recording of same button pushed (ControlSend VS ControlClick).
 ; if WinClass != #32770 ; Special rule; This with bottom send rule turns keys completely OFF
	{
		keys = %keys%%key% ; Will send extra unneeded characters on certain controls/buttons; controls recording text
	}	
  
  IfInString, keys, %endrecord%		;Finish-Shortcut was pressed. Which keys at top of the script for user to choose.
  {
		StringTrimRight, keys, keys, % length		;Remove Finish-Shortcut from record
		
		if (ControlSendFlag = 1)	;If "ControlSend" is recorded (due to pressing Finish-Shortcut)
		{
			StringRight, CheckTrimMode, keys, % 14 + StrLen(Controlname)
			if CheckTrimMode = ControlSend`, %Controlname%`,		;Check if Controlsend-Mode was initialized by Finish-Shortcut or if other letters where typed
				StringTrimRight, keys, keys, % 14 + StrLen(Controlname)		;Remove Controlsend-Command
			else		;Other letters typed --> Finish Controlsend-Command
				keys = %keys%`, %WinTitle%
		}
		else	;If "Send" is recorded (due to pressing Finish-Shortcut)
		{
			StringRight, CheckTrimMode, keys, % 5
			if CheckTrimMode = Send`,		;Check if Send-Mode was initialized by Finish-Shortcut or if other letters where typed
				StringTrimRight, keys, keys, 5		;Remove Send-Command
		}

			
	;recording = 0 ; if recieve endrecord (from record), turns recording off
  }
  If recording = 0
  {
	SetTimer, Check_Modifier_Keys, Off 
  }
}
Return

Check_Modifier_Keys:
Loop, Parse, modifiers, `,
{
  GetKeyState, state, %A_LoopField%, P
	If (state = "D" AND state%A_Index% = "")	

  {
		GoSub, CheckWindow		;Check window-changes before key-record
		state%A_Index% = D
    if InStr(A_LoopField, "Button")
    {
	    GoSub, End_Send
;			keys = %keys%Sleep`, %A_TimeSincePriorHotkey%`n  ;Wofür war das?
			
			if (WinClass = "Progman" or WinClass = "WorkerW")		;Desktop
			{
				keys = %keys%
				GoSub, MouseClick
			}
;			
;			if InStr(Controlname, "Start")
;									
			else	;"normal" Window
			{
				;Getting style for clearer information
				WinGetClass, WinClass, ahk_id %WinID%
				WinGetTitle, WinTitle, ahk_id %WinID%
				MouseGetPos, XPos, YPos, WinID, Controlname
				ControlGetText, Controltext, %Controlname%, %WinTitle%
				ControlGet, ControlStyle, Style, , %Controlname%, ahk_id %WinID%
				PixelGetColor, PixelHold, %XPos%, %YPos%
				;PixelGetColor, OutputVar, X, Y [, Alt|Slow|RGB]
				
						
				if InStr(Controlname, "Button")	;Normaler Button, Checkbox, Radio, 
				{
					if WinClass = #32770 
					if WinTitle != ASWv030
					if WinTitle != Run	
					if WinTitle != Start ;Menu
					{
						keys = %keys%ControlFocus`, %Controlname%`, %WinTitle%`n
						keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, 1`, NA,`n
						;MsgBox, rule 1	
					}
					
					if WinClass = #32770	
					if WinTitle = Run
					if WinTitle != ASWv030
					if WinTitle != Start ;Menu
					{
						keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, 2`, NA,`n	
						;MsgBox, rule 2
					}
					
					if WinClass != #32770
					if Controltext !=
					if ControlStyle !=	
					if WinTitle != ASWv030
					if WinTitle != Start ;Menu
					{
						keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, 1`,,;SpecialButton`n
						;MsgBox, rule 3
					}
					
;					if WinClass !=
;					if WinClass != #32770	
;					if WinTitle !=	
;					if WinTitle != ASWv030
;					if WinTitle != Start ;Menu
;					{
;						keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, 1`, NA,;SpecialButton`n		
;					}

							
					if ControlStyle := (ControlStyle & 0xF)		;Es ist nur B0000 bis B1111 interessant
					IfEqual, WinClass, Shell_TrayWnd
					if WinTitle != ASWv030
					if WinTitle =
					{
				 	keys = %keys%ControlClick`, %Controlname%`, ahk_class Shell_TrayWnd`, `, Left`, 1`, NA,`n
					}
					
;					if (ControlStyle = BS_PUSHBUTTON OR ControlStyle = BS_DEFPUSHBUTTON) ; rule was too tight and missing buttons
;					if WinTitle != ASWv030
;					if WinTitle != Start Menu
;					if WinTitle != 
;					IfNotEqual, WinClass, Shell_TrayWnd 
;					{
;						StartTime = %A_TickCount%
;						keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, 1`, NA,`n
;						keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`,, 1, D`n
;					}
					else if (ControlStyle = BS_3STATE OR ControlStyle = BS_AUTO3STATE)
					{
						SendMessage, BM_GETSTATE, 0, 0, %Controlname%, %WinTitle%
				  	state := ErrorLevel
				  	;Obey: The previous state has to be used for check...
				  	If (state & 0x3 = BST_UNCHECKED)	;State = CHECKED
							keys = %keys%Control`, Check`, `, %Controlname%`, %WinTitle%`n
						Else If (state & 0x3 = BST_CHECKED)		;State = INDETERMINATE
							keys = %keys%SendMessage`, %BM_SETCHECK%`, %BST_INDETERMINATE%`, 0`, %Controlname%, %WinTitle%`n
						Else If (state & 0x3 = BST_INDETERMINATE)		;State = UNCHECKED
							keys = %keys%Control`, UnCheck`, `, %Controlname%`, %WinTitle%`n
					}
					else if (ControlStyle = BS_CHECKBOX OR ControlStyle = BS_AUTOCHECKBOX)
					{
						ControlGet, Checked2, Checked, , %Controlname%, %WinTitle%
						if Checked2 = 1	;Beachte: Mausklick erfolgt erst nach Statuserfassung!
							keys = %keys%Control`, UnCheck`, `, %Controlname%`, %WinTitle%`n
						else
							keys = %keys%Control`, Check`, `, %Controlname%`, %WinTitle%`n
					}
					
					else if (ControlStyle = BS_RADIOBUTTON OR ControlStyle = BS_AUTORADIOBUTTON)
					if WinTitle != Start Menu
					if WinTitle != ASWv030
					IfNotEqual, WinClass, Shell_TrayWnd 
					{
						keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, NA,`n
					}	
					else	;Unhandled Button-Type
					{
;						StartTime = %A_TickCount%
						keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, `, `, %state%`n
					}
					
						
				}
				
					
				;if Instr(Controlname, "Static") ; This is for static type buttons
				;	if WinTitle != ASWv030
				;	if WinTitle != Start Menu
				;	if WinClass !=	
				;	IfNotEqual, WinClass, Shell_TrayWnd	
				;	{
				;		keys = %keys%ControlFocus`, %Controlname%`, %WinTitle%`n
				;		keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, 1`, NA,`n
				;	}
					
				if Instr(Controlname, "Static") ; This is for static type buttons
					if WinTitle != ASWv030
					if WinTitle != Start Menu
					IfNotEqual, WinClass, Shell_TrayWnd	
					If ControlStyle !=	
					If ControlText !=	
					{
						keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, 1`, NA,;SpecialButton`n
					}
					
				if Instr(Controlname, "Static") ; This is for static type buttons
					if WinTitle != ASWv030
					if WinTitle != Start Menu
					IfNotEqual, WinClass, Shell_TrayWnd
					If ControlStyle =
					If ControlText =	
					{
						keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, 1`, `;SpecialClick`n
					}		
					
				if Instr(Controlname, "Static") ; This is for static type buttons
					if WinTitle != ASWv030
					if WinTitle != Start Menu
					IfNotEqual, WinClass, Shell_TrayWnd
					If ControlStyle !=	
					If ControlText =	
					{
						keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, 1`, `;SpecialClick`n
					}		
					
								
				if InStr(Controlname, "ComboLBox")	
					if WinClass = #32770 
					if WinTitle != ASWv030
					if WinTitle != Start ;Menu
					if PixelHold = 0xFF9933	
					{
						keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, 1`, NA,`n
						;MsgBox, rule 4
					}
				if InStr(Controlname, "ScrollBar2")	
					if WinClass = #32770 
					if WinTitle != ASWv030
					if WinTitle != Start ;Menu
					{
						GoSub, MouseClick
					}
													
				if InStr(Controlname, "Checkbox")	;Normaler Button, Checkbox, Radio, 
								{
									if ControlStyle := (ControlStyle & 0xF)		;Es ist nur B0000 bis B1111 interessant
									IfEqual, WinClass, Shell_TrayWnd
									if WinTitle != ASWv030
									if WinTitle =
									{
								 	keys = %keys%ControlClick`, %Controlname%`, ahk_class Shell_TrayWnd`, `, Left`, 1`, NA,`n
									}
									
									if (ControlStyle = BS_PUSHBUTTON OR ControlStyle = BS_DEFPUSHBUTTON)
									if WinTitle != ASWv030
									if WinTitle != Start Menu
									if WinTitle != 
									IfNotEqual, WinClass, Shell_TrayWnd 
									{
;										StartTime = %A_TickCount%
										keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, 1`, NA,`n
									}
									else if (ControlStyle = BS_3STATE OR ControlStyle = BS_AUTO3STATE)
									{
										SendMessage, BM_GETSTATE, 0, 0, %Controlname%, %WinTitle%
								  	state := ErrorLevel
								  	;Obey: The previous state has to be used for check...
								  	If (state & 0x3 = BST_UNCHECKED)	;State = CHECKED
											keys = %keys%Control`, Check`, `, %Controlname%`, %WinTitle%`n
										Else If (state & 0x3 = BST_CHECKED)		;State = INDETERMINATE
											keys = %keys%SendMessage`, %BM_SETCHECK%`, %BST_INDETERMINATE%`, 0`, %Controlname%, %WinTitle%`n
										Else If (state & 0x3 = BST_INDETERMINATE)		;State = UNCHECKED
											keys = %keys%Control`, UnCheck`, `, %Controlname%`, %WinTitle%`n
									}
									else if (ControlStyle = BS_CHECKBOX OR ControlStyle = BS_AUTOCHECKBOX)
									{
										ControlGet, Checked2, Checked, , %Controlname%, %WinTitle%
										if Checked? = 1	;Beachte: Mausklick erfolgt erst nach Statuserfassung!
											keys = %keys%Control`, UnCheck`, `, %Controlname%`, %WinTitle%`n
										else
											keys = %keys%Control`, Check`, `, %Controlname%`, %WinTitle%`n
									}
									
									else if (ControlStyle = BS_RADIOBUTTON OR ControlStyle = BS_AUTORADIOBUTTON)
									if WinTitle != Start Menu
									if WinTitle != ASWv030
									IfNotEqual, WinClass, Shell_TrayWnd 
									{
										keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, NA,`n
									}	
									else	;Unhandled Button-Type
									{
;										StartTime = %A_TickCount%
										keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, `, `, %state%`n
									}
				}

				else if InStr(Controlname, "Combobox")		;Edit, Combobox (here only Edit-part)
				{
;					GoSub, MouseClick
;					keys = %keys%ControlFocus`, %Controlname%`, %WinTitle%`n ; Which is better is unclear. 
					keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`n
				}
				else if InStr(Controlname, "UIRibbonWorkPane1")						
				{
					keys = %keys%SendEvent`, {Click %XPos%` %YPos%}`n%FakeSleep% `;SS`n ; works better than MouseClick for this control
				}	
				else if InStr(Controlname, "NetUIHWND")						
				{
					keys = %keys%SendEvent`, {Click %XPos%` %YPos%}`n%FakeSleep% `;SS`n ; tested many times, effective and simple for now
					keys = %keys%SendEvent`, {Click %XPos%` %YPos%}`n%FakeSleep% `;SS`n
				}	
				else if InStr(Controlname, "DirectUIHWND")		; Weird Edit-like control, often with Combobox; mixes up alot with ComboLBox
				{
;					keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, 1`, `;SpecialClick`n ;Sleep`, %ElapsedTime%`n
					GoSub, MouseClick
				}
				else if InStr(Controlname, "SysTreeView321")		; Difficult control, using MouseClick and MouseClickDrag, often easier
				{
;					keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, 1`, `;SpecialClick`n ;Sleep`, %ElapsedTime%`n
					GoSub, MouseClick
				}
			

/*				
; These are recognized controls, but causes massive problems getting to work with script.

				else if InStr(Controlname, "ToolBarWindow322")		
					if WinClass = #32770 
					if Controltext !=	
					if WinClass != Program	
					if WinTitle != ASWv030
					if WinTitle != Start ;Menu
				{
					keys = %keys%ControlClick`, %Controltext%`, %WinTitle%`, `, Left`, 1`, NA,`n
;					keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, 1`, `;SpecialClick`n
				}
				
				else if InStr(Controlname, "ToolbarWindow321")
					if WinClass = #32770 
					if WinTitle != ASWv030
					if WinTitle != Start ;Menu
				{
;					keys = %keys%ControlClick`, %Controltext%`, %WinTitle%`, `, Left`, 1`, NA,`n
					keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, 1`, `;SpecialClick`n
				}
				
				
				else if InStr(Controltext, "Shell Preview Extension")
					if WinClass = #32770 
					if WinTitle != ASWv030
					if WinTitle != Start ;Menu
				{
					keys = %keys%ControlClick`, %Controltext%`, %WinTitle%`, `, Left`, 1`, NA,`n
					keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, 1`, `;SpecialClick`n
				}
				
				else if InStr(Controltext, "Navigation")		;Edit, Combobox (here only Edit-part); mixes up alot with ComboLBox
				else if InStr(Controlname, "ToolbarWindow")
					if WinClass = #32770 
					if WinTitle != ASWv030
					if WinTitle != Start ;Menu
				{
					keys = %keys%ControlClick`, %Controltext%`, %WinTitle%`, `, Left`, 1`, NA,`n
					keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, 1`, `;SpecialClick`n
				}
*/				
								
/*
			
				else if InStr(Controlname, "ComboBox")	;DropDown, Combobox (hier nur Button zum droppen)
				{
					
				}
				else if InStr(Controlname, "Listbox")	;Listbox
				{
					
				}
				else if InStr(Controlname, "Hotkey")	;Hotkey-Control
				{
					History = %History%ControlFocus`, %Controlname%`, %WinTitle%`n
				}
				else if InStr(Controlname, "Trackbar")	;Slider
				{
					
				}
				
*/
				else	;Klick somewhere in the window or unknown control
				{
					GoSub, MouseClick
				}
			}
	
 
    }
    Else
    {
		GoSub, Start_Send
		keys = %keys%{%A_LoopField% Down}
	}
  }
  
  GetKeyState, state, %A_LoopField%, P
  If (state = "U" AND state%A_Index% = "D") 
  {
	GoSub, CheckWindow		;Check window-changes before key-record
		
    if InStr(A_LoopField, "Button")
    {
		GoSub, End_Send
		GoSub, MouseClick
	}	
	Else
	IfNotInstring, A_LoopField, Button
	{
		GoSub, Start_Send
		keys = %keys%{%A_LoopField% Up}
	}
    state%A_Index%=
  }
}
If keys = {LShift Up}
  keys =
If keys = {LCtrl Up}
  keys =
If keys = {LAlt Up}
  keys =
If keys = {LWin Up}
  keys =
StringRight, ScriptHold, keys, 500 ; Number of characters being displayed by ToolTip.  Too small (like 50) = Problems
Gosub, ToolTipShow
Return

ToolTipShow:
Gui, Submit, NoHide
IfEqual, ToolTipOption, 1
{
ToolTip, %ScriptHold% ; DISPLAYS ToolTip contents on screen
return
}
IfEqual, ToolTipOption, 0
{	
ScriptHold =
}
Return

RemoveToolTip:
ToolTip
return

MouseClick:		;Saves a mouseclick (unknown controls or for controls where position is needed (Edit-Control for example)

;CoordMode, Mouse, Window
GetKeyState, Right, RButton
GetKeyState, Left, LButton
;StartTime = %A_TickCount%
;StartTime =
if Right = D 
IfNotInString, Controlname, ComboLBox
IfNotInString, Controlname, Checkbox
IfNotInString, Controlname, Static
IfNotInString, Controlname, UIRibbonWorkPane1
IfNotInString, Controlname, NetUIHWND
IfNotInString, Controlname, Button
	{		
	MouseGetPos, XPos, YPos
	ElapsedTime := A_TickCount - StartTime
	KeyWait, RButton, U	
	StartTime := A_TickCount
	Loop, 3
	{
	If (ElapsedTime < 150)
		{
		keys = %keys%MouseClick`, Right`, %XPos%`, %YPos%`, 1`n%FakeSleep% `;SS`n
		break
		}
	If (ElapsedTime > 150)
		{
		keys = %keys%MouseClick`, Right`, %XPos%`, %YPos%`, 1`nSleep`, %ElapsedTime% `;UNRS`n
		break
		}
	}
	}
if Left = D 
IfNotInString, Controlname, ComboLBox
IfNotInString, Controlname, Checkbox
IfNotInString, Controlname, Static
IfNotInString, Controlname, NetUIHWND
IfNotInString, Controlname, UIRibbonWorkPane1
IfNotInString, Controlname, Button
	{
	MouseGetPos, XPos, YPos, id, ControlCh	
	WinGet, WindowCh, ID, A
	ElapsedTime := A_TickCount - StartTime ; Time between separate mouse down clicks.  Finishes when mouse is clicked down.
	KeyWait, LButton, U
	MouseGetPos, XPos2, YPos2, id, ControlCh2
	WinGet, WindowCh2, ID, A
	StartTime := A_TickCount ; Time between separate mouse down clicks. Starts from when mouse button is up.
	X3 = (XPos - XPos2)
	Y3 = (Ypos - XPos2)
	Loop, 3
	{
	If (XPos = XPos2) or (YPos = YPos2) 
	If (ElapsedTime < 150) ;for capturing most double-clicks
		{
		keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, 2`n
		break
		}
	If (XPos = XPos2) or (YPos = YPos2) 
	If (ElapsedTime > 150)
		{
		keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, 1`nSleep`, %ElapsedTime% `;UNRS`n
		break
		}		
	If ((XPos2 <> X3-5) or (XPos2 <> X3+5) or (YPos2 <> Y3-5) or (YPos2 <> Y3+5)) ;funky, but allows some movement before considered a drag
	If (WindowCh = WindowCh2) and (ControlCh = ControlCh2) ;and (ElapsedTime != "" ) ;stops opening or closing window to be considered a drag		
		{
		keys = %keys%MouseClickDrag`, Left`,%XPos%`, %YPos%`, %XPos2%`, %YPos2%`n
		break
		}
	Else
		{
		keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, 1`n%FakeSleep% `;SS`n ;failsafe
		break
		}
	}
	}	
Return

PixelClick:

;CoordMode, ToolTip|Pixel|Mouse|Caret|Menu [, Screen|Window|Client]
;CoordMode, Pixel, Relative
; Initiated by long duration of down mouseclick, then inputs information for pixel search

			
/*
TRAYRECORD:
WinActivate, ahk_id %currentid%
WinWaitActive, ahk_id %currentid%, , 2
Gosub, Record_On		
Return
*/

UrlClick:

/*
Instead of MouseClick, copies url from address bar and adds to script.  Uses cursor type as check
If cursor IBeam, sends text





*/


CheckWindow:

WinGet, WinID, ID, A

If WinID <> %OldWinID%
{
	GoSub, End_Send
	
	WinGetClass, WinClass, ahk_id %WinID%
	WinGetTitle, WinTitle, ahk_id %WinID%

	if (WinClass = Progman) or (WinTitle = Program Manager)
	{
;		keys = %keys%{LWIN Down}m{LWIN UP}
;		ControlGet, fileName, List, Selected, SysListView321, ahk_class Progman
		Gosub, MouseClick
;		WinClass = 
;		WinTitle =
	}
	else 
		
	if WinTitle != Start 	; Prevents WinWait, etc... from being added to this window	
	if WinTitle != Start Menu	; Prevents WinWait, etc... from being added to this window
	if WinTitle != ASWv030 	; Prevents WinWait, etc... from being added to this window
	if WinTitle != 	; Adds WinWait, WinActivate, and WinWaitActive commands to found Window Title.
		keys = %keys%WinWait`, %WinTitle%`nWinActivate`, %WinTitle%`nWinWaitActive`, %WinTitle%`n
	
	else If WinClass !=
		keys = %keys%WinWait`, ahk_class %WinClass%`nWinActivate`, ahk_class %WinClass%`nWinWaitActive`, ahk_class %WinClass%`n
;
; WinWait, WinActivate, and WinWaitActive better than just WinActivate and WinWaitActive, so changed.
;

  OldWinID = %WinID%
  
}
return

Start_Send: ; Is beginning/front of the constructed command.

if SendFlag = 0		;If "Send" was not already added it is added just before the keypress...
;IfNotInString, Controlname, Button ; Turns ON and OFF ability to send text to Edit fields
;if WinClass != #32770	;
{
	ControlGetFocus, Controlname, ahk_id %WinID%
	if InStr(Controlname, "Edit")		;If control is of Edit-Type use "ControlSend" instead of "Send"
	{
		ControlSendFlag = 1
		keys = %keys%ControlSend`, %Controlname%`,
	}
	else if InStr(Controlname, "DirectUIHWND")		;This is an odd, almost Edit type control.
	{
		ControlSendFlag = 1
		keys = %keys%ControlSend`, %Controlname%`,
	}
	else
		keys = %keys%Send`,
		SendFlag = 1
}	

return

End_Send: ; Is end/last part of the constructed command on the same line from Start_Send

;IfNotInString, Controlname, Button
;if WinClass != #32770

if ControlSendFlag = 1
{
	SendFlag = 0
	ControlSendFlag = 0
	keys = %keys%`, %WinTitle%`n%ExtraSleep% `;SpecialSleep`n ; Very complicated, but needed to pad time when waiting for a file to load
	Controlname = 	;Delete Last Controlname on Windowchange
	
}
else if SendFlag = 1

{
	SendFlag = 0
	keys = %keys%`n%ExtraSleep% `;SpecialSleep`n ; Very complicated, but needed to pad time when waiting for a file to load
	

}

return

;Set constants
InitStyle:
;Borderstyles
BS_PUSHBUTTON = 0x0
BS_DEFPUSHBUTTON = 0x1
BS_CHECKBOX = 0x2
BS_AUTOCHECKBOX = 0x3
BS_RADIOBUTTON = 0x4 
BS_3STATE = 0x5
BS_AUTO3STATE = 0x6
BS_GROUPBOX = 0x7
BS_AUTORADIOBUTTON = 0x9
;BS_PUSHLIKE = 0x1000

;Constants for retreive/set 3rd state of a checkbox
BM_GETSTATE = 0xF2
BST_UNCHECKED = 0x0
BST_CHECKED = 0x1
BST_INDETERMINATE = 0x2
BM_SETCHECK = 0xF1
return

Reload:
Reload ; Should reload bring back GUI?  Presently it kills GUI and starts again in traymenu

Pause::Pause
Reload ; Why?  Pause should mean pause?

Esc::ExitApp

CloseHelpers:

DetectHiddenWindows, On  
SetTitleMatchMode, 2

winclose, AutoCompleteASW_2.ahk
winclose, AssistHelpASW_2.ahk

Return

ButtonClose:

Recording = 0
ToolTipOption = 0
SetTimer, Check_Modifier_Keys, Off
Gui, Destroy
FileDelete, %File%
ScriptHold := ""
SelectedExe := ""
ExeHold := 
GoSub, CloseHelpers

Return

GuiClose:  ; User closed the window.

Recording = 0
ToolTipOption = 0
SetTimer, Check_Modifier_Keys, Off
Gui, Destroy
FileDelete, %File%
ScriptHold := ""
SelectedExe := ""
ExeHold := ""
GoSub, CloseHelpers
ExitApp


Return

ProgramExit:

GoSub, GuiClose
Exit
ExitApp
