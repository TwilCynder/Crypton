;- Ouverture de la fenêtre 
OpenWindow(2,0,0,800,600,"Crypton - Ecriture",#PB_Window_WindowCentered | #PB_Window_SystemMenu,WindowID(1))                 ;ouverture de la fenêtre. Celle-ci dépendra de la fenètre pricipale (le menu)
  EditorGadget(5,5,5,790,525,#PB_Editor_WordWrap)                                                    ;Création d'un EditorGadget, c'est à dire un gadget permettant d'entrer beaucoup de texte
  SetGadgetFont(5,FontID(3))
  SetGadgetColor(5,#PB_Gadget_FrontColor,Config\FontColor)
  ButtonGadget(6,740,535,55,40,"VALIDER")                                                            ;Création d'un bouton cliquable avec marqué "VALIDER"         
  CreateMenu(0,WindowID(2))
  MenuTitle("Fichier")
  MenuItem(1,"Enregistrer"+Chr(9)+"Ctrl+S")
  MenuItem(2,"Enregistrer en .txt"+Chr(9)+"Ctrl+Alt+S")
  MenuItem(3,"Quitter")
  
  
  AddKeyboardShortcut(2,#PB_Shortcut_Control | #PB_Shortcut_S,1)
  AddKeyboardShortcut(2,#PB_Shortcut_Control | #PB_Shortcut_Alt |#PB_Shortcut_S,2)
  
edit:  

;- Boucle de gestion de l'édition

Repeat
  Event = WindowEvent()
  If Event=#PB_Event_CloseWindow                              ;Teste si l'énènement en tête de liste est un Close Window, en gros si on a cliqué sur la croix
    CloseWindow(2)
    End 
    Goto menu                                                         ;Dans ce cas, on retourne au label "menu:", juste avant le menu
  ElseIf (Event=#PB_Event_Gadget And EventGadget()=6) Or (Event = #PB_Event_Menu And EventMenu() = 1)       ;Teste si il y a un event de type Gadget ET qu'il est déclenché par le gadget 6, en gros si on a cliqué sur le bouton
    Break                                                                ;Dans ce cas, on quite la boucle
  ElseIf Event = #PB_Event_Menu And EventMenu() = 2
    filename$=SaveFileRequester("Crypton - Écriture",Config\DefaultPath,"Fichiers texte brut .txt | *.txt",0)
    If Not Right(filename$,4) = ".txt"
      If  MessageRequester("Crypton - Écriture","Le nom du fichier ne possédant pas l'extension .txt, elle sera rajoutée automatiquement."+Chr(13)+"Voulez-vous continuer ?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
       filename$+".txt"
      Else 
        Goto edit
      EndIf
    EndIf   
    line = CountGadgetItems(5)                                            ;La variable line sera égale au nombre de lignes de l'EditorGadget
    CreateFile(0,filename$)
    For x = 0 To line-1
      WriteStringN(0,GetGadgetItemText(5,x))
      Delay(1)
    Next  
    CloseFile(0)
    filename$ = ""
  ElseIf EventMenu() = 3 
    End 
  EndIf  
  
  Delay(10)                                                           ;Pour donner du temps au processeur et ne pas faire crasher l'ordi
ForEver  

;- Paramétrage 
line = CountGadgetItems(5)                                            ;La variable line sera égale au nombre de lignes de l'EditorGadget

For x = 1 To line
  lignes$(x)=GetGadgetItemText(5,x-1)                                 ;On remplit le tableau lignes$() avec celles de l'EditorGadget
  Delay(1)
Next  

For x = 1 To line                                            ;On lance une boucle avec 'line' itérations
  For y = 1 To Len(lignes$(x))                               ;On lance une boucle avec autant d'itérations que le nombre de caractères de lignes$(x)
    CharIsOk = 0                                             ;On met 'CharIsOk' à 0 à chaque itération de la seconde boucle
    TestingChar$ = Mid(lignes$(x),y,1)                       ;On remplit la variable 'TestingChar' avec un caractère : les deux boulces feront que tous les caractères du texte y passeront
    For z = 1 To #NombreDeCaracteres                         ;On lance une troisième boucle avec autant d'itérations qu'il y a de caractères reconnus
      If TestingChar$ = lettres$(z)                          ;On teste si 'TesingCahr$' est égale à un caractère reconnu
        CharIsOk = 1                                         ;Si oui, on passe 'CharIsOk' à 1
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
    Goto edit
  EndIf   
EndIf   
  

filename$ = SaveFileRequester("Crypton - Ecriture",Config\DefaultPath,"Fichiers cryptés|*.crypt|Tous les fichiers|*.*",0)     ;On demande où le fichier sera enregistré avec un SaveFileRequester
If filename$ = ""                                                                  ;Si le SFR a revoyé un string vide (=le SFR a été fermé)
  Goto edit                                                                        ;on revient au label "edit:".
EndIf
  
If Not Right(filename$,6) = ".crypt"                                               ;Si le nom du fichier n'a pas l'extension .crypt
  filename$+".crypt"                                                               ;on l'ajoute
EndIf 

If MessageRequester("Crypton - Ecriture","Voulez protéger ce fichier avec un mot de passe ?"+Chr(10)+"Ce mot de passe sera nécessaire pour ouvrir le fichier",#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes      ;On demande si on veut un mot de passe sur le ficher. Si oui :
  UseMDP = 1                                                                              ;on met UseMDP à 1 (variable témoin pour l'utilisation d'un mot de passe)   
  LineMDP = Random(line,1)                                                                ;LineMDP (la ligne à laquelle sera caché le MDP) est choisie au hasard
  Password$ = InputRequester("Crypton - Ecriture","Indiquez le mot de passe","")          ;on demande le MDP
EndIf


;- Ecriture

CreateFile(0,filename$)
If IsFile(0) = 0
  MessageRequester("Crypton - Ecriture","Erreur !"+Chr(10)+"Un problème est survenu au niveau du fichier")
  Goto menu
EndIf 

If Not LineMDP=0
CryptLine(0,Str(LineMDP))
Cryptline(0,Str(Len(Password$)))
ElseIf LineMDP = 0
CryptLine(0,Str(line+1))
Cryptline(0,Str(Len(Password$)))
EndIf 

For x = 1 To line
  TotalIt+Len(lignes$(x))
Next   
  
OpenWindow(3,0,0,400,100,"Crypton - Ecriture",#PB_Window_WindowCentered|#PB_Window_Tool)
ProgressBarGadget(17,5,25,390,50,0,TotalIt,#PB_ProgressBar_Smooth)
SetGadgetColor(17,#PB_Gadget_FrontColor,RGB(0,0,255))


For x = 1 To line
  If x = LineMDP
    CryptLine(0,lignes$(x)+Password$)
    Continue 
  EndIf
  cryptline(0,lignes$(x))
Next

CloseFile(0)


;- Sauvegarde automatique

If Config\EnableBackup = 1
  BackupFile$ = Config\BackupFolder+"\"+GetFilePart(filename$,#PB_FileSystem_NoExtension)+" - "+FormatDate("%dd-%mm-%yyyy %hhh%ii",Date())+".crypt"
  ReadFile(0,filename$)
  CreateFile(1,BackupFile$)
  While Not Eof(0)
    WriteStringN(1,ReadString(0))
  Wend   
  
  CloseFile(0)
  CloseFile(1)
  ;CopyFile(filename$,BackupFile$)
  
EndIf 


CloseWindow(3)
CloseWindow(2)
; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 73
; FirstLine = 44
; EnableUnicode
; EnableXP