Define isEditorb.b

Procedure initEditor(passwordState.b = 0, filetype.s = "crypt")
  Shared isEditor
  Shared Config.Param
  
  If Not isEditor
    
    If filetype = "crypt"
      ChangeFileAction$ = "Enregistrer au format texte"
      If passwordState = 1
        PasswordOption$ = "Désactiver"
      Else
        PasswordOption$ = "Activer"
      EndIf     
    Else 
      ChangeFileAction$ = "Crypter"
    EndIf   
    
    OpenWindow(2,0,0,800,620,"Crypton - lecture",#PB_Window_SystemMenu | #PB_Window_WindowCentered,WindowID(1))
    EditorGadget(7,5,5,790,560,#PB_Editor_WordWrap)
    SetGadgetFont(7,FontID(3))
    SetGadgetColor(7,#PB_Gadget_FrontColor,Config\FontColor)
    SetGadgetAttribute(7,#PB_Editor_ReadOnly,1)
    CheckBoxGadget(8,5,580,50,15,"Edition")
    ButtonGadget(9,600,570,195,20,"SAUVEGARDER ET QUITTER")
    CreateMenu(0,WindowID(2))
    MenuTitle("Fichier")
    MenuItem(1,"Enregistrer" + Chr(9) +"Ctrl + S")
    AddKeyboardShortcut(2,#PB_Shortcut_Control | #PB_Shortcut_S,1)
    MenuItem(2,"Enregistrer sous"+Chr(9)+"Ctrl+Maj+S")
    AddKeyboardShortcut(2,#PB_Shortcut_Control | #PB_Shortcut_Shift | #PB_Shortcut_S,2)
    MenuItem(3,ChangeFileAction$)
    MenuItem(4,"Changer le mot de passe")
    MenuItem(5,PasswordOption$+" mot de passe") 
    MenuItem(6,"Quitter sans sauvegarder")
    CreateToolBar(1,WindowID(2))
    ToolBarStandardButton(1,#PB_ToolBarIcon_Save)
  
    ToolBarHeight = ToolBarHeight(1)
  
    ResizeGadget(7,5,5 + 2 + ToolBarHeight,790,560 - 2 - ToolBarHeight)
    
    isEditor = 1
  EndIf 
  
EndProcedure

; IDE Options = PureBasic 5.30 (Windows - x64)
; Folding = -
; EnableUnicode
; EnableXP