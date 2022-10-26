#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


!NumpadHome:: AltFunction7()
!NumpadUp:: AltFunction8()
!NumpadPgUp:: AltFunction9()
!NumpadLeft:: AltFunction4()
!NumpadClear:: AltFunction5()
!NumpadRight:: AltFunction6()
!NumpadEnd:: AltFunction1()
!NumpadDown:: AltFunction2()
!NumpadPgDn:: AltFunction3()
!NumpadIns:: AltFunction0()
!NumpadDel:: AltFunctiondelete()


+NumpadHome:: ShiftFunction7()
+NumpadUp:: ShiftFunction8()
+NumpadPgUp:: ShiftFunction9()
+NumpadLeft:: ShiftFunction4()
+NumpadClear:: ShiftFunction5()
+NumpadRight:: ShiftFunction6()
+NumpadEnd:: ShiftFunction1()
+NumpadDown:: ShiftFunction2()
+NumpadPgDn:: ShiftFunction3()


NumpadHome:: Function7()
NumpadUp:: Function8()
NumpadPgUp:: Function9()
NumpadLeft:: Function4()
NumpadClear:: Function5()
NumpadRight:: Function6()
NumpadEnd:: Function1()
NumpadDown:: Function2()
NumpadPgDn:: Function3()
NumpadIns:: Function0()
NumpadDel:: Functiondelete()
;Default functions
Function7(){
		Send {Media_Prev}
}
Function8(){
		Send {Media_Play_Pause}
}
Function9(){
		Send {Media_Next}
}
Function4(){
		Send {AppsKey}
}
Function5(){
		Run firefox
}
Function6(){
		Run "C:\Program Files\Microsoft VS Code\Code.exe"
}
Function1(){
		Run spotify
}
Function2(){
		Run notepad
}
Function3(){
		Run "C:\Program Files\Blender Foundation\Blender 3.3\blender-launcher.exe"
}
Function0(){
		Run "C:\Program Files\Krita (x64)\bin\krita.exe"
}
Functiondelete(){
		Run "C:\Users\InventorBoy\AppData\Roaming\Zoom\bin\Zoom.exe"
}


;Alt functions
AltFunction7(){
		Send {F13}
}
AltFunction8(){
		Send {F14}
}
AltFunction9(){
		Send {F15}
}
AltFunction4(){
		Send {F16}
}
AltFunction5(){
		Send {F17}
}
AltFunction6(){
		Send {F18}
}
AltFunction1(){
		Send {F19}
}
AltFunction2(){
		Send {F20}
}
AltFunction3(){
		Send {F21}
}
AltFunction0(){
		Send {F22}
}
AltFunctiondelete(){
		Send {F23}
}


;Shift functions
ShiftFunction7(){
		Send {Media_Prev}
}
ShiftFunction8(){
		Send {Media_Play_Pause}
}
ShiftFunction9(){
		Send {Media_Next}
}
ShiftFunction4(){
		Send {AppsKey}
}
ShiftFunction5(){
		Send {F17}
}
ShiftFunction6(){
		Send {F18}
}
ShiftFunction1(){
		Send {F19}
}
ShiftFunction2(){
		Send {F20}
}
ShiftFunction3(){
		Send {F21}
}


