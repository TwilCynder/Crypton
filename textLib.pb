XIncludeFile "cryptLib.pbi"

Procedure CryptLine(fileID,line.s)     ;La procédure qui crypte une chaîne de caractère (une ligne) et qui l'écrit dans le fichier
  cLine.s
  
  For i = 1 To Len(line)
    cLine+Str(Random(9))+SelectCombinaison(Mid(line,i,1))
  Next
   
  WriteStringN(fileID,line)
EndProcedure

Procedure.s decryptString(str.s)
  Define result.s
  For i = 1 To Len(str) Step 4
    result.s + DecryptComb(Mid(str, x,4))
  Next
  ProcedureReturn result
EndProcedure 

Procedure ReadText(fileID.q, *text.Text)
  
  If Not *text 
    *text.Text = AllocateMemory(SizeOf(Text))
    InitializeStructure(*text, Text)
  EndIf    
  
  While Not Eof(FileID)
    AddElement(*text\lines())
    *text\lines() = ReadString(FileID)
  Wend
  ProcedureReturn *text 
EndProcedure

Procedure decryptText(*text.Text, *password.String)
  If Not *text
    ProcedureReturn #CPT_LoadFile_FileError 
  EndIf
  
  If *password
    Define passwordLine.l, passwordLen.l, cLine.l
  EndIf 
  
  FirstElement(*text\lines())
  If *password 
    passwordLine = Val(*text\lines()) : DeleteElement(*text\lines())
    passwordLen = Val(*text\lines()) : DeleteElement(*text\lines())
    If passwordLine < 0 Or passwordLine > ListSize(*text\lines())
      ProcedureReturn #CPT_Loadfile_CorruptFile
    EndIf   
  EndIf
  
  ForEach *text\lines()
    *text\lines() = decryptString(*text\lines())
    If *password
      If cLine = passwordLine
        *password\s = Right(*text\lines(), passwordLen)
        *text\lines() = RSet(*text\lines(),Len(*text\lines()) - passwordLen) 
      EndIf   
      cLine + 1
    EndIf   
  Next
  ProcedureReturn *text
EndProcedure

; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 9
; Folding = -
; EnableUnicode
; EnableXP