;11
#Include %A_MyDocuments%\Macro Settings\main.ahk
ImportMinigameConfig(name){
	Global MGPath
	path:=MGPath "\" name
	IniRead,StabilizerLoop,%path%,Values,StabilizerLoop,20
	IniRead,SideBarRatio,%path%,Values,SideBarRatio,0.8
	IniRead,SideBarWait,%path%,Values,SideBarWait,1.72
	IniRead,RightMult,%path%,Values,RightMult,2.6329
	IniRead,RightDiv,%path%,Values,RightDiv,1.8961
	IniRead,RightAnkleMult,%path%,Values,RightAnkleMult,1.36
	IniRead,LeftMult,%path%,Values,LeftMult,2.9892
	IniRead,LeftDiv,%path%,Values,LeftDiv,4.6235
	IniRead,Coefficient,%path%,Values,Coefficient,1.97109
	IniRead,Exponent,%path%,Values,Exponent,0.810929
	Return [StabilizerLoop,SideBarRatio,SideBarWait,RightMult,RightDiv,RightAnkleMult,LeftMult,LeftDiv,Coefficient,Exponent]
}
ScanForConfigs(cur){
	Global MGPath
	opt:=cur "||"
	cnt:=1
	Loop %MGPath%\*.*{
		item:=A_LoopFileName
		If(item!=cur&&Trim(item)!=""){
			opt.=item "|"
			cnt++
		}
	}
	Return [opt,cnt]
}
UpdateTask(t){
	GuiControl,Text,TTask,%t%
}
parseSettings(s){
	a:=StrSplit(s," ")
	For i,v in a
		If v is Number
			a[i]:=v+0
	Return a
}
GetTime(t,f:="{:}h {:02}m {:02}s"){
	Local H,M,S,A:=60,B:=A*A
	Return Format(f,H:=t//B,M:=(t:=t-H*B)//A,t-M*A,S:=H,S*A+M)
}
ShowMsg(t){
	Gui +OwnDialogs
	MsgBox % t
}
AskUser(a,b){
	Gui +OwnDialogs
	MsgBox,4,%a%,%b%
}
Chkd(b){
	Return b?"Checked":""
}
getCameraState(){
	EnvGet,LAD,LocalAppData
	logPath:=LAD "\Roblox\logs"
	t:=0
	file:=""
	Loop,%logPath%\*.log{
		If((ct:=A_LoopFileTimeModified)>=t&&SubStr(A_LoopFileName,-7,4)="last"){
			t:=ct
			file:=A_LoopFileFullPath
		}
	}
	FileRead,state,%file%
	state:=SubStr(state,InStr(state,"setting cinematic mode to ",False,0),32)
	Return InStr(state, "True")>0
}
CameraMode(t){
	Global AutoCameraDelay,CameraModeX,CameraModeY
	Sleep AutoCameraDelay
	If getCameraState()!=t
		Click %CameraModeX%,%CameraModeY%
	Sleep AutoCameraDelay
}
;leaving this here incase they remove the debugger
;CameraMode(t){
;	Global AutoCameraDelay,CameraCheckLeft,CameraCheckTop,CameraCheckRight,CameraCheckBottom,CameraModeX,CameraModeY
;	Sleep AutoCameraDelay
;	PixelSearch,,,CameraCheckLeft,CameraCheckTop,CameraCheckRight,CameraCheckBottom,0xFFFFFF,0,Fast
;	If !ErrorLevel=t
;		Click %CameraModeX%,%CameraModeY%
;	Sleep AutoCameraDelay
;}
FetchInstructions(){
	req:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	req.Open("GET","https://raw.githubusercontent.com/LopenaFollower/JavaScript/refs/heads/main/instructions.txt",1)
	req.Send()
	req.WaitForResponse()
	Return StrSplit(req.ResponseText,"`n")
}
SendStatus(st,info:=0){
	Global UseWebhook,WebhookURL,NotifyOnFailsafe,runtime2,SendScreenshot,FishBarLeft,FishBarRight,SellButtonBottom,FishBarBottom,SendFishScreenshot
	If UseWebhook&&StrLen(WebhookURL)>100{
		payload:=""
		FormatTime,ct,,hh:mm:ss
		elapsed:=GetTime(runtime2)
		req:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
		req.Open("POST",WebhookURL "?wait=true",0)
		req.SetRequestHeader("Content-Type","application/json")
		Switch st
		{
		case 0: req.Send("{""embeds"":[{""color"":5066239,""fields"":[],""title"":""Starting UI"",""footer"":{""text"":"""ct """}}]}")
		case 1: req.Send("{""embeds"":[{""color"":65280,""fields"":[],""title"":""Starting Macro"",""footer"":{""text"":"""ct """}}]}")
		case 2:
			tc:=info[1]
			req.Send("{""embeds"":[{""color"":16711680,""fields"":[{""name"":""Runtime"",""value"": """elapsed """},{""name"":""Total Catches"",""value"":"""tc """}],""title"":""Exiting Macro"",""footer"":{""text"":"""ct """}}]}")
		case 3:
			fc:=info[1]
			fl:=info[2]
			d:=info[3]
			s:=info[4]
			ratio:=fc " / "fl " ("RegExReplace(fc/(fc+fl)*100,"(?<=\.\d{3}).*$") "%)"
			dur:=RegExReplace(d,"(?<=\.\d{3}).*$")
			caught:=s?"Fish took "dur "s to catch.":"Spent "dur "s trying to catch the fish."
			if SendFishScreenshot {
				CameraMode(False)
				Sleep, 15
				CS2DC(FishBarLeft,SellButtonBottom,FishBarRight,FishBarBottom,"{""embeds"":[{""color"":15258703,""image"":{""url"":""attachment://screenshot.png""},""fields"":[{""name"":""Catch Rate"",""value"":"""ratio """},{""name"":""Fish was "(s?"Caught!":"Lost.") """,""value"":"""caught """},{""name"":""Runtime"",""value"": """elapsed """}],""footer"":{""text"":"""ct """}}]}")
				CameraMode(True)
			}
			else {
				req.Send("{""embeds"":[{""color"":15258703,""fields"":[{""name"":""Catch Rate"",""value"":"""ratio """},{""name"":""Fish was "(s?"Caught!":"Lost.") """,""value"":"""caught """},{""name"":""Runtime"",""value"": """elapsed """}],""footer"":{""text"":"""ct """}}]}")
			}
		case 4:
			FailsafeMessage:=info[1]
			Occurences:=info[2]
			If NotifyOnFailsafe
				req.Send("{""embeds"":[{""title"":""Failsafe Triggered! ("Occurences ")"",""description"":"""FailsafeMessage """,""color"":0,""fields"":[],""footer"":{""text"":"""ct """}}]}")
		case 5:
			lvl:=info[1]
			req.Send("{""embeds"":[{""color"":4848188,""fields"":[{""name"":""Level Up"",""value"": ""You are now level "lvl """}],""footer"":{""text"":"""ct """}}]}")
		}
	}
}
Wait(ms){
	DllCall("Sleep",uint,Max(.05,ms))
}
CaptureScreen(path,x,y,w,h){
	If !pT:=Gdip_Startup()
		Return False
	If !pB:=Gdip_BitmapFromScreen(x "|"y "|"w "|"h){
		Gdip_Shutdown(pT)
		Return False
	}
	If !Gdip_SaveBitmapToFile(pB,path){
		Gdip_DisposeImage(pB)
		Gdip_Shutdown(pT)
		Return False
	}
	Gdip_DisposeImage(pB)
	Gdip_Shutdown(pT)
	Return True
}
downloadTesseract(){
	Global TesseractPath,GuiAlwaysOnTop,GuiTitle
	If !FileExist(TesseractPath){
		Gui +OwnDialogs
		MsgBox,48,Tesseract Not Found,This feature requires Tesseract OCR to be installed. The script will now download and install it.
		InstallerPath:=A_Temp "\tesseract-installer.exe"
		UrlDownloadToFile,https://github.com/tesseract-ocr/tesseract/releases/download/5.5.0/tesseract-ocr-w64-setup-5.5.0.20241111.exe,%InstallerPath%
		If !FileExist(InstallerPath){
			Gui +OwnDialogs
			MsgBox,16,Error,Failed to download the Tesseract installer. Please check your internet connection and try again.
			GuiControl,ChooseString,DDSS,Off
		}
		WinSet,AlwaysOnTop,0,%GuiTitle%
		RunWait,%InstallerPath% /SILENT,,Hide
		WinSet,AlwaysOnTop,%GuiAlwaysOnTop%,%GuiTitle%
		If FileExist("C:\Program Files\Tesseract-OCR\tesseract.exe")
			MsgBox,64,Installation Complete,Tesseract OCR has been successfully installed!
		Else{
			MsgBox,16,Installation Failed,Tesseract OCR installation failed. Please install it manually at https://github.com/tesseract-ocr/tesseract.
			GuiControl,ChooseString,DDSS,Off
		}
	}
}
CS2DC(x1,y1,x2,y2,payload){
	Global WebhookURL
	tempFile:=A_Temp "\screenshot.png"
	CaptureScreen(tempFile,x1,y1,x2-x1,y2-y1)
	New CreateFormData({file:[tempFile],payload_json:payload},pd,hd)
	HTTP:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	HTTP.Open("POST",WebhookURL,0)
	HTTP.SetRequestHeader("Content-Type",hd)
	HTTP.Send(pd)
	FileDelete,%tempFile%
}
RtrvGen(k,v){
	Global SettingsPath
	IniRead,tmp,%SettingsPath%,All,%k%,%v%
	IniWrite,%tmp%,%SettingsPath%,All,%k%
}
WriteGen(k,v){
	Global SettingsPath
	IniWrite,%v%,%SettingsPath%,All,%k%
}
ReadGen(ByRef out,k){
	Global SettingsPath
	IniRead,temp,%SettingsPath%,All,%k%
	If temp is Number
		temp:=temp+0
	out:=temp
}
Class CreateFormData{
	__New(obj,ByRef rD,ByRef rH){
		Local CRLF:="`r`n",i,k,v,n,s,o,B28:="----------------------------"A_TickCount,B30:="--"B28
		this.L:=0,this.P:=DllCall("GlobalAlloc",uint,64,uint,1,"Ptr")
		For k,v in obj{
			If IsObject(v){
				For i,fn in v{
					n:=FileOpen(fn,"r").ReadUInt()
					this.SPutf8(s:=B30 CRLF "Content-Disposition:form-data;name="""k """;filename="""fn """"CRLF "Content-Type:"((n=0x474E5089)?"image/png":(n=0x38464947)?"image/gif":(n&0xFFFF=0x4D42)?"image/bmp":(n&0xFFFF=0xD8FF)?"image/jpeg":(n&0xFFFF=0x4949)?"image/tiff":(n&0xFFFF=0x4D4D)?"image/tiff":"application/octet-stream")CRLF CRLF)
					o:=FileOpen(fn,"r")
					this.P:=DllCall("GlobalReAlloc","Ptr",this.P,uint,this.L+=o.Length,uint,66)
					o.RawRead(this.P+this.L-o.length,o.length),o.Close()
					this.SPutf8(CRLF)
				}
			}Else
				this.SPutf8(s:=B30 CRLF "Content-Disposition:form-data;name="""k """"CRLF CRLF v CRLF)
		}
		this.SPutf8(B30 "--"CRLF)
		DllCall("RtlMoveMemory","Ptr",NumGet(ComObjValue(rD:=ComObjArray(16,this.L))+8+A_PtrSize),"Ptr",this.P,"Ptr",this.L)
		DllCall("GlobalFree","Ptr",this.P,"Ptr")
		rH:="multipart/form-data;boundary="B28
	}
	SPutf8(s){
		StrPut(s,(this.P:=DllCall("GlobalReAlloc","Ptr",this.P,uint,(this.L+=(R:=StrPut(s,"utf-8")-1))+1,uint,66))+this.L-R,R,"utf-8")
	}
}
