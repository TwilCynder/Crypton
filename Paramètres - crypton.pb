
LoadFont(4,"Arial",8)
CreateImage(0,38,18)
StartDrawing(ImageOutput(0))
Box(0,0,40,20,Config\FontColor)
StopDrawing()

OpenWindow(2,0,0,300,510,"Crypton - Paramètres",#PB_Window_ScreenCentered)
FrameGadget(29,10,55,270,90,"")
TextGadget(10,20,65,180,30,"Police de caractères : "+Config\Font)
TextGadget(11,20,95,100,20,"Taille de police")
SpinGadget(12,127,92,40,20,3,90,#PB_Spin_Numeric)
SetGadgetState(12,config\FontSize)
TextGadget(13,20,118,100,20,"Couleur de police")
;ButtonImageGadget(14,130,118,40,20,ImageID(0))
CanvasGadget(14,127,115,40,20,#PB_Canvas_Border)
ButtonGadget(15,200,65,70,75,"CHANGER")
FrameGadget(30,10,145,270,75,"")
OptionGadget(16,20,155,235,20,"Ne pas définir le chemin par défaut")
OptionGadget(17,20,175,235,20,"Définir manuellement le chemin pas défaut")
StringGadget(18,40,195,235,20,Config\DefaultPath.s)
FrameGadget(31,10,220,270,155,"")
CheckBoxGadget(21,20,230,180,20,"Activer la sauvegarde automatique")
TextGadget(22,38,250,290,20,"Dossier de stockage des sauvegardes :")
StringGadget(23,40,270,190,20,Config\BackupFolder.s)
CheckBoxGadget(33,20,300,260,20,"Sauvegarder aussi les fichiers texte brut (.txt)")
TextGadget(34,20,325,280,20,"Sauvegarder :")
CheckBoxGadget(35,40,340,120,20,"A l'ouverture")
CheckBoxGadget(36,160,340,100,20,"A la fermeture")
ButtonGadget(24,10,10,150,40,"Changer l'emplacement du fichier de configuration",#PB_Button_MultiLine)
HyperLinkGadget(25,170,10,170,20,"En savoir plus",RGB(0,0,255))
ButtonGadget(26,235,250,40,40,"...")
FrameGadget(32,10,375,270,85,"")
CheckBoxGadget(27,20,385,250,20,"Toujours demander avant de protéger un fichier")
TextGadget(28,25,405,250,60,"Si vous cochez cette option, le programme demandera toujours si vous voulez utiliser un mot de passe lors de la création d'un nouveau fichier, même avec la fonction "+Chr(34)+"Enregistrer sous"+Chr(34)+".")
ButtonGadget(19,170,470,60,30,"OK")
ButtonGadget(20,235,470,60,30,"Annuler")

GadgetToolTip(16,"Chemin par défaut pour l'ouverture des fichiers. Si cette option est selectionnée, Crypton gardera en mémoire le dernier dossier utilisé")
GadgetToolTip(17,"Chemin par défaut pour l'ouverture des fichiers. ")
GadgetToolTip(18,"Inidquez le chemin d'accès du DOSSIER par défaut pour l'ouverture des fichiers")

CreatePopupMenu(0)
MenuItem(0,"Sélection avancée")
MenuItem(1,"Sélection basique Windows")
If Config\Temp\UseOldColorRequester = 1
  DisableMenuItem(0,0,1)
EndIf   

Refresh:

StartDrawing(CanvasOutput(14))
DrawImage(ImageID(0),0,0)
StopDrawing()


;BindGadgetEvent(25,@ChangeConfigPathInfo())
;BindGadgetEvent(14,@ChangeFontColor())

If Config\DefaultPath = ""
  DisableGadget(18,1)
  SetGadgetState(16,1)
Else 
  SetGadgetState(16,0)
EndIf   
If Config\EnableBackup = 0
  DisableGadget(23,1)
Else 
  SetGadgetState(21,1)
EndIf 

If Config\AlwaysAskForPassword = 1
   SetGadgetState(27,1)
 EndIf 
 
 If config\BackupTxt = 1
   SetGadgetState(33,1)
 EndIf 
 
 Select Config\EnableBackup
   Case 1
     SetGadgetState(36,1)
   Case 2
     SetGadgetState(35,1)
   Case 3
     SetGadgetState(35,1)
     SetGadgetState(36,1)
 EndSelect
 

If Config\DefaultPath = ""
  SetGadgetState(16,1)
Else 
  SetGadgetState(17,1)
EndIf  

Repeat 
  WindowEvent = WindowEvent()
  If WindowEvent = #PB_Event_CloseWindow
    Break
  ElseIf WindowEvent = #PB_Event_Menu
    Select EventMenu()
      Case 0
        ColorRequester = ColorValuesRequester(2,3,"Select a color",38,Config\FontColor+255*16777216)  
          If Not ColorRequester = -1
            Config\FontColor = ColorRequester
          EndIf   
          StartDrawing(ImageOutput(0))
          Box(0,0,38,18,config\FontColor)
          StopDrawing()
          SetGadgetAttribute(14,#PB_Canvas_Image,ImageID(0))
        Case 1
          ColorRequester = ColorRequester(Config\FontColor)  
          If Not ColorRequester = -1
            config\FontColor = ColorRequester
          EndIf   
          StartDrawing(ImageOutput(0))
          Box(0,0,38,18,config\FontColor)
          StopDrawing()
          SetGadgetAttribute(14,#PB_Canvas_Image,ImageID(0))
      EndSelect     
  ElseIf WindowEvent = #PB_Event_Gadget
    EventGadget = EventGadget() 
    Select EventGadget
      Case 14
        
        Select  EventType() 
          Case #PB_EventType_LeftClick
          If Config\Temp\UseOldColorRequester = 1
            ColorRequester = ColorRequester(Config\FontColor)
          Else   
            ColorRequester = ColorValuesRequester(2,3,"Select a color",38,Config\FontColor+255*16777216)
          EndIf   
          If Not ColorRequester = -1
            config\FontColor = ColorRequester
          EndIf   
          StartDrawing(ImageOutput(0))
          Box(0,0,38,18,config\FontColor)
          StopDrawing()
          SetGadgetAttribute(14,#PB_Canvas_Image,ImageID(0))
        Case #PB_EventType_RightClick
          DisplayPopupMenu(0,WindowID(2))
        EndSelect  
          
      Case 15
         If FontRequester(Config\Font,config\FontSize,0,config\FontColor)
         config\Font = SelectedFontName()
         Config\FontSize = SelectedFontSize()
         config\FontColor = SelectedFontColor()
         SetGadgetText(10,"Police de caractères : "+config\Font)
         SetGadgetState(12,config\FontSize)
         StartDrawing(ImageOutput(0))
         Box(0,0,38,18,config\FontColor)
         StopDrawing()
        EndIf 
      Case 16 , 17
        If GetGadgetState(16) = 1
          DisableGadget(18,1)
        Else
          DisableGadget(18,0)
        EndIf 
      Case 19
        ExamineDirectory(0,GetGadgetText(23),"")
         If GetGadgetText(18) = "" And GetGadgetState(16) = 0
          MessageRequester("Crypton - Erreur","Veuillez spécifier un chemin par défaut")
          Continue
        ElseIf GetGadgetText(23) = "" And GetGadgetState(21) = 1 
          MessageRequester("Crypton - Erreur","Veuillez spécifier un dossier de sauvegarde ou désactiver la sauvegarde automatique")
          Continue  
        ElseIf IsDirectory(0) = 0
          MessageRequester("Crypton - Erreur","Le dossier de sauvegarde automatique spécifié n'existe pas")
          Continue
        EndIf
        saveParam = 1
        Break 
      Case 20
        saveParam = 0
        Break 
      Case 12
        Config\FontSize = GetGadgetState(12)
      Case 21 
        If GetGadgetState(21) = 0
          DisableGadget(23,1)
          DisableGadget(33,1)
          DisableGadget(34,1)
          DisableGadget(35,1) 
        Else
          DisableGadget(23,0)
          DisableGadget(33,0)
          DisableGadget(34,0)
          DisableGadget(35,0) 
        EndIf 
      Case 34,35
        SaveOpen = GetGadgetState(34)
        SaveClose = (GetGadgetState(35)*2)
        Config\EnableBackup = SaveClose + SaveOpen 
      Case 24
        NewConfigFile$ =SaveFileRequester("Crypton",ConfigFileFolder$+"CryptonConfig.prop","Fichier de configuration .prop ou .ini | *.ini;*.prop | Fichiers texte .txt | *.txt |Tous les fichiers|*.*",0)
        If NewConfigFile$
          If FileSize(NewConfigFile$) = -1
            CreateFile(0,NewConfigFile$)
            WriteStringN(0,Config\Font)
            WriteStringN(0,Str(Config\FontSize))
            WriteStringN(0,Str(Config\FontColor))
            WriteStringN(0,Config\DefaultPath)
            WriteStringN(0,Str(Config\EnableBackup))
            WriteStringN(0,Config\BackupFolder)
            WriteStringN(0,Str(Config\AlwaysAskForPassword))
            WriteStringN(0,Str(Config\BackupTxt))
            WriteStringN(0,Config\CVR_DLL_Path)
            CloseFile(0)
          Else
            OpenFile(0,ConfigFileFolder$+ConfigFileName$)
            Config\Font = (ReadString(0))
            Config\FontSize = Val(ReadString(0))
            Config\FontColor = Val(ReadString(0))
            Config\DefaultPath = ReadString(0)
            Config\EnableBackup = Val(ReadString(0))
            Config\BackupFolder = ReadString(0)
            Config\AlwaysAskForPassword = Val(ReadString(0))
            Config\BackupTxt = Val(ReadString(0))
            Goto Refresh
          EndIf 
          CreateFile(1,"ConfigPath")
          WriteStringN(1,GetPathPart(NewConfigFile$))
          WriteStringN(1,GetFilePart(NewConfigFile$))
        EndIf           
      Case 26
        SetGadgetText(23,PathRequester("Crypton",""))
      Case 25
        ChangeConfigPathInfo$ = "Choisir un nouveau fichier de configuration, ou le dossier ou ce dernier se trouve (dans ce cas, il devra obligatoirement s'appeler 'CryptonConfig.prop')."
        ChangeConfigPathInfo$ + Chr(13)
        ChangeConfigPathInfo$ + "Un fichier indiquant le nouveau chemin d'accès sera créé, et ne devra pas être déplacé, supprimé ou modifié."
        ChangeConfigPathInfo$ + Chr(13)
        ChangeConfigPathInfo$ +"Il est conseillé de laisser le fichier configuration dans un endroit où il a peu de chances d'être suprrimé ou déplacé (comme le dossier Appdata/Roaming/Crypton) afin de ne pas devoir rechanger son chemin d'accès ultèrieurement" 
        MessageRequester("Crypton",ChangeConfigPathInfo$)
    EndSelect   
  EndIf
  Delay(10)
Until  quit = 1

 If ConfigFileName$ = ""
    ConfigFileName$ = "CryptonConfig.prop"
  EndIf 

If Not ConfigFileReadMode$ = "DefaultConfig"
If saveParam = 0
  OpenFile(0,ConfigFileFolder$+ConfigFileName$)
Config\Font = (ReadString(0))
Config\FontSize = Val(ReadString(0))
Config\FontColor = Val(ReadString(0))
Config\DefaultPath = ReadString(0)
Config\EnableBackup = Val(ReadString(0))
Config\BackupFolder = ReadString(0)
Config\AlwaysAskForPassword = Val(ReadString(0))
Config\BackupTxt = Val(ReadString(0))
LoadFont(3,Config\Font,Config\FontSize)
CloseFile(0)
ElseIf saveParam = 1 
  If GetGadgetState(17) = 1
    Config\DefaultPath = GetGadgetText(18)
  ElseIf GetGadgetState(17) = 0 
    Config\DefaultPath = ""
  EndIf 
  
  Config\EnableBackup = GetGadgetState(21)
  Config\BackupFolder = GetGadgetText(23)
  Config\FontSize = GetGadgetState(12)
  Config\EnableBackup = GetGadgetState(21) * (GetGadgetState(35)*2 + GetGadgetState(36))
  Config\BackupFolder = GetGadgetText(23)
  Config\AlwaysAskForPassword = GetGadgetState(27)
  Config\BackupTxt = GetGadgetState(33)
  
   
  CreateFile(0,ConfigFileFolder$+ConfigFileName$)
  WriteStringN(0,Config\Font)
  WriteStringN(0,Str(Config\FontSize))
  WriteStringN(0,Str(Config\FontColor))
  WriteStringN(0,Config\DefaultPath)
  WriteStringN(0,Str(Config\EnableBackup))
  WriteStringN(0,Config\BackupFolder)
  WriteStringN(0,Str(Config\AlwaysAskForPassword))
  WriteStringN(0,Str(Config\BackupTxt))
  WriteStringN(0,Config\CVR_DLL_Path)
EndIf 
Else 
  If saveParam = 0
    Config\Font = "Arial"
  Config\FontSize = 12
  Config\FontColor = 0
  Config\DefaultPath = ""
  Config\EnableBackup = 0
  Config\PropertiesPath = ""
  Config\BackupTxt = 1
ElseIf saveParam = 1
  If GetGadgetState(17) = 1
    Config\DefaultPath = GetGadgetText(18)
  ElseIf GetGadgetState(17) = 0 
    Config\DefaultPath = ""
  EndIf 
  
  Config\EnableBackup = GetGadgetState(21)
  Config\BackupFolder = GetGadgetText(23)
  Config\FontSize = GetGadgetState(12)
  Config\EnableBackup = GetGadgetState(21) * (GetGadgetState(35)*2 + GetGadgetState(36))
  Config\BackupFolder = GetGadgetText(23)
  Config\AlwaysAskForPassword = GetGadgetState(27)
  Config\BackupTxt = GetGadgetState(33)
  
EndIf 
EndIf 
;Idée possible : mettre le fichier config en pseudo J-Son (genre font=***), pour faciliter le bidouillage.

CloseWindow(2)

quit = 0
saveParam = 0
EventGadget = 0
SaveOpen = 0
SaveClose = 0
; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 58
; FirstLine = 54
; EnableUnicode
; EnableXP