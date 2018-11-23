; Procedure drawIntro(time.f, splashText.s)  ;La procédure qui gère l'intro
;   t.s
;   
;   color = RGB(255,30,30)
;   LoadFont(0,"Velvenda Cooler",50)
;   
;   
;   Repeat
;     ClearScreen(0)
;     red_Circle_One + speed  
;     
;     If red_Circle_One > 12
;      red_Circle_Two + speed
;    EndIf 
;    
;    If red_Circle_Two > 12
;      red_Circle_three + speed
;    EndIf   
;    
;    If red_Circle_three > 15
;      red_Circle_four + speed
;    EndIf   
;      
;    If red_Circle_four > 40 
;      red_Circle_five + speed
;    EndIf
;    
;    If red_Circle_five > 400
;      Text=1
;      alpha+speed
;    EndIf
;     
;    If text = 1
;      timetext+speed+1
;      text$="C"
;    EndIf 
;    
;    
;    If timetext > 50
;      text$="Cr"
;    EndIf
;    
;    If timetext > 100
;      text$="Cry"
;    EndIf   
;    
;    If timetext > 150
;      text$="Cryp"
;    EndIf 
;    
;    If timetext > 200
;      text$="Crypt"
;    EndIf 
;    
;    If timetext > 250
;      text$="Crypto"
;    EndIf 
;    
;    If timetext > 300
;      text$="Crypton"
;    EndIf   
;            
;     StartDrawing(ScreenOutput())
;     DrawingMode(#PB_2DDrawing_Outlined )
;        
;     Circle(400,300,red_Circle_One,RGB(255,0,0))
;     Circle(400,300,red_Circle_Two,RGB(255,0,0))
;     Circle(400,300,red_Circle_three,RGB(255,0,0))
;     
;     DrawingMode(#PB_2DDrawing_Default)
;     
;     Circle(400,300,red_Circle_four,RGB(255,0,0))
;     Circle(400,300,red_Circle_five,RGB(40,0,0))
;     
;     DrawingMode(#PB_2DDrawing_Transparent)
;     DrawingFont(FontID(0))
;     If Text=1
;       DrawText(300,265,Text$,color)
;     EndIf   
;     If timetext>1 And timetext<15
;       Box(300,0,40,600,RGB(255,0,0))
;     EndIf   
;     If timetext>50 And timetext <65
;       Box(325,0,40,700,RGB(255,0,0))
;     EndIf
;     If timetext>100 And timetext < 115
;       Box(350,0,40,700,RGB(255,0,0))
;     EndIf
;     If timetext>150 And timetext < 165
;       Box(375,0,40,700,RGB(255,0,0))
;     EndIf
;     If timetext>200 And timetext < 215
;       Box(405,0,40,700,RGB(255,0,0))
;     EndIf
;     If timetext>250 And timetext < 265
;       Box(430,0,40,700,RGB(255,0,0))
;     EndIf
;     If timetext>300 And timetext < 315
;       Box(460,0,40,700,RGB(255,0,0))
;     EndIf   
;     
;     StopDrawing()
;     
;     LoadFont(2,"Arial",10)
;     
;    StartDrawing(ScreenOutput()) 
;     DrawingMode(#PB_2DDrawing_Transparent)
;     DrawText(50,500,"Crypton ©" + SelectedSplash$)    
;    StopDrawing()
;     
;     FlipBuffers()
;        
;     If red_Circle_One > 1200
;       quit=1
;     EndIf
;     
;   Until quit=1
; EndProcedure  


Procedure drawIntro(time.f, splashText.s)  ;La procédure qui gère l'intro
  
  color = RGB(255,30,30)
  LoadFont(0,"Velvenda Cooler",50)
  
  StartDrawing(ScreenOutput())
  DrawingMode(#PB_2DDrawing_Outlined)
  
  w = ScreenWidth(): h = ScreenHeight
  x = w / 2 : y = h / 2
  
  If time < ScreenWidth() 
    Circle(x, y, time, color)
  EndIf   
  
EndProcedure  

Procedure Intro(speed.f)
  startTime.q = ElapsedMilliseconds()
  Repeat 
    time = (ElapsedMilliseconds() - startTime) * speed / 1000
  WindowEvent()  
  ForEver  
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 142
; FirstLine = 103
; Folding = -
; EnableUnicode
; EnableXP