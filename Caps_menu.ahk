!CapsLock::
    Menu, Launch_Menu, Add, Blender, Launch_Menu_Handler
    Menu, Launch_Menu, Add, Chrome, Launch_Menu_Handler
    Menu, Launch_Menu, Add, Zoom, Launch_Menu_Handler
    Menu, Launch_Menu, Add, Discord, Launch_Menu_Handler
    Menu, Launch_Menu, Add, Cancel, Launch_Menu_Handler

    Menu, Launch_Menu, Show

Launch_Menu_Handler:
    {
        If ( A_ThisMenuItem = "Blender" )
        {
            Run, "C:\Users\InventorBoy\Desktop\Blender.lnk"
        }
        Else If ( A_ThisMenuItem = "Chrome" )
        {
            Run, "C:\Users\InventorBoy\Desktop\Google Chrome.lnk"
        }
        Else If ( A_ThisMenuItem = "Zoom" )
        {
            Run, "C:\Users\InventorBoy\Desktop\Zoom.lnk"
        }
        Else If ( A_ThisMenuItem = "Discord" )
        {
            Run, "C:\Users\InventorBoy\Desktop\Discord.lnk"
        }
        Else If ( A_ThisMenuItem = "Cancel" )
        {

        }
    }
Return

