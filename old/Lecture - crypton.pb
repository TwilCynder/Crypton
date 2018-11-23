LoadFont(1,"Agency FB",48)                                     ;Chargement de la police de caractère qui sera utilisée
;-Ouverture du fichier crypt

FileSelect:

Basefile$=OpenFileRequester("Choisissez le fichier a ouvrir",Config\DefaultPath,"Fichiers cryptés|*.crypt|Fichiers Texte|*.txt|Tous les fichiers|*.*",0)
If Basefile$ = ""
  Goto menu 
EndIf   
If SelectedFilePattern() = 1
  BasefileType$ = "text"
  ChangeFileAction$ = "Crypter"
ElseIf SelectedFilePattern() = 0
  BasefileType$ = "crypt"
  ChangeFileAction$ = "Enregistrer au format .txt"
Else 
  If GetExtensionPart(Basefile$) = "txt"
    BasefileType$ = "text"
    ChangeFileAction$ = "Crypter"
  ElseIf GetExtensionPart(Basefile$) = "crypt"
     BasefileType$ = "crypt"
     ChangeFileAction$ = "Enregistrer au format .txt"
  Else 
    MessageRequester("Crypton - Lecture","Fichier non-reconnu par Crypton."+Chr(13)+"Veuillez choisir un fichier .crypt ou .txt")
    Goto FileSelect
  EndIf   
        
EndIf   

OpenFile:
fileType$ = BasefileType$

file$ = Basefile$

If Not ReadFile(1,file$)
  MessageRequester("Erreur","Un problème est survenu au niveau du fichier :"+Chr(13)+"Le programme n'a pas pu ouvrir le fichier spécifié, "+Chr(13)+"celui-ci est peut être corrompu, on n'existe pas.")
  Goto menu
EndIf   
  
  
  

Dim decrypt$(100)   

If fileType$ = "text"
    x = 0
  While Not Eof(1)
    x+1
    decrypt$(x) = ReadString(1)
  Wend     
  open = 1

  
Else   
;-lecture du fichier crypt

r_lectMDP$=ReadString(1)                             ;On remplit r_lectMDP$ avec la première ligne du fichier

For i = 1 To Len(r_lectMDP$) Step 4
  lectMDP$+lettres$(selectcharacter(Mid(r_lectMDP$,i,4),#NombreDeCaracteres))     ;On décrypte 'r_lectMDP$' pour créer 'lectMDP$'
Next 

r_lenMDP$=ReadString(1)                              ;On remplit r_lenMDP$ avec la seconde ligne du fichier

For i = 1 To Len(r_lenMDP$) Step 4
  lenMDP$+lettres$(selectcharacter(Mid(r_lenMDP$,i,4),#NombreDeCaracteres))      ;On décrypte 'r_lenMDP$' pour créer 'lenMDP$'
Next 

lectMDP=Val(lectMDP$)       ;On transforme les strings en valeurs numériques
lenMDP=Val(lenMDP$)
lectMDP$ = ""
lenMDP$ = ""


        
;Dim readed$(100)

;-Décryptage 

x = 0
MDP$ = ""
While Not Eof(1)          ;On lance une boucle qui continue tant que la fin du fichier n'a pas été atteinte
  x+1
  
  readed$=ReadString(1)
  For y = 1 To Len(readed$) Step 4
    readComb$=Mid(readed$,y,4)
    decrypted$+lettres$(selectcharacter(readComb$,#NombreDeCaracteres)) 
  Next 
  decrypt$(x)=decrypted$
  decrypted$=""

If lectMDP=x 
  MDP$=Right(decrypt$(x),lenMDP)
  decrypt$(x)=RSet(decrypt$(x),Len(decrypt$(x))-lenMDP) 
EndIf  
  
Wend   

formerLine = x                                                      ;on initialise la 'formerLine' avec le nombre de lignes (x) pour ne pas le perdre.
CloseFile(1)

;-demande ( ou pas ) du mot de passe

If lectMDP<>0 And Not lectMDP=x+1
  MDP:
  PasswordOption$ = "Désactiver"
  
  OpenWindow(2,0,0,400,100,"Crypton - Lecture",#PB_Window_WindowCentered|#PB_Window_SystemMenu,WindowID(1))
  DisableWindow(1,1)
  TextGadget(7,20,10,360,15,"Un mot de passe est requis pour ouvrir ce fichier.",#PB_Text_Center)
  StringGadget(8,100,35,200,20,"")
  ButtonGadget(9,140,65,55,30,"OK")
  ButtonGadget(10,205,65,55,30,"Annuler")
  OpenWindowedScreen(WindowID(2),0,0,1,1)
  SetActiveGadget(8)
  
  Repeat 
    ExamineKeyboard()
    WindowEvent = WindowEvent()
    If WindowEvent = #PB_Event_Gadget
      If EventGadget() = 9
        EnterMDP = 1
      ElseIf EventGadget() = 10
       EnterMDP = 2
      EndIf 
    ElseIf WindowEvent = #PB_Event_CloseWindow    
      EnterMDP = 2 
    EndIf 
    If KeyboardReleased(#PB_Key_Return)
      EnterMDP = 1
    EndIf  
    If KeyboardReleased(#PB_Key_Escape)
      EnterMDP = 2  
    EndIf   
      Delay(5)
      
    Until EnterMDP > 0
    WindowEvent = 0
  DisableWindow(1,0)

  InputRequester$ = GetGadgetText(8)
  CloseWindow(2)
  If EnterMDP = 2 
    EnterMDP = 0
    Goto menu
  EndIf   
  EnterMDP = 0
  
        
 ; InputRequester$ = InputRequester("Mot de passe requis","Un mot de passe est requis pour ouvrir ce fichier ","")
  
  If InputRequester$=MDP$
    open=1

  EndIf 
ElseIf lectMDP=x+1
 PasswordOption$ = "Activer"
  open=1
ElseIf lectMDP = 0
  MessageRequester("Crypton - Erreur","Une erreur est survenue"+Chr(13)+"Il semblerai qu'une tentative de modification manuelle d'un fichier crypté ait corrompu celui-ci"+Chr(13)+"Veuillez contacter le support technique")
End   
EndIf   
  
;-affichage

EndIf 

If open=1    
  
  
  If (Config\EnableBackup = 2 Or Config\EnableBackup = 3) And Not GetPathPart(file$) = Config\BackupFolder And Not (fileType$ = "text" And Config\BackupTxt = 0 )
  If fileType$ = "text"
    BackupFileExtension$ = ".txt"
  Else 
    BackupFileExtension$ = ".crypt"
  EndIf   
  BackupFile$ = Config\BackupFolder+GetFilePart(file$,#PB_FileSystem_NoExtension)+" - "+FormatDate("%dd-%mm-%yyyy %hhh%ii",Date())+" (Open)"+BackupFileExtension$
  ReadFile(0,file$)
  CreateFile(1,BackupFile$)
  While Not Eof(0)
    WriteStringN(1,ReadString(0))
  Wend   
  
  CloseFile(0)
  CloseFile(1)
  
EndIf  
  
  initEditor(0,fileType$)
  
  For z = 1 To x
    AddGadgetItem(7,-1,decrypt$(z))
  Next 
  
  ;- Boucle de gestion de l'éditeur de texte
  edition:
  Repeat
    WindowEvent = WindowEvent()
    If WindowEvent = #PB_Event_CloseWindow
         
      If modif = 1
        Select  MessageRequester("Fichier non-enregistré","Ce fichier n'a pas été enregistré"+Chr(13)+"Voulez-vous le faire maintenant ?",#PB_MessageRequester_YesNoCancel) 
          Case #PB_MessageRequester_Yes
            save = 1
            quit = 1
          Case #PB_MessageRequester_No
            End   
        EndSelect 
      Else
        End 
      EndIf   
    ElseIf WindowEvent = #PB_Event_Gadget
     If EventGadget() = 9
        save = 1
        quit = 1
      EndIf 
    ElseIf WindowEvent = #PB_Event_Menu
      Select EventMenu()
        Case 1 
          save = 1
        Case 2
          save = 2
        Case 3
          If ChangeFileAction$ = "Enregistrer au format .txt"
            save = 3
          ElseIf ChangeFileAction$ = "Crypter"
              save = 1
              fileType$ = "crypt"
          EndIf     
        Case 4 
          If InputRequester("Crypton - Edition","Entrez le mot de passe actuel","") = MDP$
            MDP$ = InputRequester("Crypton - Edition","Entrez le nouveau mot de passe","")
          Else 
            MessageRequester("Crypton - Edition","Mot de passe incorrect")
          EndIf 
        Case 5 
          If PasswordOption$="Activer"
          newMDP$ = InputRequester("Crypton - Edition","Indiquez le mot de passe","")
          If Not newMDP$ = ""
            MDP$ = newMDP$
            lectMDP = 1
            PasswordOption$ = "Désactiver"
         EndIf   
      ElseIf PasswordOption$="Désactiver"
        If InputRequester("Crypton - Edition","Entrez le mot de passe actuel","") = MDP$
            lectMDP = x+1
            PasswordOption$ = "Activer"
          EndIf   
        EndIf 
      Case 6
        End 
      EndSelect 
    EndIf   
    
    If GetGadgetState(8) = #PB_Checkbox_Checked
      modif = 1
      modifAct = 1
      SetGadgetAttribute(7,#PB_Editor_ReadOnly,0)
    ElseIf GetGadgetState(8) = #PB_Checkbox_Unchecked
      modifAct = 0
      SetGadgetAttribute(7,#PB_Editor_ReadOnly,1)
    EndIf   
      
    Delay(5)
  Until save > 0
  
  ;save = 1 :::: on enregistre simplement les modifications
  ;save = 2 :::: on enregistre sous un autre nom
  ;save = 3 :::: on enregistre en .txt 
   
Else 
  MessageRequester("Mot de passe","Le mot de passe est incorrect.")
  Goto MDP
  open=0
EndIf   

;- Enregistrement du fichier
Select save
  Case 1, 2
    
  ;  If save = 2
  ;    file$=SaveFileRequester("Crypton - Ecriture",Config\DefaultPath,"Fichier cryptés|*.crypt|Fichiers Texte|*.txt",0)
  ;    If file$ = ""
  ;      End   
  ;    EndIf
  ;    If SelectedFilePattern() = 1
  ;      fileType$="text"  
  ;    EndIf   
  ;  EndIf 
    
    If save = 2   
      file$ = SaveFileRequester("Crypton - Écriture",Config\DefaultPath,"Fichier cryptés|*.crypt|Fichiers Texte|*.txt|Tous les fichiers|*.*",0)
      If file$ = ""
        file$ = Basefile$
        BasePattern = 0
        Goto edition 
      EndIf   
        If SelectedFilePattern() = 0 
          fileType$ = "crypt"
        ElseIf SelectedFilePattern() = 1
          fileType$ = "text"
        EndIf 
        If Not BasefileType$ = fileType$
          If MessageRequester("Crypton - Écriture","Le nouveau fichier aura un format différent du fichier d'origine. Voulez-vous continuer ?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_No
           file$ = Basefile$
           BasePattern = 0
           Goto edition  
         EndIf 
        EndIf  
          
    
  EndIf 
    
  If fileType$ = "text"
    If BasefileType$ = "crypt" And Right(file$,6) = ".crypt"
      file$ = LSet(file$,Len(file$) - 6)      
    EndIf   
     If Not Right(file$,4) = ".txt"
       file$ + ".txt"
      EndIf
    Else
      If BasefileType$ = "text" And Right(file$,4) = ".txt"
        file$ = LSet(file$,Len(file$) - 4)      
      EndIf   
      If Not Right(file$,6) = ".crypt"
        file$ + ".crypt"
      EndIf
    EndIf 
    
   
    
    
CreateFile(1,file$)

line=CountGadgetItems(7)

For y = 1 To line
  lignes$(y)=GetGadgetItemText(7,y-1)                                        ;On remplit le tableau lignes$() avec celles de l'EditorGadget
  Delay(1)
Next 


If Not fileType$="text"
  BadCharactersNb = 0
  BadCharacters$ = ""
For x = 1 To line                                            ;On lance une boucle avec 'line' itérations
  For y = 1 To Len(lignes$(x))                               ;On lance une boucle avec autant d'itérations que le nombre de caractères de lignes$(x)
    CharIsOk = 0                                             ;On met 'CharIsOk' à 1 à chaque itération de la seconde boucle
    TestingChar$ = Mid(lignes$(x),y,1)                       ;On remplit la variable 'TestingChar' avec un caractère : les deux boulces feront que tous les caractères du texte y passeront
    For z = 0 To #NombreDeCaracteres                         ;On lance une troisième boucle avec autant d'itérations qu'il y a de caractères reconnus
      If TestingChar$ = lettres$(z)                          ;On teste si 'TesingCahr$' est égal à un caractère reconnu
        CharIsOk = 1                                        ;Si oui, on passe 'CharIsOk' à 1
      EndIf                           
    Next 
    If CharIsOk = 0                                          ;On teste si CharIsOk est toujours à 0, donc si 'testingChar$' ne correspond à aucun caractère reconnu
      BadCharacters$ + TestingChar$                          ;Si c'est la cas, on ajoute 'TestingChar$' aux caractères non-reconnus
    EndIf   
  Next
Next

If Not BadCharacters$ = ""
  BadCharactersNb = Len(BadCharacters$)
  If BadCharactersNb > 1
    For x = 1 To BadCharactersNb - 1
      BadCharacters$ = InsertString(BadCharacters$,";",x*2)
    Next 
  EndIf  
  BadCharsErrorMessage$ = "Le texte contient des caractères non-reconnus par Crypton"+Chr(13)
  BadCharsErrorMessage$ + "Le fichier sera correctement enregitré, mais les caractères"+Chr(13)
  BadCharsErrorMessage$ + "suivants n'y figureront pas : "
  BadCharsErrorMessage$ + BadCharacters$
  BadCharsErrorMessage$ + "Voulez-vous continuer ?"
  
  If MessageRequester( "Crypton - Ecriture",BadCharsErrorMessage$,#PB_MessageRequester_YesNo) = #PB_MessageRequester_No
    Goto edition
  EndIf   
EndIf   
EndIf 


For y = 1 To line
  TotalIt+Len(lignes$(y))
Next   
  
OpenWindow(3,0,0,400,100,"Crypton - Ecriture",#PB_Window_WindowCentered|#PB_Window_Tool)
ProgressBarGadget(17,5,25,390,50,0,TotalIt,#PB_ProgressBar_Smooth)
SetGadgetColor(17,#PB_Gadget_FrontColor,RGB(0,0,255))

If fileType$ = "text"
  For y = 1 To line
  WriteString(1,lignes$(y)+Chr(13)+Chr(10))
  progress + Len(lignes$(y))
  SetGadgetState(17,progress)
  Delay(100)
Next
Else
  
  If PasswordOption$ = "Désactiver" 
    SaveWithMDP = 1
  ElseIf PasswordOption$ = "Activer" 
    SaveWithMDP = 0
  EndIf   
  
If BasefileType$ = "text" Or (save = 2 And Config\AlwaysAskForPassword = 1)
  If MessageRequester("Crypton - Ecriture","Voulez protéger le fichier avec un mot de passe ?"+Chr(10)+"Ce mot de passe sera nécessaire pour ouvrir le fichier",#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes      ;On demande si on veut un mot de passe sur le ficher. Si oui : 
    MDP$ = InputRequester("Crypton - Ecriture","Indiquez le mot de passe","")                                                                                                                                               ;on demande le MDP
    SaveWithMDP = 1
  Else 
    SaveWithMDP = 0 
  EndIf
EndIf     
    
    
If  SaveWithMDP = 1
    lectMDP = Random(line,1)
CryptLine(1,Str(lectMDP))
Cryptline(1,Str(Len(MDP$)))
ElseIf SaveWithMDP = 0
CryptLine(1,Str(line+1))
Cryptline(1,Str(Len(MDP$)))
EndIf 

   

For x = 1 To line
  If x = lectMDP
    CryptLine(1,lignes$(x)+MDP$)
    Continue 
  EndIf
  cryptline(1,lignes$(x))
Next   
EndIf 

CloseFile(1)

If (Config\EnableBackup = 1 Or Config\EnableBackup = 3) And Not GetPathPart(file$) = Config\BackupFolder And Not (fileType$ = "text" And Config\BackupTxt = 0 )
  If fileType$ = "text"
    BackupFileExtension$ = ".txt"
  Else 
    BackupFileExtension$ = ".crypt"
  EndIf   
  BackupFile$ = Config\BackupFolder+GetFilePart(file$,#PB_FileSystem_NoExtension)+" - "+FormatDate("%dd-%mm-%yyyy %hhh%ii",Date())+BackupFileExtension$
  ReadFile(0,file$)
  CreateFile(1,BackupFile$)
  While Not Eof(0)
    WriteStringN(1,ReadString(0))
  Wend   
  
  CloseFile(0)
  CloseFile(1)
  
EndIf 


Case 3
  
  If Right(file$,4) = ".txt"
    file$ = RSet(file$,Len(file$)-4)
  ElseIf Right(file$,6) = ".crypt"
     file$ = RSet(file$,Len(file$)-6)
  EndIf 
  
  CreateFile(1,file$+".txt")
  line=CountGadgetItems(7)
  
  For x = 1 To line
  lignes$(x)=GetGadgetItemText(7,x-1)                                        ;On remplit le tableau lignes$() avec celles de l'EditorGadget
  Delay(1)
Next 

For x = 1 To line
  TotalIt+Len(lignes$(x))
Next   
  
OpenWindow(3,0,0,400,100,"Crypton - Ecriture",#PB_Window_WindowCentered|#PB_Window_Tool)
ProgressBarGadget(17,5,25,390,50,0,TotalIt,#PB_ProgressBar_Smooth)
SetGadgetColor(17,#PB_Gadget_FrontColor,RGB(0,0,255))

For x = 1 To line
  WriteString(1,lignes$(x)+Chr(13)+Chr(10))
  progress + Len(lignes$(x))
  SetGadgetState(17,progress)
  Delay(100)
Next 

EndSelect  

If quit = 0
  save = 0
  SaveWithMDP = 0
  fileType$ = ""
  line = 0
  file$ = Basefile$
  BadCharacters$ = ""
  BadCharactersNb = 0
  BadCharsErrorMessage$ = ""
  TotalIt = 0
  progress = 0
  BasePattern = 0
  fileType$ = BasefileType$
  If IsWindow(3)
    CloseWindow(3)
   EndIf  
  Goto edition
EndIf 
; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 189
; FirstLine = 155
; EnableXP