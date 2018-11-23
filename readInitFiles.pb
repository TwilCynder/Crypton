CompilerIf #PB_Compiler_IsIncludeFile 

;
;- - Lecture du fichier de configuration

#ConfRead_SimplyRead = 1
#ConfRead_Default = 2
#ConfRead_Recreate = 3

ConfigFileReadMode.b = 0

If Not FileSize("CryptonConfig.prop") = -1 
  OpenFile(0,"CryptonConfig.prop")
  ConfigFileReadMode = #ConfRead_SimplyRead
ElseIf Not FileSize("ConfigPath") = -1
    OpenFile(1,"ConfigPath")
    ConfigFileFolder$ = ReadString(1)
    ConfigFileName$ = ReadString(1)
    If Not FileSize(ConfigFileFolder$+ConfigFileName$) = -1
      OpenFile(0,ConfigFileFolder$+ConfigFileName$)
      ConfigFileReadMode = #ConfRead_SimplyRead
    EndIf  
EndIf   
If ConfigFileReadMode = 0
  OpenWindow(0,0,0,400,150,"Crypton - Erreur")
       TextGadget(0,20,20,360,20,"Le fichier configuration n'a pas été trouvé.",#PB_Text_Center) 
       ButtonGadget(1,20,45,110,95,"Rechercher le fichier configuration",#PB_Button_MultiLine)
       ButtonGadget(2,150,45,110,95,"Utiliser la configuration par défaut (les paramètres ne seront pas sauvegardés et ce message d'erreur réapparaitra)",#PB_Button_MultiLine)
       ButtonGadget(3,280,45,100,95,"Utiliser la configuration par défaut et recréer le fichier configuration",#PB_Button_MultiLine)
       Repeat
         Select WindowEvent() 
           Case #PB_Event_CloseWindow
             End 
           Case #PB_Event_Gadget
             Select EventGadget()
               Case 1
                 NewConfigPath$ = OpenFileRequester("Crypton","","Fichier de configuration .ini ou .prop | *.ini;*.prop | Fichier texte .txt | *.txt",0)
                 If NewConfigPath$ = ""
                   End
                 EndIf   
                 OpenFile(0,NewConfigPath$)
                 CreateFile(1,"ConfigPath")
                 WriteStringN(1,GetPathPart(NewConfigPath$))
                 WriteStringN(1,GetFilePart(NewConfigPath$))
                 ConfigFileFolder$ = GetPathPart(NewConfigPath$)
                 ConfigFileName$ = GetFilePart(NewConfigPath$)
                 ConfigFileReadMode = #ConfRead_SimplyRead
               Case 2 
                 ConfigFileReadMode = #ConfRead_Default
               Case 3
                 ConfigFileReadMode = #ConfRead_Recreate
                 ConfigFileName$ = "CryptonConfig.prop"
             EndSelect
         EndSelect                     
       Until Not ConfigFileReadMode = 0
      CloseWindow(0)   
EndIf   


If ConfigFileReadMode = #ConfRead_SimplyRead
Config\Font = ReadString(0)
Config\FontSize = Val(ReadString(0))
Config\FontColor = Val(ReadString(0))
Config\DefaultPath = ReadString(0)
Config\EnableBackup = Val(ReadString(0))
Config\BackupFolder = ReadString(0)
Config\AlwaysAskForPassword = Val(ReadString(0))
Config\BackupTxt = Val(ReadString(0))
Config\CVR_DLL_Path = ReadString(0)

LoadFont(3,Config\Font,Config\FontSize)

ElseIf ConfigFileReadMode = #ConfRead_Default Or ConfigFileReadMode = #ConfRead_Recreate
  Config\Font = "Arial"
  Config\FontSize = 12
  Config\FontColor = 0
  Config\DefaultPath = ""
  Config\EnableBackup = 0
  Config\BackupFolder = ""
  Config\AlwaysAskForPassword = 0
  Config\BackupTxt = 1 
  
  If ConfigFileReadMode = #ConfRead_Recreate
    CreateFile(0,ConfigFileFolder$+ConfigFileName$)
  EndIf   
  
EndIf 

If IsFile(0)
  CloseFile(0) 
EndIf 
If IsFile(1)
  CloseFile(1)
EndIf   

;- - Lecture des splashs

If ReadFile(0,"CryptonSplash.crypt")
  NewList splashRead.s()
  ReadString(0)
  ReadString(0)
  SPL_nb.b = 0
  While Not Eof(0)
    RawSplash$ = ReadString(0)
    AddElement(splashRead())
    For y = 1 To Len(RawSplash$) Step 4
      Mid(RawSplash$,y,4)
    Next 
  Wend
  CloseFile(0)
  SPL_nb = ListSize(splashRead())
  i = 0
  ForEach splashRead()
    splash(i) = splashRead()
    i + 1 
  Next  
Else 
  SPL_nb = 1
  Splash(0) = "Someone Somewhere"
EndIf  

CompilerEndIf

; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 96
; FirstLine = 82
; Folding = -
; EnableUnicode
; EnableXP