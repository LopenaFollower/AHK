;11
#Include %A_MyDocuments%\Macro Settings\main.ahk
InitGui:
	If !FileExist(LogoPath)
		UrlDownloadToFile,https://raw.githubusercontent.com/LopenaFollower/AHK/refs/heads/main/Fisch`%20Releases/Assets/logo.ico,%LogoPath%
	Menu,Tray,Icon,%LogoPath%
	Gui -MinimizeBox -MaximizeBox +AlwaysOnTop
	Gui Add,Tab3,vTabs x0 y0 w450 h176,Info|Main|Webhook|Minigame|Locations|Misc|Manual Setup|Credits
	Gui Tab,1
	Gui Font,s10
	Gui Add,Text,x5 y22 w72 h16,Gui Runtime
	Gui Font
	Gui Add,Text,vTRT1 x6 y38 w56 h13,0h 00m 00s
	Gui Font,s10
	Gui Add,Text,x5 y54 w90 h16,Macro Runtime
	Gui Font
	Gui Add,Text,vTRT2 x6 y70 w56 h13,0h 00m 00s
	Gui Add,Text,vTTask x5 y87 w162 h14,Current Task: Idle
	Gui Font
	Gui Add,Text,vTFC x5 y102 w100 h13,Fish Count: 0/0
	Gui Tab,2
	Gui Font,w600
	Gui Add,GroupBox,x2 y21 w140 h84,Shaking
	Gui Font
	Gui Add,Text,x9 y35 w64 h13,Shake Mode:
	Gui Add,Text,x9 y53 w75 h13,Navigation Key:
	Gui Add,Text,x9 y70 w64 h13,Shake Delay:
	Gui Add,Text,x9 y87 w58 h13,Shake Only:
	ListVal:=(ShakeMode="click")?"Click||Navigation":"Click|Navigation||"
	Gui Add,DropDownList,vDDSM gSubAll x74 y31 w65,%ListVal%
	Gui Add,Edit,vNK gSubAll x85 y53 w54 h16,%NavigationKey%
	Gui Add,Edit,vSD gSubAll x74 y70 w65 h16 Number,%ShakeDelay%
	SHO:=Chkd(ShakeOnly)
	Gui Add,CheckBox,vCBSO gSubAll x125 y87 w13 h13 %SHO%,Shake Only:
	Gui Font,w600
	Gui Add,GroupBox,x2 y104 w140 h71,Hotkeys
	Gui Font
	Gui Add,Text,x9 y116 w67 h13,Start Fisching:
	Gui Add,Text,x9 y136 w70 h13,Reload Macro:
	Gui Add,Text,x9 y155 w54 h13,Exit Macro:
	Gui Add,Hotkey,vCSHK gSubAll x81 y115 w57 h18,%StartHotkey%
	Gui Add,Hotkey,vCRHK gSubAll x81 y134 w57 h18,%ReloadHotkey%
	Gui Add,Hotkey,vCEHK gSubAll x81 y153 w57 h18,%ExitHotkey%
	Gui Font,w600
	Gui Add,GroupBox,x144 y21 w134 h106,Options
	Gui Font
	ALG:=Chkd(AutoLowerGraphics),AZC:=Chkd(AutoZoomInCamera),ALD:=Chkd(AutoLookDownCamera),ABlS:=Chkd(AutoBlurShake),ABlM:=Chkd(AutoBlurMinigame),ASF:=Chkd(ShutdownAfterFailLimit)
	Gui Add,CheckBox,vCBLG gSubAll x148 y35 w96 h14 %ALG%,Lower Graphics
	Gui Add,CheckBox,vCBZC gSubAll x148 y50 w98 h14 %AZC%,Zoom In Camera
	Gui Add,CheckBox,vCBLD gSubAll x148 y65 w98 h14 %ALD%,Look Down
	Gui Add,CheckBox,vCBBS gSubAll x148 y80 w104 h14 %ABlS%,Blur When Shake
	Gui Add,CheckBox,vCBBM gSubAll x148 y95 w118 h14 %ABlM%,Blur When Minigame
	Gui Add,CheckBox,vCBSF gSubAll x148 y110 w128 h14 %ASF%,ShutdownAfterFailLimit
	Gui Font,w600
	Gui Add,GroupBox,x144 y126 w134 h48,Game
	Gui Font
	Gui Add,Button,gJG x152 y138 w120 h17,Join Game
	Gui Add,Text,x148 y156 w41 h13,PS Link:
	Gui Add,Edit,vPSL gSubAll x189 y155 w86 h16,%PrivateServer%
	Gui Font,w600
	Gui Add,GroupBox,x280 y21 w168 h95,Delays
	Gui Font
	Gui Add,Text,x284 y36 w64 h14,Restart Delay
	Gui Add,Text,x284 y56 w68 h14,Hold Rod Cast
	Gui Add,Text,x284 y76 w94 h14,Cast Randomization
	Gui Add,Text,x284 y96 w78 h14,Wait For Bobber
	Gui Add,Edit,vDLRL gSubAll x387 y34 w58 h18 Number,%RestartDelay%
	Gui Add,Edit,vDLHR gSubAll x387 y54 w58 h18 Number,%RodCastDuration%
	Gui Add,Edit,vDLCR gSubAll x387 y74 w58 h18 Number,%CastRandomization%
	Gui Add,Edit,vDLWB gSubAll x387 y94 w58 h18 Number,%WaitForBobber%
	Gui Font,w600
	Gui Add,GroupBox,x280 y115 w168 h60,Settings
	Gui Font
	Gui Add,Button,gSTRS x284 y130 w80 h26,Reset Settings
	Gui Add,Button,gSTSV x366 y130 w80 h26,Save Settings
	ASS:=Chkd(AutosaveSettings)
	Gui Add,CheckBox,vCBAS gSubAll x286 y158 w120 h14 %ASS%,Autosave Settings
	Gui Tab,3
	Gui Add,Text,x5 y24 w73 h14,Webhook URL
	Gui Add,Edit,vWURL gSubAll x3 y36 w120 h21,%WebhookURL%
	UWH:=Chkd(UseWebhook)
	Gui Add,CheckBox,vCBWH gSubAll x4 y59 w100 h14 %UWH%,Enable Webhook
	Gui Add,Text,x4 y76 w56 h13,Notify every
	Gui Add,Edit,vWHSK gSubAll x60 y74 w22 h18 Number,%NotifEveryN%
	Gui Add,Text,x83 y76 w40 h13,catches.
	NSI:=Chkd(NotifyImg)
	Gui Add,CheckBox,vCBSI gSubAll x4 y92 w92 h14 %NSI%,Send Img every
	Gui Add,Edit,vSIEN gSubAll x97 y91 w22 h18,%ImgNotifEveryN%
	Gui Add,Text,x5 y106 w40 h13,catches.
	Gui Font,w600
	Gui Add,GroupBox,x125 y21 w322 h153,Options
	Gui Font
	NOF:=Chkd(NotifyOnFailsafe),SFL:=Chkd(SendScreenshotFL)
	Gui Add,CheckBox,vCBNF gSubAll x129 y35 w100 h14 %NOF%,Notify on Failsafe
	Gui Add,CheckBox,vCBSS gSubAll x129 y51 w114 h14 %SFL%,Send SS on fish lost
	ListVal:=(LvlUpMode="off")?"Off||Txt|Img":(LvlUpMode="txt")?"Off|Txt||Img":"Off|Txt|Img||"
	Gui Add,DropDownList,vDDSS gSubAll x129 y66 w42,%ListVal%
	Gui Add,Text,x174 y70 w84 h14,Notify on level up
	Gui Add,Text,x129 y87 w62 h13,Check every
	Gui Add,Edit,vCLEN gSubAll x190 y85 w26 h18 Number,%CheckLvlEveryN%
	Gui Add,Text,x218 y87 w40 h13,catches.
	SSP:=Chkd(SendSellProfit)
	Gui Add,CheckBox,vCBSP gSubAll x129 y104 w154 h14 %SSP%,Send Sell Profits (Gamepass)
	SFS:=Chkd(SendFishScreenshot),SFWT:=Chkd(SendFishWhenTimeOn)
	Gui Add,CheckBox,vCBFSS gSubAll x129 y120 w174 h14 %SFS% , Send Fish Screenshot On Catch
	Gui Add,CheckBox,vCBFTSO gSubAll x129 y136 h14 %SFWT%, Only Send If Catch Time < 
	Gui Add,Edit,vCBFTSV gSubAll x275 y136 w26 h18 Number, %SendFishWhenTimeValue%
	Gui Add,Text, x305 y139,Seconds
	Gui Tab,4
	cnfgoptions:=ScanForConfigs(curMGFile)
	Gui Add,DropDownList,vMGCF gMGCCF x2 y24 w100,% cnfgoptions[1]
	Gui Add,Button,gMGSave x103 y23 w40 h23,Save
	Gui Add,Button,gMGExport x143 y23 w70 h23,New Config
	Gui Add,Button,gMGOpen x213 y23 w70 h23,Open Folder
	Gui Add,Button,gMGRefresh x283 y23 w70 h23,Scan Folder
	Gui Font,w600
	Gui Add,GroupBox,x2 y46 w120 h52,Left
	Gui Font
	Gui Add,Text,x9 y58 w42 h14,Multiplier
	Gui Add,Text,x9 y77 w32 h14,Divisor
	Gui Add,Edit,vMGLM x68 y56 w52 h17 gNumberEdit,%LeftMult%
	Gui Add,Edit,vMGLD x68 y76 w52 h17 gNumberEdit,%LeftDiv%
	Gui Font,w600
	Gui Add,GroupBox,x2 y98 w120 h76,Right
	Gui Font
	Gui Add,Text,x9 y111 w42 h14,Multiplier
	Gui Add,Text,x9 y130 w32 h14,Divisor
	Gui Add,Text,x9 y150 w50 h14,Ankle Mult
	Gui Add,Edit,vMGRM x68 y108 w52 h17 gNumberEdit,%RightMult%
	Gui Add,Edit,vMGRD x68 y128 w52 h17 gNumberEdit,%RightDiv%
	Gui Add,Edit,vMGAM x68 y148 w52 h17 gNumberEdit,%RightAnkleMult%
	Gui Font,w600
	Gui Add,GroupBox,x124 y46 w128 h128,Other
	Gui Font
	Gui Add,Text,x128 y58 w68 h14,Stabilizer Loop
	Gui Add,Text,x128 y78 w64 h14,Sidebar Ratio
	Gui Add,Text,x128 y98 w62 h14,Sidebar Wait
	Gui Add,Text,x128 y118 w82 h14,Scale Coeff
	Gui Add,Text,x128 y138 w82 h14,Scale Exp
	Gui Add,Edit,vMGSL x198 y56 w52 h17 gNumberEdit,%StabilizerLoop%
	Gui Add,Edit,vMGSR x198 y76 w52 h17 gNumberEdit,%SideBarRatio%
	Gui Add,Edit,vMGSW x198 y96 w52 h17 gNumberEdit,%SideBarWait%
	Gui Add,Edit,vMGCO x198 y116 w52 h17 gNumberEdit,%Coefficient%
	Gui Add,Edit,vMGXP x198 y136 w52 h17 gNumberEdit,%Exponent%
	Gui Tab,5
	Gui Add,GroupBox,x2 y21 w223 h77,Cryogenic Canal
	CFH:=Chkd(FarmLocation="cryo"),CBC:=Chkd(buyConch)
	Gui Add,CheckBox,vCBCF gSubAll x7 y36 w64 h18 %CFH%,Farm here
	Gui Add,CheckBox,vCBBC gSubAll x7 y53 w70 h18 %CBC%,Buy Conch
	Gui Add,Text,x105 y29 w38 h14,Setup:
	Gui Add,Text,x115 y42 w94 h14,Set spawn at Grotto
	Gui Add,Text,x115 y55 w90 h14,Equip needed gear
	Gui Add,Text,x115 y68 w106 h14,Use conch, face north
	Gui Add,Text,x115 y81 w100 h14,Put conch at slot 9
	Gui Tab,6
	AOT:=Chkd(GuiAlwaysOnTop)
	Gui Add,CheckBox,vCBOT gSubAll x9 y24 w90 h14 %AOT%,Always On Top
	Gui,Add,Text,x4 y44 w44 h14,Themes:
	Gui,Add,ComboBox,vDDSL gChangeTheme x50 y40 w120 h100,
	Loop,%SkinsPath%\*.she
		GuiControl,,DDSL,% A_LoopFileName
	UAS:=Chkd(AutoSell)
	Gui Add,CheckBox,vCBGS gSubAll x5 y64 w120 h13 %UAS%,Auto Sell (Gamepass)
	Gui Add,Edit,vASIG gSubAll x60 y78 w28 h18,%AutoSellInterval%
	Gui Add,Text,x4 y79 w56 h18,Sell Interval
	Gui Add,GroupBox,x302 y22 w146 h154,What is this for?
	Gui Font,s20
	Gui Add,Button,vX1Y1 gTTT x304 y33 w48 h48
	Gui Add,Button,vX2Y1 gTTT x351 y33 w48 h48
	Gui Add,Button,vX3Y1 gTTT x398 y33 w48 h48
	Gui Add,Button,vX1Y2 gTTT x304 y80 w48 h48
	Gui Add,Button,vX2Y2 gTTT x351 y80 w48 h48
	Gui Add,Button,vX3Y2 gTTT x398 y80 w48 h48
	Gui Add,Button,vX1Y3 gTTT x304 y127 w48 h48
	Gui Add,Button,vX2Y3 gTTT x351 y127 w48 h48
	Gui Add,Button,vX3Y3 gTTT x398 y127 w48 h48
	Gui Font
	Gui Tab,7
	Gui Add,Button,gShowBounds x2 y24 w80 h23,Show Bounds
	Gui Add,Button,gHideBounds x83 y24 w80 h23,Hide Bounds
	Gui Add,Button,gResetBounds x164 y24 w102 h23,Reset All Bounds
	Gui Font,w600
	Gui Add,GroupBox,x270 y22 w179 h152,Position And Size
	Gui Font
	Gui Add,Text,x275 y37 w68 h14,Select Bound:
	Gui Add,ComboBox,vDDBN gSubAll x276 y51 w119,CameraCheck|FishBar|ProgBar|LvlCheck|SellProfit|CameraMode|SellButton
	Gui Add,Text,x275 y75 w37 h23,X (Left):
	Gui Add,Edit,x312 y75 w46 h18 gApplyBnd vBNX
	Gui Add,UpDown,x341 y75 w18 h18 +0x80 Range-10000-10000 gApplyBnd vUDX
	Gui Add,Text,x361 y75 w38 h23,Y (Top):
	Gui Add,Edit,x399 y75 w46 h18 gApplyBnd vBNY
	Gui Add,UpDown,x428 y75 w18 h18 +0x80 Range-10000-10000 gApplyBnd vUDY
	Gui Add,Text,x275 y96 w37 h23,Width:
	Gui Add,Edit,x313 y96 w46 h18 gApplyBnd vBNW
	Gui Add,UpDown,x341 y96 w18 h18 +0x80 Range-10000-10000 gApplyBnd vUDW
	Gui Add,Text,x361 y96 w37 h23,Height:
	Gui Add,Edit,x399 y96 w46 h18 gApplyBnd vBNH
	Gui Add,UpDown,x428 y96 w18 h18 +0x80 Range-10000-10000 gApplyBnd vUDH
	Gui Add,Text,vBDSC x276 y120 w166
	Gui Tab,8
	Gui Add,Link,x6 y22 w276 h14,This macro is based on the <a href="https://www.youtube.com/@AsphaltCake">AsphaltCake</a> Fisch Macro V11
	Gui Add,Text,x6 y+4 w257 h14,Gui, modified minigame, polishing, and webhook by me.
	Gui Add,Text,x6 y+4 w257 h14,Image webhook provided by @lunarosity, embed by me.
	Gui Add,Text,x6 y+4 w257 h14,Themes and Lvl checker provided by @toxgt
	Gui Add,Text,x6 y+4 w257 h14,Accurate Camera mode by @b0red_man
	Gui Add,Text,x6 y+4 w257 h14,Logo design by @grubrescue
	Gui Add,Link,x6 y+4 w252 h14,Check out my <a href="https://github.com/LopenaFollower">GitHub</a> and <a href="https://discord.gg/Fh5rmgg27X">Discord Server</a>
	Gui Show,w450 h175,%GuiTitle%
	Return
	TTT:
		Gui Submit,NoHide
		c:=A_GuiControl
		GuiControlGet,sym,,%c%
		If(sym=""&&XOdebounce){
			XOdebounce:=False
			GuiControl,,%c%,X
			Random,slp,250,400
			Wait(slp)
			ncb:=["X1Y1","X2Y1","X3Y1","X1Y2","X2Y2","X3Y2","X1Y3","X2Y3","X3Y3"]
			cb:=""
			For _,v in ncb{
				GuiControlGet,s,,%v%
				cb.=(s="")?"_":s
			}
			For k,v in instructions
				If(SubStr(v,1,9)=cb)
					bm:=StrSplit(SubStr(v,10))
			GuiControl,,% "X"bm[1] "Y"bm[2],O
			clb:=False
			XOdebounce:=True
			For _,v in ["100100100","010010010","001001001","111000000","000111000","000000111","100010001","001010100"]{
				won:=True
				For k,i in StrSplit(v){
					GuiControlGet,ns,,% ncb[k]
					If(ns!="O"&&i="1")
						won:=False
				}
				If clb:=won
					Break
			}
			If !clb{
				clb:=True
				For k,v in ncb{
					GuiControlGet,ns,,% v
					If(ns="")
						clb:=False
				}
			}
			Wait(500-slp)
			If clb
				For j,i in ncb
					GuiControl,,%i%,
		}
	Return
	ChangeTheme:
		Gui Submit,NoHide
		If(Trim(DDSL)!=""){
			sl:=SkinsPath "\"DDSL
			If FileExist(sl){
				SelectedSkin:=DDSL
				DllCall("SkinHu\SkinH_AttachEx","Str",sl)
				Goto SaveSettings
			}
		}
	Return
	NumberEdit:
		c:=A_GuiControl
		GuiControlGet,inp,,%c%
		If !RegExMatch(inp,"^[0-9]*\.?[0-9]*$"){
			inp:=RegExReplace(inp,"[^0-9.]")
			parts:=StrSplit(inp,".")
			If(parts.MaxIndex()>2)
				inp:=parts[1] "."parts[2]
			GuiControl,,%c%,%inp%
		}
		Goto SubAll
	Return
	SubAll:
		Gui Submit,NoHide
		If StrLen(NK)=1
			NavigationKey:=NK
		If StrLen(SD)>0
			ShakeDelay:=SD
		If StrLen(DLRL)>0
			RestartDelay:=DLRL
		If StrLen(DLHR)>0
			RodCastDuration:=DLHR
		If StrLen(DLCR)>0
			CastRandomization:=DLCR
		If StrLen(DLWB)>0
			WaitForBobber:=DLWB
		If StrLen(WURL)>100
			WebhookURL:=WURL
		If StrLen(WHSK)>0
			NotifEveryN:=WHSK
		If StrLen(PSL)>32
			PrivateServer:=PSL
		If(CSHK!=StartHotkey){
			If Trim(CSHK)!=""&&CSHK!=CRHK&&CSHK!=CEHK{
				Hotkey % "$"StartHotkey,Off
				StartHotkey:=CSHK
				Hotkey % "$"CSHK,StartMacro
			}Else{
				GuiControl,,CSHK,%StartHotkey%
				ShowMsg("Hotkey in use")
			}
		}
		If(CRHK!=ReloadHotkey){
			If Trim(CRHK)!=""&&CRHK!=CSHK&&CRHK!=CEHK{
				Hotkey % "$"ReloadHotkey,Off
				ReloadHotkey:=CRHK
				Hotkey % "$"CRHK,ReloadMacro
			}Else{
				GuiControl,,CRHK,%ReloadHotkey%
				ShowMsg("Hotkey in use")
			}
		}
		If(CEHK!=ExitHotkey){
			If Trim(CEHK)!=""&&CEHK!=CSHK&&CEHK!=CRHK{
				Hotkey % "$"ExitHotkey,Off
				ExitHotkey:=CEHK
				Hotkey % "$"CEHK,ExitMacro
			}Else{
				GuiControl,,CEHK,%ExitHotkey%
				ShowMsg("Hotkey in use")
			}
		}
		ShakeMode:=DDSM
		AutoLowerGraphics:=CBLG
		AutoZoomInCamera:=CBZC
		AutoLookDownCamera:=CBLD
		AutoBlurShake:=CBBS
		AutoBlurMinigame:=CBBM
		ShutdownAfterFailLimit:=CBSF
		UseWebhook:=CBWH
		NotifyOnFailsafe:=CBNF
		ShakeOnly:=CBSO
		AutosaveSettings:=CBAS
		GuiAlwaysOnTop:=CBOT
		CheckLvlEveryN:=Max(5,CLEN)
		SendScreenshotFL:=CBSS
		NotifyImg:=CBSI
		ImgNotifEveryN:=SIEN
		LvlUpMode:=DDSS
		SelectedBound:=DDBN
		AutoSell:=CBGS
		SendSellProfit:=CBSP
		AutoSellInterval:=ASIG
		SendFishScreenshot:=CBFSS
		SendFishWhenTimeOn:=CBFTSO
		SendFishWhenTimeValue:=CBFTSV
		If Trim(DDBN)!=""
			Gosub SelectBound
		If CBCF
			FarmLocation:="cryo"
		Else
			FarmLocation:="none"
		buyConch:=CBBC
		If(DDSS!="Off")
			downloadTesseract()
		WinSet,AlwaysOnTop,%CBOT%,%GuiTitle%
		If CBAS
			Goto SaveSettings
	Return
	STRS:
		AskUser("Reset Settings","Are you sure?")
		IfMsgBox Yes
		{
			FileDelete,%SettingsPath%
			Goto DefaultSettings
		}
	Return
	STSV:
		AskUser("Save Settings","Overwrite old settings?")
		IfMsgBox Yes
			Goto SaveSettings
	Return
	MGCCF:
		Gui Submit,NoHide
		curMGFile:=MGCF
		Gosub UpdateMGVals
		Goto UpdateDisplay
	Return
	MGSave:
		Gui Submit,NoHide
		SplitPath,MGCF,,,,FileName
		MGConfig:="[Values]`nStabilizerLoop="MGSL "`nSideBarRatio="MGSR "`nSideBarWait="MGSW "`nRightMult="MGRM "`nRightDiv="MGRD "`nRightAnkleMult="MGAM "`nLeftMult="MGLM "`nLeftDiv="MGLD "`nCoefficient="MGCO "`nExponent="MGXP
		path:=DirPath "\Minigame\"FileName ".txt"
		FileDelete,%path%
		FileAppend,%MGConfig%,%path%
		Goto MGCCF
	Return
	MGExport:
		Gui Submit,NoHide
		isvalid:=True
		Gui +OwnDialogs
		InputBox,FileName,File name,Enter file name.,,170,140
		chars:="\\/:*?""<>| "
		Loop,Parse,chars
			If InStr(FileName,A_LoopField)
				isvalid:=False
		If RegExMatch(FileName,"i)^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])$")
			isvalid:=False
		If Trim(FileName)=""
			isvalid:=False
		If isvalid{
			isdupe:=False
			Loop %MGPath%\*.*{
				SplitPath,A_LoopFileName,,,,n
				If(n=FileName)
					isdupe:=True
			}
			MGConfig:="[Values]`nStabilizerLoop=10`nSideBarRatio=0.8`nSideBarWait=2`nRightMult=2.6`nRightDiv=1.4`nRightAnkleMult=1.2`nLeftMult=2.6`nLeftDiv=1.4`nCoefficient=1`nExponent=1"
			path:=DirPath "\Minigame\"FileName ".txt"
			If isdupe{
				AskUser("Duplicate Found","Overwrite this file?")
				IfMsgBox Yes
				{
					FileDelete,%path%
					FileAppend,%MGConfig%,%path%
				}
			}Else{
				FileDelete,%path%
				FileAppend,%MGConfig%,%path%
				newopt:=ScanForConfigs(FileName ".txt")
				GuiControl,,MGCF,|
				GuiControl,,MGCF,% newopt[1]
				Goto MGCCF
			}
		}Else{
			Gui +OwnDialogs
			MsgBox,16,Invalid,File name contains invalid character or is empty.
		}
	Return
	MGRefresh:
		Gui Submit,NoHide
		newopt:=ScanForConfigs(curMGFile)
		GuiControl,,MGCF,|
		GuiControl,,MGCF,% newopt[1]
		f:=(newopt[2]=1)?" file.":" files."
		ShowMsg("Found "newopt[2] f)
	Return
	MGOpen:
		Run % MGPath
	Return
	UpdateMGVals:
		cf:=ImportMinigameConfig(curMGFile)
		StabilizerLoop:=cf[1]
		SideBarRatio:=cf[2]
		SideBarWait:=cf[3]
		RightMult:=cf[4]
		RightDiv:=cf[5]
		RightAnkleMult:=cf[6]
		LeftMult:=cf[7]
		LeftDiv:=cf[8]
		Coefficient:=cf[9]
		Exponent:=cf[10]
	Return
	UpdateDisplay:
		cf:=ImportMinigameConfig(curMGFile)
		GuiControl,,MGSL,% cf[1]
		GuiControl,,MGSR,% cf[2]
		GuiControl,,MGSW,% cf[3]
		GuiControl,,MGRM,% cf[4]
		GuiControl,,MGRD,% cf[5]
		GuiControl,,MGAM,% cf[6]
		GuiControl,,MGLM,% cf[7]
		GuiControl,,MGLD,% cf[8]
		GuiControl,,MGCO,% cf[9]
		GuiControl,,MGXP,% cf[10]
	Return
	JG:
		Gui Submit,NoHide
		PS:="roblox://placeID=16732694052"
		If StrLen(PSL)>32
			PS:=PSL
		Run % PS
	Return
Return
GuiClose:
	Goto ExitMacro
