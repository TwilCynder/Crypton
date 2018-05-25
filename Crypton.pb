;VERSION 2.6

;EN COURS DE DEVELOPPEMENT

#DevMode = 1

;-Correspondances entre caractères et combinaisons

XIncludeFile "Tableau des correspondances caractères-nombre.txt"

Global Dim Splash$(88)
Global Dim debuglettre$(1000)
Global Dim debugconb(1000)
Global progress=0
Global debug_=0
Global progressbar.f=0
Global totalIt.f
Global SPL_nb
 Dim lignes$(100)
Global BadCharacters.s  
  
;Procédures diverses

Procedure introII(speed.f)  ;La procédure qui gère l'intro
  
  SelectedSplash$ = " "+Splash$(Random(SPL_nb,1))
  
  color=RGB(255,30,30)
  LoadFont(0,"Velvenda Cooler",50)
    
  Repeat
    ClearScreen(0)
    red_Circle_One + speed  
    
    If red_Circle_One > 12
     red_Circle_Two + speed
   EndIf 
   
   If red_Circle_Two > 12
     red_Circle_three + speed
   EndIf   
   
   If red_Circle_three > 15
     red_Circle_four + speed
   EndIf   
     
   If red_Circle_four > 40 
     red_Circle_five + speed
   EndIf
   
   If red_Circle_five > 400
     Text=1
     alpha+speed
   EndIf
    
   If text = 1
     timetext+speed+1
     text$="C"
   EndIf 
   
   
   If timetext > 50
     text$="Cr"
   EndIf
   
   If timetext > 100
     text$="Cry"
   EndIf   
   
   If timetext > 150
     text$="Cryp"
   EndIf 
   
   If timetext > 200
     text$="Crypt"
   EndIf 
   
   If timetext > 250
     text$="Crypto"
   EndIf 
   
   If timetext > 300
     text$="Crypton"
   EndIf   
           
    StartDrawing(ScreenOutput())
    DrawingMode(#PB_2DDrawing_Outlined )
       
    Circle(400,300,red_Circle_One,RGB(255,0,0))
    Circle(400,300,red_Circle_Two,RGB(255,0,0))
    Circle(400,300,red_Circle_three,RGB(255,0,0))
    
    DrawingMode(#PB_2DDrawing_Default)
    
    Circle(400,300,red_Circle_four,RGB(255,0,0))
    Circle(400,300,red_Circle_five,RGB(40,0,0))
    
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawingFont(FontID(0))
    If Text=1
      DrawText(300,265,Text$,color)
    EndIf   
    If timetext>1 And timetext<15
      Box(300,0,40,600,RGB(255,0,0))
    EndIf   
    If timetext>50 And timetext <65
      Box(325,0,40,700,RGB(255,0,0))
    EndIf
    If timetext>100 And timetext < 115
      Box(350,0,40,700,RGB(255,0,0))
    EndIf
    If timetext>150 And timetext < 165
      Box(375,0,40,700,RGB(255,0,0))
    EndIf
    If timetext>200 And timetext < 215
      Box(405,0,40,700,RGB(255,0,0))
    EndIf
    If timetext>250 And timetext < 265
      Box(430,0,40,700,RGB(255,0,0))
    EndIf
    If timetext>300 And timetext < 315
      Box(460,0,40,700,RGB(255,0,0))
    EndIf   
    
    StopDrawing()
    
    LoadFont(2,"Arial",10)
    
   StartDrawing(ScreenOutput()) 
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText(50,500,"Crypton ©" + SelectedSplash$)    
   StopDrawing()
    
    FlipBuffers()
       
    If red_Circle_One > 1200
      quit=1
    EndIf
    
  Until quit=1
EndProcedure  

Procedure SelectCombinaison(TotalCaract,Caract$)
  For x = 1 To TotalCaract
    If Caract$ = lettres$(x)
      numCaract=x
      Break
    EndIf
  Next
  If numCaract = 0
    BadCharacters+Caract$
  EndIf   
  
  SubNumCaract=Random(2)+1  
  
  Combinaison=combinaisons(numCaract,SubNumCaract)
 
 debug_+1
 
 debuglettre$(debug_)=lettres$(x)
 debugconb(debug_)=Combinaison
  
  ProcedureReturn Combinaison
  
EndProcedure


Procedure SelectCharacter(combinaison$,totalCaract)    ;La procédure qui convertit une combinaison (incluant le chiffre random) en caractère
  
 revCombinaison$ = ReverseString(combinaison$)
 
 comb_$ = LSet(revCombinaison$,3)
 
 comb$ = ReverseString(comb_$)
  
  For x = 1 To totalCaract
    For y = 1 To 3
      If comb$=Str(combinaisons(x,y))
        letter=x
      EndIf 
    Next
  Next
  
ProcedureReturn letter 
EndProcedure 


Procedure intro(time)                           ;La vieille intro dégueulasse
  LoadFont(1,"Velvenda Cooler",50)
  StartDrawing(ScreenOutput())
   DrawingMode(#PB_2DDrawing_Transparent)
   DrawingFont(FontID(1))
   Circle(400,300,200,RGB(200,0,10))
   Circle(400,300,50,RGB(10,0,255))
   DrawText(300,265,"CRYPTON",RGB(255,255,255))
   StopDrawing()
   LoadFont(2,"Arial",10)
  StartDrawing(ScreenOutput()) 
   DrawText(50,500,"Crypton © Sainte Russie  " , RGB(255,255,255))
  StopDrawing()
  FlipBuffers()
  Delay(time)
EndProcedure
 
Procedure CryptLine(numFile,text$)     ;La procédure qui crypte une chaîne de caractère (une ligne) et qui l'écrit dans le fichier
  Static progress
  
  For x = 1 To Len(text$)
    chain$+Str(Random(9))+SelectCombinaison(#NombreDeCaracteres,Mid(text$,x,1))
    Delay(10)
    progress+1
    
    progressbar=(progress*10)/totalIt
        
    If IsFile(17)
    SetGadgetState(17,progress)
    EndIf 
  Next
   
  WriteString(numFile,chain$+Chr(13)+Chr(10))
 
EndProcedure 

CompilerIf #DevMode = 1
  CVRPath$ = "C:\Users\mrmac_000\Documents\Prog\Sources\ColorValuesRequester\CVR 3.dll"
CompilerElse
  CVRPath$ = "ColorValuesRequester.dll"
CompilerEndIf



;-Configuration
#CR_Config_UseIntro=1

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
  CVR_DLL_Path.s ;penser à placer ce paramètre en dernier dans les processus de lecture/écriture des paramètres
  Temp.TempParam
EndStructure  
Global Config.Param

;Procedure ChangeFontColor()
;      If EventType() = #PB_EventType_LeftClick
;        config\FontColor = ColorRequester()
;        StartDrawing(ImageOutput(0))
;        Box(0,0,38,18,config\FontColor)
;        StopDrawing()
;        
;        StartDrawing(CanvasOutput(14))
;        DrawImage(ImageID(0),0,0)
;        StopDrawing()
;      EndIf   
;EndProcedure

;Procedure ChangeFont()
;        If FontRequester(Config\Font,config\FontSize,0,config\FontColor)
;        config\Font = SelectedFontName()
;        Config\FontSize = SelectedFontSize()
;        config\FontColor = SelectedFontColor()
;        SetGadgetText(10,"Police de caractères : "+config\Font)
;        SetGadgetState(12,config\FontSize)
;        StartDrawing(ImageOutput(0))
;        Box(0,0,38,18,config\FontColor)
;        StopDrawing()
;      EndIf 
;EndProcedure      
      

;Procedure ChangeConfigPathInfo()
;  ChangeConfigPathInfo$ + "Choisir un nouveau fichier de configuration, ou le dossier ou ce dernier se trouve (dans ce cas, il devra oubligatoirement s'appeler 'CryptonConfig.prop')."
;  ChangeConfigPathInfo$ + Chr(13)
;  ChangeConfigPathInfo$ + "Un fichier indiquant le nouveau chemin d'accès sera créé, et ne devra pas être déplacé, supprimé ou modifié."
;  ChangeConfigPathInfo$ + Chr(13)
;  ChangeConfigPathInfo$ +"Il est conseillé de laisser le fichier configuration dans un endroit où il a peu de chances d'être suprrimé ou déplacé (comme le dossier Appdata/Roaming/Crypton) afin de ne pas devoir rechanger son chemin d'accès ultèrieurement" 
;  MessageRequester("Crypton",ChangeConfigPathInfo$)
;EndProcedure  

;If Not OpenFile(0,"CryptonConfig.prop")
;  If Not OpenFile(1,"ConfigPath.txt")
;    If MessageRequester("Crypton - Error","Les fichier de configuration n'ont pas été trouvés."+Chr(13)+"Voulez-vous utiliser la configuration par défaut ?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
;      Config\Font = "Arial"
;      Config\FontSize = 12
;      Config\FontColor = 0
;      Config\DefaultPath = ReadString(0)
;      LoadFont(3,Config\Font,Config\FontSize)
;      LoadFont(3,Config\Font,Config\FontSize)
;    Else 
;      End 
;    EndIf
;  Else 
;    Config\PropertiesPath = ReadString(1)
;    CloseFile(1)
;   OpenFile(0,Config\PropertiesPath+"CryptonConfig.prop")
;  EndIf   
;EndIf


;- Chargement de fichiers (DLL, paramètres) 


If Not FileSize("CryptonConfig.prop") = -1 
  OpenFile(0,"CryptonConfig.prop")
  ConfigFileReadMode$ = "SimplyRead"
Else   
  If Not FileSize("ConfigPath") = -1
    OpenFile(1,"ConfigPath")
    ConfigFileFolder$ = ReadString(1)
    ConfigFileName$ = ReadString(1)
    If Not FileSize(ConfigFileFolder$+ConfigFileName$) = -1
      OpenFile(0,ConfigFileFolder$+ConfigFileName$)
      ConfigFileReadMode$ = "SimplyRead"
    Else 
   OpenWindow(0,0,0,400,150,"Crypton - Erreur")
       TextGadget(0,20,20,360,20,"Le fichier configuration n'a pas été trouvé à l'emplacement indiqué.",#PB_Text_Center) 
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
                 NewConfigFilename$ = OpenFileRequester("Crypton","","Fichier de configuration .ini ou .prop | *.ini;*.prop",0)
                  If NewConfigFilename$ = ""
                   End
                 EndIf   
                 OpenFile(0,NewConfigFilename$)
                 CreateFile(1,"ConfigPath")
                 WriteStringN(1,GetPathPart(NewConfigFilename$))
                 WriteStringN(1,GetFilePart(NewConfigFilename$))
                 ConfigFileFolder$ = GetPathPart(NewConfigFilename$)
                 ConfigFileName$ = GetFilePart(NewConfigFilename$)
                 ConfigFileReadMode$ = "SimplyRead"
               Case 2 
                 ConfigFileReadMode$ = "DefaultConfig"
               Case 3
                 ConfigFileReadMode$ = "RecreateConfigFile"
             EndSelect
         EndSelect                     
       Until Not ConfigFileReadMode$ = ""  
      CloseWindow(0) 
    EndIf   
  Else   
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
                 NewConfigFilename$ = OpenFileRequester("Crypton","","Fichier de configuration .ini ou .prop | *.ini;*.prop | Fichier texte .txt | *.txt",0)
                 If NewConfigFilename$ = ""
                   End
                 EndIf   
                 OpenFile(0,NewConfigFilename$)
                 CreateFile(1,"ConfigPath")
                 WriteStringN(1,GetPathPart(NewConfigFilename$))
                 WriteStringN(1,GetFilePart(NewConfigFilename$))
                 ConfigFileFolder$ = GetPathPart(NewConfigFilename$)
                 ConfigFileName$ = GetFilePart(NewConfigFilename$)
                 ConfigFileReadMode$ = "SimplyRead"
               Case 2 
                 ConfigFileReadMode$ = "DefaultConfig"
               Case 3
                 ConfigFileReadMode$ = "RecreateConfigFile"
                 ConfigFileName$ = "CryptonConfig.prop"
             EndSelect
         EndSelect                     
       Until Not ConfigFileReadMode$ = ""  
      CloseWindow(0)   
  EndIf 
  
EndIf   



If ConfigFileReadMode$ = "SimplyRead"
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

ElseIf ConfigFileReadMode$ = "DefaultConfig" Or ConfigFileReadMode$ = "RecreateConfigFile"
  Config\Font = "Arial"
  Config\FontSize = 12
  Config\FontColor = 0
  Config\DefaultPath = ""
  Config\EnableBackup = 0
  Config\BackupFolder = ""
  Config\AlwaysAskForPassword = 0
  Config\BackupTxt = 1 
  
  If ConfigFileReadMode$ = "RecreateConfigFile"
    CreateFile(0,ConfigFileFolder$+ConfigFileName$)
  EndIf   
  
EndIf 

If IsFile(0)
  CloseFile(0) 
EndIf 
If IsFile(1)
  CloseFile(1)
EndIf   

CVRPath$ = Config\CVR_DLL_Path
Prototype CVR(MotherWindow.q,WindowInd.q=#PB_Any,Title$="Select color",Parameters.u = 38,DefaultColor.q = 4278190080)
If FileSize(CVRPath$) = -1
  NoCvrDllErrorMessage$ = "La DLL "+Chr(34)+"ColorValuesRequester"+Chr(34)+" n'a pas pu être trouvée. Voulez-vous la recherchezr manuellement ? "
  NoCvrDllErrorMessage$ + "L'absence de la DLL n'affectera que la sélection de le couleur dans les paramètres, qui utilisera l'interface basique de Windows"
  MessageAnswer = MessageRequester("Erreur",NoCvrDllErrorMessage$,#PB_MessageRequester_YesNoCancel) 
  If MessageAnswer = #PB_MessageRequester_Yes
    CVRSeekPath:
    CVRPath$ = OpenFileRequester("Crypton","","DLL ColorValuesRequester |ColorValuesRequester.dll|DLL sous un autre nom|*.dll",0)
    OpenLibrary(0,CVRPath$)
    If SelectedFilePattern() = 1 And GetFunction(0,"ColorValuesRequester") = 0
      MessageRequester("Crypton - Erreur","La DLL sélectionnée ne contient pas la fonction attendue.")
      Goto CVRSeekPath
    EndIf 
    ColorValuesRequester.CVR = GetFunction(0,"ColorValuesRequester")  
    Config\CVR_DLL_Path = CVRPath$
    
    
    
  ElseIf MessageAnswer = #PB_MessageRequester_No 
    Config\Temp\UseOldColorRequester = 1
  Else
    End 
  EndIf  
Else
  OpenLibrary(0,CVRPath$)
  ColorValuesRequester.CVR = GetFunction(0,"ColorValuesRequester") 
EndIf   

If ReadFile(0,"CryptonSplash.crypt")
  ReadString(0)
  ReadString(0)
  
 While Not Eof(0)
   SPL_nb + 1
   RawSplash$ = ReadString(0)
   For y = 1 To Len(RawSplash$) Step 4
   Splash$(SPL_nb) + lettres$(SelectCharacter(Mid(RawSplash$,y,4),#NombreDeCaracteres))
    Next 
  Wend
  
  CloseFile(0)
  
Else 
  SPL_nb = 1
  Splash$(1) = "Someone Somewhere"
EndIf   

UseJPEGImageDecoder()
InitSprite()
InitKeyboard()

OpenWindow(1,0,0,800,600,"Crypton - Logiciel de gestion de fichiers cryptés",#PB_Window_ScreenCentered | #PB_Window_SystemMenu)

;- Chargement des images 
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

 ;- Introduction graphique 
  
If #CR_Config_UseIntro=1
  OpenWindowedScreen(WindowID(1),0,0,800,600)
  introII(7)
  CloseScreen()
EndIf



;-Menu principal

LoadFont(0,"Velvenda Cooler",35)
TextGadget(0,0,100,800,60,"Crypton",#PB_Text_Center)
SetGadgetFont(0,FontID(0))
ButtonGadget(1,100,200,230,200,"Nouveau fichier",#PB_Button_MultiLine)
ButtonGadget(2,460,200,230,200,"Ouvrir un fichier",#PB_Button_MultiLine)
ButtonGadget(3,350,200,90,40,".txt -> .crypt",#PB_Button_MultiLine) 
ButtonGadget(4,350,360,90,40,".crypt -> .txt",#PB_Button_MultiLine)
ButtonGadget(5,5,5,60,20,"Paramètres")



;-gestion des events et du menu


menu:

UseMDP=0

ProgramParameter.s = ProgramParameter()
If GetExtensionPart(ProgramParameter) = "txt" 
  Basefile$ = ProgramParameter
  BasefileType$  = "text"
  Goto OpenFile
ElseIf GetExtensionPart(ProgramParameter) = "crypt" 
  Basefile$ = ProgramParameter
  BasefileType$  = "crypt"
  Goto OpenFile
EndIf   

Repeat
  
Select WindowEvent() 
  Case #PB_Event_CloseWindow
    End 
  Case #PB_Event_Gadget
    event = EventGadget()
    Select event
      Case 1 
        XIncludeFile "Ecriture2 - crypton.pb"
        quit=1
      Case 2
        XIncludeFile "Lecture - crypton.pb"
        quit=1
      Case 3
        XIncludeFile "Cryptage de fichier - crypton.pb"         
        quit=1
      Case 4
        XIncludeFile "Réecriture - crypton.pb"
        quit=1
      Case 5
        XIncludeFile "Paramètres - crypton.pb"  
      EndSelect  
EndSelect

    
    Delay(2)
Until quit=1


;Buglog

;24/09/13 : [RESOLU]La police de caractère selectionée avec drawingFont n'est pas utilisée -----> erreur dans le nom de la police , suffit de mettre le bon
;29/09/13 : [RESOLU]Le programme se termine alors qu'il devrait être bloqué par WaitWindowEvent() ------> Bug pas résolu , j'utilse jutste 'repeat'windowEvent'until'
;16/11/13 : [RESOLU]Dans le fichier crypté , certains chiffres sont manquants ou en trop . L'erreur est déja présente au Writestring()----> si le chiifre au hasard des combnaisons était 0 , il était pas compté --->  rajouter simplement le caractère au hasard en tant que texte 

;27/07/15 : [RESOLU]Les fenètres d'édition ne veulent pas se fermer ----> Il faut utiliser WindowEvent une seule fois par boucle
;27/07/15 : [RESOLU]Ipossible de changer la couleur de police, le bouton ne réagit pas ----> Bug contourné, utilisation d'un CallBack au lieu de la boucle.

;Projets
;27/05/16 : Ajouter une toolbar aux éditeurs, ainsi que des raccourcis clavier ----> Fait
; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 432
; FirstLine = 410
; Folding = --
; EnableXP
; UseIcon = Icone2.ico
; Executable = C:\Users\mrmac_000\Desktop\Cypton 2.5 Temp.exe