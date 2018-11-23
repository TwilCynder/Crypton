CompilerIf #PB_Compiler_IsIncludeFile
  
XIncludeFile "characterConversion.pb"
  
Procedure SelectCombinaison(char.s)
  
  comb.b = letters(char)\comb[Random(2)]
  
  If comb = 0
    DeleteMapElement(letters(),char)
    ProcedureReturn  0
  EndIf     
  
  ProcedureReturn comb
  
EndProcedure

Procedure.s CryptChar(char.s)
  comb.s = Str(SelectCombinaison(char))
  comb = Str(Random(9)) + comb
EndProcedure  

Procedure.s SelectCharacter(comb.b)
  ForEach letters()
    For i = 0 To 2
      If comb = letters()\comb[i]
        ProcedureReturn MapKey(letters())    
      EndIf    
    Next   
  Next  
  ProcedureReturn ""
EndProcedure

Procedure.s DecryptComb(comb.s)    ;La procédure qui convertit une combinaison (incluant le chiffre random) en caractère
  
  comb = Mid(comb, 2, 3)
  
ProcedureReturn SelectCharacter(Val(comb))
EndProcedure 

CompilerEndIf
; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 2
; Folding = -
; EnableUnicode
; EnableXP