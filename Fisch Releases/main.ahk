#NoEnv
#SingleInstance Force
#Persistent
SetWinDelay,-1
If !(A_IsUnicode=1&&A_PtrSize=4){
	SplitPath,A_AhkPath,,dir
	Run,%dir%\AutoHotkeyU32.exe "%A_ScriptFullPath%" 
	ExitApp
}
WinActivate,Roblox
If WinActive("Roblox"){
	WinMaximize,Roblox
	Send {LButton up}
	Send {RButton up}
	Send {Shift up}
}
SetKeyDelay,-1
SetMouseDelay,-1
SetBatchLines,-1
ListLines 0
SetTitleMatchMode 2
CoordMode,Pixel,Relative
CoordMode,Mouse,Relative
#Include %A_MyDocuments%\Macro Settings\Lib
#Include Gdip_All.ahk
GuiTitle:="Fisch V1.4 by 0x3b5"
DirPath:=A_MyDocuments "\Macro Settings"
LibPath:=DirPath "\Lib"
DllCall("LoadLibrary","Str",LibPath "\SkinHu.dll")
MGPath:=DirPath "\Minigame"
SkinsPath:=DirPath "\skins"
SettingsPath:=DirPath "\general.txt"
BoundsPath:=DirPath "\bounds.txt"
DefMGPath:=DirPath "\Minigame\default.txt"
TesseractPath:="C:\Program Files\Tesseract-OCR\tesseract.exe"
VersionPath:=DirPath "\ver.txt"
If !FileExist(DirPath)
	FileCreateDir,%DirPath%
If !FileExist(LibPath)
	FileCreateDir,%LibPath%
If !FileExist(MGPath)
	FileCreateDir,%MGPath%
If !FileExist(DefMGPath)
	FileAppend,[Values]`nStabilizerLoop=20`nSideBarRatio=0.8`nSideBarWait=1.72`nRightMult=2.6329`nRightDiv=1.8961`nRightAnkleMult=1.36`nLeftMult=2.9892`nLeftDiv=4.6235`nCoefficient=1.97109`nExponent=0.810929,%DefMGPath%
If !FileExist(VersionPath)
	FileAppend,1.4 14,%VersionPath%
IniRead,curVer,%SettingsPath%,.,v
configVer:="12"
If(curVer!=configVer){
	Gosub DefaultSettings
	IniWrite,%configVer%,%SettingsPath%,.,v
}
ReadGen(ShakeMode,"ShakeMode")
ReadGen(NavigationKey,"NavKey")
ReadGen(ShakeDelay,"ShakeDelay")
ReadGen(ShakeOnly,"ShakeOnly")
ReadGen(StartHotkey,"StartHotkey")
ReadGen(ReloadHotkey,"ReloadHotkey")
ReadGen(ExitHotkey,"ExitHotkey")
ReadGen(AutoLowerGraphics,"LowerGraphics")
ReadGen(AutoZoomInCamera,"ZoomInCamera")
ReadGen(AutoLookDownCamera,"LookDown")
ReadGen(AutoBlurShake,"BlurShake")
ReadGen(AutoBlurMinigame,"BlurMinigame")
ReadGen(ShutdownAfterFailLimit,"ShutdownAfterFailLimit")
ReadGen(PrivateServer,"PrivateServer")
ReadGen(RestartDelay,"RestartDelay")
ReadGen(RodCastDuration,"CastDelay")
ReadGen(CastRandomization,"CastRandomization")
ReadGen(WaitForBobber,"WaitForBobber")
ReadGen(AutosaveSettings,"AutoSave")
ReadGen(WebhookURL,"WebhookURL")
ReadGen(UseWebhook,"WebhookEnabled")
ReadGen(NotifEveryN,"WebhookNotifyInterval")
ReadGen(NotifyImg,"WebhookSendImg")
ReadGen(ImgNotifEveryN,"WebhookImgNotifyInterval")
ReadGen(NotifyOnFailsafe,"NotifyOnFailsafe")
ReadGen(SendScreenshotFL,"NotifyOnFishLost")
ReadGen(LvlUpMode,"LvlNotifyMode")
ReadGen(LastLvl,"LastLvl")
ReadGen(CheckLvlEveryN,"WebhookLvlNotifyInterval")
ReadGen(curMGFile,"SelectedConfig")
ReadGen(SelectedSkin,"SelectedTheme")
ReadGen(FarmLocation,"FarmLocation")
ReadGen(buyConch,"PurchaseConch")
ReadGen(GuiAlwaysOnTop,"AlwaysOnTop")
ReadGen(AutoSell,"AutoSell")
ReadGen(AutoSellInterval,"AutoSellInterval")
ReadGen(SendSellProfit,"SendSellProfit")
AutoGraphicsDelay:=50
AutoZoomDelay:=40
AutoCameraDelay:=25
AutoLookDelay:=50
AutoBlurDelay:=25
If(SelectedSkin!="none"){
	sl:=SkinsPath "\"SelectedSkin
	If FileExist(sl)
		DllCall("SkinHu\SkinH_AttachEx","Str",sl)
}
If !FileExist(MGPath "\"curMGFile)
	curMGFile:="default.txt"
curMGConfig:=ImportMinigameConfig(curMGFile)
StabilizerLoop:=curMGConfig[1]
SideBarRatio:=curMGConfig[2]
SideBarWait:=curMGConfig[3]
RightMult:=curMGConfig[4]
RightDiv:=curMGConfig[5]
RightAnkleMult:=curMGConfig[6]
LeftMult:=curMGConfig[7]
LeftDiv:=curMGConfig[8]
Coefficient:=curMGConfig[9]
Exponent:=curMGConfig[10]
Scale(x){
	Global Coefficient,Exponent
	Return Coefficient*x**Exponent
}
LeftDeviation:=50
ShakeFailsafe:=15
BarDetectionFailsafe:=3
FailsInARow:=0
RepeatBypassLimit:=10
BarColor:=0xF8F8F8
BarCalcColor:=0xF0F0F0
ArrowColor:=0x868483
FishColor:=0x5B4B43
ManualBarSize:=0
Test1:=0
Test2:=0
MSD:=250
MAD:=200
SS:=1
FishCaught:=0
FishLost:=0
CatchCount:=0
runtime1:=0
runtime2:=0
cryoCanal:={CF:False}
XOdebounce:=True
SelectedBound:=""
boundNames:=["CameraCheck","FishBar","ProgBar","LvlCheck","SellProfit","CameraMode","SellButton"]
WW:=A_ScreenWidth
WH:=A_ScreenHeight
instructions:=FetchInstructions()
SetTimer,GuiRuntime,1000
Gosub Calculations
Gosub InitGui
GuiControl,Choose,Tabs,2
Hotkey % "$"StartHotkey,StartMacro
Hotkey % "$"ReloadHotkey,ReloadMacro
Hotkey % "$"ExitHotkey,ExitMacro
SendStatus(0)
Return
DefaultSettings:
	RtrvGen("ShakeMode","Click")
	RtrvGen("NavKey","\")
	RtrvGen("ShakeDelay",35)
	RtrvGen("ShakeOnly",0)
	RtrvGen("StartHotkey","F1")
	RtrvGen("ReloadHotkey","F2")
	RtrvGen("ExitHotkey","F3")
	RtrvGen("LowerGraphics",1)
	RtrvGen("ZoomInCamera",1)
	RtrvGen("LookDown",1)
	RtrvGen("BlurShake",1)
	RtrvGen("BlurMinigame",1)
	RtrvGen("ShutdownAfterFailLimit",1)
	RtrvGen("PrivateServer","")
	RtrvGen("RestartDelay",800)
	RtrvGen("CastDelay",750)
	RtrvGen("CastRandomization",100)
	RtrvGen("WaitForBobber",300)
	RtrvGen("AutoSave",1)
	RtrvGen("WebhookURL","")
	RtrvGen("WebhookEnabled",0)
	RtrvGen("WebhookNotifyInterval",1)
	RtrvGen("WebhookSendImg",0)
	RtrvGen("WebhookImgNotifyInterval",10)
	RtrvGen("NotifyOnFailsafe",1)
	RtrvGen("NotifyOnFishLost",1)
	RtrvGen("LvlNotifyMode","Off")
	RtrvGen("LastLvl",1)
	RtrvGen("WebhookLvlNotifyInterval",1)
	RtrvGen("SelectedConfig","default.txt")
	RtrvGen("SelectedTheme","none")
	RtrvGen("FarmLocation","none")
	RtrvGen("PurchaseConch",1)
	RtrvGen("AlwaysOnTop",1)
	RtrvGen("AutoSell",0)
	RtrvGen("AutoSellInterval",25)
	RtrvGen("SendSellProfit",0)
Return
SaveSettings:
	WriteGen("ShakeMode",ShakeMode)
	WriteGen("NavKey",NavigationKey)
	WriteGen("ShakeDelay",ShakeDelay)
	WriteGen("ShakeOnly",ShakeOnly)
	WriteGen("StartHotkey",StartHotkey)
	WriteGen("ReloadHotkey",ReloadHotkey)
	WriteGen("ExitHotkey",ExitHotkey)
	WriteGen("LowerGraphics",AutoLowerGraphics)
	WriteGen("ZoomInCamera",AutoZoomInCamera)
	WriteGen("LookDown",AutoLookDownCamera)
	WriteGen("BlurShake",AutoBlurShake)
	WriteGen("BlurMinigame",AutoBlurMinigame)
	WriteGen("ShutdownAfterFailLimit",ShutdownAfterFailLimit)
	WriteGen("PrivateServer",PrivateServer)
	WriteGen("RestartDelay",RestartDelay)
	WriteGen("CastDelay",RodCastDuration)
	WriteGen("CastRandomization",CastRandomization)
	WriteGen("WaitForBobber",WaitForBobber)
	WriteGen("AutoSave",AutosaveSettings)
	WriteGen("WebhookURL",WebhookURL)
	WriteGen("WebhookEnabled",UseWebhook)
	WriteGen("WebhookNotifyInterval",NotifEveryN)
	WriteGen("WebhookSendImg",NotifyImg)
	WriteGen("WebhookImgNotifyInterval",ImgNotifEveryN)
	WriteGen("NotifyOnFailsafe",NotifyOnFailsafe)
	WriteGen("NotifyOnFishLost",SendScreenshotFL)
	WriteGen("LvlNotifyMode",LvlUpMode)
	WriteGen("LastLvl",LastLvl)
	WriteGen("WebhookLvlNotifyInterval",CheckLvlEveryN)
	WriteGen("SelectedConfig",curMGFile)
	WriteGen("SelectedTheme",SelectedSkin)
	WriteGen("FarmLocation",FarmLocation)
	WriteGen("PurchaseConch",buyConch)
	WriteGen("AlwaysOnTop",GuiAlwaysOnTop)
	WriteGen("AutoSell",AutoSell)
	WriteGen("AutoSellInterval",AutoSellInterval)
	WriteGen("SendSellProfit",SendSellProfit)
Return
GuiRuntime:
	runtime1++
	GuiControl,Text,TRT1,% GetTime(runtime1)
	GuiControl,Text,TRT2,% GetTime(runtime2)
	GuiControl,Text,TFC,% FishCaught " / "FishLost " ("RegExReplace(FishCaught/CatchCount*100,"(?<=\.\d{3}).*$") "%)"
Return
ReloadMacro:
	Reload
Return
ExitMacro:
	Send {LButton up}
	Send {RButton up}
	Send {Shift up}
	SendStatus(2,[FishCaught])
	Sleep 25
	ExitApp
Return
MoveGui:
	x:=WW-455
	y:=WH-200
	WinMove,%GuiTitle%,,%x%,%y%
Return
StartMacro:
	WinActivate,Roblox
	WinMaximize,Roblox
	SendStatus(1)
	Sleep 150
	Gosub MoveGui
	If GuiAlwaysOnTop
		GuiControl,Choose,Tabs,1
	SetTimer,Failsafe3,1000
	If AutoLowerGraphics{
		UpdateTask("Current Task: Lower Graphics")
		Sleep AutoGraphicsDelay/2
		Send {Shift}
		Loop,20{
			Send {Shift down}{F10}
			Sleep AutoGraphicsDelay
		}
		Send {Shift up}
		Sleep AutoGraphicsDelay/2
	}
	If AutoZoomInCamera{
		UpdateTask("Current Task: Zoom Camera")
		Sleep AutoZoomDelay
		Loop,20{
			Send {WheelUp}
			Sleep AutoZoomDelay
		}
		Send {WheelDown}
		Sleep AutoZoomDelay*5
	}
	UpdateTask("Current Task: Enable Camera Mode")
	PixelSearch,,,CameraCheckLeft,CameraCheckTop,CameraCheckRight,CameraCheckBottom,0xFFFFFF,1,Fast
	If !ErrorLevel{
		Sleep AutoCameraDelay
		Send 2
		Sleep AutoCameraDelay
		Send 1
		Sleep AutoCameraDelay
		CameraMode(True)
	}
	Goto RestartMacro
Return
RestartMacro:
	If(FarmLocation=="cryo"&&!cryoCanal.CF){
		UpdateTask("Current Task: Walking To Cryogenic Canal")
		Click 0,500
		Loop,6{
			Send {WheelDown}
			Sleep AutoZoomDelay
		}
		Send {d up}{w up}{s up}{a up}{Space up}
		Sleep 100
		Send {d down}
		Sleep 1300
		Send {w down}
		Sleep 850
		Send {w up}{s down}
		Sleep 2700
		Send {d up}e
		Sleep 200
		Send {s up}e
		Sleep 200
		Loop,5{
			Send e
			Sleep 25
		}
		Sleep 200
		Send {Space down}{w down}{d down}e
		Sleep 1000
		Send {d up}
		Sleep 1000
		Send {Space up}
		Sleep 4250
		Send {d down}{Space down}
		Sleep 5600
		Send {w up}{Space up}
		Sleep 1450
		Send {Space down}
		Sleep 6000
		Send {d up}{Space up}
		Sleep 100
		Send {Space down}{a down}{s down}
		Sleep 4400
		Send {a up}
		Sleep 500
		Send {Space up}
		Sleep 3600
		Send {a down}{s up}
		Sleep 1500
		Send {w down}
		Sleep 200
		Send {w up}
		Sleep 4200
		Send {s down}
		Sleep 300
		Send {a up}
		Sleep 500
		Send {a down}{w down}{s up}
		Sleep 1250
		Send {a up}
		Sleep 1870
		Send {w up}
		Sleep 250
		Loop,25{
			Send {WheelUp}
			Sleep AutoZoomDelay
		}
		Loop,3{
			Send {WheelDown}
			Sleep AutoZoomDelay
		}
		Sleep AutoZoomDelay*5
		StopFarmingAt:=A_TickCount+36*60000
		cryoCanal.CF:=True
	}
	MouseMove,LookDownX,LookDownY
	If AutoLookDownCamera{
		UpdateTask("Current Task: Look Down")
		Send {RButton up}
		Sleep AutoLookDelay
		MouseMove,LookDownX,LookDownY
		Sleep AutoLookDelay
		Send {RButton down}
		Sleep AutoLookDelay
		DllCall("mouse_event",uint,1,int,0,int,10000)
		Sleep AutoLookDelay
		Send {RButton up}
		Sleep AutoLookDelay
		MouseMove,LookDownX,LookDownY
		Sleep AutoLookDelay
	}
	If AutoBlurShake{
		UpdateTask("Current Task: Blur Camera")
		Sleep AutoBlurDelay
		Send m
		Sleep AutoBlurDelay
	}
	UpdateTask("Current Task: Cast Rod")
	Send {LButton down}
	Random,RCD,0,CastRandomization*2
	Sleep RodCastDuration-RCD+CastRandomization
	Send {LButton up}
	Sleep WaitForBobber
	UpdateTask("Current Task: Shake")
	If(ShakeMode=="Click")
		Goto CShakeMode
	Else
		Goto NShakeMode
Return
Failsafe1:
	FailsafeCount++
	If(FailsafeCount>=ShakeFailsafe){
		SetTimer,Failsafe1,Off
		FailsInARow++
		SendStatus(4,["Shaking failed.",FailsInARow])
		ForceReset:=True
	}
Return
Failsafe2:
	BarCalcFailsafeCounter++
	If(BarCalcFailsafeCounter>=BarDetectionFailsafe){
		SetTimer,Failsafe2,Off
		FailsInARow++
		SendStatus(4,["Bar not found.",FailsInARow])
		ForceReset:=True
	}
Return
Failsafe3:
	If(ShutdownAfterFailLimit&&FailsInARow>14){
		SetTimer,Failsafe3,Off
		SendStatus(4,["Failsafe triggered too many times, shutting down.",FailsInARow])
		Sleep 25
		Shutdown,1
		Goto ExitMacro
	}
	runtime2++
Return
#Include shake.ahk
#Include minigame.ahk
backUp:
	cryoCanal.CF:=False
	Sleep 200
	If AutoBlurMinigame
		Send m
	CameraMode(False)
	Sleep 150	
	If buyConch{
		Send {s down}
		Sleep 600
		Send {s up}{d down}
		Sleep 1500
		Send {d up}
		Sleep 300
		Send {Space down}
		Sleep 400
		Send {d down}
		Sleep 900
		Send {Space up}{d up}{s down}e
		Sleep 200
		Send {s up}e
		Sleep 400
		Loop,5{
			Send {WheelDown}e
			Sleep AutoZoomDelay
		}
		Sleep 200
		Send e
		Sleep 300
		Loop,5{
			Click 830,600
			Sleep 50
		}
	}Else
		Sleep 1000
	Send {9}
	Sleep 500
	Click 0,500
	Sleep 400
	Send {1}
	CameraMode(True)
	Click 0,500
	Sleep 4000
Return
#Include gui.ahk
#Include other.ahk
#Include manual_setup.ahk
GuiClose:
	Goto ExitMacro