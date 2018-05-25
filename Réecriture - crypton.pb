
;-Ouverture du fichier crypt

file$=OpenFileRequester("Choisissez le fichier a lire","","fichiers cryptés|*.crypt",1)



OpenFile(1,file$)

If Not IsFile(1)
  End 
EndIf   


;-lecture du fichier crypt

r_lectMDP$=ReadString(1)

For i = 1 To Len(r_lectMDP$) Step 4
  lectMDP$+lettres$(selectcharacter(Mid(r_lectMDP$,i,4),#NombreDeCaracteres))
Next 

r_lenMDP$=ReadString(1)

For i = 1 To Len(r_lenMDP$) Step 4
  lenMDP$+lettres$(selectcharacter(Mid(r_lenMDP$,i,4),#NombreDeCaracteres))
Next 


lectMDP=Val(lectMDP$)
lenMDP=Val(lenMDP$)



Dim decrypt$(100)
;Dim readed$(100)


;-Décryptage

While Not Eof(1)
  
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
  
;-demande ( ou pas ) du mot de passe

If lectMDP<>0
  MDPR:
  If InputRequester("Mot de passe requis","Un mot de passe est requis pour ouvrir ce fichier ","")=MDP$
    open=1
  EndIf 
ElseIf lectMDP=x+1
  open=1
ElseIf lectMDP = 0
  MessageRequester("Crypton - Erreur","Une erreur est survenue"+Chr(13)+"Il semblerai qu'une tentative de modification manuelle d'un fichier crypté ait corrompu celui-ci"+Chr(13)+"Veuillez contacter le support technique")
End   
EndIf   
  
;-affichage

If open=1
  
txtName$=InputRequester("Création du fichier texte","Veuillez indiquer le nom du fichier texte ","")
  If Not Right(txtName$,4)=".txt"
    txtName$+".txt"
  EndIf 
  
  
  
  
  
  CreateFile(0,PathRequester("Choisissez l'emplacement","")+txtName$)
  
  
  For lign=1 To x
    WriteStringN(0,decrypt$(lign))
  Next 
  
  CloseFile(0)
  
  
  
   

Else 
  MessageRequester("Mot de passe","le mot de passe est incorrect .")
  Goto MDPR
  open=0
EndIf   




; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 77
; FirstLine = 45
; EnableXP