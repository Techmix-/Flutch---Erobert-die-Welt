#include "_Const.au3"
#include-once
#RequireAdmin

#cs ================================================================================================================================
==== ChangeLog =====================================================================================================================
====================================================================================================================================

 AutoIt Version: 	3.3.7.23 (beta)
 Skript:			_Misc.au3
 Author:         	Techmix

##	--------------------------------------------------------------------------------------------------------------------------------

	Miscfunctions

	Ausgelagerte Mapping-Funktionen


##	--------------------------------------------------------------------------------------------------------------------------------

		V0.11:
	Main-Title (AtWork)

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.10:
	SetUp Panel

##	================================================================================================================================
#ce

#Region -UDF-Variablen--------------------------------------------------------------------------------------------------------------



#EndRegion -UDF-Variablen-----------------------------------------------------------------------------------------------------------


#Region -Hauptfunktionen-------------------------------------------------------------------------------------------------------------



#EndRegion -Hauptfunktionen----------------------------------------------------------------------------------------------------------

Func _FirstStart()
	Local $Form1 = "", $Label1 = ""

	Local $s_Path_SQLFile = @ScriptDir & "\data\game\Game.db"
	if not FileExists($s_Path_SQLFile) then
		$Form1 = GUICreate("Flutch - Erobert die Welt", 405, 225, -1, -1, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
		$Label1 = GUICtrlCreateLabel("", 8, 8, 388, 209, $WS_BORDER)
		GUICtrlSetData($Label1, "Flutch - Erobert die Welt"&@CRLF&@CRLF)
		$txt=GUICtrlRead($Label1)
		GUICtrlSetData($Label1, $txt&"Data Setup"&@CRLF&@CRLF)
		GUISetState(@SW_SHOW)
		Sleep(1000)

		$txt=GUICtrlRead($Label1)
		GUICtrlSetData($Label1, $txt&"    Schreibe: 'Game.db'"&@CRLF)
		__MakeNewSQL()
	EndIf
	__BaseDBData()

	Local $a_Maps = _GettingData("$e_Map_Name", "", 1)
	for $i = 1 to UBound($a_Maps)-1
		$s_File = $a_Path[$e_Path_Map]&$a_Maps[$i][0]
		if not FileExists($s_File) or $s_MakeAllMaps = 1 Then
			if $Form1 = "" Then
				$Form1 = GUICreate("Flutch - Data Setup", 405, 225, -1, -1, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
				$Label1 = GUICtrlCreateLabel("", 8, 8, 388, 209, $WS_BORDER)
				GUICtrlSetData($Label1, "Flutch - Erobert die Welt"&@CRLF&@CRLF)
				$txt=GUICtrlRead($Label1)
				GUICtrlSetData($Label1, $txt&"Data Setup"&@CRLF&@CRLF)
				GUISetState(@SW_SHOW)
				Sleep(1000)
			EndIf
			$txt=GUICtrlRead($Label1)
			GUICtrlSetData($Label1, $txt&"    Erstelle Map: '"&$a_Maps[$i][1]&"'"&@CRLF)
			if FileExists($a_Path[$e_Path_Map]&$a_Maps[$i][1]) then __ReadMapfile($a_Maps[$i][1])
			__MakeMap($a_Maps[$i][1])
		EndIf
	Next

	if $Form1 <> "" Then
		$txt=GUICtrlRead($Label1)
		GUICtrlSetData($Label1, $txt&@CRLF&"...Fertig!"&@CRLF)
		Sleep(5000)
		GUIDelete($Form1)
	EndIf
EndFunc

Func _ShowPanel()
	__ConsoleWrite("_Misc: _ShowPanel()"&@CRLF)
	#Region ### START Koda GUI *schäm*
	$Form1 = GUICreate("Settings "&$a_System[$e_Sys_GameVersion], 386, 203, -1, -1, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
	$Group1 = GUICtrlCreateGroup("Renderer", 8, 8, 369, 49)
	GUICtrlSetColor(-1, 0x0054E3)
	$Combo1 = GUICtrlCreateCombo("", 24, 24, 337, 25)
	GUICtrlSetData(-1, "Software|OpenGL|Direct3D8|Direct3D9", "Direct3D9")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Group2 = GUICtrlCreateGroup("Display Mode", 8, 64, 369, 97)
	GUICtrlSetColor(-1, 0x0054E3)
	$Checkbox1 = GUICtrlCreateCheckbox("Full-Screen", 16, 88, 105, 17)
	$Checkbox2 = GUICtrlCreateCheckbox("V-Sync", 136, 88, 105, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$Checkbox3 = GUICtrlCreateCheckbox("Double-Buffer", 256, 88, 105, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$Checkbox4 = GUICtrlCreateCheckbox("Use Shadows", 16, 112, 105, 17)
	$Checkbox5 = GUICtrlCreateCheckbox("Use FPU", 136, 112, 105, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$Checkbox6 = GUICtrlCreateCheckbox("Extended Shaders", 256, 112, 105, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$Combo2 = GUICtrlCreateCombo("Resolution", 16, 132, 105, 25)
	GUICtrlSetData(-1, "640x480|800x600|1024x768|1280x1024", "800x600")
	$Combo3 = GUICtrlCreateCombo("Use32Bit", 136, 132, 105, 25)
	GUICtrlSetData(-1, "0|1", "1")
	$Combo4 = GUICtrlCreateCombo("Antialias", 256, 132, 105, 25)
	GUICtrlSetData(-1, "0|2|4|8|16", "0")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Button1 = GUICtrlCreateButton("Weiter", 8, 168, 91, 25, $WS_GROUP)
	$Checkbox7 = GUICtrlCreateCheckbox("Dieses Panel nicht mehr zeigen", 104, 172, 177, 17, -1, $WS_EX_STATICEDGE)
	$Button2 = GUICtrlCreateButton("Abbruch", 285, 168, 91, 25, $WS_GROUP)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI

	#Region ### Get Data
	; Full-Screen
	if $a_System[$e_Sys_Fullscreen] = "" then $a_System[$e_Sys_Fullscreen] = $IRR_WINDOWED
	if $a_System[$e_Sys_Fullscreen] = $IRR_WINDOWED then
		GUICtrlSetState($Checkbox1, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Checkbox1, $GUI_CHECKED)
	EndIf
	; V-Sync
	if $a_System[$e_Sys_VSync] = "" then $a_System[$e_Sys_VSync] = $IRR_VERTICAL_SYNC_ON
	if $a_System[$e_Sys_VSync] = $IRR_VERTICAL_SYNC_ON then
		GUICtrlSetState($Checkbox2, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox2, $GUI_UNCHECKED)
	EndIf
	; Double-Buffer
	if $a_System[$e_Sys_DoubleBuffer] = "" then $a_System[$e_Sys_DoubleBuffer] = $IRR_ON
	if $a_System[$e_Sys_DoubleBuffer] = $IRR_OFF then
		GUICtrlSetState($Checkbox3, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Checkbox3, $GUI_CHECKED)
	EndIf
	; Use Shadows
	if $a_System[$e_Sys_Shadows] = "" then $a_System[$e_Sys_Shadows] = $IRR_NO_SHADOWS
	if $a_System[$e_Sys_Shadows] = $IRR_NO_SHADOWS then
		GUICtrlSetState($Checkbox4, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Checkbox4, $GUI_CHECKED)
	EndIf
	; Use FPU
	if $a_System[$e_Sys_HighPrecisionFpu] = "" then $a_System[$e_Sys_HighPrecisionFpu] = $IRR_ON
	if $a_System[$e_Sys_HighPrecisionFpu] = $IRR_ON then
		GUICtrlSetState($Checkbox5, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox5, $GUI_UNCHECKED)
	EndIf
	; Extended Shaders
	if $a_System[$e_Sys_ExtendedShaders] = "" then $a_System[$e_Sys_ExtendedShaders] = $IRR_OFF
	if $a_System[$e_Sys_ExtendedShaders] = $IRR_ON then
		GUICtrlSetState($Checkbox6, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox6, $GUI_UNCHECKED)
	EndIf
	; Panel
	if $a_System[$e_Sys_ShowPanel] = "" then $a_System[$e_Sys_ShowPanel] = 1
	if $a_System[$e_Sys_ShowPanel] = 1 then
		GUICtrlSetState($Checkbox7, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Checkbox7, $GUI_CHECKED)
	EndIf
	; DeviceType
	if $a_System[$e_Sys_DeviceType] = "" then $a_System[$e_Sys_DeviceType] = "Direct3D9"
	if $a_System[$e_Sys_DeviceType] = $IRR_EDT_SOFTWARE2 then $a_System[$e_Sys_DeviceType] = "Software"
	if $a_System[$e_Sys_DeviceType] = $IRR_EDT_OPENGL then $a_System[$e_Sys_DeviceType] = "OpenGL"
	if $a_System[$e_Sys_DeviceType] = $IRR_EDT_DIRECT3D8 then $a_System[$e_Sys_DeviceType] = "Direct3D8"
	if $a_System[$e_Sys_DeviceType] = $IRR_EDT_DIRECT3D9 then $a_System[$e_Sys_DeviceType] = "Direct3D9"
	GUICtrlSetData($Combo1, "")
	GUICtrlSetData($Combo1, "Software|OpenGL|Direct3D8|Direct3D9", $a_System[$e_Sys_DeviceType])
	; Resolution
	if $a_System[$e_Sys_ScreenWidth] = "" then $a_System[$e_Sys_ScreenWidth] = 800
	if $a_System[$e_Sys_ScreenHeight] = "" then $a_System[$e_Sys_ScreenHeight] = 600
	GUICtrlSetData($Combo2, "")
	GUICtrlSetData($Combo2, "Resolution|640x480|800x600|1024x768|1280x1024", $a_System[$e_Sys_ScreenWidth]&"x"&$a_System[$e_Sys_ScreenHeight])
	; 32Bit
	if $a_System[$e_Sys_Use32Bit] = "" then $a_System[$e_Sys_Use32Bit] = $IRR_BITS_PER_PIXEL_32
	Local $tmp_Use32Bit =0
	if $a_System[$e_Sys_Use32Bit] = $IRR_BITS_PER_PIXEL_32 then $tmp_Use32Bit = 1
	GUICtrlSetData($Combo3, "")
	GUICtrlSetData($Combo3, "Use32Bit|0|1", $tmp_Use32Bit)
	; Antialias
	if $a_System[$e_Sys_Antialias] = "" then $a_System[$e_Sys_Antialias] = 0
	GUICtrlSetData($Combo4, "")
	GUICtrlSetData($Combo4, "Antialias|0|2|4|8|16", $a_System[$e_Sys_Antialias])
	#EndRegion ### Get Data


	while 1
		; Full-Screen
		if GUICtrlRead($Checkbox1) = $GUI_CHECKED Then
			if GUICtrlRead($Combo2) <> @DesktopWidth&"x"&@DesktopHeight Then
				GUICtrlSetState($Combo2, $GUI_DISABLE)
				GUICtrlSetData($Combo2, "")
				GUICtrlSetData($Combo2, "Resolution|"&@DesktopWidth&"x"&@DesktopHeight, @DesktopWidth&"x"&@DesktopHeight)
			EndIf
		Else
			if GUICtrlGetState($Combo2) = 144 Then
				GUICtrlSetState($Combo2, $GUI_ENABLE)
				GUICtrlSetData($Combo2, "")
				GUICtrlSetData($Combo2, "Resolution|640x480|800x600|1024x768|1280x1024", "800x600")
			EndIf
		EndIf

;~ 		; 32Bit
;~ 		if GUICtrlRead($Combo3) = "32Bit" Then
;~ 			GUICtrlSetData($Combo3, "")
;~ 			GUICtrlSetData($Combo3, "32Bit|16|32", "32")
;~ 		EndIf

;~ 		; Antialias
;~ 		if GUICtrlRead($Combo4) = "Antialias" Then
;~ 			GUICtrlSetData($Combo4, "")
;~ 			GUICtrlSetData($Combo4, "Antialias|0|2|4|8|16", "0")
;~ 		EndIf

		$s_GUI_Msg = GUIGetMsg()
		Switch $s_GUI_Msg
			Case $GUI_EVENT_CLOSE ; Close
				Exit
			Case $Button2 ; Abbruch
				Exit
			Case $Button1 ; Weiter
				ExitLoop
		EndSwitch

		Sleep(5)
	WEnd

	#Region ### Set Data
	; Full-Screen
	If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then
		$a_System[$e_Sys_Fullscreen] = $IRR_FULLSCREEN
	Else
		$a_System[$e_Sys_Fullscreen] = $IRR_WINDOWED
	EndIf
	; V-Sync
	If GUICtrlRead($Checkbox2) = $GUI_CHECKED Then
		$a_System[$e_Sys_VSync] = $IRR_VERTICAL_SYNC_ON
	Else
		$a_System[$e_Sys_VSync] = $IRR_VERTICAL_SYNC_OFF
	EndIf
	; Double-Buffer
	If GUICtrlRead($Checkbox3) = $GUI_CHECKED Then
		$a_System[$e_Sys_DoubleBuffer] = $IRR_ON
	Else
		$a_System[$e_Sys_DoubleBuffer] = $IRR_OFF
	EndIf
	; Use Shadows
	If GUICtrlRead($Checkbox4) = $GUI_CHECKED Then
		$a_System[$e_Sys_Shadows] = $IRR_SHADOWS
	Else
		$a_System[$e_Sys_Shadows] = $IRR_NO_SHADOWS
	EndIf
	; Use FPU
	If GUICtrlRead($Checkbox5) = $GUI_CHECKED Then
		$a_System[$e_Sys_HighPrecisionFpu] = $IRR_ON
	Else
		$a_System[$e_Sys_HighPrecisionFpu] = $IRR_OFF
	EndIf
	; Extended Shaders
	If GUICtrlRead($Checkbox6) = $GUI_CHECKED Then
		$a_System[$e_Sys_ExtendedShaders] = $IRR_ON
	Else
		$a_System[$e_Sys_ExtendedShaders] = $IRR_OFF
	EndIf
	; Panel
	If GUICtrlRead($Checkbox7) = $GUI_CHECKED Then $a_System[$e_Sys_ShowPanel] = 0
	; DeviceType
	$a_System[$e_Sys_DeviceType] = GUICtrlRead($Combo1)
	if $a_System[$e_Sys_DeviceType] = "Software" then $a_System[$e_Sys_DeviceType] = $IRR_EDT_SOFTWARE2
	if $a_System[$e_Sys_DeviceType] = "OpenGL" then $a_System[$e_Sys_DeviceType] = $IRR_EDT_OPENGL
	if $a_System[$e_Sys_DeviceType] = "Direct3D8" then $a_System[$e_Sys_DeviceType] = $IRR_EDT_DIRECT3D8
	if $a_System[$e_Sys_DeviceType] = "Direct3D9" then $a_System[$e_Sys_DeviceType] = $IRR_EDT_DIRECT3D9
	; Resolution
	$tmp_Resolution = GUICtrlRead($Combo2)
	$tmp_Resolution = StringSplit($tmp_Resolution, "x")
	$a_System[$e_Sys_ScreenWidth] = $tmp_Resolution[1]
	$a_System[$e_Sys_ScreenHeight] = $tmp_Resolution[2]
	; 32Bit
	$a_System[$e_Sys_Use32Bit] = GUICtrlRead($Combo3)
	if $a_System[$e_Sys_Use32Bit] = 0 then $a_System[$e_Sys_Use32Bit] = $IRR_BITS_PER_PIXEL_16
	if $a_System[$e_Sys_Use32Bit] = 1 then $a_System[$e_Sys_Use32Bit] = $IRR_BITS_PER_PIXEL_32
	; Antialias
	$a_System[$e_Sys_Antialias] = GUICtrlRead($Combo4)

	_SettingData("$e_Sys_Fullscreen", $a_System[$e_Sys_Fullscreen])
	_SettingData("$e_Sys_VSync", $a_System[$e_Sys_VSync])
	_SettingData("$e_Sys_ShowPanel", $a_System[$e_Sys_ShowPanel])
	_SettingData("$e_Sys_DoubleBuffer", $a_System[$e_Sys_DoubleBuffer])
	_SettingData("$e_Sys_Shadows", $a_System[$e_Sys_Shadows])
	_SettingData("$e_Sys_HighPrecisionFpu", $a_System[$e_Sys_HighPrecisionFpu])
	_SettingData("$e_Sys_ExtendedShaders", $a_System[$e_Sys_ExtendedShaders])
	_SettingData("$e_Sys_DeviceType", $a_System[$e_Sys_DeviceType])
	_SettingData("$e_Sys_ScreenWidth", $a_System[$e_Sys_ScreenWidth])
	_SettingData("$e_Sys_ScreenHeight", $a_System[$e_Sys_ScreenHeight])
	_SettingData("$e_Sys_Use32Bit", $a_System[$e_Sys_Use32Bit])
	_SettingData("$e_Sys_Antialias", $a_System[$e_Sys_Antialias])
	_SettingData("$e_Sys_GameVersion", $a_System[$e_Sys_GameVersion])
	#EndRegion ### Set Data
	GUIDelete($Form1)
EndFunc

Func _Intro()

EndFunc

Func _MainMenu()
	__ConsoleWrite("_Misc: _MainMenu()"&@CRLF)

	; 'Main.Title' Auslesen
	Local $a_TitleData
	_FileReadToArray($a_Path[$e_Path_Gfx] & "MainTitle\Main.title", $a_TitleData)
	Local $a_Images[$a_TitleData[0]][2]
	for $i = 0 to UBound($a_Images)-1
		$tmp = StringSplit($a_TitleData[$i+1], "=", 1)
		$a_Images[$i][0] 	= $tmp[1]
		if $i > 0 then $a_Images[$i][1] 	= _IrrGetTexture($a_Path[$e_Path_Gfx] & "MainTitle\"&$tmp[2])
		if $i = 0 then $a_Images[$i][1] 	= $tmp[2]
	Next

	; Buttons Suchen
	Local $i_BackgroundGfx= _ArraySearch($a_Images, "BackgroundGfx"), _
		$i_IntroPic		= _ArraySearch($a_Images, "IntroPic"), _
		$i_ButtonOK		= _ArraySearch($a_Images, "ButtonOK"), _
		$i_ButtonAbbruch= _ArraySearch($a_Images, "ButtonAbbruch"), _
		$i_ButtonInfo	= _ArraySearch($a_Images, "ButtonInfo"), _
		$i_ButtonConfig	= _ArraySearch($a_Images, "ButtonConfig"), _
		$i_ButtonChat	= _ArraySearch($a_Images, "ButtonChat"), _
		$i_BackgroundMap= _ArraySearch($a_Images, "BackgroundMap"), _
		$i_ButtonPosX	= $a_System[$e_Sys_ScreenWidth]/6, _
		$i_ButtonPosY	= $a_System[$e_Sys_ScreenHeight]-152

	; IntroPic Anzeigen *ALPHA*
	_IrrBeginScene(0,0,0)
	_IrrDrawScene()
	$irr_IntroPic = _IrrDraw2DImageElementStretch($a_Images[$i_IntroPic][1], 0, 0, $a_System[$e_Sys_ScreenWidth], $a_System[$e_Sys_ScreenHeight], 0, 0, 960, 540, $IRR_USE_ALPHA)
	_IrrEndScene()
	Sleep(1500)

	; Init Data
;~ 	_Camera("CiC")
	_Camera("RPG")
	_LoadLevel("TitleMap")

	Local $i__ScaleMap = $s_ScaleXY, $aPoint = _IrrGetNodePosition($a_PlayerData[0][$e_Player_Node])
	Local $i_PosX, $i_PosY
	do
		$i_PosX = Random($aPoint[0]-25*$i__ScaleMap,$aPoint[0]+25*$i__ScaleMap,1)
		$i_PosY = Random($aPoint[2]-25*$i__ScaleMap,$aPoint[2]+25*$i__ScaleMap,1)
	Until ($i_PosX > 100*$i__ScaleMap and $i_PosX < 900*$i__ScaleMap) and ($i_PosY > 100*$i__ScaleMap and $i_PosY < 900*$i__ScaleMap)
	_Automatic_Movement($a_PlayerData[0][$e_Player_Node], $i_PosX, $i_PosY)
	_Control()

	_IrrRemoveTexture($irr_IntroPic)

	; Haupt-Schleife
	WHILE _IrrRunning()
		_IrrBeginSceneAdvanced(_IrrMakeARGB(0,0,0,0))
		_IrrDrawScene()


;~ 		_Automatic_Movement($a_PlayerData[0][$e_Player_Node])
;~ 		_Control()
;~ 		_Camera()

		; Title Animation
		_DrawTitle()

		; Buttons Zeichnen
		_IrrDraw2DImageElementStretch($a_Images[$i_BackgroundGfx][1], $i_ButtonPosX, $i_ButtonPosY, $i_ButtonPosX*5, $i_ButtonPosY + 128, 0, 0, $i_ButtonPosX*5, 128, $IRR_USE_ALPHA)
		_IrrDraw2DImageElementStretch($a_Images[$i_ButtonOK][1], $i_ButtonPosX, $i_ButtonPosY, $i_ButtonPosX + 128, $i_ButtonPosY + 128, 0, 0, 128, 128, $IRR_USE_ALPHA)
		_IrrDraw2DImageElementStretch($a_Images[$i_ButtonAbbruch][1], $i_ButtonPosX*2, $i_ButtonPosY, $i_ButtonPosX*2 + 128, $i_ButtonPosY + 128, 0, 0, 128, 128, $IRR_USE_ALPHA)
		_IrrDraw2DImageElementStretch($a_Images[$i_ButtonInfo][1], $i_ButtonPosX*3, $i_ButtonPosY, $i_ButtonPosX*3 + 128, $i_ButtonPosY + 128, 0, 0, 128, 128, $IRR_USE_ALPHA)
		_IrrDraw2DImageElementStretch($a_Images[$i_ButtonChat][1], $i_ButtonPosX*4, $i_ButtonPosY, $i_ButtonPosX*4 + 128, $i_ButtonPosY + 128, 0, 0, 128, 128, $IRR_USE_ALPHA)

		_IrrEndScene()
	WEND


	; Release MainTitle
	for $i = 0 to UBound($a_Images)-1
		_IrrRemoveTexture($a_Images[$i][1])
	Next
	$a_Images=0
	_LoadLevel(-1)	; Release Level
	_LoadPlayer(-1)	; Release Player
EndFunc

#Region -Unterfunktionen------------------------------------------------------------------------------------------------------------

Func _DrawTitle()

EndFunc

#EndRegion -Unterfunktionen---------------------------------------------------------------------------------------------------------
