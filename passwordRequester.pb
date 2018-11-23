Procedure.s passwordRequester(motherWindow.q)
  win.q = OpenWindow(#PB_Any,0,0,400,100,"password",#PB_Window_WindowCentered|#PB_Window_SystemMenu,WindowID(motherWindow))
  TextGadget(#PB_Any,20,10,360,15,Text$,#PB_Text_Center)
  stringG.q = StringGadget(#PB_Any,100,35,200,20,"")
  buttonG_OK.q = ButtonGadget(#PB_Any,140,65,55,30,"OK")
  buttonG_Cancel.q = ButtonGadget(#PB_Any,205,65,55,30,"Cancel")
  SetActiveGadget(stringG)
  AddKeyboardShortcut(win, #PB_Key_Escape, 0)
  AddKeyboardShortcut(win, #PB_Key_Return, 1)
  
  Repeat 
    WindowEvent = WaitWindowEvent()
    If WindowEvent = #PB_Event_Gadget
      If EventGadget() = buttonG_OK
        ;Clicked on the OK button
        Done = 1
      ElseIf EventGadget() = buttonG_Cancel
        ;Clicked on the Cancel button
       Done = 2
      EndIf 
    ElseIf WindowEvent = #PB_Event_CloseWindow    
      Done = 2 
    ElseIf WindowEvent = #PB_Event_Menu
      If EventMenu()
        Done = 1
      Else
        done = 2
      EndIf   
    EndIf 
    Delay(5)
  Until Done > 0
  WindowEvent = 0
  If Done = 1
   ProcedureReturn GetGadgetText(8)
  Else 
   ProcedureReturn ""
  EndIf  
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 5
; Folding = -
; EnableUnicode
; EnableXP