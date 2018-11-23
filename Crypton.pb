;Crypton version 3.0 
;Par Téo "TwilCynder" Tinarrage.

;Tasks :
; - Réimplémenter la progress bar lors de l'écriture
; - Réintégrer CVR

;===============================
;- Initalisations
;===============================

;-== Constantes
#CPT_FileType_Text = 0
#CPT_FileType_Crypt = 1
Enumeration -1 Step -1
  #CPT_LoadFile_Success
  #CPT_LoadFile_FileError
  #CPT_LoadFile_WrongPassword
  #CPT_Loadfile_Canceled
  #CPT_Loadfile_CorruptFile
EndEnumeration  
;-== Structures
Structure TempParam
  UseOldColorRequester.b
EndStructure   

Structure Param
  Font.s
  FontSize.b
  FontColor.l
  DefaultPath.s
  PropertiesPath.s
  EnableBackup.b
  BackupFolder.s
  AlwaysAskForPassword.b
  BackupTxt.b
  UseIntro.b
  CVR_DLL_Path.s ;penser à placer ce paramètre en dernier dans les processus de lecture/écriture des paramètres
  Temp.TempParam
EndStructure 

Structure opWin
  id.q  
  type.s
EndStructure

Structure editorGadgetlist
  editor.q
  readOnlyToggle.q
  saveButton.q
EndStructure 

Structure editConfig
  readOnly.b
EndStructure 

Structure editor
  win.opWin
  lastFileOpened.s
  currentFile.s
  fileType.b
  g.editorGadgetList
  config.editConfig
EndStructure    

Structure Text
  List lines.s()
EndStructure  

;-== Variables et objets
Global Config.Param
Dim splash.s(10)

NewList editors.editor()
Define id.q, welcomeWin.opWin

;-== Modules externes
InitKeyboard()
InitSprite()
UseJPEGImageDecoder()

;===============================
;- Procedures
;===============================

Procedure checkWindows()
  Shared editors(), welcomeWin
  If Not (ListSize(editors()) Or IsWindow(welcomeWin\id))
    End
  EndIf   
EndProcedure

XIncludeFile "intro.pb"
XIncludeFile "textLib.pb"
XIncludeFile "editorLib.pbi"

;-== Callbacks

Procedure welcomeWindowGadgetsCallback()
  Select EventGadget()
    Case 0
      openEditor()
    Case 1
      openEditor(OpenFileRequester("Select a file", "", "Fichiers Cryptés|*.crypt|Fichier Texte|*.txt", 0))
  EndSelect
EndProcedure  

Procedure closeWelcomeWindow()
  *welcomeWin.opWin = GetWindowData(EventWindow())
  CloseWindow(*welcomeWin\id)
  CheckWindows()
EndProcedure

;===============================
;- Préparation
;===============================

XIncludeFile "readInitFiles.pb"

;-== Chargement des images 
If LoadImage(0,"Icon\FolderIcon.jpg")
  FolderIconLoaded = 1
Else 
 FolderIconLoaded = 0
EndIf   

If FolderIconLoaded = 0
  CreateImage(0,20,20)
  LoadFont(0,"Velvenda Cooler",30)
  StartDrawing(ImageOutput(0))
  DrawText(0,0,"P",RGB(255,0,0))
  StopDrawing()
EndIf    


;===============================
;- Lancement
;===============================

id = OpenWindow(#PB_Any, 0, 0, 800, 600, "Crypton", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
ButtonGadget(0, 5, 5, 100, 40, "Nouveau")
ButtonGadget(1, 5, 50, 100, 40, "Ouvrir")

welcomeWin\id = id
SetWindowData(id, @welcomeWin)
BindEvent(#PB_Event_CloseWindow, @closeWelcomeWindow(), id)
BindEvent(#PB_Event_Gadget, @welcomeWindowGadgetsCallback(), id)

Repeat 
  Delay(20)
  WaitWindowEvent()
ForEver 

; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 14
; Folding = -
; EnableUnicode
; EnableXP