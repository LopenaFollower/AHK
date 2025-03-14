;24
#Include ..\main.ahk
Track:
	If GetFishPos()||Seraphic{
		PixelSearch,x,,ProgBarRight,ProgBarTop,ProgBarLeft,ProgBarBottom,0xFFFFFF,0,Fast
		If !ErrorLevel
			ProgressX:=x
		Else{
			PixelSearch,x,,ProgBarRight,ProgBarTop,ProgBarLeft,ProgBarBottom,0x9F9F9F,0,Fast
			If !ErrorLevel
				ProgressX:=x
		}
		If ShowTooltips{
			Tooltip,p,%ProgressX%,%ToolTipY%,3
			BX:=GetBarPos()
			If MaxLeftToggle||MaxRightToggle{
				DR:=MaxLeftToggle?"<":">"
				Tooltip,%DR%,%BX%,%ToolTipY%,2
			}Else
				Tooltip,|,%BX%,%ToolTipY%,2
		}
	}
Return
BarMinigame:
	Sleep 700
	If AutoBlurMinigame
		Send m
	ForceReset:=False
	BarCalcFailsafeCounter:=0
	SetTimer,Failsafe2,1000
	Loop{
		Sleep 1
		UpdateTask("Current Task: Calculating Bar Size")
		If ForceReset{
			If(FarmLocation="cryo"&&A_TickCount>=StopFarmingAt)
				Gosub backUp
			Goto RestartMacro
		}
		PixelSearch,SBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,BarCalcColor,1,Fast
		If !ErrorLevel{
			SetTimer,Failsafe2,Off
			If ManualBarSize{
				WhiteBarSize:=ManualBarSize
				Break
			}
			WhiteBarSize:=FishBarRight-SBX+FishBarLeft-SBX
			If !Test1
				Test1:=WhiteBarSize
			Else If !Test2{
				If(Test1=WhiteBarSize)
					Test2:=WhiteBarSize
				Else
					Test1:=0
			}Else If(Test1=Test2)
				WhiteBarSize:=Test2
			If(WhiteBarSize>0)
				Break
		}
	}
	UpdateTask("Current Task: Bar Minigame")
	HalfBarSize:=WhiteBarSize/2
	SideDelay:=0
	AnkleBreakDelay:=0
	DirectionalToggle:=""
	MaxLeftToggle:=False
	MaxRightToggle:=False
	ProgressX:=0
	MaxLeftBar:=FishBarLeft+WhiteBarSize*SideBarRatio
	MaxRightBar:=FishBarRight-WhiteBarSize*SideBarRatio
	GetFishPos(){
		Global FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor
		PixelSearch,FishX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
		Return ErrorLevel?False:FishX
	}
	SeraphicTrackerV1(){
		Global FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor
		OX:=10
		OY:=50
		PixelSearch,FishX,,FishBarLeft-OX,FishBarTop-OY,FishBarRight+OX,FishBarBottom+OY,FishColor,3,Fast
		Return !ErrorLevel
	}
	GetBarPos(){
		Global FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,BarColor1,BarColor2,ArrowColor,HalfBarSize
		Alw:=HalfBarSize*.8
		PixelSearch,TBX,,FishBarLeft,FishBarTop,FishBarRight-Alw,FishBarBottom,BarColor1,2,Fast
		If !ErrorLevel
			Return Max(FishBarLeft,Min(FishBarRight,TBX+HalfBarSize))
		PixelSearch,AX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,ArrowColor,1,Fast
		If !ErrorLevel{
			PixelGetColor,UC,AX+25,FishBarTop+3
			If(UC=FishColor)
				PixelGetColor,UC,AX-25,FishBarTop+3
			PixelSearch,TBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,UC,5,Fast
			If !ErrorLevel
				Return Max(FishBarLeft,Min(FishBarRight,TBX+HalfBarSize))
		}
		PixelSearch,TBX,,FishBarLeft,FishBarTop,FishBarRight-Alw,FishBarBottom,BarColor2,0,Fast
		If !ErrorLevel
			Return Max(FishBarLeft,Min(FishBarRight,TBX+HalfBarSize))
	}
	Stabilize(s:=0,w:=5){
		Global StabilizerLoop
		Loop,%StabilizerLoop%{
			Send {LButton up}
			If s
				Wait(w)
			Send {LButton down}
			If s
				Wait(w)
		}
	}
	MinigameStart:=A_TickCount
	SetTimer,Track,100
	Goto MinigameLoop
Return
MinigameLoop:
	Sleep 1
	If !FishX:=GetFishPos(){
		Seraphic:=SeraphicTrackerV1()
		MaxLeftToggle:=False
		MaxRightToggle:=False
	}
	If FishX||Seraphic{
		If ShowTooltips
			Tooltip,.,%FishX%,%ToolTipY%,1
		If ShakeOnly
			Goto MinigameLoop
		FailsInARow:=0
		If(FishX<MaxLeftBar){
			If !MaxLeftToggle{
				DirectionalToggle=Right
				MaxLeftToggle:=True
				Send {LButton up}
				Wait(1)
				Send {LButton up}
				Wait(Min(MSD,SideDelay))
				AnkleBreakDelay:=0
				SideDelay:=0
			}
			Goto MinigameLoop
		}Else If(FishX>MaxRightBar){
			If !MaxRightToggle{
				DirectionalToggle=Left
				MaxRightToggle:=True
				Send {LButton down}
				Wait(1)
				Send {LButton down}
				Wait(Min(MSD,SideDelay))
				AnkleBreakDelay:=0
				SideDelay:=0
			}
			Goto MinigameLoop
		}
		MaxLeftToggle:=False
		MaxRightToggle:=False
		If BarX:=GetBarPos(){
			If(Abs(BarX-FishX)<HalfBarSize*.45)
				Stabilize()
			If((BarX:=GetBarPos())<=FishX){
				Difference:=Scale(FishX-BarX)*ResolutionScaling*RightMult
				CounterDifference:=Difference/RightDiv
				Send {LButton down}
				If(DirectionalToggle=="Left"){
					Send {LButton down}
					Wait(Min(MAD,AnkleBreakDelay))
					AnkleBreakDelay:=0
				}Else{
					AnkleBreakDelay:=AnkleBreakDelay+(Difference-CounterDifference)*RightAnkleMult
					SideDelay:=AnkleBreakDelay/RightAnkleMult*SideBarWait
				}
				Wait(Difference)
				Send {LButton up}
				FishX:=GetFishPos()
				If(FishX<MaxLeftBar||FishX>MaxRightBar)
					Goto MinigameLoop
				Wait(CounterDifference)
				Send {LButton up}
				DirectionalToggle=Right
			}Else{
				Difference:=Scale(BarX-FishX)*ResolutionScaling*LeftMult
				CounterDifference:=Difference/LeftDiv
				Send {LButton up}
				AnkleBreakDelay:=0
				If(DirectionalToggle=="Right"){
					Send {LButton up}
					Wait(MAD)
				}
				Wait(Difference-LeftDeviation)
				Send {LButton down}
				FishX:=GetFishPos()
				If(FishX<MaxLeftBar||FishX>MaxRightBar)
					Goto MinigameLoop
				Wait(CounterDifference)
				Send {LButton down}
				DirectionalToggle=Left
			}
		}Else If Seraphic
			Stabilize(1,10)
		Goto MinigameLoop
	}Else{
		Duration:=(A_TickCount-MinigameStart)/1000
		WasFishCaught:=ProgressX>CatchCheck
		SetTimer,Track,Off
		Loop,3
			Tooltip,,,,%A_Index%
		If AutoBlurMinigame
			Send m
		CatchCount++
		If WasFishCaught
			FishCaught++
		Else
			FishLost++
		Sleep RestartDelay/2
		If UseWebhook{
			If(!WasFishCaught&&SendScreenshotFL)||(WasFishCaught&&Mod(CatchCount,ImgNotifEveryN)=0&&NotifyImg){
				ratio:=FishCaught " / "FishLost " ("RegExReplace(FishCaught/CatchCount*100,"(?<=\.\d{3}).*$") "%)"
				dur:=RegExReplace(Duration,"(?<=\.\d{3}).*$")
				caught:=WasFishCaught?"Fish took "dur "s to catch.":"Spent "dur "s trying to catch the fish."
				CS2DC(0,0,A_ScreenWidth,A_ScreenHeight,"{""embeds"":[{""image"":{""url"":""attachment://screenshot.png""},""color"":15258703,""fields"":[{""name"":""Catch Rate"",""value"":"""ratio """},{""name"":""Fish was "(WasFishCaught?"Caught!":"Lost.") """,""value"":"""caught """},{""name"":""Runtime"",""value"": """GetTime(runtime2) """}],""timestamp"":"""getISO8601() """}]}")
			}Else If(Mod(CatchCount,NotifEveryN)=0)
				If(!SendFishWhenTimeOn||(SendFishWhenTimeOn&&Duration>=SendFishWhenTimeValue))
					SendStatus(3,[FishCaught,FishLost,Duration,WasFishCaught])
			If(LvlUpMode!="Off"&&Mod(CatchCount,CheckLvlEveryN)=0)
				Gosub CheckStats
		}
		Sleep RestartDelay/2
		If(AutoSell&&Mod(CatchCount,AutoSellInterval)=0)
			Gosub SellFish
		If(FarmLocation=="cryo"&&A_TickCount>=StopFarmingAt)
			Gosub backUp
		Goto RestartMacro
	}
Return
CheckStats:
	CameraMode(False)
	Sleep 200
	x:=WW-455
	WinMove,%GuiTitle%,,%x%,0
	Sleep 300
	If !CaptureScreen("capture.png",LvlCheckLeft,LvlCheckTop,LvlCheckRight-LvlCheckLeft,LvlCheckBottom-LvlCheckTop)
		RunWait,% TesseractPath " ""capture.png"" ""capture.png_out""",,Hide
	FileRead,lvl,capture.png_out.txt
	FileDelete,capture.png
	FileDelete,capture.png_out.txt
	lvl:=RegExReplace(lvl,"[^0-9]")
	If(lvl!=""&&lvl!=LastLvl){
		LastLvl:=lvl
		Gosub SaveSettings
		If(LvlUpMode=="Txt")
			SendStatus(5,[lvl])
		Else
			CS2DC(LvlCheckLeft,LvlCheckTop,LvlCheckRight,LvlCheckBottom,"{""embeds"":[{""image"":{""url"":""attachment://screenshot.png""},""color"":4848188,""title"":""Level Up"",""timestamp"":"""getISO8601() """}]}")
	}
	Gosub MoveGui
	Sleep 250
	WinActivate,Roblox
	WinMaximize,Roblox
	Sleep AutoCameraDelay
	CameraMode(True)
	Sleep AutoCameraDelay
Return
SellFish:
	CameraMode(False)
	Sleep 200
	x:=WW-455
	WinMove,%GuiTitle%,,%x%,0
	Sleep 250
	If AutoBlurMinigame
		Send m
	Sleep 200
	Send {``}
	Sleep 500
	MouseMove,SellPosX,SellPosY
	Sleep 100
	Click %SellPosX%,%SellPosY%
	SellingStart:=A_TickCount
	EmStop:=False
	SetTimer,Failsafe4,250
	Sleep 1200
	Send {``}
	Loop{
		PixelSearch,,,SellProfitLeft,SellProfitTop,SellProfitRight,SellProfitBottom,0x49D164,13,Fast
		If ErrorLevel&&!EmStop
			Sleep 100
		Else
			Break
	}
	Sleep 200
	If UseWebhook&&SendSellProfit&&!EmStop
		CS2DC(SellProfitLeft,SellProfitTop,SellProfitRight,SellProfitBottom,"{""embeds"":[{""image"":{""url"":""attachment://screenshot.png""},""color"":6607177,""title"":""Money Gained"",""timestamp"": """getISO8601() """}]}")
	Gosub MoveGui
	Sleep 250
	WinActivate,Roblox
	WinMaximize,Roblox
	Sleep AutoCameraDelay
	CameraMode(True)
	Sleep AutoCameraDelay
Return