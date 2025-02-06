;14
#Include %A_MyDocuments%\Macro Settings\main.ahk
Track:
	If GetFishPos(){
		PixelSearch,x,,ProgBarRight,ProgBarTop,ProgBarLeft,ProgBarBottom,0xFFFFFF,2,Fast
		If !ErrorLevel
			ProgressX:=x
		Else{
			PixelSearch,x,,ProgBarRight,ProgBarTop,ProgBarLeft,ProgBarBottom,0x9F9F9F,2,Fast
			If !ErrorLevel
				ProgressX:=x
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
		Global FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,BarColor1,BarColor2,HalfBarSize
		FB:=False
		PixelSearch,TBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,BarColor1,0,Fast
		If !ErrorLevel
			Return TBX+HalfBarSize
		Else{
			PixelSearch,TBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,BarColor2,0,Fast
			If !ErrorLevel
				Return TBX+HalfBarSize
		}
		If !FB{
			PixelSearch,AX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,ArrowColor,5,Fast
			If !ErrorLevel{
				PixelGetColor,UC,AX+25,FishBarTop-5
				If(UC=FishColor)
					PixelGetColor,UC,AX-25,FishBarTop-5
				PixelSearch,TBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,UC,0,Fast
				If !ErrorLevel
					Return TBX+HalfBarSize
			}
		}
	}
	Stabilize(s:=0,w:=5){
		Global StabilizerLoop
		Loop,StabilizerLoop{
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
	Wait(1)
	If !FishX:=GetFishPos(){
		Seraphic:=SeraphicTrackerV1()
		MaxLeftToggle:=False
		MaxRightToggle:=False
	}
	If FishX||Seraphic{
		If ShakeOnly
			Goto MinigameLoop
		FailsInARow:=0
		Stabilize(1,25)
		Stabilize()
		If(FishX<MaxLeftBar){
			If !MaxLeftToggle{
				DirectionalToggle:="Right"
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
				DirectionalToggle:="Left"
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
			If(BarX<=FishX){
				Difference:=Scale(FishX-BarX)*ResolutionScaling*RightMult
				CounterDifference:=Difference/RightDiv
				Send {LButton down}
				Stabilize()
				Send {LButton down}
				If(DirectionalToggle=="Left"){
					Stabilize()
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
				Stabilize(1)
				Send {LButton up}
				DirectionalToggle:="Right"
			}Else{
				Difference:=Scale(BarX-FishX)*ResolutionScaling*LeftMult
				CounterDifference:=Difference/LeftDiv
				Send {LButton up}
				Stabilize()
				Send {LButton up}
				AnkleBreakDelay:=0
				If(DirectionalToggle=="Right"){
					Stabilize()
					Send {LButton up}
					Wait(MAD)
				}
				Wait(Difference-LeftDeviation)
				Send {LButton down}
				FishX:=GetFishPos()
				If(FishX<MaxLeftBar||FishX>MaxRightBar)
					Goto MinigameLoop
				Wait(CounterDifference)
				Stabilize(1)
				Send {LButton down}
				DirectionalToggle:="Left"
			}
		}Else If Seraphic
			Stabilize(1)
		Goto MinigameLoop
	}Else{
		Duration:=(A_TickCount-MinigameStart)/1000
		WasFishCaught:=ProgressX>CatchCheck
		SetTimer,Track,Off
		CatchCount++
		If WasFishCaught
			FishCaught++
		Else
			FishLost++
		Sleep RestartDelay/2
		If UseWebhook{
			If(!WasFishCaught&&SendScreenshotFL)||(WasFishCaught&&Mod(CatchCount,ImgNotifEveryN)=0&&NotifyImg){
				FormatTime,ct,,hh:mm:ss
				ratio:=FishCaught " / "FishLost " ("RegExReplace(FishCaught/CatchCount*100,"(?<=\.\d{3}).*$") "%)"
				dur:=RegExReplace(Duration,"(?<=\.\d{3}).*$")
				caught:=WasFishCaught?"Fish took "dur "s to catch.":"Spent "dur "s trying to catch the fish."
				
			}Else If(Mod(CatchCount,NotifEveryN)=0)
				If((!SendFishWhenTimeOn)||(SendFishWhenTimeOn&&Duration>=SendFishWhenTimeValue))
					SendStatus(3,[FishCaught,FishLost,Duration,WasFishCaught])
			If(LvlUpMode!="Off"&&Mod(CatchCount,CheckLvlEveryN)=0)
				Gosub CheckStatistics
		}
		Sleep RestartDelay/2
		If(AutoSell&&Mod(CatchCount,AutoSellInterval)=0)
			Gosub SellFish
		If(FarmLocation=="cryo"&&A_TickCount>=StopFarmingAt)
			Gosub backUp
		Goto RestartMacro
	}
Return
CheckStatistics:
	CameraMode(False)
	Sleep 200
	x:=WW-455
	WinMove,%GuiTitle%,,%x%,0
	Sleep 500
	If !CaptureScreen("capture.png",LvlCheckLeft,LvlCheckTop,LvlCheckRight-LvlCheckLeft,LvlCheckBottom-LvlCheckTop)
		RunWait,% TesseractPath " ""capture.png"" ""capture.png_out""",,Hide
	FileRead,lvl,capture.png_out.txt
	FileDelete,capture.png
	FileDelete,capture.png_out.txt
	lvl:=RegExReplace(lvl,"[^0-9]")
	FormatTime,ct,,hh:mm:ss
	If(lvl!=""&&lvl!=LastLvl){
		LastLvl:=lvl
		Gosub SaveSettings
		If(LvlUpMode=="Txt")
			SendStatus(5,[lvl])
		Else
			CS2DC(LvlCheckLeft,LvlCheckTop,LvlCheckRight,LvlCheckBottom,"{""embeds"":[{""image"":{""url"":""attachment://screenshot.png""},""color"":4848188,""title"":""Level Up"",""footer"":{""text"":"""ct """}}]}")
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
	Send {``}
	Sleep 500
	MouseMove,SellPosX,SellPosY
	Sleep 100
	Click %SellPosX%,%SellPosY%
	Sleep 1200
	Send {``}
	Loop{
		PixelSearch,,,SellProfitLeft,SellProfitTop,SellProfitRight,SellProfitBottom,0x49D164,12,Fast
		If ErrorLevel
			Sleep 100
		Else
			Break
	}
	Sleep 200
	FormatTime,ct,,hh:mm:ss
	If UseWebhook&&SendSellProfit
		CS2DC(SellProfitLeft,SellProfitTop,SellProfitRight,SellProfitBottom,"{""embeds"":[{""image"":{""url"":""attachment://screenshot.png""},""color"":6607177,""title"":""Money Gained"",""footer"":{""text"":"""ct """}}]}")
	Gosub MoveGui
	Sleep 250
	WinActivate,Roblox
	WinMaximize,Roblox
	Sleep AutoCameraDelay
	CameraMode(True)
	Sleep AutoCameraDelay
Return
