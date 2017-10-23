^#Left::
    WinGet, id, list, , , Program Manager
    Loop, %id%
    {
        StringTrimRight, this_id, id%a_index%, 0
        WinGet, this_cmd, ProcessName, ahk_id %this_id%
        if (this_cmd = "idea64.exe")
        {
            WinGet MMX, MinMax, ahk_id %this_id%
            IfEqual, MMX, -1
            {
                WinRestore, ahk_id %this_id%
            }
            WinGetPos, Xpos, Ypos,,, ahk_id %this_id%
            WinGetTitle, this_title, ahk_id %this_id%
            WinGetText, this_text, ahk_id %this_id%
            IfLessOrEqual, 1358, Xpos
            {
                WinGet MMX, MinMax, ahk_id %this_id%
                IfEqual, MMX, 1
                {
                    WinRestore, ahk_id %this_id%
                }
                Xposminus:=(Xpos - 1358)
                if (Xposminus < 0)
                {
                    Xposminus:=0
                }
                ;MsgBox, 4,, %Xposminus% - %Xpos% - %Ypos% - Continue?
                WinMove, %this_title%, %this_text%, %Xposminus%, %Ypos%
                WinMaximize, ahk_id %this_id%
            }
        }
    }
return

^#Right::
    WinGet, id, list, , , Program Manager
    Loop, %id%
    {
        StringTrimRight, this_id, id%a_index%, 0
        WinGet, this_cmd, ProcessName, ahk_id %this_id%
        if (this_cmd = "idea64.exe")
        {
            WinGet MMX, MinMax, ahk_id %this_id%
            IfEqual, MMX, -1
            {
                WinRestore, ahk_id %this_id%
            }
            WinGetPos, Xpos, Ypos,,, ahk_id %this_id%
            WinGetTitle, this_title, ahk_id %this_id%
            WinGetText, this_text, ahk_id %this_id%
            IfLess, Xpos, 1358 ;This value needs to be 8 pixels less than the monitor width because when a window is maximized, it hangs over by 8 pixels.
            {
                WinGet MMX, MinMax, ahk_id %this_id%
                IfEqual, MMX, 1
                {
                    WinRestore, ahk_id %this_id%
                }
                Xposplus:=(Xpos + 1366)
                if (Xposplus < 1358)
                {
                    Xposplus:=1366
                }
                ;MsgBox, 4,, %Xposplus% - %Xpos% - %Ypos% - Continue?
                WinMove, %this_title%, %this_text%, %Xposplus%, %Ypos%
                WinMaximize, ahk_id %this_id%
            }
        }
    }
return