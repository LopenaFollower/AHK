init:
#NoEnv
#SingleInstance, Force
#Persistent	
#HotKeyInterval 1
#MaxHotkeysPerInterval 256
version = 2.7
traytip, %version%, Running!, 1, 1
Menu, tray, NoStandard
Menu, tray, Tip, Sharpshooter %version%
Menu, tray, Add, Sharpshooter %version%, return
Menu, tray, Add, Exit, exit
SetKeyDelay,-1, 1
SetControlDelay, -1
SetMouseDelay, -1
SetWinDelay,-1
SendMode, InputThenPlay
SetBatchLines,-1
ListLines, Off
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, High
;0x0BD700
EMCol := 0xE600E6
CenterX := (A_ScreenWidth // 2)
CenterY := (A_ScreenHeight // 2)
CFovX := (A_ScreenWidth // 8)
CFovY := (A_ScreenHeight // 6)
ScanL := CenterX - CFovX
ScanT := CenterY - CFovY // 3
ScanR := CenterX + CFovX
ScanB := CenterY + CFovY
NearAimScanL := CenterX - 2
NearAimScanT := CenterY - 2
NearAimScanR := CenterX
NearAimScanB := CenterY
intensity := 1.5
running := false
updateStatus(false)
Loop{
	if running{
		PixelSearch, AimPixelX, AimPixelY, NearAimScanL, NearAimScanT, NearAimScanR, NearAimScanB, EMCol, 1, Fast RGB

		if (!ErrorLevel=0) {
			PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EMCol, 1, Fast RGB
			AimX := AimPixelX - CenterX
			AimY := AimPixelY - CenterY + 15
			if( Abs(AimX) > 100){
				intensity := 1.4
			}
			if( Abs(AimX) > 10 && intensity > 2.4){
				intensity -= .5
			}
			DirX := -1
			DirY := -1
			if ( AimX > 0 ) {
				DirX := 1
			}
			if ( AimY > 0 ) {
				DirY := 1
			}
			AimOffsetX := AimX * DirX
			AimOffsetY := AimY * DirY
			MoveX := Floor(( AimOffsetX ** ( 1 / intensity ))) * DirX * 1.5
			MoveY := Floor(( AimOffsetY ** ( 1 / 2 ))) * DirY
			if( Abs(MoveX) < 1.75 ){
				MoveX := 0
			}else{
				if( intensity < 5 ) {
					intensity += 0.05
				}
			}
			DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
		}
	}
}
updateStatus(r){
	color := 0x00ff00
	if(!r){
		color := 0xff0000
	}
	gy := A_ScreenHeight - 5
	Gui, 1:Destroy
	Gui, 1:-Caption +AlwaysOnTop +ToolWindow
	Gui, 1:Color, %color%
	Gui, 1:Show, x0 y%gy% w5 h5
}
`::
	running := !running
	updateStatus(running)
	Sleep, 50
	Click
return
Pause:: pause
return:
goto, init
 
exit:
exitapp