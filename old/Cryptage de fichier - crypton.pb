

;-Ouverutre du fichier txt

OpenFile(2,OpenFileRequester("Choisissez le fichier texte a crypter ",Config\DefaultPath,"Fichiers Texte .txt|*.txt",1))

If Not IsFile(2)
  End
EndIf   


;-lecture du fichier txt

While Not Eof(2)
  line+1
 
  
    lignes$(line)=ReadString(2)
    
  Wend 
  
  
  ;-parametres du fichier crypt ( nom , dossier ,...)
  
  

filename$=PathRequester("Choisissez l'emplacement du fichier",Config\DefaultPath)

filename$+InputRequester("Crypton - Réécriture","Indiquez le nom du nouveau fichier crypté","")
If Not Right(filename$,6)=".crypt"
  filename$+".crypt"
EndIf 


;-Création ( ou pas ) du mot de passe

If MessageRequester("Crypton","Voulez-vous protéger ce fichier à l'aide d'un mot de passe ?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
  UseMDP=1
  LineMDP=Random(line,1)
   

Password$=InputRequester("Crypton","Indiquez le mot de passe","")
  
EndIf

PrintN("Creation du fichier en cours...")

;-Cryptage et création du fichier crypt

CreateFile(1,filename$)
If IsFile(1)=0
  MessageRequester("erreur","une erreur est survenue au niveau du fichier")
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
ProgressBarGadget(7,5,25,390,50,0,TotalIt,#PB_ProgressBar_Smooth)
SetGadgetColor(7,#PB_Gadget_FrontColor,RGB(0,0,255))

  
  
For i = 1 To line
  If Not lignes$(i) = "stop"
    
    If UseMDP=1 And i = LineMDP
      cryptline(1,lignes$(i)+Password$)
      Continue 
    EndIf   
      
    CryptLine(1,lignes$(i))
      
      
      
  EndIf   
Next


CloseWindow(3)


;PrintN("Debug")
;PrintN("")

;For deb = 1 To debug_
;  PrintN(debuglettre$(deb)+"   "+Str(debugconb(deb)))
;  
;Next 
  
  
 

; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 101
; FirstLine = 64
; EnableXP