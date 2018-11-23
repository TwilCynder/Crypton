XIncludeFile "passwordRequester.pb"

Declare editor_closeCallback()
Declare loadFileEditor(*editor.editor, fileName.s)
Procedure openEditor(file.s = "", *mother.opWin = 0)
  e.editor
  Shared editors()
  If *mother And IsWindow(*mother\id)
    e\win\id = OpenWindow(#PB_Any, 0, 0, 800, 800, "Crypton Editor", #PB_Window_WindowCentered | #PB_Window_SizeGadget, WindowID(*mother\id))
  Else 
    e\win\id = OpenWindow(#PB_Any, 0, 0, 800, 800, "Crypton Editor", #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  EndIf 
  
  e\g\editor = EditorGadget(#PB_Any, 5, 5, 790, 750, #PB_Editor_WordWrap)
  e\g\readOnlyToggle = CheckBoxGadget(#PB_Any, 5, 770, 60, 20, "Read only")
  e\g\saveButton = ButtonGadget(#PB_Any, 600, 760, 100, 30, "SAVE")
  
  If CreateToolBar(#PB_Any  , WindowID(e\win\id))
      ToolBarStandardButton(0, #PB_ToolBarIcon_New)
      ToolBarStandardButton(1, #PB_ToolBarIcon_Open)
      ToolBarStandardButton(2, #PB_ToolBarIcon_Save)
  EndIf

  
  BindEvent(#PB_Event_CloseWindow, @editor_closeCallback(), e\win\id)
  
  AddElement(editors()) : editors() = e
  SetWindowData(e\win\id, @editors())
  
  If file
    loadFileEditor(@editor, file)
  EndIf  
  
  ProcedureReturn @editors()
  
EndProcedure

Procedure editor_closeCallback()
  Shared editors()
  window = EventWindow()
  ChangeCurrentElement(editors(), GetWindowData(window))
  DeleteElement(editors(), 1)
  CloseWindow(window)
  checkWindows()
EndProcedure

Procedure setEditorText(*editor.editor, *text.Text)
  ClearGadgetItems(*editor\g\editor)
  
  ForEach *text\lines()
    AddGadgetItem(*editor\g\editor, -1, *text\lines())
  Next  
EndProcedure

Procedure loadFileEditor(*editor.editor, fileName.s)
  Define text.Text, fileType.b, password.s, passwordLine.l, passwordLen.l, passwordPrompt.s
  fileID.q = ReadFile(#PB_Any, fileName)
  If Not FileID
    ProcedureReturn #CPT_LoadFile_FileError
  EndIf
  
  Select GetExtensionPart(fileName)
    Case ".txt"
      fileType = #CPT_FileType_Text
    Case ".crypt"
      fileType = #CPT_FileType_Crypt
  EndSelect    
  
  ReadText(FileID,@text)
  
  If fileType
    decryptText(@text, @password)
    If password
      passwordPrompt = passwordRequester(*editor\win\id)
      If passwordPrompt
        If Not passwordPrompt = password
          ProcedureReturn #CPT_LoadFile_WrongPassword
        EndIf   
      Else
        ProcedureReturn #CPT_Loadfile_Canceled
      EndIf  
    EndIf   
  EndIf 
    
  setEditorText(*editor, @text)
  
  *editor\fileType = fileType
  *editor\currentFile = fileName
  *editor\lastFileOpened = fileName
  
  ProcedureReturn #CPT_LoadFile_Success
    
EndProcedure

Procedure getEditorText(*editor.editor, *text.Text = 0)
  If Not *text 
    *text.Text = AllocateMemory(SizeOf(Text))
    InitializeStructure(*text, Text)
  EndIf 
  
  For i = 0 To CountGadgetItems(*editor\g\editor) - 1
    AddElement(*text\lines())
    *text\lines() = GetGadgetItemText(*editor\g\editor, i)
  Next   
  
EndProcedure

Procedure saveEditorText(*editor, fileName.s, crypt.b, password.s)
  *text.Text = getEditorText(*editor)
  Define passwordLine.l, passwordLen.l, textLen.l = ListSize(*text\lines())
  
  fileID.q = CreateFile(#PB_Any, fileName)
  
  If crypt
    If password
      passwordLine = Random(textLen - 1)
      passwordLen = Len(password)
    Else 
      passwordLine = textLen
      passwordLen = Random(99)
    EndIf 
    
    CryptLine(fileID, Str(passwordLine))
    CryptLine(fileID, Str(passwordLen))
    ForEach *text\lines()
      CryptLine(fileID, *text\lines())
    Next
  EndIf   
  
EndProcedure

; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 17
; Folding = --
; EnableUnicode
; EnableXP