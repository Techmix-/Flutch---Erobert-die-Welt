#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Outfile=Mapper.exe
#AutoIt3Wrapper_Res_Description=THE Editor
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_Field=Programmversion|V0.06
#AutoIt3Wrapper_Res_Field=by|Team ???
#AutoIt3Wrapper_Res_Field=Original Name|Mapper.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include-once
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <GUIListBox.au3>
#include <GuiToolbar.au3>
#include <ImageListConstants.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <ToolbarConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <GuiTab.au3>
#include "include\IncludeAll.au3"

#cs ================================================================================================================================
==== ChangeLog =====================================================================================================================
====================================================================================================================================

 AutoIt Version: 	3.3.7.23 (beta)
 Skript:			Mapper.au3
 Author:         	Techmix

##	--------------------------------------------------------------------------------------------------------------------------------

	Mapper - THE Editor

	Hauptfunktionen für dem Mapper


##	--------------------------------------------------------------------------------------------------------------------------------

		V0.06:
	Fast alle Bug´s entfernt... thx 2 Cotec :D
	Mapper GUI V2.0
	Blurring Bug Entfernt
	'Flutch-BigFail' Entfernt
	'Weiße Texturen' Bug entfernt
	SessionLoader erweitert
	Resize Vergrößerung Fehlerfrei
	Mappingsystem erweitert und verbessert
	__FillAutoFlipRotate Fehlerfrei
	__CombineBitmaps2to1 zugefügt
	__CombineBitmaps4to1 zugefügt
	__MakeAlpha zugefügt (ALPHA)

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.05:
	Mapper-Basisfunktion erstellt

##	================================================================================================================================
#ce

;~ opt("MustDeclareVars", True)
Opt("GUIResizeMode", $GUI_DOCKLEFT+$GUI_DOCKTOP)
HotKeySet("{ESC}", "__Exit")

#Region -Variablen------------------------------------------------------------------------------------------------------------------

; ----------------------------------------------------------------------------------------------------------------------------------
;	Globals
; ----------------------------------------------------------------------------------------------------------------------------------

; Main
Global $irr_Handle, $Movement=0, $__GUIStarterSelectFromMap=0, $__Automatic_Movement=0
	$s_MakeAllMaps = 1

; Settings BackUps
Global $BackUp_Data[128], $__MapSizes[13] = [64,128,256,384,512,768,1024,1536,2048,3072,4096,6144,8192]


; Mapper-Main
Global $MapperGUI, $Mapper_ToolBar, $Mapper_Group0, $Mapper_Group1, $Mapper_Group2, $Mapper_Group3, $Mapper_Edit1, $Mapper_Edit2, _
	$MenuItem1, $MenuItem2, $MenuItem3, $MenuItem4, $MenuItem5, $MenuItem6
Enum $ToolBar_New=1000, $ToolBar_Open, $ToolBar_Save, $ToolBar_Exit, $ToolBar_Layer1, $ToolBar_Layer2, $ToolBar_Settings, $ToolBar_Char

; Mapper-MainTab
Global $Mapper_Tab

; Mapper-Datei
; Datei-Neu
Global $FileNew_Button0, _
	$File_Group1, $FileNew_Label1, $FileNew_Input1, $FileNew_Button1, $FileNew_Label2, $FileNew_Input2, $FileNew_Label3, $FileNew_Slider3, $FileNew_Input3, _
	$FileNew_Slider4, $FileNew_Label4, $FileNew_Input4, $FileNew_Label5, $FileNew_Slider5, $FileNew_Input5, $FileNew_Slider6, $FileNew_Label6, $FileNew_Input6
; Datei-Laden
Global $File_Group2, _
	$FileOpen_Group1, $FileOpen_Label1, $FileOpen_Button1
; Datei-Speichern
Global $FileSave_Button0, _
	$File_Group3, $FileSave_Label1, $FileSave_Input1, $FileSave_Label2, $FileSave_Input2, $FileSave_Label3, $FileSave_Slider3, $FileSave_Input3, _
	$FileSave_Slider4, $FileSave_Label4, $FileSave_Input4, $FileSave_Label5, $FileSave_Slider5, $FileSave_Input5, $FileSave_Slider6, $FileSave_Label6, $FileSave_Input6, $FileSave_Slider7, $FileSave_Label7, $FileSave_Input7, _
	$FileSave_Group1, $FileSave_Checkbox1, $FileSave_Checkbox2, $FileSave_Checkbox3, $FileSave_Button1, $FileSave_Button2, $FileSave_Button3, _
	$FileSave_Group2, $FileSave_Checkbox4, $FileSave_Checkbox5, $FileSave_Checkbox6, $FileSave_Button4, $FileSave_Button5, $FileSave_Button6, _
	$FileSave_Group3, $FileSave_Checkbox7, $FileSave_Checkbox8, $FileSave_Button7, $FileSave_Button8

; Mapper-Layer1
; HightMap
Global $HightMap_Button0, $HightMap_Button1, $HightMap_Button2, $HightMap_Button3, _
	$HightMap_Group1, _
	$HightMap_Slider10, $HightMap_Label10, $HightMap_Input10, $HightMap_Slider11, $HightMap_Label11, $HightMap_Input11, $HightMap_Slider12, $HightMap_Label12, $HightMap_Input12, $HightMap_Slider13, $HightMap_Label13, $HightMap_Input13, $HightMap_Checkbox11, $HightMap_Checkbox11, _
	$HightMap_Checkbox10, $HightMap_Slider14, $HightMap_Label14, $HightMap_Input14, $HightMap_Slider15, $HightMap_Label15, $HightMap_Input15, _
	$HightMap_Group2, _
	$HightMap_Checkbox2, $HightMap_Checkbox20, $HightMap_Slider20, $HightMap_Label20, $HightMap_Input20, $HightMap_Slider21, $HightMap_Label21, $HightMap_Input21, $HightMap_Slider22, $HightMap_Label22, $HightMap_Input22, $HightMap_Slider23, $HightMap_Label23, $HightMap_Input23, _
	$HightMap_Label24, $HightMap_Input24, $HightMap_Button24, $HightMap_Label25, $HightMap_Input25, $HightMap_Button25, $HightMap_Slider26, $HightMap_Label26, $HightMap_Input26, _
	$HightMap_Group3, _
	$HightMap_Checkbox3, $HightMap_Slider30, $HightMap_Label30, $HightMap_Input30, $HightMap_Slider31, $HightMap_Label31, $HightMap_Input31, $HightMap_Slider32, $HightMap_Label32, $HightMap_Input32, $HightMap_Button33, $HightMap_Label33, $HightMap_Input33, _
	$HightMap_Label34, $HightMap_Input34, $HightMap_Button34, $HightMap_Label35, $HightMap_Input35, $HightMap_Button35, $HightMap_Label36, $HightMap_Input36, $HightMap_Slider36
; ColorMap
Global $ColorMap_Button0, $ColorMap_Button1, $ColorMap_Button2, $ColorMap_Button3, _
	$ColorMap_Group1, _
	$ColorMap_Checkbox10, $ColorMap_Slider12, $ColorMap_Label12, $ColorMap_Input12, $ColorMap_Slider13, $ColorMap_Label13, $ColorMap_Input13, _
	$ColorMap_Slider10, $ColorMap_Label10, $ColorMap_Input10, $ColorMap_Slider11, $ColorMap_Label11, $ColorMap_Input11, $ColorMap_Slider14, $ColorMap_Label14, $ColorMap_Input14, $ColorMap_Button15, $ColorMap_Label15, $ColorMap_Input15, _
	$ColorMap_Group2, _
	$ColorMap_Checkbox2, $ColorMap_Checkbox20, $ColorMap_Slider20, $ColorMap_Label20, $ColorMap_Input20, $ColorMap_Slider21, $ColorMap_Label21, $ColorMap_Input21, $ColorMap_Slider22, $ColorMap_Label22, $ColorMap_Input22, _
	$ColorMap_Label23, $ColorMap_Input23, $ColorMap_Button23, $ColorMap_Label24, $ColorMap_Input24, $ColorMap_Button24, _
	$ColorMap_Group3, _
	$ColorMap_Checkbox3, $ColorMap_Checkbox30, $ColorMap_Slider30, $ColorMap_Label30, $ColorMap_Input30, $ColorMap_Slider31, $ColorMap_Label31, $ColorMap_Input31, $ColorMap_Slider32, $ColorMap_Label32, $ColorMap_Input32, _
	$ColorMap_Label33, $ColorMap_Input33, $ColorMap_Button33, $ColorMap_Label34, $ColorMap_Input34, $ColorMap_Button34, $ColorMap_Label35, $ColorMap_Input35, $ColorMap_Button35, _
	$ColorMap_Label36, $ColorMap_Input36, $ColorMap_Button36, $ColorMap_Label37, $ColorMap_Input37, $ColorMap_Button37
; DetailMap
Global $DetailMap_Button0, $DetailMap_Button1, $DetailMap_Button2, _
	$DetailMap_Group1, _
	$DetailMap_Checkbox10, $DetailMap_Slider10, $DetailMap_Label10, $DetailMap_Input10, $DetailMap_Slider11, $DetailMap_Label11, $DetailMap_Input11, $DetailMap_Slider12, $DetailMap_Label12, $DetailMap_Input12, _
	$DetailMap_Slider13, $DetailMap_Label13, $DetailMap_Input13, $DetailMap_Slider14, $DetailMap_Label14, $DetailMap_Input14, $DetailMap_Button15, $DetailMap_Label15, $DetailMap_Input15, _
	$DetailMap_Group2, _
	$DetailMap_Checkbox2, $DetailMap_Checkbox20, $DetailMap_Slider20, $DetailMap_Label20, $DetailMap_Input20, $DetailMap_Slider21, $DetailMap_Label21, $DetailMap_Input21, $DetailMap_Slider22, $DetailMap_Label22, $DetailMap_Input22, _
	$DetailMap_Label23, $DetailMap_Input23, $DetailMap_Button23, $DetailMap_Label24, $DetailMap_Input24, $DetailMap_Button24, $DetailMap_Label25, $DetailMap_Input25, $DetailMap_Button25, _
	$DetailMap_Label26, $DetailMap_Input26, $DetailMap_Button26, $DetailMap_Label27, $DetailMap_Input27, $DetailMap_Button27
; Scaler
Global $Scaler_Button0, $Scaler_Group1, _
	$Scaler_Slider1, $Scaler_Label1, $Scaler_Input1, $Scaler_Slider2, $Scaler_Label2, $Scaler_Input2, $Scaler_Slider3, $Scaler_Label3, $Scaler_Input3
; Startpoints
Global $Starter_Button0, $Starter_Group1, _
	$Starter_Pic1, $Starter_List1, $Starter_Button1, $Starter_Button2, $Starter_Button3, $Starter_Label1, $Starter_Input1, $Starter_Slider2, $Starter_Label2, $Starter_Input2

#EndRegion -Variablen---------------------------------------------------------------------------------------------------------------

_SetUP()
_MainLoop()

#Region -Hauptfunktionen-------------------------------------------------------------------------------------------------------------

Func _SetUP()
	__ConsoleWrite("Mapper: _SetUP()"&@CRLF)

	; Engine StartUp
	_FirstStart()
	if $a_System[$e_Sys_ShowPanel] = 1 then _ShowPanel()
	_IrrStartAdvanced($a_System[$e_Sys_DeviceType], 512, 346, $a_System[$e_Sys_Use32Bit], _
			$a_System[$e_Sys_Fullscreen], $a_System[$e_Sys_Shadows], $IRR_CAPTURE_EVENTS, $a_System[$e_Sys_VSync], _
			0, $a_System[$e_Sys_DoubleBuffer], $a_System[$e_Sys_Antialias], $a_System[$e_Sys_HighPrecisionFpu])
	$a_System[$e_Sys_GameName] = "Mapper"
	_IrrSetWindowCaption($a_System[$e_Sys_GameName]&" "&$a_System[$e_Sys_GameVersion])
	$irr_Handle = WinActive($a_System[$e_Sys_GameName]&" "&$a_System[$e_Sys_GameVersion])
	_MapperGUI()
	$a_System[$e_Sys_FontSmall]	= _IrrGetFont($a_Path[$e_Path_Font] & "Small.xml")
	$a_System[$e_Sys_FontBig] 	= _IrrGetFont($a_Path[$e_Path_Font] & "Big.xml")
	_IrrTransparentZWrite()
	_Smoke()

	; Game StartUp
	_Camera("RPG")
;~ 	_LoadLevel("TitleMap")
	_LoadLevel("WorldMap.map")
	_RPG_Movement($a_Camera[0][$e_Cam_Node], $a_PlayerData[0][$e_Player_Node])
	_IrrHideMouse()

EndFunc

Func _MainLoop()
	; Main Loop
	WHILE 1
		if not _IrrRunning() then Exit
		_GUICtrl()
		_IrrBeginSceneAdvanced(_IrrMakeARGB(0,0,0,0))
		_IrrDrawScene()

		_IrrEndScene()

		; Steuerung
		if $__Automatic_Movement=1 then
			_Automatic_Movement($a_PlayerData[0][$e_Player_Node])
			; _RPG_Movement($a_Camera[0][$e_Cam_Node], $a_PlayerData[0][$e_Player_Node])
		EndIf

		_MapperFControl()
		__SetGUIdata()
		__GUIMoveIrr()

	WEND
EndFunc

Func _MapperFControl()
	; Main
	_FControl()

	If _IsPressed('20', $sys_IsPressed_dll) = 0 then 	; Anziehungskraft
		if $a_System[$e_Sys_MoveTyp] = "RPG" then
			$a_Vector = _IrrGetNodePosition($a_PlayerData[0][$e_Player_Node])
			$a_Vector[1] = _IrrGetTerrainTileHeight($a_MapData[$e_Map_Node], $a_Vector[0], $a_Vector[2]) + 1
			_IrrSetNodePosition($a_PlayerData[0][$e_Player_Node], $a_Vector[0], $a_Vector[1], $a_Vector[2])
		Elseif $a_System[$e_Sys_MoveTyp] = "FPS" then
			$a_Vector = _IrrGetNodePosition($a_Camera[0][$e_Cam_Node])
			$a_Vector[1] = _IrrGetTerrainTileHeight($a_MapData[$e_Map_Node], $a_Vector[0], $a_Vector[2]) +60
			_IrrSetNodePosition($a_PlayerData[0][$e_Player_Node], $a_Vector[0], $a_Vector[1], $a_Vector[2])
			_IrrSetNodePosition($a_Camera[0][$e_Cam_Node], $a_Vector[0], $a_Vector[1], $a_Vector[2]-10)
		Else
			$a_Vector = _IrrGetNodePosition($a_Camera[0][$e_Cam_Node])
			$a_Vector[1] = _IrrGetTerrainTileHeight($a_MapData[$e_Map_Node], $a_Vector[0], $a_Vector[2]) +60
			_IrrSetNodePosition($a_PlayerData[0][$e_Player_Node], $a_Vector[0], $a_Vector[1], $a_Vector[2])
			_IrrSetNodePosition($a_Camera[0][$e_Cam_Node], $a_Vector[0], $a_Vector[1], $a_Vector[2]-10)
		EndIf
	EndIf

	; Mapper
	if _IsPressed("02", $sys_IsPressed_dll) then ; Rechte Maustaste
		$Movement = 1-$Movement
		if $Movement = 0 Then _IrrShowMouse()
		if $Movement = 1 Then _IrrHideMouse()
		While _IsPressed("02", $sys_IsPressed_dll)
			Sleep(1)
		WEnd
	EndIf

;~ 	if $Movement = 0 Then _IrrShowMouse()
	if $Movement = 1 and $a_System[$e_Sys_MoveTyp] = "RPG" then ; Rechte Maustaste
;~ 		_IrrHideMouse()
		_RPG_Movement($a_Camera[0][$e_Cam_Node], $a_PlayerData[0][$e_Player_Node])
	EndIf

EndFunc



Func _GUICtrl()
	$nMsg = GUIGetMsg()

	If GUICtrlRead($Mapper_Group1) = "Tools: Datei" then
		; Dateien
		if GUICtrlRead($Mapper_Tab) = 0 Then		; Datei Neu

		elseif GUICtrlRead($Mapper_Tab) = 1 Then	; Datei Öffnen

		elseif GUICtrlRead($Mapper_Tab) = 2 Then	; Datei Speichern

		EndIf

	Elseif GUICtrlRead($Mapper_Group1) = "Tools: Layer-1" then
		; Layer-1
		if GUICtrlRead($Mapper_Tab) = 0 Then		; HightMap Settings
			if $BackUp_Data[0] <> "HightMap" then	; BackUp Data Initieren
				__CleanBackUp_Data()
				__GUIHightMapSetData()
				$BackUp_Data[0] = "HightMap"
				$BackUp_Data[1] = $s_HightMapBMP
				$BackUp_Data[2] = $s_HightMapBlur1
				$BackUp_Data[3] = $s_HightMapBlur2
				$BackUp_Data[4] = $s_HightMapInvert
				$BackUp_Data[5] = $s_HightMapSizeX
				$BackUp_Data[6] = $s_HightMapSizeY
				;
				$BackUp_Data[7] = $s_NormalMapBMP
				$BackUp_Data[8] = $s_NormalMapFileA
				$BackUp_Data[9] = $s_NormalMapFileB
				$BackUp_Data[10] = $s_NormalMapProzent
				$BackUp_Data[11] = $s_NormalMapSizeX
				$BackUp_Data[12] = $s_NormalMapSizeY
				;
				$BackUp_Data[13] = $s_MixedMapBMP
				$BackUp_Data[14] = $s_MixedMapFileA
				$BackUp_Data[15] = $s_MixedMapFileB
				$BackUp_Data[16] = $s_MixedMapMask
				$BackUp_Data[17] = $s_MixedMapProzent
				$BackUp_Data[18] = $s_MixedMapSizeX
				$BackUp_Data[19] = $s_MixedMapSizeY
			EndIf

			; HightMap: Main
			Switch $nMsg
				Case $HightMap_Button0				; Übernehmen Button
					__MakeHightMap($s_BaseMap, $s_HightMapBlur1, $s_HightMapBlur2, $s_HightMapInvert, $s_HightMapSizeX, $s_HightMapSizeY)
					__CleanBackUp_Data()
					__ResetMap()
				Case $HightMap_Button1				; HightMap Button
					__GUIHightMapSwitchState("HightMap")

				Case $HightMap_Button2				; BumpMap Button
					__GUIHightMapSwitchState("BumpMap")

				Case $HightMap_Button3				; MixedMap Button
					__GUIHightMapSwitchState("MixedMap")
			EndSwitch

			if GUICtrlGetState($HightMap_Group1) = $GUI_SHOW + $GUI_ENABLE then
				; HightMap: HightMap
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						$s_HightMapBMP = $BackUp_Data[1]
						$s_HightMapBlur1 = $BackUp_Data[2]
						$s_HightMapBlur2 = $BackUp_Data[3]
						$s_HightMapInvert = $BackUp_Data[4]
						$s_HightMapSizeX = $BackUp_Data[5]
						$s_HightMapSizeY = $BackUp_Data[6]
						;
						$s_NormalMapBMP = $BackUp_Data[7]
						$s_NormalMapFileA = $BackUp_Data[8]
						$s_NormalMapFileB = $BackUp_Data[9]
						$s_NormalMapProzent = $BackUp_Data[10]
						$s_NormalMapSizeX = $BackUp_Data[11]
						$s_NormalMapSizeY = $BackUp_Data[12]
						;
						$s_MixedMapBMP = $BackUp_Data[13]
						$s_MixedMapFileA = $BackUp_Data[14]
						$s_MixedMapFileB = $BackUp_Data[15]
						$s_MixedMapMask = $BackUp_Data[16]
						$s_MixedMapProzent = $BackUp_Data[17]
						$s_MixedMapSizeX = $BackUp_Data[18]
						$s_MixedMapSizeY = $BackUp_Data[19]
	;~ 					GUISetState(@SW_HIDE, $HightMapGUI)
						__CleanBackUp_Data()

					Case $HightMap_Checkbox10	; Blur-FX Aktivieren
						__GUIHightMapSwitchCheckBox()

				EndSwitch
				__CheckCtrl(__GetSliderMapSize($HightMap_Slider10), $HightMap_Input10)
				__CheckCtrl(__GetSliderMapSize($HightMap_Slider11), $HightMap_Input11)
				__CheckCtrl(GUICtrlRead($HightMap_Slider12), $HightMap_Input12)
				__CheckCtrl(GUICtrlRead($HightMap_Slider13), $HightMap_Input13)
				__CheckCtrl(Round2(GUICtrlRead($HightMap_Slider14)/100,2), $HightMap_Input14)
				__CheckCtrl(GUICtrlRead($HightMap_Slider15), $HightMap_Input15)

			elseif GUICtrlGetState($HightMap_Group2) = $GUI_SHOW + $GUI_ENABLE then
				; HightMap: Bumpmapping
				Switch $nMsg
				Case $HightMap_Checkbox2	; Bump-FX Aktivieren
						__GUIHightMapSwitchCheckBox()

					Case $HightMap_Button24		; Master Texture auswählen
						$tmp = $s_NormalMapFileA
						$s_NormalMapFileA = FileOpenDialog("Master Texture wählen", $a_Path[$e_Path_Map]&$s_BaseMap, "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_NormalMapFileA, "\", 1)
;~ 						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_NormalMapFileA, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_NormalMapFileA = $_tmp[$_tmp[0]]
						if @error or $s_NormalMapFileA = "" then $s_NormalMapFileA = $tmp
						GUICtrlSetData($HightMap_Input24, $s_NormalMapFileA)


					Case $HightMap_Button25		; Mix Texture auswählen
						$tmp = $s_NormalMapFileB
						$s_NormalMapFileB = FileOpenDialog("Mix Texture wählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_NormalMapFileB, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_NormalMapFileB, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_NormalMapFileB = $_tmp[$_tmp[0]]
						if @error or $s_NormalMapFileB = "" then $s_NormalMapFileB = $tmp
						GUICtrlSetData($HightMap_Input25, $s_NormalMapFileB)

				EndSwitch
				__CheckCtrl(__GetSliderMapSize($HightMap_Slider20), $HightMap_Input20)
				__CheckCtrl(__GetSliderMapSize($HightMap_Slider21), $HightMap_Input21)
				__CheckCtrl(GUICtrlRead($HightMap_Slider22), $HightMap_Input22)
				__CheckCtrl(GUICtrlRead($HightMap_Slider23), $HightMap_Input23)

			elseif GUICtrlGetState($HightMap_Group3) = $GUI_SHOW + $GUI_ENABLE then
				; HightMap: MixedMap
				Switch $nMsg
					Case $HightMap_Checkbox3	; MixedMap-FX Aktivieren
						__GUIHightMapSwitchCheckBox()

					Case $HightMap_Button34		; Master Texture auswählen
						$tmp = $s_MixedMapFileA
						$s_MixedMapFileA = FileOpenDialog("Master Texture wählen", $a_Path[$e_Path_Map], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_MixedMapFileA, "\", 1)
						$s_MixedMapFileA = $_tmp[$_tmp[0]]
						if @error or $s_MixedMapFileA = "" then $s_MixedMapFileA = $tmp
						GUICtrlSetData($HightMap_Input34, $s_MixedMapFileA)

					Case $HightMap_Button35		; Mix Texture auswählen
						$tmp = $s_MixedMapFileB
						$s_MixedMapFileB = FileOpenDialog("Mix Texture wählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_MixedMapFileB, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_MixedMapFileB, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_MixedMapFileB = $_tmp[$_tmp[0]]
						if @error or $s_MixedMapFileB = "" then $s_MixedMapFileB = $tmp
						GUICtrlSetData($HightMap_Input35, $s_MixedMapFileB)

					Case $HightMap_Button33		; Mask Texture auswählen
						$tmp = $s_MixedMapMask
						$s_MixedMapMask = FileOpenDialog("Mask Texture wählen", $a_Path[$e_Path_Masks], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_MixedMapMask, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_MixedMapMask, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_MixedMapMask = $_tmp[$_tmp[0]]
						if @error or $s_MixedMapMask = "" then $s_MixedMapMask = $tmp
						GUICtrlSetData($HightMap_Input33, $s_MixedMapMask)

				EndSwitch
				__CheckCtrl(__GetSliderMapSize($HightMap_Slider30), $HightMap_Input30)
				__CheckCtrl(__GetSliderMapSize($HightMap_Slider31), $HightMap_Input31)
				__CheckCtrl(GUICtrlRead($HightMap_Slider32), $HightMap_Input32)
			EndIf

		elseif GUICtrlRead($Mapper_Tab) = 1 Then	; ColorMap Settings
			if $BackUp_Data[0] <> "ColorMap" then
				__CleanBackUp_Data()
				__GUIColorMapSetData()
				$BackUp_Data[0] = "ColorMap"
				$BackUp_Data[1] = $s_ColorMapBMP
				$BackUp_Data[2] = $s_ColorMapBlur1
				$BackUp_Data[3] = $s_ColorMapBlur2
				$BackUp_Data[4] = $s_ColorMapDiffuseUV
				$BackUp_Data[5] = $s_ColorMapSizeX
				$BackUp_Data[6] = $s_ColorMapSizeY
				;
				$BackUp_Data[7] = $s_MacroMapBMP
				$BackUp_Data[8] = $s_MacroMapFileA
				$BackUp_Data[9] = $s_MacroMapFileB
				$BackUp_Data[10] = $s_MacroMapMask
				$BackUp_Data[11] = $s_MacroMapAutoFlipRotate
				$BackUp_Data[12] = $s_MacroMapDiffuseUV
				$BackUp_Data[13] = $s_MacroMapProzent
				$BackUp_Data[14] = $s_MacroMapSizeX
				$BackUp_Data[15] = $s_MacroMapSizeY
				;
				$BackUp_Data[16] = $s_MixedMacroMapBMP
				$BackUp_Data[17] = $s_MixedMacroMapFile
				$BackUp_Data[18] = $s_MixedMacroMapMask
				$BackUp_Data[19] = $s_MixedMacroMapTex1
				$BackUp_Data[20] = $s_MixedMacroMapTex2
				$BackUp_Data[21] = $s_MixedMacroMapTex3
				$BackUp_Data[22] = $s_MixedMacroMapTex4
				$BackUp_Data[23] = $s_MixedMacroMapAutoFlipRotate
				$BackUp_Data[24] = $s_MixedMacroMapDiffuseUV
				$BackUp_Data[25] = $s_MixedMacroMapProzent
				$BackUp_Data[26] = $s_MixedMacroMapSizeX
				$BackUp_Data[27] = $s_MixedMacroMapSizeY
			EndIf

			; ColorMapGUI: Main
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					$s_ColorMapBMP 			= $BackUp_Data[1]
					$s_ColorMapBlur1 		= $BackUp_Data[2]
					$s_ColorMapBlur2 		= $BackUp_Data[3]
					$s_ColorMapDiffuseUV 	= $BackUp_Data[4]
					$s_ColorMapSizeX 		= $BackUp_Data[5]
					$s_ColorMapSizeY 		= $BackUp_Data[6]
					;
					$s_MacroMapBMP 			= $BackUp_Data[7]
					$s_MacroMapFileA 		= $BackUp_Data[8]
					$s_MacroMapFileB 		= $BackUp_Data[9]
					$s_MacroMapMask 		= $BackUp_Data[10]
					$s_MacroMapAutoFlipRotate = $BackUp_Data[11]
					$s_MacroMapDiffuseUV 	= $BackUp_Data[12]
					$s_MacroMapProzent 		= $BackUp_Data[13]
					$s_MacroMapSizeX 		= $BackUp_Data[14]
					$s_MacroMapSizeY 		= $BackUp_Data[15]
					;
					$s_MixedMacroMapBMP 	= $BackUp_Data[16]
					$s_MixedMacroMapFile 	= $BackUp_Data[17]
					$s_MixedMacroMapMask 	= $BackUp_Data[18]
					$s_MixedMacroMapTex1 	= $BackUp_Data[19]
					$s_MixedMacroMapTex2 	= $BackUp_Data[20]
					$s_MixedMacroMapTex3 	= $BackUp_Data[21]
					$s_MixedMacroMapTex4 	= $BackUp_Data[22]
					$s_MixedMacroMapAutoFlipRotate = $BackUp_Data[23]
					$s_MixedMacroMapDiffuseUV = $BackUp_Data[24]
					$s_MixedMacroMapProzent	= $BackUp_Data[25]
					$s_MixedMacroMapSizeX 	= $BackUp_Data[26]
					$s_MixedMacroMapSizeY 	= $BackUp_Data[27]
	;~ 				GUISetState(@SW_HIDE, $ColorMapGUI)
					__CleanBackUp_Data()

				Case $ColorMap_Button0				; OK Button
					__MakeColorMap($s_BaseMap, $s_ColorMapBlur1, $s_ColorMapBlur2, $s_ColorMapDiffuseUV, $s_ColorMapSizeX, $s_ColorMapSizeY)
					__CleanBackUp_Data()
					__ResetMap()

				Case $ColorMap_Button1				; Standart ColorMap Button
					__GUIColorMapSwitchState("ColorMap")

				Case $ColorMap_Button2				; Standart MacroMap Button
					__GUIColorMapSwitchState("MacroMap")

				Case $ColorMap_Button3				; Standart MixedMacroMap Button
					__GUIColorMapSwitchState("MixedMacroMap")
			EndSwitch

			if GUICtrlGetState($ColorMap_Group1) = $GUI_SHOW + $GUI_ENABLE then
				; ColorMap: ColorMap
				Switch $nMsg
					Case $ColorMap_Checkbox10	; Blurred FX Aktivieren
						__GUIColorMapSwitchCheckBox()

					Case $ColorMap_Button15		; SkyBox auswählen
						$tmp = $s_SkyBox
						$s_SkyBox = FileSelectFolder("SkyBox Ordner wählen", $a_Path[$e_Path_Sky])
						$s_SkyBox = StringReplace($s_SkyBox, $a_Path[$e_Path_Sky], "", 0,1)
						if @error or $s_SkyBox = "" then $s_SkyBox = $tmp
						GUICtrlSetData($ColorMap_Input15, $s_SkyBox)

				EndSwitch
				__CheckCtrl(__GetSliderMapSize($ColorMap_Slider10), $ColorMap_Input10)
				__CheckCtrl(__GetSliderMapSize($ColorMap_Slider11), $ColorMap_Input11)
				__CheckCtrl(Round2(GUICtrlRead($ColorMap_Slider12)/100,2), $ColorMap_Input12)
				__CheckCtrl(GUICtrlRead($ColorMap_Slider13), $ColorMap_Input13)
				__CheckCtrl(GUICtrlRead($ColorMap_Slider14), $ColorMap_Input14)

			elseif GUICtrlGetState($ColorMap_Group2) = $GUI_SHOW + $GUI_ENABLE then
				; ColorMap: MacroMap
				Switch $nMsg
					Case $ColorMap_Checkbox2	; MacroMap-FX Aktivieren
						__GUIColorMapSwitchCheckBox()

					Case $ColorMap_Button24		; Mix Texture auswählen
						$tmp = $s_MacroMapMask
						$s_MacroMapMask = FileOpenDialog("Mix Texture wählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_MacroMapMask, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_MacroMapMask, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_MacroMapMask = $_tmp[$_tmp[0]]
						if @error or $s_MacroMapMask = "" then $s_MacroMapMask = $tmp
						GUICtrlSetData($ColorMap_Input24, $s_MacroMapMask)

					Case $ColorMap_Button23		; Mask Texture auswählen
						$tmp = $s_MacroMapFileB
						$s_MacroMapFileB = FileOpenDialog("Mask Texture wählen", $a_Path[$e_Path_Masks], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_MacroMapFileB, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_MacroMapFileB, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_MacroMapFileB = $_tmp[$_tmp[0]]
						if @error or $s_MacroMapFileB = "" then $s_MacroMapFileB = $tmp
						GUICtrlSetData($ColorMap_Input23, $s_MacroMapFileB)

				EndSwitch
				__CheckCtrl(__GetSliderMapSize($ColorMap_Slider20), $ColorMap_Input20)
				__CheckCtrl(__GetSliderMapSize($ColorMap_Slider21), $ColorMap_Input21)
				__CheckCtrl(GUICtrlRead($ColorMap_Slider22), $ColorMap_Input22)

			elseif GUICtrlGetState($ColorMap_Group3) = $GUI_SHOW + $GUI_ENABLE then
				; ColorMap: MixedMacroMap
				Switch $nMsg
					Case $ColorMap_Checkbox3	; MixedMacroMap-FX Aktivieren
						__GUIColorMapSwitchCheckBox()

					Case $ColorMap_Button33		; Mask Texture auswählen
						$tmp = $s_MixedMacroMapMask
						$s_MixedMacroMapMask = FileOpenDialog("Mask Texture wählen", $a_Path[$e_Path_Masks], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_MixedMacroMapMask, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_MixedMacroMapMask, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_MixedMacroMapMask = $_tmp[$_tmp[0]]
						if @error or $s_MixedMacroMapMask = "" then $s_MixedMacroMapMask = $tmp
						GUICtrlSetData($ColorMap_Input33, $s_MixedMacroMapMask)

					Case $ColorMap_Button34		; Macro Texture 1 auswählen
						$tmp = $s_MixedMacroMapTex1
						$s_MixedMacroMapTex1 = FileOpenDialog("Macro Texture wählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_MixedMacroMapTex1, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_MixedMacroMapTex1, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_MixedMacroMapTex1 = $_tmp[$_tmp[0]]
						if @error or $s_MixedMacroMapTex1 = "" then $s_MixedMacroMapTex1 = $tmp
						GUICtrlSetData($ColorMap_Input34, $s_MixedMacroMapTex1)

					Case $ColorMap_Button35		; Macro Texture 2 auswählen
						$tmp = $s_MixedMacroMapTex2
						$s_MixedMacroMapTex2 = FileOpenDialog("Macro Texture wählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_MixedMacroMapTex2, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_MixedMacroMapTex2, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_MixedMacroMapTex2 = $_tmp[$_tmp[0]]
						if @error or $s_MixedMacroMapTex2 = "" then $s_MixedMacroMapTex2 = $tmp
						GUICtrlSetData($ColorMap_Input35, $s_MixedMacroMapTex2)

					Case $ColorMap_Button36		; Macro Texture 3 auswählen
						$tmp = $s_MixedMacroMapTex3
						$s_MixedMacroMapTex3 = FileOpenDialog("Macro Texture wählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_MixedMacroMapTex3, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_MixedMacroMapTex3, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_MixedMacroMapTex3 = $_tmp[$_tmp[0]]
						if @error or $s_MixedMacroMapTex3 = "" then $s_MixedMacroMapTex3 = $tmp
						GUICtrlSetData($ColorMap_Input36, $s_MixedMacroMapTex3)

					Case $ColorMap_Button37		; Macro Texture 4 auswählen
						$tmp = $s_MixedMacroMapTex4
						$s_MixedMacroMapTex4 = FileOpenDialog("Macro Texture wählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_MixedMacroMapTex4, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_MixedMacroMapTex4, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_MixedMacroMapTex4 = $_tmp[$_tmp[0]]
						if @error or $s_MixedMacroMapTex4 = "" then $s_MixedMacroMapTex4 = $tmp
						GUICtrlSetData($ColorMap_Input37, $s_MixedMacroMapTex4)

				EndSwitch
				__CheckCtrl(__GetSliderMapSize($ColorMap_Slider30), $ColorMap_Input30)
				__CheckCtrl(__GetSliderMapSize($ColorMap_Slider31), $ColorMap_Input31)
				__CheckCtrl(GUICtrlRead($ColorMap_Slider32), $ColorMap_Input32)

			EndIf


		elseif GUICtrlRead($Mapper_Tab) = 2 Then	; DetailMap Settings
			if $BackUp_Data[0] <> "DetailMap" then
				__CleanBackUp_Data()
				__GUIDetailMapSetData()
				$BackUp_Data[0] = "DetailMap"
				$BackUp_Data[1] = $s_DetailMapBMP
				$BackUp_Data[2] = $s_ScaleD
				$BackUp_Data[3] = $s_BitplanesTex1
				$BackUp_Data[4] = $s_BitplanesTex2
				$BackUp_Data[5] = $s_BitplanesTex3
				$BackUp_Data[6] = $s_BitplanesTex4
				$BackUp_Data[7] = $s_BitplanesSizeX
				$BackUp_Data[8] = $s_BitplanesSizeY
				$BackUp_Data[9] = $s_DetailMapFile
			EndIf

			; DetailMap: Main
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					$s_DetailMapBMP = $BackUp_Data[1]
					$s_ScaleD = $BackUp_Data[2]
					$s_BitplanesTex1 = $BackUp_Data[3]
					$s_BitplanesTex2 = $BackUp_Data[4]
					$s_BitplanesTex3 = $BackUp_Data[5]
					$s_BitplanesTex4 = $BackUp_Data[6]
					$s_BitplanesSizeX = $BackUp_Data[7]
					$s_BitplanesSizeY = $BackUp_Data[8]
					$s_DetailMapFile = $BackUp_Data[9]
	;~ 				GUISetState(@SW_HIDE, $DetailMapGUI)
					__CleanBackUp_Data()

				Case $DetailMap_Button0				; OK Button
					__MakeDetailMap($s_DetailMapFile)
					__MakeBitplaneMap($s_BitplanesTex1, $s_BitplanesTex2, $s_BitplanesTex3, $s_BitplanesTex4, $s_BitplanesSizeX, $s_BitplanesSizeY)
					__CleanBackUp_Data()
					__ResetMap()

				Case $DetailMap_Button1				; Tool: Standart DetailMap
					__GUIDetailMapSwitchState("DetailMap")
					__GUIDetailMapSwitchCheckBox()

				Case $DetailMap_Button2				; Tool: Bitplane DetailMap
					__GUIDetailMapSwitchState("BitplaneMap")
					__GUIDetailMapSwitchCheckBox()
			EndSwitch

			if GUICtrlGetState($DetailMap_Group1) = $GUI_SHOW + $GUI_ENABLE then
				; DetailMap: DetailMap
				Switch $nMsg
					Case $DetailMap_Button15		; DetailMap Wechseln
						$tmp = $s_DetailMapFile
						$s_DetailMapFile = FileOpenDialog("DetailMap Texture wählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_DetailMapFile, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_DetailMapFile, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_DetailMapFile = $_tmp[$_tmp[0]]
						if @error or $s_DetailMapFile = "" then $s_DetailMapFile = $tmp
						GUICtrlSetData($DetailMap_Input15, $s_DetailMapFile)

				EndSwitch
				__CheckCtrl(__GetSliderMapSize($DetailMap_Slider10), $DetailMap_Input10)
				__CheckCtrl(__GetSliderMapSize($DetailMap_Slider11), $DetailMap_Input11)
				__CheckCtrl(GUICtrlRead($DetailMap_Slider12), $DetailMap_Input12)
				__CheckCtrl(GUICtrlRead($DetailMap_Slider13), $DetailMap_Input13)
				__CheckCtrl(GUICtrlRead($DetailMap_Slider14), $DetailMap_Input14)

			elseif GUICtrlGetState($DetailMap_Group2) = $GUI_SHOW + $GUI_ENABLE then
				; DetailMap: BitplaneMap
				Switch $nMsg
					Case $DetailMap_Checkbox2		; BitplaneMap Aktivieren
						__GUIDetailMapSwitchCheckBox()

					Case $DetailMap_Button24		; Textur 1 auswählen
						$tmp = $s_BitplanesTex1
						$s_BitplanesTex1 = FileOpenDialog("Bitplanemap Texture auswählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_BitplanesTex1, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_BitplanesTex1, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_BitplanesTex1 = $_tmp[$_tmp[0]]
						if @error or $s_BitplanesTex1 = "" then $s_BitplanesTex1 = $tmp
						GUICtrlSetData($DetailMap_Input24, $s_BitplanesTex1)

					Case $DetailMap_Button25		; Textur 2 auswählen
						$tmp = $s_BitplanesTex2
						$s_BitplanesTex2 = FileOpenDialog("Bitplanemap Texture auswählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_BitplanesTex2, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_BitplanesTex2, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_BitplanesTex2 = $_tmp[$_tmp[0]]
						if @error or $s_BitplanesTex2 = "" then $s_BitplanesTex2 = $tmp
						GUICtrlSetData($DetailMap_Input25, $s_BitplanesTex2)

					Case $DetailMap_Button26		; Textur 3 auswählen
						$tmp = $s_BitplanesTex3
						$s_BitplanesTex3 = FileOpenDialog("Bitplanemap Texture auswählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_BitplanesTex3, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_BitplanesTex3, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_BitplanesTex3 = $_tmp[$_tmp[0]]
						if @error or $s_BitplanesTex3 = "" then $s_BitplanesTex3 = $tmp
						GUICtrlSetData($DetailMap_Input26, $s_BitplanesTex3)

					Case $DetailMap_Button27		; Textur 4 auswählen
						$tmp = $s_BitplanesTex4
						$s_BitplanesTex4 = FileOpenDialog("Bitplanemap Texture auswählen", $a_Path[$e_Path_Texturen], "Pics (*.jpg;*.bmp;*.jpg;*.gif)")
						$_tmp = StringSplit($s_BitplanesTex4, "\", 1)
						if FileExists($a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]]) = 0 then FileCopy($s_BitplanesTex4, $a_Path[$e_Path_Map]&$s_BaseMap&"\"&$_tmp[$_tmp[0]], 9)
						$s_BitplanesTex4 = $_tmp[$_tmp[0]]
						if @error or $s_BitplanesTex4 = "" then $s_BitplanesTex4 = $tmp
						GUICtrlSetData($DetailMap_Input27, $s_BitplanesTex4)

				EndSwitch
				__CheckCtrl(__GetSliderMapSize($DetailMap_Slider20), $DetailMap_Input20)
				__CheckCtrl(__GetSliderMapSize($DetailMap_Slider21), $DetailMap_Input21)
				__CheckCtrl(GUICtrlRead($DetailMap_Slider22), $DetailMap_Input22)
			EndIf


		elseif GUICtrlRead($Mapper_Tab) = 3 Then	; Scaler
			if $BackUp_Data[0] <> "Scaler" then
				__CleanBackUp_Data()
				__GUIScalerSetData()
				$BackUp_Data[0] = "Scaler"
				$BackUp_Data[1] = $s_ScaleXY
				$BackUp_Data[2] = $s_ScaleZ
				$BackUp_Data[3] = $s_ScaleD
			EndIf

			Switch $nMsg
				Case $Scaler_Button0	; OK Button
					__GUIScalerGetData()
					__CleanBackUp_Data()
					_IrrSetNodeScale($a_MapData[$e_Map_Node], Number($s_ScaleXY), Number($s_ScaleZ), Number($s_ScaleXY))
					_IrrScaleTexture($a_MapData[$e_Map_Node], 1, Number($s_ScaleD))	; Detail Textur grösse

				Case $Scaler_Slider1	; X/Y-Scale
					$tmp1 = GUICtrlRead($Scaler_Slider1)
					$tmp2 = GUICtrlRead($Scaler_Slider2)
					_IrrSetNodeScale($a_MapData[$e_Map_Node], Number($tmp1), Number($tmp2), Number($tmp1))

				Case $Scaler_Slider2	; Z-Scale
					$tmp1 = GUICtrlRead($Scaler_Slider1)
					$tmp2 = GUICtrlRead($Scaler_Slider2)
					_IrrSetNodeScale($a_MapData[$e_Map_Node], Number($tmp1), Number($tmp2), Number($tmp1))

				Case $Scaler_Slider3	; Detail-Scale
					$tmp = GUICtrlRead($Scaler_Slider3)
					_IrrScaleTexture($a_MapData[$e_Map_Node], 1, Number($tmp))	; Detail Textur grösse

			EndSwitch
			__CheckCtrl(GUICtrlRead($Scaler_Slider1), $Scaler_Input1)
			__CheckCtrl(GUICtrlRead($Scaler_Slider2), $Scaler_Input2)
			__CheckCtrl(GUICtrlRead($Scaler_Slider3), $Scaler_Input3)

		elseif GUICtrlRead($Mapper_Tab) = 4 Then	; Starter
			if $BackUp_Data[0] <> "Starter" then
				__CleanBackUp_Data()
				__GUIStarterSetData()
				$BackUp_Data[0] = "Starter"
				$BackUp_Data[1] = UBound($a_Startpoints,1)-1
				for $i = 0 to $BackUp_Data[1]
					$BackUp_Data[2+$i] = $a_Startpoints[$i][0]&", "&$a_Startpoints[$i][1]
				Next
			EndIf

			Switch $nMsg
				Case $Starter_Button0	; OK Button
					__GUIStarterGetData()
					__CleanBackUp_Data()

				Case $Starter_Button1	; Startpoint von Map wählen
					$__GUIStarterSelectFromMap = 1-$__GUIStarterSelectFromMap

				Case $Starter_Button2	; Startpoint zufügen
					Local $tmp_Input1=GUICtrlRead($Starter_Input1), $tmp_Input2=GUICtrlRead($Starter_Input2)
					ReDim $a_Startpoints[UBound($a_Startpoints,1)+1][2]
					$a_Startpoints[UBound($a_Startpoints,1)-1][0] = $tmp_Input1
					$a_Startpoints[UBound($a_Startpoints,1)-1][1] = $tmp_Input2
					GUICtrlSetData($Starter_List1, "")
					for $i = 0 to UBound($a_Startpoints,1)-1
						GUICtrlSetData($Starter_List1, $a_Startpoints[$i][0]&", "&$a_Startpoints[$i][1])
					Next

				Case $Starter_List1		; Startpoint aus Liste wählen
					Local $tmp_Txt=GUICtrlRead($Starter_List1,1)
					if StringInStr($tmp_Txt, ", ", 1) then
						Local $tmp_Split = StringSplit($tmp_Txt, ", ", 1)
						GUICtrlSetData($Starter_Input1, $tmp_Split[1])
						GUICtrlSetData($Starter_Input2, $tmp_Split[2])
					EndIf

				Case $Starter_Button3	; Eintrag löschen
					Local $tmp_Txt=GUICtrlRead($Starter_List1,1)
					if StringInStr($tmp_Txt, ", ", 1) then
						Local $tmp_Split = StringSplit($tmp_Txt, ", ", 1)
						for $i = 0 to UBound($a_Startpoints,1)-1
							if $a_Startpoints[$i][0] = $tmp_Split[1] and $a_Startpoints[$i][1] = $tmp_Split[2] then
								_ArrayDelete($a_Startpoints, $i)
								GUICtrlSetData($Starter_List1, "")
								for $i = 0 to UBound($a_Startpoints,1)-1
									GUICtrlSetData($Starter_List1, $a_Startpoints[$i][0]&", "&$a_Startpoints[$i][1])
								Next
							EndIf
						Next
					EndIf

			EndSwitch
			__GUIStarterSelectFromMap()

;~ 		elseif WinActive("Save Map") Then
;~ 			if $BackUp_Data[0] <> "Save Map" then
;~ 				__CleanBackUp_Data()
;~ 				$BackUp_Data[0] = "Save Map"
;~ 				$BackUp_Data[1] = $s_MapName
;~ 				$BackUp_Data[2] = $s_SkyBox
;~ 				$BackUp_Data[3] = $s_BaseMap
;~ 				$BackUp_Data[4] = $s_ScaleXY
;~ 				$BackUp_Data[5] = $s_ScaleZ
;~ 				$BackUp_Data[6] = $s_ScaleD
;~ 				$BackUp_Data[7] = $s_HightMapSizeX
;~ 				$BackUp_Data[8] = $s_HightMapSizeY
;~ 				GUICtrlSetData($Save_List1, "")
;~ 				for $i = 0 to UBound($a_Startpoints,1)-1
;~ 					GUICtrlSetData($Save_List1, $a_Startpoints[$i][0]&", "&$a_Startpoints[$i][1])
;~ 				Next
;~ 				GUICtrlSetData($Save_List1, "Startpoints:")
;~ 			EndIf

;~ 			Switch $nMsg
;~ 				Case $GUI_EVENT_CLOSE
;~ 					$s_MapName = $BackUp_Data[1]
;~ 					$s_SkyBox = $BackUp_Data[2]
;~ 					$s_BaseMap = $BackUp_Data[3]
;~ 					$s_ScaleXY = $BackUp_Data[4]
;~ 					$s_ScaleZ = $BackUp_Data[5]
;~ 					$s_ScaleD = $BackUp_Data[6]
;~ 					$s_HightMapSize = $BackUp_Data[7]
;~ 					__CleanBackUp_Data()

;~ 				Case $Save_Button1	; OK Button
;~ 					__ResetMap()
;~ 					__CleanBackUp_Data()

;~ 				Case $Save_Button2	; Abbruch Button
;~ 					$s_MapName = $BackUp_Data[1]
;~ 					$s_SkyBox = $BackUp_Data[2]
;~ 					$s_BaseMap = $BackUp_Data[3]
;~ 					$s_ScaleXY = $BackUp_Data[4]
;~ 					$s_ScaleZ = $BackUp_Data[5]
;~ 					$s_ScaleD = $BackUp_Data[6]
;~ 					$s_HightMapSize = $BackUp_Data[7]
;~ 					__CleanBackUp_Data()

;~ 				Case $Save_Button3	; Basemap ändern

;~ 				Case $Save_Button4	; Skybox ändern
;~ 					$tmp = $s_SkyBox
;~ 					$s_SkyBox = FileSelectFolder("SkyBox Ordner wählen", $a_Path[$e_Path_Sky])
;~ 					$s_SkyBox = StringReplace($s_SkyBox, $a_Path[$e_Path_Sky], "", 0,1)
;~ 					if @error or $s_SkyBox = "" then $s_SkyBox = $tmp

;~ 			EndSwitch

		EndIf

	EndIf


	; Mapper ToolBar
	if _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_New) Then
		; Neu
		__GUIMainSwitchState("Datei Neu")
		While _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_New)
			Sleep(1)
		WEnd

	elseif _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Open) Then
		; Öffnen
		__GUIMainSwitchState("Datei Öffnen")

		While _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Open)
			Sleep(1)
		WEnd

	elseif _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Save) Then
		; Speichern
		__GUIMainSwitchState("Datei Speichern")

		While _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Save)
			Sleep(1)
		WEnd

	elseif _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Exit) Then
		; Beenden
		Exit

		While _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Exit)
			Sleep(1)
		WEnd

	elseif _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Layer1) Then
		; Layer-1
		__GUIMainSwitchState("Layer1")

		While _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Layer1)
			Sleep(1)
		WEnd

	elseif _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Layer2) Then
		; Layer-2
		__GUIMainSwitchState("Layer2")

		While _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Layer2)
			Sleep(1)
		WEnd

	elseif _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Settings) Then
		; Settings
		__GUIMainSwitchState("System")

		While _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Settings)
			Sleep(1)
		WEnd

	elseif _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Char) Then
		; Character-Ani´s

		While _GUICtrlToolbar_IsButtonPressed($Mapper_ToolBar, $ToolBar_Char)
			Sleep(1)
		WEnd

	EndIf


	; Mapper Menu
	Switch $nMsg
		Case $GUI_EVENT_CLOSE

		Case $MenuItem2
			; Neu
			__GUIMainSwitchState("Datei Neu")

		Case $MenuItem3
			; Laden
			__GUIMainSwitchState("Datei Öffnen")

		Case $MenuItem4
			; Speichern
			__GUIMainSwitchState("Datei Speichern")

		Case $MenuItem6
			; Beenden
			Exit

	EndSwitch





;~ 			Case $Mapper_Button24	; Starter
;~ 				Local $s_File = __ConvertBMP2JPG($a_Path[$e_Path_Map]&$s_BaseMap)


;~ 			Case $Mapper_Button32	; Auto Movement umschalten
;~ 				$__Automatic_Movement = 1-$__Automatic_Movement
;~ 				if $__Automatic_Movement=1 then
;~ 					if GUICtrlRead($Mapper_Button32) = "Auto Movement: OFF" then GUICtrlSetData($Mapper_Button32, "Auto Movement: ON")
;~ 					Local $i__ScaleMap = $s_ScaleXY, $aPoint = _IrrGetNodePosition($a_PlayerData[0][$e_Player_Node])
;~ 					Local $i_PosX, $i_PosY
;~ 					do
;~ 						$i_PosX = Random($aPoint[0]-25*$i__ScaleMap,$aPoint[0]+25*$i__ScaleMap,1)
;~ 						$i_PosY = Random($aPoint[2]-25*$i__ScaleMap,$aPoint[2]+25*$i__ScaleMap,1)
;~ 					Until ($i_PosX > 100*$i__ScaleMap and $i_PosX < 900*$i__ScaleMap) and ($i_PosY > 100*$i__ScaleMap and $i_PosY < 900*$i__ScaleMap)
;~ 					_Automatic_Movement($a_PlayerData[0][$e_Player_Node], $i_PosX, $i_PosY)
;~ 				Else
;~ 					if GUICtrlRead($Mapper_Button32) = "Auto Movement: ON" then GUICtrlSetData($Mapper_Button32, "Auto Movement: OFF")
;~ 				EndIf
EndFunc

Func _MapperGUI()
	; Main GUI
	$MapperGUI = GUICreate("Mapper - THE Editor", 993, 590, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_TABSTOP))
	__GUIMapperToolMenu($MapperGUI)

	$Mapper_Group0 = GUICtrlCreateGroup("Map: ", 8, 48, 528, 400)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Mapper_Group2 = GUICtrlCreateGroup("Log", 8, 448, 528, 113)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH)
	$Mapper_Edit1 = GUICtrlCreateEdit("", 16, 464, 511, 89, BitOR($ES_AUTOVSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Mapper_Group3 = GUICtrlCreateGroup("Informationen", 544, 448, 441, 113)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
	$Mapper_Edit2 = GUICtrlCreateEdit("", 552, 464, 425, 89, BitOR($ES_AUTOVSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Mapper_Group1 = GUICtrlCreateGroup("Tools: ", 544, 48, 441, 400, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUISetState(@SW_SHOW, $MapperGUI)
	__GUIMainSwitchState("Datei")
	_WinAPI_SetParent($irr_Handle, $MapperGUI)
	WinMove($irr_Handle, "", 15, 20)
EndFunc
Func __GUIMapperToolMenu($hGUI)
	$MenuItem1 = GUICtrlCreateMenu("&Datei")
	$MenuItem2 = GUICtrlCreateMenuItem("Neu", $MenuItem1)
	$MenuItem3 = GUICtrlCreateMenuItem("Laden", $MenuItem1)
	$MenuItem4 = GUICtrlCreateMenuItem("Speichern", $MenuItem1)
	$MenuItem5 = GUICtrlCreateMenuItem("", $MenuItem1)
	$MenuItem6 = GUICtrlCreateMenuItem("Beenden", $MenuItem1)
	$ToolBar_ImageList = _GUIImageList_Create(32, 32, 5)
	_GUIImageList_AddIcon($ToolBar_ImageList, $a_Path[$e_Path_Gfx]&"Mapper\window_new.ico", 0, True)
	_GUIImageList_AddIcon($ToolBar_ImageList, $a_Path[$e_Path_Gfx]&"Mapper\fileopen.ico", 0, True)
	_GUIImageList_AddIcon($ToolBar_ImageList, $a_Path[$e_Path_Gfx]&"Mapper\filesaveas.ico", 0, True)
	_GUIImageList_AddIcon($ToolBar_ImageList, $a_Path[$e_Path_Gfx]&"Mapper\exit.ico", 0, True)
	_GUIImageList_AddIcon($ToolBar_ImageList, $a_Path[$e_Path_Gfx]&"Mapper\linneighborhood.ico", 0, True)
	_GUIImageList_AddIcon($ToolBar_ImageList, $a_Path[$e_Path_Gfx]&"Mapper\khelpcenter.ico", 0, True)
	_GUIImageList_AddIcon($ToolBar_ImageList, $a_Path[$e_Path_Gfx]&"Mapper\configure.ico", 0, True)
	_GUIImageList_AddIcon($ToolBar_ImageList, $a_Path[$e_Path_Gfx]&"Mapper\kdmconfig.ico", 0, True)
	$Mapper_ToolBar = _GUICtrlToolbar_Create($hGUI, BitOR($WS_VISIBLE,$WS_CHILD,$WS_CLIPSIBLINGS))
	_GUICtrlToolbar_SetImageList($Mapper_ToolBar, $ToolBar_ImageList)
	_GUICtrlToolbar_AddButton($Mapper_ToolBar, $ToolBar_New, 0, 0)
	_GUICtrlToolbar_AddButton($Mapper_ToolBar, $ToolBar_Open, 1, 0)
	_GUICtrlToolbar_AddButton($Mapper_ToolBar, $ToolBar_Save, 2, 0)
	_GUICtrlToolbar_AddButton($Mapper_ToolBar, $ToolBar_Exit, 3, 0)
	_GUICtrlToolbar_AddButton($Mapper_ToolBar, 0, 23, 0, $BTNS_SEP)
	_GUICtrlToolbar_AddButton($Mapper_ToolBar, $ToolBar_Layer1, 4, 0)
	_GUICtrlToolbar_AddButton($Mapper_ToolBar, $ToolBar_Layer2, 5, 0)
	_GUICtrlToolbar_AddButton($Mapper_ToolBar, $ToolBar_Settings, 6, 0)
	_GUICtrlToolbar_AddButton($Mapper_ToolBar, 0, 23, 0, $BTNS_SEP)
	_GUICtrlToolbar_AddButton($Mapper_ToolBar, $ToolBar_Char, 7, 0)
EndFunc
Func __GUIMapperTab0(ByRef $hTab)
	GUICtrlSetData($Mapper_Group1, "Tools: Datei")
	GUICtrlDelete($hTab)

	$hTab = GUICtrlCreateTab(552, 64, 425, 377)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Tab0_1 = GUICtrlCreateTabItem("Datei Neu")
	$File_Group1 = GUICtrlCreateGroup("", 560, 88, 409, 345)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileNew_Label1 = GUICtrlCreateLabel(" Map Texture", 576, 126, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileNew_Input1 = GUICtrlCreateInput("", 576, 143, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileNew_Button1 = GUICtrlCreateButton("Auswählen", 672, 126, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileNew_Label2 = GUICtrlCreateLabel(" Map Name", 776, 126, 185, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileNew_Input2 = GUICtrlCreateInput("", 776, 143, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileNew_Label3 = GUICtrlCreateLabel("Grösse-X", 672, 182, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileNew_Slider3 = GUICtrlCreateSlider(568, 184, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 2)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Die Grösse der Highmap bestimmen. 64 - 1024")
	$FileNew_Input3 = GUICtrlCreateInput("", 672, 200, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileNew_Slider4 = GUICtrlCreateSlider(768, 184, 100, 37)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 2)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileNew_Label4 = GUICtrlCreateLabel("Grösse-Y", 872, 182, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileNew_Input4 = GUICtrlCreateInput("", 872, 200, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileNew_Label5 = GUICtrlCreateLabel("Irrlicht Scale X/Y", 672, 246, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileNew_Slider5 = GUICtrlCreateSlider(568, 248, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 128, 1)
	GUICtrlSetData(-1, 32)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Breiten & Tiefen Scaling. 1 - 128")
	$FileNew_Input5 = GUICtrlCreateInput("", 672, 264, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileNew_Slider6 = GUICtrlCreateSlider(768, 248, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 32, 1)
	GUICtrlSetData(-1, 3)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Höhen Scaling. 1 - 32")
	$FileNew_Label6 = GUICtrlCreateLabel("Irrlicht Scale Z", 872, 246, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileNew_Input6 = GUICtrlCreateInput("", 872, 264, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$FileNew_Button0 = GUICtrlCreateButton("Übernehmen", 878, 406, 89, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)

	$Tab0_2 = GUICtrlCreateTabItem("Datei Öffnen")
	$File_Group2 = GUICtrlCreateGroup("", 560, 88, 409, 345)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileOpen_Group1 = GUICtrlCreateGroup("Map Datei Laden", 568, 112, 289, 57)
	$FileOpen_Label1 = GUICtrlCreateLabel(" Datei Auswählen", 584, 134, 132, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileOpen_Button1 = GUICtrlCreateButton("Auswählen", 720, 134, 121, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$Tab0_3 = GUICtrlCreateTabItem("Datei Speichern")
	$FileSave_Button0 = GUICtrlCreateButton("Speichern", 878, 405, 89, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$File_Group3 = GUICtrlCreateGroup("", 560, 88, 409, 345)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileSave_Label1 = GUICtrlCreateLabel(" Map Name", 576, 102, 185, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileSave_Input1 = GUICtrlCreateInput("", 576, 119, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileSave_Label2 = GUICtrlCreateLabel(" File Name", 776, 102, 185, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileSave_Input2 = GUICtrlCreateInput("", 776, 119, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileSave_Label3 = GUICtrlCreateLabel("Grösse-X", 672, 150, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileSave_Slider3 = GUICtrlCreateSlider(568, 152, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 2)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Die Grösse der Highmap bestimmen. 64 - 1024")
	$FileSave_Input3 = GUICtrlCreateInput("", 672, 168, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileSave_Slider4 = GUICtrlCreateSlider(768, 152, 100, 37)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 2)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileSave_Label4 = GUICtrlCreateLabel("Grösse-Y", 872, 150, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileSave_Input4 = GUICtrlCreateInput("", 872, 168, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileSave_Label5 = GUICtrlCreateLabel("Irrlicht Scale X/Y", 672, 206, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileSave_Slider5 = GUICtrlCreateSlider(568, 208, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 128, 1)
	GUICtrlSetData(-1, 32)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Breiten & Tiefen Scaling. 1 - 128")
	$FileSave_Input5 = GUICtrlCreateInput("", 672, 224, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileSave_Slider6 = GUICtrlCreateSlider(768, 208, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 32, 1)
	GUICtrlSetData(-1, 3)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Höhen Scaling. 1 - 32")
	$FileSave_Label6 = GUICtrlCreateLabel("Irrlicht Scale Z", 872, 206, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileSave_Input6 = GUICtrlCreateInput("", 872, 224, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileSave_Slider7 = GUICtrlCreateSlider(768, 264, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 32, 1)
	GUICtrlSetData(-1, 3)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$FileSave_Label7 = GUICtrlCreateLabel("Irrlicht Scale D", 872, 262, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileSave_Input7 = GUICtrlCreateInput("", 872, 280, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$FileSave_Group1 = GUICtrlCreateGroup("Hightmap", 576, 248, 185, 89)
	$FileSave_Checkbox1 = GUICtrlCreateCheckbox("HightMap", 584, 264, 97, 17)
	$FileSave_Checkbox2 = GUICtrlCreateCheckbox("BumpMap", 584, 288, 97, 17)
	$FileSave_Checkbox3 = GUICtrlCreateCheckbox("MixedMap", 584, 312, 97, 17)
	$FileSave_Button1 = GUICtrlCreateButton("Edit", 680, 264, 75, 17)
	$FileSave_Button2 = GUICtrlCreateButton("Edit", 680, 288, 75, 17)
	$FileSave_Button3 = GUICtrlCreateButton("Edit", 680, 312, 75, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$FileSave_Group2 = GUICtrlCreateGroup("Colormap", 576, 336, 185, 89)
	$FileSave_Checkbox4 = GUICtrlCreateCheckbox("ColorMap", 584, 352, 97, 17)
	$FileSave_Checkbox5 = GUICtrlCreateCheckbox("MacroMap", 584, 376, 97, 17)
	$FileSave_Checkbox6 = GUICtrlCreateCheckbox("MixedMacro", 584, 400, 97, 17)
	$FileSave_Button4 = GUICtrlCreateButton("Edit", 680, 352, 75, 17)
	$FileSave_Button5 = GUICtrlCreateButton("Edit", 680, 376, 75, 17)
	$FileSave_Button6 = GUICtrlCreateButton("Edit", 680, 400, 75, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$FileSave_Group3 = GUICtrlCreateGroup("Detailmap", 776, 312, 185, 65)
	$FileSave_Checkbox7 = GUICtrlCreateCheckbox("DetailMap", 784, 328, 97, 17)
	$FileSave_Checkbox8 = GUICtrlCreateCheckbox("BitplaneMap", 784, 352, 97, 17)
	$FileSave_Button7 = GUICtrlCreateButton("Edit", 880, 328, 75, 17)
	$FileSave_Button8 = GUICtrlCreateButton("Edit", 880, 352, 75, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")
EndFunc
Func __GUIMapperTab1(ByRef $hTab)
	GUICtrlSetData($Mapper_Group1, "Tools: Layer-1")
	GUICtrlDelete($hTab)

	$hTab = GUICtrlCreateTab(552, 64, 425, 377)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Tab1_1 = GUICtrlCreateTabItem("HightMap")
	$HightMap_Button1 = GUICtrlCreateButton("Hightmap", 560, 94, 131, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Button2 = GUICtrlCreateButton("Bumpmap", 694, 94, 139, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Button3 = GUICtrlCreateButton("Mixedmap", 837, 94, 131, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Group1 = GUICtrlCreateGroup("HightMap: Basics", 560, 120, 409, 313)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Checkbox10 = GUICtrlCreateCheckbox("Blur-FX Aktiv", 576, 264, 97, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Slider14 = GUICtrlCreateSlider(568, 288, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 100, 1)
	GUICtrlSetData(-1, 12)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Blurring Scaling. 0.00 - 1.00")
	$HightMap_Slider15 = GUICtrlCreateSlider(768, 288, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 4, 0)
	GUICtrlSetData(-1, 3)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Blurring Interpolation. 0 - 4")
	$HightMap_Input14 = GUICtrlCreateInput("", 672, 304, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Input15 = GUICtrlCreateInput("", 872, 304, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Label14 = GUICtrlCreateLabel("Blur Scale", 672, 286, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Label15 = GUICtrlCreateLabel("Blur Interpolation", 872, 286, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Checkbox11 = GUICtrlCreateCheckbox("Invert-FX Aktiv", 576, 336, 121, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Die Hightmap Invertieren")
	$HightMap_Label10 = GUICtrlCreateLabel("Grösse-X", 672, 150, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Slider10 = GUICtrlCreateSlider(568, 152, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 2)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Die Grösse der Highmap bestimmen. 64 - 1024")
	$HightMap_Input10 = GUICtrlCreateInput("", 672, 168, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Label12 = GUICtrlCreateLabel("Irrlicht Scale X/Y", 672, 214, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Slider12 = GUICtrlCreateSlider(568, 216, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 128, 1)
	GUICtrlSetData(-1, 32)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Breiten & Tiefen Scaling. 1 - 128")
	$HightMap_Input12 = GUICtrlCreateInput("", 672, 232, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Slider13 = GUICtrlCreateSlider(768, 216, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 32, 1)
	GUICtrlSetData(-1, 3)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Höhen Scaling. 1 - 32")
	$HightMap_Label13 = GUICtrlCreateLabel("Irrlicht Scale Z", 872, 214, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Input13 = GUICtrlCreateInput("", 872, 232, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Slider11 = GUICtrlCreateSlider(768, 152, 100, 37)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 2)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label11 = GUICtrlCreateLabel("Grösse-Y", 872, 150, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Input11 = GUICtrlCreateInput("", 872, 168, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$HightMap_Group2 = GUICtrlCreateGroup("HightMap: Bumpmapping", 560, 120, 409, 313)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO+$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Checkbox2 = GUICtrlCreateCheckbox("BumpMap-FX Aktiv", 576, 152, 113, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Slider20 = GUICtrlCreateSlider(568, 184, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 6)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Slider21 = GUICtrlCreateSlider(768, 184, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 6)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label20 = GUICtrlCreateLabel("Grösse-X", 672, 182, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input20 = GUICtrlCreateInput("", 672, 200, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label21 = GUICtrlCreateLabel("Grösse-Y", 872, 182, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input21 = GUICtrlCreateInput("", 872, 200, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Slider22 = GUICtrlCreateSlider(568, 296, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 32, 0)
	GUICtrlSetData(-1, 5)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input22 = GUICtrlCreateInput("", 672, 312, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label22 = GUICtrlCreateLabel("Bump Intense", 672, 294, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label24 = GUICtrlCreateLabel(" Texture 1", 576, 240, 100, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input24 = GUICtrlCreateInput("", 576, 257, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Button24 = GUICtrlCreateButton("Auswählen", 678, 240, 83, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label25 = GUICtrlCreateLabel(" Texture 2", 776, 240, 100, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Button25 = GUICtrlCreateButton("Auswählen", 878, 240, 83, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input25 = GUICtrlCreateInput("", 776, 257, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Slider23 = GUICtrlCreateSlider(768, 296, 102, 37)
	GUICtrlSetData(-1, 50)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label23 = GUICtrlCreateLabel("Deckungsgrad", 872, 294, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input23 = GUICtrlCreateInput("", 872, 312, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$HightMap_Group3 = GUICtrlCreateGroup("HightMap: Mixedmap", 560, 120, 409, 313)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$HightMap_Checkbox3 = GUICtrlCreateCheckbox("MixedMap-FX Aktiv", 576, 152, 145, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Slider30 = GUICtrlCreateSlider(568, 176, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Slider31 = GUICtrlCreateSlider(768, 176, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label30 = GUICtrlCreateLabel("Grösse-X", 672, 174, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label31 = GUICtrlCreateLabel("Grösse-Y", 872, 174, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input30 = GUICtrlCreateInput("", 672, 192, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input31 = GUICtrlCreateInput("", 872, 192, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label34 = GUICtrlCreateLabel(" Texture 1", 576, 232, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input34 = GUICtrlCreateInput("", 576, 249, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Button34 = GUICtrlCreateButton("Auswählen", 672, 232, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label35 = GUICtrlCreateLabel(" Texture 2", 776, 232, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Button35 = GUICtrlCreateButton("Auswählen", 870, 232, 91, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input35 = GUICtrlCreateInput("", 776, 249, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label33 = GUICtrlCreateLabel(" Mask File", 576, 288, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Button33 = GUICtrlCreateButton("Auswählen", 672, 288, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input33 = GUICtrlCreateInput("", 576, 305, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Slider32 = GUICtrlCreateSlider(768, 288, 102, 37)
	GUICtrlSetData(-1, 50)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input32 = GUICtrlCreateInput("", 872, 304, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label32 = GUICtrlCreateLabel("Deckungsgrad", 872, 286, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Slider36 = GUICtrlCreateSlider(568, 344, 102, 37)
	GUICtrlSetLimit(-1, 32, 0)
	GUICtrlSetData(-1, 5)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Input36 = GUICtrlCreateInput("", 672, 360, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$HightMap_Label36 = GUICtrlCreateLabel("Bump Intens", 672, 342, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$HightMap_Button0 = GUICtrlCreateButton("Übernehmen", 878, 406, 89, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$Tab1_2 = GUICtrlCreateTabItem("ColorMap")
	$ColorMap_Button1 = GUICtrlCreateButton("Colormap", 560, 94, 131, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Button2 = GUICtrlCreateButton("Macromap", 694, 94, 139, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Button3 = GUICtrlCreateButton("Mixed-Macromap", 837, 94, 131, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Group1 = GUICtrlCreateGroup("ColorMap: Basics", 560, 120, 409, 313)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Checkbox10 = GUICtrlCreateCheckbox("Blur-FX Aktiv", 576, 200, 97, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Slider12 = GUICtrlCreateSlider(568, 224, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetData(-1, 60)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Blurring: Scale")
	$ColorMap_Slider13 = GUICtrlCreateSlider(768, 224, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 4, 0)
	GUICtrlSetData(-1, 2)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Blurring: Interpolation")
	$ColorMap_Input12 = GUICtrlCreateInput("", 672, 240, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Scale")
	$ColorMap_Input13 = GUICtrlCreateInput("", 872, 240, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Interpolation")
	$ColorMap_Slider14 = GUICtrlCreateSlider(568, 280, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 4, 0)
	GUICtrlSetData(-1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Diffuse UV Mixing")
	$ColorMap_Input14 = GUICtrlCreateInput("", 672, 296, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Slider10 = GUICtrlCreateSlider(568, 152, 102, 37)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 6)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Label10 = GUICtrlCreateLabel("Grösse-X", 672, 150, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Input10 = GUICtrlCreateInput("", 672, 168, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Slider11 = GUICtrlCreateSlider(768, 152, 102, 37)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 6)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Label11 = GUICtrlCreateLabel("Grösse-Y", 872, 150, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Input11 = GUICtrlCreateInput("", 872, 168, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Label12 = GUICtrlCreateLabel("Blur Scale", 672, 222, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Label13 = GUICtrlCreateLabel("Blur Interpolation", 872, 222, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Label14 = GUICtrlCreateLabel("Diffuse-UV", 672, 278, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Label15 = GUICtrlCreateLabel(" Sky Box", 776, 279, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Input15 = GUICtrlCreateInput("", 776, 296, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Button15 = GUICtrlCreateButton("Auswählen", 872, 279, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$ColorMap_Group2 = GUICtrlCreateGroup("ColorMap: Macromap", 560, 120, 409, 313)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Checkbox2 = GUICtrlCreateCheckbox("MacroMap-FX Aktiv", 576, 152, 113, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Slider20 = GUICtrlCreateSlider(568, 176, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Slider21 = GUICtrlCreateSlider(768, 176, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Label20 = GUICtrlCreateLabel("Grösse-X", 672, 174, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Label21 = GUICtrlCreateLabel("Grösse-Y", 872, 174, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Input20 = GUICtrlCreateInput("", 672, 192, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Input21 = GUICtrlCreateInput("", 872, 192, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Label24 = GUICtrlCreateLabel(" Macro Texture", 776, 232, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Input24 = GUICtrlCreateInput("", 776, 249, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Button24 = GUICtrlCreateButton("Auswählen", 872, 232, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Label23 = GUICtrlCreateLabel(" Mask File", 576, 232, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Button23 = GUICtrlCreateButton("Auswählen", 672, 232, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Input23 = GUICtrlCreateInput("", 576, 249, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Slider22 = GUICtrlCreateSlider(568, 288, 302, 37)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Input22 = GUICtrlCreateInput("", 872, 304, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Label22 = GUICtrlCreateLabel("Deckungsgrad", 872, 286, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Checkbox20 = GUICtrlCreateCheckbox("Fill: AutoFlipRotate", 576, 344, 113, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$ColorMap_Group3 = GUICtrlCreateGroup("ColorMap: Mixed-Macromap", 560, 120, 409, 313)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Checkbox3 = GUICtrlCreateCheckbox("Mixed-MacroMap-FX Aktiv", 576, 152, 145, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Slider30 = GUICtrlCreateSlider(568, 176, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Slider31 = GUICtrlCreateSlider(768, 176, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Label30 = GUICtrlCreateLabel("Grösse-X", 672, 174, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Label31 = GUICtrlCreateLabel("Grösse-Y", 872, 174, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Input30 = GUICtrlCreateInput("", 672, 192, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Input31 = GUICtrlCreateInput("", 872, 192, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Label34 = GUICtrlCreateLabel(" Macro Texture 1", 576, 232, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Input34 = GUICtrlCreateInput("", 576, 249, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Button34 = GUICtrlCreateButton("Auswählen", 672, 232, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Label35 = GUICtrlCreateLabel(" Macro Texture 2", 768, 232, 100, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Button35 = GUICtrlCreateButton("Auswählen", 870, 232, 91, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Input35 = GUICtrlCreateInput("", 768, 249, 193, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Label33 = GUICtrlCreateLabel(" Mask File", 576, 344, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Button33 = GUICtrlCreateButton("Auswählen", 672, 344, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Input33 = GUICtrlCreateInput("", 576, 361, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Slider32 = GUICtrlCreateSlider(768, 344, 102, 37)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Input32 = GUICtrlCreateInput("", 872, 360, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Label32 = GUICtrlCreateLabel("Deckungsgrad", 872, 342, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Label36 = GUICtrlCreateLabel(" Macro Texture 3", 576, 288, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Input36 = GUICtrlCreateInput("", 576, 305, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Button36 = GUICtrlCreateButton("Auswählen", 672, 288, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Label37 = GUICtrlCreateLabel(" Macro Texture 4", 768, 288, 100, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$ColorMap_Button37 = GUICtrlCreateButton("Auswählen", 870, 288, 91, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Input37 = GUICtrlCreateInput("", 768, 305, 193, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$ColorMap_Checkbox30 = GUICtrlCreateCheckbox("Fill: AutoFlipRotate", 576, 392, 129, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$ColorMap_Button0 = GUICtrlCreateButton("Übernehmen", 878, 406, 89, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$Tab1_3 = GUICtrlCreateTabItem("DetailMap")
	$DetailMap_Button1 = GUICtrlCreateButton("Detailmap", 560, 94, 195, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Button2 = GUICtrlCreateButton("Bitplanemap", 773, 94, 195, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Group1 = GUICtrlCreateGroup("DetailMap: Basics", 560, 120, 409, 313)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Slider14 = GUICtrlCreateSlider(568, 320, 302, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetData(-1, 50)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Diffuse UV Mixing")
	$DetailMap_Input14 = GUICtrlCreateInput("", 872, 336, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Slider10 = GUICtrlCreateSlider(568, 152, 102, 37)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 6)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Label10 = GUICtrlCreateLabel("Grösse-X", 672, 150, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Input10 = GUICtrlCreateInput("", 672, 168, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Slider11 = GUICtrlCreateSlider(768, 152, 102, 37)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 6)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Label11 = GUICtrlCreateLabel("Grösse-Y", 872, 150, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Input11 = GUICtrlCreateInput("", 872, 168, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Label14 = GUICtrlCreateLabel("Transparenz", 872, 318, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Slider13 = GUICtrlCreateSlider(568, 264, 302, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 4, 0)
	GUICtrlSetData(-1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Diffuse UV Mixing")
	$DetailMap_Input13 = GUICtrlCreateInput("", 872, 280, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Label13 = GUICtrlCreateLabel("Diffuse-UV", 872, 262, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Label12 = GUICtrlCreateLabel("Detail Scale", 872, 206, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Slider12 = GUICtrlCreateSlider(768, 208, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 128, 1)
	GUICtrlSetData(-1, 5)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Breiten & Tiefen Scaling. 1 - 128")
	$DetailMap_Input12 = GUICtrlCreateInput("", 872, 224, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Checkbox10 = GUICtrlCreateCheckbox("Fill: AutoFlipRotate", 576, 368, 129, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Label15 = GUICtrlCreateLabel(" Detail Texture", 576, 206, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Input15 = GUICtrlCreateInput("", 576, 223, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Button15 = GUICtrlCreateButton("Auswählen", 672, 206, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$DetailMap_Group2 = GUICtrlCreateGroup("DetailMap: Bitplanemap", 560, 120, 409, 313)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Checkbox2 = GUICtrlCreateCheckbox("BitplaneMap-FX Aktiv", 576, 152, 145, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Slider20 = GUICtrlCreateSlider(568, 176, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Slider21 = GUICtrlCreateSlider(768, 176, 102, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Label20 = GUICtrlCreateLabel("Grösse-X", 672, 174, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Label21 = GUICtrlCreateLabel("Grösse-Y", 872, 174, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Input20 = GUICtrlCreateInput("", 672, 192, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Input21 = GUICtrlCreateInput("", 872, 192, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Label24 = GUICtrlCreateLabel(" Plane Texture 1", 576, 232, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Input24 = GUICtrlCreateInput("", 576, 249, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Button24 = GUICtrlCreateButton("Auswählen", 672, 232, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Label25 = GUICtrlCreateLabel(" Plane Texture 2", 768, 232, 100, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Button25 = GUICtrlCreateButton("Auswählen", 870, 232, 91, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Input25 = GUICtrlCreateInput("", 768, 249, 193, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Slider22 = GUICtrlCreateSlider(568, 344, 302, 37)
	GUICtrlSetData(-1, 50)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Input22 = GUICtrlCreateInput("", 872, 360, 89, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Label22 = GUICtrlCreateLabel("Transparenz", 872, 342, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Label26 = GUICtrlCreateLabel(" Plane Texture 3", 576, 288, 92, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Input26 = GUICtrlCreateInput("", 576, 305, 185, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Button26 = GUICtrlCreateButton("Auswählen", 672, 288, 89, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Label27 = GUICtrlCreateLabel(" Plane Texture 4", 768, 288, 100, 17, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$DetailMap_Button27 = GUICtrlCreateButton("Auswählen", 870, 288, 91, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Input27 = GUICtrlCreateInput("", 768, 305, 193, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$DetailMap_Checkbox20 = GUICtrlCreateCheckbox("Fill: AutoFlipRotate", 576, 392, 129, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$DetailMap_Button0 = GUICtrlCreateButton("Übernehmen", 878, 405, 89, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$Tab1_4 = GUICtrlCreateTabItem("Scaler")
	$Scaler_Group1 = GUICtrlCreateGroup("Scaler", 560, 88, 409, 345)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Scaler_Input1 = GUICtrlCreateInput("", 872, 136, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Scaler_Input2 = GUICtrlCreateInput("", 872, 192, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Scaler_Input3 = GUICtrlCreateInput("", 872, 248, 89, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Scaler_Label1 = GUICtrlCreateLabel("Irrlicht Scale: X/Y", 872, 118, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Scaler_Label2 = GUICtrlCreateLabel("Irrlicht Scale: Z", 872, 174, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Scaler_Label3 = GUICtrlCreateLabel(" Detail Scale", 872, 230, 89, 17, $SS_CENTER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Scaler_Slider1 = GUICtrlCreateSlider(568, 120, 302, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 128, 1)
	GUICtrlSetData(-1, 32)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$Scaler_Slider2 = GUICtrlCreateSlider(568, 176, 302, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 64, 1)
	GUICtrlSetData(-1, 5)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$Scaler_Slider3 = GUICtrlCreateSlider(568, 232, 302, 37, $GUI_SS_DEFAULT_SLIDER)
	GUICtrlSetLimit(-1, 128, 1)
	GUICtrlSetData(-1, 8)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$Scaler_Button0 = GUICtrlCreateButton("Übernehmen", 877, 405, 89, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Tab1_5 = GUICtrlCreateTabItem("Starter")
	$Starter_Group1 = GUICtrlCreateGroup("Starter", 560, 88, 409, 345)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Starter_Pic1 = GUICtrlCreatePic("", 568, 104, 256, 256, BitOR($GUI_SS_DEFAULT_PIC,$WS_CLIPSIBLINGS))
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$Starter_Input1 = GUICtrlCreateInput("", 904, 136, 57, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Starter_Input2 = GUICtrlCreateInput("", 904, 160, 57, 21, $GUI_SS_DEFAULT_INPUT)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Starter_Label1 = GUICtrlCreateLabel(" X-Pos:", 832, 136, 68, 21, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$Starter_Label2 = GUICtrlCreateLabel(" Y-Pos:", 832, 160, 68, 21, $WS_BORDER)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$Starter_Button1 = GUICtrlCreateButton("Von der Map auswählen", 832, 104, 131, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Starter_Button2 = GUICtrlCreateButton("Eintrag zufügen", 832, 192, 129, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Starter_Button3 = GUICtrlCreateButton("Eintrag löschen", 832, 344, 131, 17, $BS_NOTIFY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Starter_List1 = GUICtrlCreateList("", 832, 224, 129, 110, BitOR($LBS_NOTIFY,$LBS_SORT,$WS_BORDER))
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
	$Starter_Button0 = GUICtrlCreateButton("Übernehmen", 877, 405, 89, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")



	__GUIHightMapSwitchState("HightMap")
	__GUIHightMapSwitchCheckBox()
	__GUIColorMapSwitchState("ColorMap")
	__GUIColorMapSwitchCheckBox()
	__GUIDetailMapSwitchState("DetailMap")
	__GUIDetailMapSwitchCheckBox()
EndFunc


#EndRegion -Hauptfunktionen----------------------------------------------------------------------------------------------------------


#Region -GUI Funktionen------------------------------------------------------------------------------------------------------------

; Main GUI
Func __GUIMainSwitchState($sMode)
	Switch $sMode
		Case "Datei"
			__GUIMapperTab0($Mapper_Tab)
			_GUICtrlTab_ClickTab($Mapper_Tab, 1)
		Case "Datei Neu"
			__GUIMapperTab0($Mapper_Tab)
			_GUICtrlTab_ClickTab($Mapper_Tab, 0)
		Case "Datei Öffnen"
			__GUIMapperTab0($Mapper_Tab)
			_GUICtrlTab_ClickTab($Mapper_Tab, 1)
		Case "Datei Speichern"
			__GUIMapperTab0($Mapper_Tab)
			_GUICtrlTab_ClickTab($Mapper_Tab, 2)
;~ 		Case "Datei Config"
;~ 			__GUIMapperTab0($Mapper_Tab)
;~ 			_GUICtrlTab_ClickTab($Mapper_Tab, 3)
;~ 		Case "Datei Beenden"6
;~ 			__GUIMapperTab0($Mapper_Tab)
;~ 			_GUICtrlTab_ClickTab($Mapper_Tab, 4)

		Case "Layer1"
			__GUIMapperTab1($Mapper_Tab)
			__GUIHightMapSwitchState("HightMap")
			_GUICtrlTab_ClickTab($Mapper_Tab, 0)
		Case "Layer1 Hightmap"
			__GUIMapperTab1($Mapper_Tab)
			__GUIHightMapSwitchState("HightMap")
			_GUICtrlTab_ClickTab($Mapper_Tab, 0)
		Case "Layer1 Bumpmap"
			__GUIMapperTab1($Mapper_Tab)
			__GUIHightMapSwitchState("BumpMap")
			_GUICtrlTab_ClickTab($Mapper_Tab, 0)
		Case "Layer1 Mixedmap"
			__GUIMapperTab1($Mapper_Tab)
			__GUIHightMapSwitchState("MixedMap")
			_GUICtrlTab_ClickTab($Mapper_Tab, 0)
		Case "Layer1 Colormap"
			__GUIMapperTab1($Mapper_Tab)
			__GUIColorMapSwitchState("ColorMap")
			_GUICtrlTab_ClickTab($Mapper_Tab, 1)
		Case "Layer1 Macromap"
			__GUIMapperTab1($Mapper_Tab)
			__GUIColorMapSwitchState("MacroMap")
			_GUICtrlTab_ClickTab($Mapper_Tab, 1)
		Case "Layer1 Mixedmacromap"
			__GUIMapperTab1($Mapper_Tab)
			__GUIColorMapSwitchState("MixedMacroMap")
			_GUICtrlTab_ClickTab($Mapper_Tab, 1)
		Case "Layer1 Detailmap"
			__GUIMapperTab1($Mapper_Tab)
			__GUIDetailMapSwitchState("DetailMap")
			_GUICtrlTab_ClickTab($Mapper_Tab, 2)
		Case "Layer1 Bitplanemap"
			__GUIMapperTab1($Mapper_Tab)
			__GUIDetailMapSwitchState("BitplaneMap")
			_GUICtrlTab_ClickTab($Mapper_Tab, 2)
		Case "Layer1 Scaler"
			__GUIMapperTab1($Mapper_Tab)
			_GUICtrlTab_ClickTab($Mapper_Tab, 3)
		Case "Layer1 Starter"
			__GUIMapperTab1($Mapper_Tab)
			_GUICtrlTab_ClickTab($Mapper_Tab, 4)
;~ 		Case "Layer1 Config"
;~ 			__GUIMapperTab1($Mapper_Tab)
;~ 			_GUICtrlTab_ClickTab($Mapper_Tab, 5)

;~ 		Case "Layer2"
;~ 			__GUIMapperTab2($Mapper_Tab)
;~ 			_GUICtrlTab_ClickTab($Mapper_Tab, 5)
;~ 		Case "Layer2 PlaKlein"
;~ 			__GUIMapperTab2($Mapper_Tab)
;~ 			_GUICtrlTab_ClickTab($Mapper_Tab, 5)
;~ 		Case "Layer2 PlaGroß"
;~ 			__GUIMapperTab2($Mapper_Tab)
;~ 			_GUICtrlTab_ClickTab($Mapper_Tab, 5)
;~ 			__GUIMapperTab2($Mapper_Tab)
;~ 		Case "Layer2 TerKlein"
;~ 			__GUIMapperTab2($Mapper_Tab)
;~ 			_GUICtrlTab_ClickTab($Mapper_Tab, 5)
;~ 		Case "Layer2 TerGroß"
;~ 			__GUIMapperTab2($Mapper_Tab)
;~ 			_GUICtrlTab_ClickTab($Mapper_Tab, 5)
;~ 		Case "Layer2 Config"
;~ 			__GUIMapperTab2($Mapper_Tab)
;~ 			_GUICtrlTab_ClickTab($Mapper_Tab, 5)

;~ 		Case "System Config"
;~ 			__GUIMapperTab2($Mapper_Tab)
;~ 			_GUICtrlTab_ClickTab($Mapper_Tab, 5)

	EndSwitch

EndFunc

; HightMap GUI
Func __GUIHightMap()
	__GUIHightMapGetData()
;~ 	$s_File = $a_Path[$e_Path_Map]&$s_MapName&"\"&__MakeHightMap($s_BaseMap, $s_HightMapBlur1, $s_HightMapBlur2, $s_HightMapInvert, $s_HightMapSizeX, $s_HightMapSizeY)
;~ 	$s_File = __ConvertBMP2JPG($s_File)
;~ 	GUICtrlSetImage($HightMap_Pic1, $s_File)
;~ 	Return $s_File
EndFunc
Func __GUIHightMapGetData()
;~ 		Global $s_HightMapBMP, $s_HightMapBlur1=0.12, $s_HightMapBlur2=3, $s_HightMapInvert=0, $s_HightMapSizeX=256, $s_HightMapSizeY=256
;~ 		Global $s_NormalMapBMP, $s_NormalMapFileA, $s_NormalMapFileB="", $s_NormalMapIntense=5, $s_NormalMapProzent=50, $s_NormalMapSizeX=4096, $s_NormalMapSizeY=4096
;~ 		Global $s_MixedMapBMP, $s_MixedMapFileA, $s_MixedMapFileB, $s_MixedMapMask, $s_MixedMapIntense=5, $s_MixedMapProzent=50, $s_MixedMapSizeX=4096, $s_MixedMapSizeY=4096
	; HightMap
	$s_HightMapBMP			= "_HightMap.jpg"
	$s_HightMapSizeX 		= GUICtrlRead($HightMap_Input10)
	$s_HightMapSizeY	 	= GUICtrlRead($HightMap_Input11)
	$s_ScaleXY	 			= GUICtrlRead($HightMap_Input12)
	$s_ScaleZ	 			= GUICtrlRead($HightMap_Input13)
	if GUICtrlRead($HightMap_Checkbox10) = $GUI_CHECKED then
		$s_HightMapBlur1 	= GUICtrlRead($HightMap_Input14)/100
		$s_HightMapBlur2 	= GUICtrlRead($HightMap_Input15)
	Else
		$s_HightMapBlur1 	= 0
		$s_HightMapBlur2 	= 0
	EndIf
	if GUICtrlRead($HightMap_Checkbox11) = $GUI_CHECKED then
		$s_HightMapInvert 	= 1
	Else
		$s_HightMapInvert 	= 0
	EndIf

	; BumpMap
	$s_NormalMapBMP			= "_BumpMap.jpg"
	$s_NormalMapSizeX		= GUICtrlRead($HightMap_Input20)
	$s_NormalMapSizeY		= GUICtrlRead($HightMap_Input21)
	$s_NormalMapFileA		= GUICtrlRead($HightMap_Input24)
	$s_NormalMapFileB		= GUICtrlRead($HightMap_Input25)
	$s_NormalMapIntense		= GUICtrlRead($HightMap_Input22)
	$s_NormalMapProzent		= GUICtrlRead($HightMap_Input23)

	; MixedMap
	$s_MixedMapBMP			= "_MixedMap.jpg"
	$s_MixedMapSizeX		= GUICtrlRead($HightMap_Input30)
	$s_MixedMapSizeY		= GUICtrlRead($HightMap_Input31)
	$s_MixedMapFileA		= GUICtrlRead($HightMap_Input34)
	$s_MixedMapFileB		= GUICtrlRead($HightMap_Input35)
	$s_MixedMapMask			= GUICtrlRead($HightMap_Input33)
	$s_MixedMapIntense		= GUICtrlRead($HightMap_Input36)
	$s_MixedMapProzent		= GUICtrlRead($HightMap_Input32)
EndFunc
Func __GUIHightMapSetData()
;~ 		Global $s_HightMapBMP, $s_HightMapBlur1=0.12, $s_HightMapBlur2=3, $s_HightMapInvert=0, $s_HightMapSizeX=256, $s_HightMapSizeY=256
;~ 		Global $s_NormalMapBMP, $s_NormalMapFileA, $s_NormalMapFileB="", $s_NormalMapIntense=5, $s_NormalMapProzent=50, $s_NormalMapSizeX=4096, $s_NormalMapSizeY=4096
;~ 		Global $s_MixedMapBMP, $s_MixedMapFileA, $s_MixedMapFileB, $s_MixedMapMask, $s_MixedMapIntense=5, $s_MixedMapProzent=50, $s_MixedMapSizeX=4096, $s_MixedMapSizeY=4096
	; HightMap
	__SetSliderMapSize($HightMap_Slider10, $s_HightMapSizeX)
	GUICtrlSetData($ColorMap_Input10, $s_HightMapSizeX)
	__SetSliderMapSize($HightMap_Slider11, $s_HightMapSizeY)
	GUICtrlSetData($ColorMap_Input11, $s_HightMapSizeY)
	GUICtrlSetData($HightMap_Slider12, $s_ScaleXY)
	GUICtrlSetData($ColorMap_Input12, $s_ScaleXY)
	GUICtrlSetData($HightMap_Slider13, $s_ScaleZ)
	GUICtrlSetData($ColorMap_Input13, $s_ScaleZ)
	if $s_HightMapBlur1 > 0 and $s_HightMapBlur2 > 0 then
		GUICtrlSetState($HightMap_Checkbox10, $GUI_CHECKED)
		GUICtrlSetData($HightMap_Slider14, $s_HightMapBlur1*100)
		GUICtrlSetData($ColorMap_Input14, $s_HightMapBlur1)
		GUICtrlSetData($HightMap_Slider15, $s_HightMapBlur2)
		GUICtrlSetData($ColorMap_Input15, $s_HightMapBlur2)
	Else
		GUICtrlSetState($HightMap_Checkbox10, $GUI_UNCHECKED)
		GUICtrlSetData($HightMap_Slider14, 0)
		GUICtrlSetData($ColorMap_Input14, 0)
		GUICtrlSetData($HightMap_Slider15, 0)
		GUICtrlSetData($ColorMap_Input15, 0)
	EndIf
	if $s_HightMapInvert = 1 then
		GUICtrlSetState($HightMap_Checkbox11, $GUI_CHECKED)
	Else
		GUICtrlSetState($HightMap_Checkbox11, $GUI_UNCHECKED)
	EndIf

	; BumpMap
	__SetSliderMapSize($HightMap_Slider20, $s_NormalMapSizeX)
	GUICtrlSetData($HightMap_Input20, $s_NormalMapSizeX)
	__SetSliderMapSize($HightMap_Slider21, $s_NormalMapSizeY)
	GUICtrlSetData($HightMap_Input21, $s_NormalMapSizeY)
	GUICtrlSetData($HightMap_Input24, $s_NormalMapFileA)
	GUICtrlSetData($HightMap_Input25, $s_NormalMapFileB)
	GUICtrlSetData($HightMap_Slider22, $s_NormalMapIntense)
	GUICtrlSetData($HightMap_Input22, $s_NormalMapIntense)
	GUICtrlSetData($HightMap_Slider23, $s_NormalMapProzent)
	GUICtrlSetData($HightMap_Input23, $s_NormalMapProzent)

	; MixedMap
	__SetSliderMapSize($HightMap_Slider30, $s_MixedMapSizeX)
	GUICtrlSetData($HightMap_Input30, $s_MixedMapSizeX)
	__SetSliderMapSize($HightMap_Slider31, $s_MixedMapSizeY)
	GUICtrlSetData($HightMap_Input31, $s_MixedMapSizeY)
	GUICtrlSetData($HightMap_Input34, $s_MixedMapFileA)
	GUICtrlSetData($HightMap_Input35, $s_MixedMapFileB)
	GUICtrlSetData($HightMap_Input33, $s_MixedMapMask)
	GUICtrlSetData($HightMap_Slider36, $s_MixedMapIntense)
	GUICtrlSetData($HightMap_Input36, $s_MixedMapIntense)
	GUICtrlSetData($HightMap_Slider32, $s_MixedMapProzent)
	GUICtrlSetData($HightMap_Input32, $s_MixedMapProzent)

EndFunc
Func __GUIHightMapSwitchState($sMode)
	Local $_State[3]
	Switch $sMode
		Case "HightMap"
			dim $_State[3] = [$GUI_SHOW, $GUI_HIDE, $GUI_HIDE]
		Case "BumpMap"
			dim $_State[3] = [$GUI_HIDE, $GUI_SHOW, $GUI_HIDE]
		Case "MixedMap"
			dim $_State[3] = [$GUI_HIDE, $GUI_HIDE, $GUI_SHOW]
	EndSwitch
;~ 	$_State[1] += $GUI_DISABLE
;~ 	$_State[2] += $GUI_DISABLE

	; Standart HightMap
	Local $Data1[22] = [$HightMap_Group1, _
		$HightMap_Slider10, $HightMap_Label10, $HightMap_Input10, $HightMap_Slider11, $HightMap_Label11, $HightMap_Input11, $HightMap_Slider12, $HightMap_Label12, $HightMap_Input12, $HightMap_Slider13, $HightMap_Label13, $HightMap_Input13, $HightMap_Checkbox11, $HightMap_Checkbox11, _
		$HightMap_Checkbox10, $HightMap_Slider14, $HightMap_Label14, $HightMap_Input14, $HightMap_Slider15, $HightMap_Label15, $HightMap_Input15]
	; BumpMap
	Local $Data2[24] = [$HightMap_Group2, _
		$HightMap_Checkbox2, $HightMap_Checkbox20, $HightMap_Slider20, $HightMap_Label20, $HightMap_Input20, $HightMap_Slider21, $HightMap_Label21, $HightMap_Input21, $HightMap_Slider22, $HightMap_Label22, $HightMap_Input22, $HightMap_Slider23, $HightMap_Label23, $HightMap_Input23, _
		$HightMap_Label24, $HightMap_Input24, $HightMap_Button24, $HightMap_Label25, $HightMap_Input25, $HightMap_Button25, $HightMap_Slider26, $HightMap_Label26, $HightMap_Input26]
	; MixedMap
	Local $Data3[23] = [$HightMap_Group3, _
	$HightMap_Checkbox3, $HightMap_Slider30, $HightMap_Label30, $HightMap_Input30, $HightMap_Slider31, $HightMap_Label31, $HightMap_Input31, $HightMap_Slider32, $HightMap_Label32, $HightMap_Input32, $HightMap_Button33, $HightMap_Label33, $HightMap_Input33, _
	$HightMap_Label34, $HightMap_Input34, $HightMap_Button34, $HightMap_Label35, $HightMap_Input35, $HightMap_Button35, $HightMap_Label36, $HightMap_Input36, $HightMap_Slider36]

	; Alle auf $GUI_HIDE umschalten
	for $i = 0 to UBound($_State)-1
		if $i = 0 and $_State[$i] <> $GUI_SHOW Then
			for $j = 0 to UBound($Data1)-1
				GUICtrlSetState($Data1[$j], $_State[$i])
			Next
		elseif $i = 1 and $_State[$i] <> $GUI_SHOW Then
			for $j = 0 to UBound($Data2)-1
				GUICtrlSetState($Data2[$j], $_State[$i])
			Next
		elseif $i = 2 and $_State[$i] <> $GUI_SHOW Then
			for $j = 0 to UBound($Data3)-1
				GUICtrlSetState($Data3[$j], $_State[$i])
			Next
		EndIf
	Next
	; Auf $GUI_SHOW umschalten
	for $i = 0 to UBound($_State)-1
		if $i = 0 and $_State[$i] = $GUI_SHOW Then
			for $j = 0 to UBound($Data1)-1
				GUICtrlSetState($Data1[$j], $_State[$i])
			Next
		elseif $i = 1 and $_State[$i] = $GUI_SHOW Then
			for $j = 0 to UBound($Data2)-1
				GUICtrlSetState($Data2[$j], $_State[$i])
			Next
		elseif $i = 2 and $_State[$i] = $GUI_SHOW Then
			for $j = 0 to UBound($Data3)-1
				GUICtrlSetState($Data3[$j], $_State[$i])
			Next
		EndIf
	Next
EndFunc
Func __GUIHightMapSwitchCheckBox()
	Local $_State1, $_State2, $_State3

	; Standart HightMap: Blur-FX
	if GUICtrlRead($HightMap_Checkbox10) = $GUI_CHECKED then
		$_State1 = $GUI_ENABLE
	Else
		$_State1 = $GUI_DISABLE
	EndIf
	GUICtrlSetState($HightMap_Label14, $_State1)
	GUICtrlSetState($HightMap_Input14, $_State1)
	GUICtrlSetState($HightMap_Slider14, $_State1)
	GUICtrlSetState($HightMap_Label15, $_State1)
	GUICtrlSetState($HightMap_Input15, $_State1)
	GUICtrlSetState($HightMap_Slider15, $_State1)

	; BumpMap
	if GUICtrlRead($HightMap_Checkbox2) = $GUI_CHECKED then
		$_State2 = $GUI_ENABLE
	Else
		$_State2 = $GUI_DISABLE
	EndIf
	GUICtrlSetState($HightMap_Slider20, $_State2)
	GUICtrlSetState($HightMap_Label20, $_State2)
	GUICtrlSetState($HightMap_Input20, $_State2)
	GUICtrlSetState($HightMap_Slider21, $_State2)
	GUICtrlSetState($HightMap_Label21, $_State2)
	GUICtrlSetState($HightMap_Input21, $_State2)
	GUICtrlSetState($HightMap_Slider22, $_State2)
	GUICtrlSetState($HightMap_Label22, $_State2)
	GUICtrlSetState($HightMap_Input22, $_State2)
	GUICtrlSetState($HightMap_Slider23, $_State2)
	GUICtrlSetState($HightMap_Label23, $_State2)
	GUICtrlSetState($HightMap_Input23, $_State2)
	GUICtrlSetState($HightMap_Button24, $_State2)
	GUICtrlSetState($HightMap_Label24, $_State2)
	GUICtrlSetState($HightMap_Input24, $_State2)
	GUICtrlSetState($HightMap_Button25, $_State2)
	GUICtrlSetState($HightMap_Label25, $_State2)
	GUICtrlSetState($HightMap_Input25, $_State2)

	; MixedMap
	if GUICtrlRead($HightMap_Checkbox3) = $GUI_CHECKED then
		$_State3 = $GUI_ENABLE
	Else
		$_State3 = $GUI_DISABLE
	EndIf
	GUICtrlSetState($HightMap_Slider30, $_State3)
	GUICtrlSetState($HightMap_Label30, $_State3)
	GUICtrlSetState($HightMap_Input30, $_State3)
	GUICtrlSetState($HightMap_Slider31, $_State3)
	GUICtrlSetState($HightMap_Label31, $_State3)
	GUICtrlSetState($HightMap_Input31, $_State3)
	GUICtrlSetState($HightMap_Slider32, $_State3)
	GUICtrlSetState($HightMap_Label32, $_State3)
	GUICtrlSetState($HightMap_Input32, $_State3)
	GUICtrlSetState($HightMap_Button33, $_State3)
	GUICtrlSetState($HightMap_Label33, $_State3)
	GUICtrlSetState($HightMap_Input33, $_State3)
	GUICtrlSetState($HightMap_Label34, $_State3)
	GUICtrlSetState($HightMap_Input34, $_State3)
	GUICtrlSetState($HightMap_Button34, $_State3)
	GUICtrlSetState($HightMap_Label35, $_State3)
	GUICtrlSetState($HightMap_Input35, $_State3)
	GUICtrlSetState($HightMap_Button35, $_State3)
	GUICtrlSetState($HightMap_Label36, $_State3)
	GUICtrlSetState($HightMap_Input36, $_State3)
	GUICtrlSetState($HightMap_Slider36, $_State3)
EndFunc

; ColorMap GUI
Func __GUIColorMap()
	__GUIColorMapGetData()
;~ 	$s_File = $a_Path[$e_Path_Map]&$s_MapName&"\"&__MakeColorMap($s_BaseMap, $s_ColorMapBlur1, $s_ColorMapBlur2, $s_ColorMapDiffuseUV)
;~ 	$s_File = __ConvertBMP2JPG($s_File)
;~ 	GUICtrlSetImage($ColorMap_Pic1, $s_File)
;~ 	Return $s_File
EndFunc
Func __GUIColorMapGetData()
;~ 		$s_ColorMapBMP, $s_ColorMapBlur1=0.60, $s_ColorMapBlur2=2, $s_ColorMapDiffuseUV=0, $s_ColorMapSizeX=4096, $s_ColorMapSizeY=4096
;~ 		$s_MacroMapBMP, $s_MacroMapFileA, $s_MacroMapFileB, $s_MacroMapMask, $s_MacroMapAutoFlipRotate=1, $s_MacroMapDiffuseUV=0, $s_MacroMapProzent=50, $s_MacroMapSizeX=4096, $s_MacroMapSizeY=4096
;~ 		$s_MixedMacroMapBMP, $s_MixedMacroMapFile, $s_MixedMacroMapMask, $s_MixedMacroMapTex1, $s_MixedMacroMapTex2, $s_MixedMacroMapTex3, $s_MixedMacroMapTex4, $s_MixedMacroMapAutoFlipRotate=1, $s_MixedMacroMapDiffuseUV=0, $s_MixedMacroMapProzent=50, $s_MixedMacroMapSizeX=4096, $s_MixedMacroMapSizeY=4096
	; ColorMap
	$s_ColorMapBMP			= "_ColorMap.jpg"
	$s_ColorMapSizeX 		= GUICtrlRead($ColorMap_Input10)
	$s_ColorMapSizeY	 	= GUICtrlRead($ColorMap_Input11)
	$s_ColorMapDiffuseUV 	= GUICtrlRead($ColorMap_Input14)
	$s_SkyBox 				= GUICtrlRead($ColorMap_Input15)
	if GUICtrlRead($ColorMap_Checkbox10) = $GUI_CHECKED then
		$s_ColorMapBlur1 	= GUICtrlRead($ColorMap_Input12)/100
		$s_ColorMapBlur2 	= GUICtrlRead($ColorMap_Input13)
	Else
		$s_ColorMapBlur1 	= 0
		$s_ColorMapBlur2 	= 0
	EndIf

	; MacroMap
	$s_MacroMapBMP			= "_MacroMap.jpg"
	$s_MacroMapSizeX 		= GUICtrlRead($ColorMap_Input20)
	$s_MacroMapSizeY 		= GUICtrlRead($ColorMap_Input21)
	$s_MacroMapProzent 		= GUICtrlRead($ColorMap_Input22)
	$s_MacroMapMask 		= GUICtrlRead($ColorMap_Input23)
	$s_MacroMapFileA 		= $s_ColorMapBMP
	$s_MacroMapFileB 		= GUICtrlRead($ColorMap_Input24)
	$s_MacroMapDiffuseUV 	= 0
	if GUICtrlRead($ColorMap_Checkbox20) = $GUI_CHECKED then
		$s_MacroMapAutoFlipRotate = 1
	Else
		$s_MacroMapAutoFlipRotate = 0
	EndIf

	; MixedMacroMap
	$s_MixedMacroMapBMP		= "_MixedMacroMap.jpg"
	$s_MixedMacroMapSizeX	= GUICtrlRead($ColorMap_Input30)
	$s_MixedMacroMapSizeY	= GUICtrlRead($ColorMap_Input31)
	$s_MixedMacroMapProzent	= GUICtrlRead($ColorMap_Input32)
	$s_MixedMacroMapMask	= GUICtrlRead($ColorMap_Input33)
	$s_MixedMacroMapFile	= $s_ColorMapBMP
	$s_MixedMacroMapTex1	= GUICtrlRead($ColorMap_Input34)
	$s_MixedMacroMapTex2	= GUICtrlRead($ColorMap_Input35)
	$s_MixedMacroMapTex3	= GUICtrlRead($ColorMap_Input36)
	$s_MixedMacroMapTex4	= GUICtrlRead($ColorMap_Input37)
	$s_MixedMacroMapDiffuseUV	= 0
	if GUICtrlRead($ColorMap_Checkbox30) = $GUI_CHECKED then
		$s_MixedMacroMapAutoFlipRotate = 1
	Else
		$s_MixedMacroMapAutoFlipRotate = 0
	EndIf
EndFunc
Func __GUIColorMapSetData()
;~ 		$s_ColorMapBMP, $s_ColorMapBlur1=0.60, $s_ColorMapBlur2=2, $s_ColorMapDiffuseUV=0, $s_ColorMapSizeX=4096, $s_ColorMapSizeY=4096
;~ 		$s_MacroMapBMP, $s_MacroMapFileA, $s_MacroMapFileB, $s_MacroMapMask, $s_MacroMapAutoFlipRotate=1, $s_MacroMapDiffuseUV=0, $s_MacroMapProzent=50, $s_MacroMapSizeX=4096, $s_MacroMapSizeY=4096
;~ 		$s_MixedMacroMapBMP, $s_MixedMacroMapFile, $s_MixedMacroMapMask, $s_MixedMacroMapTex1, $s_MixedMacroMapTex2, $s_MixedMacroMapTex3, $s_MixedMacroMapTex4, $s_MixedMacroMapAutoFlipRotate=1, $s_MixedMacroMapDiffuseUV=0, $s_MixedMacroMapProzent=50, $s_MixedMacroMapSizeX=4096, $s_MixedMacroMapSizeY=4096
	; ColorMap
	__SetSliderMapSize($ColorMap_Slider10, $s_ColorMapSizeX)
	GUICtrlSetData($ColorMap_Input10, $s_ColorMapSizeX)
	__SetSliderMapSize($ColorMap_Slider11, $s_ColorMapSizeY)
	GUICtrlSetData($ColorMap_Input11, $s_ColorMapSizeY)
	GUICtrlSetData($ColorMap_Slider14, $s_ColorMapDiffuseUV)
	GUICtrlSetData($ColorMap_Input14, $s_ColorMapDiffuseUV)
	GUICtrlSetData($ColorMap_Input15, $s_SkyBox)
	if $s_HightMapBlur1 > 0 and $s_HightMapBlur2 > 0 then
		GUICtrlSetState($ColorMap_Checkbox10, $GUI_CHECKED)
		GUICtrlSetData($ColorMap_Slider12, $s_ColorMapBlur1*100)
		GUICtrlSetData($ColorMap_Input12, $s_ColorMapBlur1)
		GUICtrlSetData($ColorMap_Slider13, $s_ColorMapBlur2)
		GUICtrlSetData($ColorMap_Input13, $s_ColorMapBlur2)
	Else
		GUICtrlSetState($ColorMap_Checkbox10, $GUI_UNCHECKED)
		GUICtrlSetData($ColorMap_Slider12, 0)
		GUICtrlSetData($ColorMap_Input12, 0)
		GUICtrlSetData($ColorMap_Slider13, 0)
		GUICtrlSetData($ColorMap_Input13, 0)
	EndIf

	; MacroMap
	__SetSliderMapSize($ColorMap_Slider20, $s_MacroMapSizeX)
	GUICtrlSetData($ColorMap_Input20, $s_MacroMapSizeX)
	__SetSliderMapSize($ColorMap_Slider21, $s_MacroMapSizeY)
	GUICtrlSetData($ColorMap_Input21, $s_MacroMapSizeY)
	GUICtrlSetData($ColorMap_Slider22, $s_MacroMapProzent)
	GUICtrlSetData($ColorMap_Input22, $s_MacroMapProzent)
	GUICtrlSetData($ColorMap_Input23, $s_MacroMapFileB)
	GUICtrlSetData($ColorMap_Input24, $s_MacroMapMask)
	if $s_MacroMapAutoFlipRotate = 1 then
		GUICtrlSetState($ColorMap_Checkbox20, $GUI_CHECKED)
	Else
		GUICtrlSetState($ColorMap_Checkbox20, $GUI_UNCHECKED)
	EndIf

	; Mixed MacroMap
	__SetSliderMapSize($ColorMap_Slider30, $s_MixedMacroMapSizeX)
	GUICtrlSetData($ColorMap_Input30, $s_MixedMacroMapSizeX)
	__SetSliderMapSize($ColorMap_Slider31, $s_MixedMacroMapSizeY)
	GUICtrlSetData($ColorMap_Input31, $s_MixedMacroMapSizeY)
	GUICtrlSetData($ColorMap_Slider32, $s_MixedMacroMapProzent)
	GUICtrlSetData($ColorMap_Input32, $s_MixedMacroMapProzent)
	GUICtrlSetData($ColorMap_Input33, $s_MixedMacroMapMask)
	GUICtrlSetData($ColorMap_Input34, $s_MixedMacroMapTex1)
	GUICtrlSetData($ColorMap_Input35, $s_MixedMacroMapTex2)
	GUICtrlSetData($ColorMap_Input36, $s_MixedMacroMapTex3)
	GUICtrlSetData($ColorMap_Input37, $s_MixedMacroMapTex4)
	if $s_MixedMacroMapAutoFlipRotate = 1 then
		GUICtrlSetState($ColorMap_Checkbox30, $GUI_CHECKED)
	Else
		GUICtrlSetState($ColorMap_Checkbox30, $GUI_UNCHECKED)
	EndIf
EndFunc
Func __GUIColorMapSwitchState($sMode)
	Local $_State[3]
	Switch $sMode
		Case "ColorMap"
			dim $_State[3] = [$GUI_SHOW, $GUI_HIDE, $GUI_HIDE]
		Case "MacroMap"
			dim $_State[3] = [$GUI_HIDE, $GUI_SHOW, $GUI_HIDE]
		Case "MixedMacroMap"
			dim $_State[3] = [$GUI_HIDE, $GUI_HIDE, $GUI_SHOW]
	EndSwitch
;~ 	$_State[1] += $GUI_DISABLE
;~ 	$_State[2] += $GUI_DISABLE

		; Standart ColorMap
	Local $Data1[20] = [$ColorMap_Group1, _
		$ColorMap_Checkbox10, $ColorMap_Slider12, $ColorMap_Label12, $ColorMap_Input12, $ColorMap_Slider13, $ColorMap_Label13, $ColorMap_Input13, _
		$ColorMap_Slider10, $ColorMap_Label10, $ColorMap_Input10, $ColorMap_Slider11, $ColorMap_Label11, $ColorMap_Input11, $ColorMap_Slider14, $ColorMap_Label14, $ColorMap_Input14, $ColorMap_Button15, $ColorMap_Label15, $ColorMap_Input15]
	; MacroMap
	Local $Data2[18] = [$ColorMap_Group2, _
		$ColorMap_Checkbox2, $ColorMap_Checkbox20, $ColorMap_Slider20, $ColorMap_Label20, $ColorMap_Input20, $ColorMap_Slider21, $ColorMap_Label21, $ColorMap_Input21, $ColorMap_Slider22, $ColorMap_Label22, $ColorMap_Input22, _
		$ColorMap_Label23, $ColorMap_Input23, $ColorMap_Button23, $ColorMap_Label24, $ColorMap_Input24, $ColorMap_Button24]
	; MixedMacroMap
	Local $Data3[27] = [$ColorMap_Group3, _
		$ColorMap_Checkbox3, $ColorMap_Checkbox30, $ColorMap_Slider30, $ColorMap_Label30, $ColorMap_Input30, $ColorMap_Slider31, $ColorMap_Label31, $ColorMap_Input31, $ColorMap_Slider32, $ColorMap_Label32, $ColorMap_Input32, _
		$ColorMap_Label33, $ColorMap_Input33, $ColorMap_Button33, $ColorMap_Label34, $ColorMap_Input34, $ColorMap_Button34, $ColorMap_Label35, $ColorMap_Input35, $ColorMap_Button35, _
		$ColorMap_Label36, $ColorMap_Input36, $ColorMap_Button36, $ColorMap_Label37, $ColorMap_Input37, $ColorMap_Button37]

	; Alle auf $GUI_HIDE umschalten
	for $i = 0 to UBound($_State)-1
		if $i = 0 and $_State[$i] <> $GUI_SHOW Then
			for $j = 0 to UBound($Data1)-1
				GUICtrlSetState($Data1[$j], $_State[$i])
			Next
		elseif $i = 1 and $_State[$i] <> $GUI_SHOW Then
			for $j = 0 to UBound($Data2)-1
				GUICtrlSetState($Data2[$j], $_State[$i])
			Next
		elseif $i = 2 and $_State[$i] <> $GUI_SHOW Then
			for $j = 0 to UBound($Data3)-1
				GUICtrlSetState($Data3[$j], $_State[$i])
			Next
		EndIf
	Next
	; Auf $GUI_SHOW umschalten
	for $i = 0 to UBound($_State)-1
		if $i = 0 and $_State[$i] = $GUI_SHOW Then
			for $j = 0 to UBound($Data1)-1
				GUICtrlSetState($Data1[$j], $_State[$i])
			Next
		elseif $i = 1 and $_State[$i] = $GUI_SHOW Then
			for $j = 0 to UBound($Data2)-1
				GUICtrlSetState($Data2[$j], $_State[$i])
			Next
		elseif $i = 2 and $_State[$i] = $GUI_SHOW Then
			for $j = 0 to UBound($Data3)-1
				GUICtrlSetState($Data3[$j], $_State[$i])
			Next
		EndIf
	Next
EndFunc
Func __GUIColorMapSwitchCheckBox()
	Local $_State1,$_State2,$_State3

	; Standart ColorMap: Blur-FX
	if GUICtrlRead($ColorMap_Checkbox10) = $GUI_CHECKED then
		$_State1 = $GUI_ENABLE
	Else
		$_State1 = $GUI_DISABLE
	EndIf
	GUICtrlSetState($ColorMap_Slider12, $_State1)
	GUICtrlSetState($ColorMap_Input12, $_State1)
	GUICtrlSetState($ColorMap_Label12, $_State1)
	GUICtrlSetState($ColorMap_Slider13, $_State1)
	GUICtrlSetState($ColorMap_Input13, $_State1)
	GUICtrlSetState($ColorMap_Label13, $_State1)

	; MacroMap
	if GUICtrlRead($ColorMap_Checkbox2) = $GUI_CHECKED then
		$_State2 = $GUI_ENABLE
	Else
		$_State2 = $GUI_DISABLE
	EndIf
	GUICtrlSetState($ColorMap_Checkbox20, $_State2)
	GUICtrlSetState($ColorMap_Slider20, $_State2)
	GUICtrlSetState($ColorMap_Label20, $_State2)
	GUICtrlSetState($ColorMap_Input20, $_State2)
	GUICtrlSetState($ColorMap_Input21, $_State2)
	GUICtrlSetState($ColorMap_Slider21, $_State2)
	GUICtrlSetState($ColorMap_Label21, $_State2)
	GUICtrlSetState($ColorMap_Slider22, $_State2)
	GUICtrlSetState($ColorMap_Label22, $_State2)
	GUICtrlSetState($ColorMap_Input22, $_State2)
	GUICtrlSetState($ColorMap_Label23, $_State2)
	GUICtrlSetState($ColorMap_Input23, $_State2)
	GUICtrlSetState($ColorMap_Button23, $_State2)
	GUICtrlSetState($ColorMap_Label24, $_State2)
	GUICtrlSetState($ColorMap_Input24, $_State2)
	GUICtrlSetState($ColorMap_Button24, $_State2)

	; MixedMacroMap
	if GUICtrlRead($ColorMap_Checkbox3) = $GUI_CHECKED then
		$_State3 = $GUI_ENABLE
	Else
		$_State3 = $GUI_DISABLE
	EndIf
	GUICtrlSetState($ColorMap_Checkbox30, $_State3)
	GUICtrlSetState($ColorMap_Slider30, $_State3)
	GUICtrlSetState($ColorMap_Label30, $_State3)
	GUICtrlSetState($ColorMap_Input30, $_State3)
	GUICtrlSetState($ColorMap_Slider31, $_State3)
	GUICtrlSetState($ColorMap_Label31, $_State3)
	GUICtrlSetState($ColorMap_Input31, $_State3)
	GUICtrlSetState($ColorMap_Slider32, $_State3)
	GUICtrlSetState($ColorMap_Label32, $_State3)
	GUICtrlSetState($ColorMap_Input32, $_State3)
	GUICtrlSetState($ColorMap_Label33, $_State3)
	GUICtrlSetState($ColorMap_Input33, $_State3)
	GUICtrlSetState($ColorMap_Button33, $_State3)
	GUICtrlSetState($ColorMap_Label34, $_State3)
	GUICtrlSetState($ColorMap_Input34, $_State3)
	GUICtrlSetState($ColorMap_Button34, $_State3)
	GUICtrlSetState($ColorMap_Label35, $_State3)
	GUICtrlSetState($ColorMap_Input35, $_State3)
	GUICtrlSetState($ColorMap_Button35, $_State3)
	GUICtrlSetState($ColorMap_Label36, $_State3)
	GUICtrlSetState($ColorMap_Input36, $_State3)
	GUICtrlSetState($ColorMap_Button36, $_State3)
	GUICtrlSetState($ColorMap_Label37, $_State3)
	GUICtrlSetState($ColorMap_Input37, $_State3)
	GUICtrlSetState($ColorMap_Button37, $_State3)
EndFunc

; DetailMap GUI
Func __GUIDetailMap()
;~ 	__GUIDetailMapGetData()
	Local $s_File = $a_Path[$e_Path_Map]&$s_MapName&"\_DetailMap.jpg"
;~ 	$s_File = $a_Path[$e_Path_Map]&$s_MapName&"\"&__MakeDetailMap($s_DetailMapFile)
;~ 	$s_File = __ConvertBMP2JPG($s_File)
;~ 	GUICtrlSetImage($DetailMap_Pic1, $s_File)
;~ 	GUICtrlSetImage($DetailMap_Pic10, $s_File)
	if GUICtrlRead($DetailMap_Checkbox20) = $GUI_CHECKED then
;~ 		GUICtrlSetImage($DetailMap_Pic20, __ConvertBMP2JPG($a_Path[$e_Path_Detail]&$s_BitplanesTex1))
;~ 		GUICtrlSetImage($DetailMap_Pic21, __ConvertBMP2JPG($a_Path[$e_Path_Detail]&$s_BitplanesTex2))
;~ 		GUICtrlSetImage($DetailMap_Pic22, __ConvertBMP2JPG($a_Path[$e_Path_Detail]&$s_BitplanesTex3))
;~ 		GUICtrlSetImage($DetailMap_Pic23, __ConvertBMP2JPG($a_Path[$e_Path_Detail]&$s_BitplanesTex4))
;~ 		$s_File = $a_Path[$e_Path_Map]&$s_MapName&"\"&__MakeBitplaneMap($s_BitplanesTex1, $s_BitplanesTex2, $s_BitplanesTex3, $s_BitplanesTex4, $s_BitplanesSizeX, $s_BitplanesSizeY)
;~ 		$s_File = __ConvertBMP2JPG($s_File)
;~ 		GUICtrlSetImage($DetailMap_Pic1, $s_File)
	EndIf
;~ 	Return $s_File
EndFunc
Func __GUIDetailMapGetData()
;~ 		Global $s_DetailMapBMP, $s_DetailMapFile, $s_DetailMapBlur1=0, $s_DetailMapBlur2=0, $s_DetailMapAlpha=0, $s_DetailMapInvert=0, $s_DetailMapDiffuseUV=0, $s_DetailMapAutoFlipRotate=1, $s_DetailMapSizeX=4096, $s_DetailMapSizeY=4096
;~ 		Global $s_BitplanesBMP, $s_BitplanesTex1, $s_BitplanesTex2, $s_BitplanesTex3, $s_BitplanesTex4, $s_BitplanesAlpha=0, $s_BitplanesDiffuseUV=0, $s_BitplanesAutoFlipRotate=1, $s_BitplanesSizeX=4096, $s_BitplanesSizeY=4096
	; DetailMap
	$s_DetailMapBMP		= "_DetailMap.jpg"
	$s_DetailMapSizeX 	= GUICtrlRead($HightMap_Input10)
	$s_DetailMapSizeY 	= GUICtrlRead($HightMap_Input11)
	$s_DetailMapFile 	= GUICtrlRead($DetailMap_Input15)
	$s_ScaleD 			= GUICtrlRead($DetailMap_Input12)
	$s_DetailMapDiffuseUV= GUICtrlRead($DetailMap_Input13)
	$s_DetailMapAlpha	= GUICtrlRead($DetailMap_Input14)
	if GUICtrlRead($DetailMap_Checkbox10) = $GUI_CHECKED then
		$s_DetailMapAutoFlipRotate 	= 1
	Else
		$s_DetailMapAutoFlipRotate 	= 0
	EndIf

	; BitplaneMap
	$s_BitplanesBMP		= "_BitplaneMap.jpg"
	$s_BitplanesSizeX 	= GUICtrlRead($DetailMap_Input20)
	$s_BitplanesSizeY 	= GUICtrlRead($DetailMap_Input21)
	$s_BitplanesTex1 	= GUICtrlRead($DetailMap_Input24)
	$s_BitplanesTex2 	= GUICtrlRead($DetailMap_Input25)
	$s_BitplanesTex3 	= GUICtrlRead($DetailMap_Input26)
	$s_BitplanesTex4 	= GUICtrlRead($DetailMap_Input27)
	$s_BitplanesAlpha 	= GUICtrlRead($DetailMap_Input22)
	$s_BitplanesDiffuseUV= 0
	if GUICtrlRead($DetailMap_Checkbox20) = $GUI_CHECKED then
		$s_BitplanesAutoFlipRotate 	= 1
	Else
		$s_BitplanesAutoFlipRotate 	= 0
	EndIf
EndFunc
Func __GUIDetailMapSetData()
;~ 		Global $s_DetailMapBMP, $s_DetailMapFile, $s_DetailMapBlur1=0, $s_DetailMapBlur2=0, $s_DetailMapAlpha=0, $s_DetailMapInvert=0, $s_DetailMapDiffuseUV=0, $s_DetailMapAutoFlipRotate=1, $s_DetailMapSizeX=4096, $s_DetailMapSizeY=4096
;~ 		Global $s_BitplanesBMP, $s_BitplanesTex1, $s_BitplanesTex2, $s_BitplanesTex3, $s_BitplanesTex4, $s_BitplanesAlpha=0, $s_BitplanesDiffuseUV=0, $s_BitplanesAutoFlipRotate=1, $s_BitplanesSizeX=4096, $s_BitplanesSizeY=4096
	; DetailMap
	__SetSliderMapSize($DetailMap_Slider10, $s_DetailMapSizeX)
	GUICtrlSetData($DetailMap_Input10, $s_DetailMapSizeX)
	__SetSliderMapSize($DetailMap_Slider11, $s_DetailMapSizeY)
	GUICtrlSetData($DetailMap_Input11, $s_DetailMapSizeY)
	GUICtrlSetData($DetailMap_Input15, $s_DetailMapFile)
	GUICtrlSetData($DetailMap_Slider12, $s_ScaleD)
	GUICtrlSetData($DetailMap_Input12, $s_ScaleD)
	GUICtrlSetData($DetailMap_Slider13, $s_DetailMapDiffuseUV)
	GUICtrlSetData($DetailMap_Input13, $s_DetailMapDiffuseUV)
	GUICtrlSetData($DetailMap_Slider14, $s_DetailMapAlpha)
	GUICtrlSetData($DetailMap_Input14, $s_DetailMapAlpha)
	if $s_DetailMapAutoFlipRotate = 1 then
		GUICtrlSetState($DetailMap_Checkbox10, $GUI_CHECKED)
	Else
		GUICtrlSetState($DetailMap_Checkbox10, $GUI_UNCHECKED)
	EndIf

	; Bitplane
	__SetSliderMapSize($DetailMap_Slider20, $s_BitplanesSizeX)
	GUICtrlSetData($DetailMap_Input20, $s_BitplanesSizeX)
	__SetSliderMapSize($DetailMap_Slider21, $s_BitplanesSizeY)
	GUICtrlSetData($DetailMap_Input21, $s_BitplanesSizeY)
	GUICtrlSetData($DetailMap_Input24, $s_BitplanesTex1)
	GUICtrlSetData($DetailMap_Input25, $s_BitplanesTex2)
	GUICtrlSetData($DetailMap_Input26, $s_BitplanesTex3)
	GUICtrlSetData($DetailMap_Input27, $s_BitplanesTex4)
	GUICtrlSetData($DetailMap_Slider22, $s_BitplanesAlpha)
	GUICtrlSetData($DetailMap_Input22, $s_BitplanesAlpha)
	if $s_BitplanesAutoFlipRotate = 1 then
		GUICtrlSetState($DetailMap_Checkbox20, $GUI_CHECKED)
	Else
		GUICtrlSetState($DetailMap_Checkbox20, $GUI_UNCHECKED)
	EndIf
EndFunc
Func __GUIDetailMapSwitchState($sMode)
	Local $_State[2]
	Switch $sMode
		Case "DetailMap"
			dim $_State[2] = [$GUI_SHOW, $GUI_HIDE]
		Case "BitplaneMap"
			dim $_State[2] = [$GUI_HIDE, $GUI_SHOW]
	EndSwitch
;~ 	$_State[1] += $GUI_DISABLE

	; Standart DetailMap
	Local $Data1[20] = [$DetailMap_Group1, _
		$DetailMap_Checkbox10, $DetailMap_Slider10, $DetailMap_Label10, $DetailMap_Input10, $DetailMap_Slider11, $DetailMap_Label11, $DetailMap_Input11, $DetailMap_Slider12, $DetailMap_Label12, $DetailMap_Input12, _
		$DetailMap_Slider13, $DetailMap_Label13, $DetailMap_Input13, $DetailMap_Slider14, $DetailMap_Label14, $DetailMap_Input14, $DetailMap_Button15, $DetailMap_Label15, $DetailMap_Input15]
	; BitplaneMap
	Local $Data2[27] = [$DetailMap_Group2, _
		$DetailMap_Checkbox2, $DetailMap_Checkbox20, $DetailMap_Slider20, $DetailMap_Label20, $DetailMap_Input20, $DetailMap_Slider21, $DetailMap_Label21, $DetailMap_Input21, $DetailMap_Slider22, $DetailMap_Label22, $DetailMap_Input22, _
		$DetailMap_Label23, $DetailMap_Input23, $DetailMap_Button23, $DetailMap_Label24, $DetailMap_Input24, $DetailMap_Button24, $DetailMap_Label25, $DetailMap_Input25, $DetailMap_Button25, _
		$DetailMap_Label26, $DetailMap_Input26, $DetailMap_Button26, $DetailMap_Label27, $DetailMap_Input27, $DetailMap_Button27]

	; Alle auf $GUI_HIDE umschalten
	for $i = 0 to UBound($_State)-1
		if $i = 0 and $_State[$i] <> $GUI_SHOW Then
			for $j = 0 to UBound($Data1)-1
				GUICtrlSetState($Data1[$j], $_State[$i])
			Next
		elseif $i = 1 and $_State[$i] <> $GUI_SHOW Then
			for $j = 0 to UBound($Data2)-1
				GUICtrlSetState($Data2[$j], $_State[$i])
			Next
		EndIf
	Next
	; Auf $GUI_SHOW umschalten
	for $i = 0 to UBound($_State)-1
		if $i = 0 and $_State[$i] = $GUI_SHOW Then
			for $j = 0 to UBound($Data1)-1
				GUICtrlSetState($Data1[$j], $_State[$i])
			Next
		elseif $i = 1 and $_State[$i] = $GUI_SHOW Then
			for $j = 0 to UBound($Data2)-1
				GUICtrlSetState($Data2[$j], $_State[$i])
			Next
		EndIf
	Next
EndFunc
Func __GUIDetailMapSwitchCheckBox()
	Local $_State1

	; BitplaneMap
	if GUICtrlRead($DetailMap_Checkbox2) = $GUI_CHECKED then
		$_State1 = $GUI_ENABLE
	Else
		$_State1 = $GUI_DISABLE
	EndIf
	GUICtrlSetState($DetailMap_Checkbox20, $_State1)
	GUICtrlSetState($DetailMap_Slider20, $_State1)
	GUICtrlSetState($DetailMap_Label20, $_State1)
	GUICtrlSetState($DetailMap_Input20, $_State1)
	GUICtrlSetState($DetailMap_Slider21, $_State1)
	GUICtrlSetState($DetailMap_Label21, $_State1)
	GUICtrlSetState($DetailMap_Input21, $_State1)
	GUICtrlSetState($DetailMap_Slider22, $_State1)
	GUICtrlSetState($DetailMap_Label22, $_State1)
	GUICtrlSetState($DetailMap_Input22, $_State1)
	GUICtrlSetState($DetailMap_Label23, $_State1)
	GUICtrlSetState($DetailMap_Input23, $_State1)
	GUICtrlSetState($DetailMap_Button23, $_State1)
	GUICtrlSetState($DetailMap_Label24, $_State1)
	GUICtrlSetState($DetailMap_Input24, $_State1)
	GUICtrlSetState($DetailMap_Button24, $_State1)
	GUICtrlSetState($DetailMap_Label25, $_State1)
	GUICtrlSetState($DetailMap_Input25, $_State1)
	GUICtrlSetState($DetailMap_Button25, $_State1)
	GUICtrlSetState($DetailMap_Label26, $_State1)
	GUICtrlSetState($DetailMap_Input26, $_State1)
	GUICtrlSetState($DetailMap_Button26, $_State1)
	GUICtrlSetState($DetailMap_Label27, $_State1)
	GUICtrlSetState($DetailMap_Input27, $_State1)
	GUICtrlSetState($DetailMap_Button27, $_State1)
EndFunc

; Starter GUI
Func __GUIStarterGetData()
;~ 		Global $Starter_Button0, $Starter_Group1, _
;~ 		$Starter_Pic1, $Starter_List1, $Starter_Button1, $Starter_Button2, $Starter_Button3, $Starter_Label1, $Starter_Input1, $Starter_Slider2, $Starter_Label2, $Starter_Input2
	; Starter
EndFunc
Func __GUIStarterSetData()
;~ 		Global $Starter_Button0, $Starter_Group1, _
;~ 		$Starter_Pic1, $Starter_List1, $Starter_Button1, $Starter_Button2, $Starter_Button3, $Starter_Label1, $Starter_Input1, $Starter_Slider2, $Starter_Label2, $Starter_Input2
	; Starter
	GUICtrlSetData($Starter_List1, "")
	for $i = 0 to UBound($a_Startpoints,1)-1
		GUICtrlSetData($Starter_List1, $a_Startpoints[$i][0]&", "&$a_Startpoints[$i][1])
	Next

EndFunc
Func __GUIStarterSelectFromMap()
	if $__GUIStarterSelectFromMap = 1 Then
		if GUICtrlGetState($Starter_Button1) = $GUI_SHOW + $GUI_ENABLE Then
			GUICtrlSetState($Starter_Label1, $GUI_DISABLE)
			GUICtrlSetState($Starter_Label2, $GUI_DISABLE)
			GUICtrlSetState($Starter_Button1, $GUI_DISABLE)
			GUICtrlSetState($Starter_Button2, $GUI_DISABLE)
			GUICtrlSetState($Starter_Button3, $GUI_DISABLE)
			GUICtrlSetState($Starter_List1, $GUI_DISABLE)
		EndIf

		Local $a_MousePos, $Starter_GUI_Pos, $Starter_Pic1_Pos, $i_MousePosX, $i_MousePosY, $i_PicPosX, $i_PicPosY, $i_PicSpaceX, $i_PicSpaceY
		$a_MousePos = MouseGetPos()
		$Starter_GUI_Pos = WinGetPos($MapperGUI)
		$Starter_Pic1_Pos = ControlGetPos($MapperGUI, "", $Starter_Pic1)
		$i_MousePosX = $a_MousePos[0] - $Starter_GUI_Pos[0]
		$i_MousePosY = $a_MousePos[1] - $Starter_GUI_Pos[1]
		if @OSVersion = "WIN_XP" Then
			$i_PicSpaceX = 3
			$i_PicSpaceY = 29
		Else ; Win7
			$i_PicSpaceX = 3
			$i_PicSpaceY = 29
		EndIf
		$i_PicPosX = $Starter_Pic1_Pos[0] + $i_PicSpaceX
		$i_PicPosY = $Starter_Pic1_Pos[1] + $i_PicSpaceY
		if ($i_MousePosX >= $i_PicPosX and $i_MousePosX <= $i_PicPosX+256) and _
			($i_MousePosY >= $i_PicPosY and $i_MousePosY <= $i_PicPosY+256) Then
			if MouseGetCursor() <> 3 then GUISetCursor(3, 1)
			Local $i_tmpX = int($i_MousePosX-$i_PicPosX), $i_tmpY = int($i_MousePosY-$i_PicPosY)
			__CheckCtrl($i_tmpX, $Starter_Input1)
			__CheckCtrl($i_tmpY, $Starter_Input2)
			If _IsPressed('01', $sys_IsPressed_dll) then $__GUIStarterSelectFromMap=0		; Left Mouse Button

		Else
			if MouseGetCursor() <> 2 then GUISetCursor(2, 1)

		EndIf

	Else
		if GUICtrlGetState($Starter_Button1) = $GUI_SHOW + $GUI_DISABLE Then
			GUICtrlSetState($Starter_Label1, $GUI_ENABLE)
			GUICtrlSetState($Starter_Button1, $GUI_ENABLE)
			GUICtrlSetState($Starter_Button2, $GUI_ENABLE)
			GUICtrlSetState($Starter_List1, $GUI_ENABLE)
			if MouseGetCursor() <> 2 then GUISetCursor(2, 1)
		EndIf

	EndIf
EndFunc

; Scaler GUI
Func __GUIScalerGetData()
;~ 		Global $Scaler_Button0, $Scaler_Group1, _
;~ 		$Scaler_Slider1, $Scaler_Label1, $Scaler_Input1, $Scaler_Slider2, $Scaler_Label2, $Scaler_Input2, $Scaler_Slider3, $Scaler_Label3, $Scaler_Input3
	; Scaler
	$s_ScaleXY = GUICtrlRead($Scaler_Input1)
	$s_ScaleZ = GUICtrlRead($Scaler_Input2)
	$s_ScaleD = GUICtrlRead($Scaler_Input3)
EndFunc
Func __GUIScalerSetData()
;~ 		Global $Scaler_Button0, $Scaler_Group1, _
;~ 		$Scaler_Slider1, $Scaler_Label1, $Scaler_Input1, $Scaler_Slider2, $Scaler_Label2, $Scaler_Input2, $Scaler_Slider3, $Scaler_Label3, $Scaler_Input3
	; Scaler
	GUICtrlSetData($Scaler_Slider1, $s_ScaleXY)
	GUICtrlSetData($Scaler_Input1, $s_ScaleXY)
	GUICtrlSetData($Scaler_Slider2, $s_ScaleZ)
	GUICtrlSetData($Scaler_Input2, $s_ScaleZ)
	GUICtrlSetData($Scaler_Slider3, $s_ScaleD)
	GUICtrlSetData($Scaler_Input3, $s_ScaleD)
EndFunc

; Datei GUI Neu
; Datei GUI Öffnen
; Datei GUI Speichern
Func _GUISaveLevel($s_File="Mapper")
	__ConsoleWrite("Mapper: _GUISaveLevel($s_File="&$s_File&")"&@CRLF)

	; Daten von GUI holen
	Local $_SaveAsMap=-1, $_SaveAsSQL=-1
;~ 	$s_MapName 	= GUICtrlRead($Save_Input0)
;~ 	$s_SkyBox 	= GUICtrlRead($Save_Input1)
;~ 	$s_BaseMap 	= GUICtrlRead($Save_Input2)
;~ 	$s_ScaleXY 	= GUICtrlRead($Save_Input3)
;~ 	$s_ScaleZ 	= GUICtrlRead($Save_Input4)
;~ 	$s_ScaleD 	= GUICtrlRead($Save_Input5)
;~ 	$s_HightMapSize	= GUICtrlRead($Save_Input6)
;~ 	$_SaveAsMap	= GUICtrlRead($Save_Checkbox1)
;~ 	$_SaveAsSQL	= GUICtrlRead($Save_Checkbox2)

	; Map Speichern
	if $_SaveAsMap = $GUI_CHECKED then
		__WriteMAPfile($s_MapName)
		__MakeAllMaps($s_BaseMap)
	EndIf
	if $_SaveAsSQL = $GUI_CHECKED then
		Local $tmp_Array[2]=[$s_MapName, $s_MapName&".map"]
		_SettingData("$e_Map_Name", $tmp_Array)
	EndIf
EndFunc




Func __GUIMoveIrr()
	; Irrlicht GUI zum Child machen
	$size = WinGetPos(GUICtrlGetHandle($Mapper_Group0))
	WinMove($irr_Handle, "", ($size[0])+8, $size[1]+16)
EndFunc
Func __CheckCtrl($h_A, ByRef $h_B)
	Local $s_tmp1
	$s_tmp1 = $h_A
	if $s_tmp1 <> GUICtrlRead($h_B) then GUICtrlSetData($h_B, $s_tmp1)
EndFunc
Func __GetSliderMapSize(ByRef $h_A)
	; $__MapSizes[13] = [64,128,256,384,512,768,1024,1536,2048,3072,4096,6144,8192]
	Return $__MapSizes[GUICtrlRead($h_A)]
EndFunc
Func __SetSliderMapSize(ByRef $h_A, $i_Int)
	; $__MapSizes[13] = [64,128,256,384,512,768,1024,1536,2048,3072,4096,6144,8192]
	$tmp = _ArraySearch($__MapSizes, $i_Int)
	GUICtrlSetData($h_A, $tmp)
EndFunc

Func __SetGUIdata()
;~ 	Local $i_ScaleMapXY = $s_ScaleXY
;~ 	Local $i_ScaleMapZ = $s_ScaleZ
;~ 	Local $i_ScaleMapD = $s_ScaleD
;~ 	Local $a_Pos = _IrrGetNodePosition($a_PlayerData[0][$e_Player_Node])
;~ 	Local $i_Fps = _IrrGetFPS()
;~ 	Local $i_Xpos = Round2($a_Pos[0] / $i_ScaleMapXY,2)
;~ 	Local $i_Ypos = Round2($a_Pos[1] / $i_ScaleMapXY,2)
;~ 	Local $i_Zpos = Round2((_IrrGetTerrainTileHeight($a_MapData[$e_Map_Node], $a_Pos[0], $a_Pos[1])+1) / $i_ScaleMapZ,2)

	; Main GUI
;~ 	if GUICtrlRead($Mapper_Button25) <> "X/Y-Scale: "&$i_ScaleMapXY 	then GUICtrlSetData($Mapper_Button25, "X/Y-Scale: "&$i_ScaleMapXY)
;~ 	if GUICtrlRead($Mapper_Button26) <> "Z-Scale: "&$i_ScaleMapZ 		then GUICtrlSetData($Mapper_Button26, "Z-Scale: "&$i_ScaleMapZ)
;~ 	if GUICtrlRead($Mapper_Button27) <> "Detail-Scale: "&$i_ScaleMapD	then GUICtrlSetData($Mapper_Button27, "Detail-Scale: "&$i_ScaleMapD)

;~ 	if GUICtrlRead($Mapper_Label30) <> " X-Pos: "&$i_Xpos 	then GUICtrlSetData($Mapper_Label30, " X-Pos: "&$i_Xpos)
;~ 	if GUICtrlRead($Mapper_Label31) <> " Y-Pos: "&$i_Ypos 	then GUICtrlSetData($Mapper_Label31, " Y-Pos: "&$i_Ypos)
;~ 	if GUICtrlRead($Mapper_Label32) <> " Z-Pos: "&$i_Zpos 	then GUICtrlSetData($Mapper_Label32, " Z-Pos: "&$i_Zpos)
;~ 	if GUICtrlRead($Mapper_Label33) <> " FPS: "&$i_Fps 		then GUICtrlSetData($Mapper_Label33, " FPS: "&$i_Fps)

;~ 	; Color-Map
;~ 	if GUICtrlRead($ColorMap_Label10) <> " __Blur("&$s_ColorMapBlur1&", "&$s_ColorMapBlur2&")"	then GUICtrlSetData($ColorMap_Label10, " __Blur("&$s_ColorMapBlur1&", "&$s_ColorMapBlur2&")")
;~ 	if GUICtrlRead($ColorMap_Label11) <> " __DiffuseUV("&$s_ColorMapDiffuseUV&")" then GUICtrlSetData($ColorMap_Label11, " __DiffuseUV("&$s_ColorMapDiffuseUV&")")

	; Hight-Map
;~ 	if GUICtrlRead($HightMap_Input1) <> $s_HightMapBlur1 then GUICtrlSetData($HightMap_Input1, $s_HightMapBlur1)
;~ 	if GUICtrlRead($HightMap_Input2) <> $s_HightMapBlur2 then GUICtrlSetData($HightMap_Input1, $s_HightMapBlur1)

	; Detailmap
;~ 	if GUICtrlRead($DetailMap_Input11) <> $i_ScaleMapD then GUICtrlSetData($DetailMap_Input11, $i_ScaleMapD)

	; Scaler
;~ 	if GUICtrlRead($Scaler_Input1) <> $i_ScaleMapXY then GUICtrlSetData($Scaler_Input1, $i_ScaleMapXY)
;~ 	if GUICtrlRead($Scaler_Input2) <> $i_ScaleMapZ 	then GUICtrlSetData($Scaler_Input2, $i_ScaleMapZ)
;~ 	if GUICtrlRead($Scaler_Input3) <> $i_ScaleMapD	then GUICtrlSetData($Scaler_Input3, $i_ScaleMapD)

	; Startpoints
;~ 	if GUICtrlRead($Starter_Input1) <> $i_Xpos	then GUICtrlSetData($Starter_Input1, $i_Xpos)
;~ 	if GUICtrlRead($Starter_Input2) <> $i_Ypos	then GUICtrlSetData($Starter_Input2, $i_Ypos)


;~ 	Local $s_Map = $a_MapData[$e_Map_File]
;~ 	if GUICtrlRead($Mapper_Group00) <> "Map: "&$s_Map	then GUICtrlSetData($Mapper_Group00, "Map: "&$s_Map)
;~ 	if GUICtrlRead($ColorMap_Label1) <> " Datei: "&$s_ColorMapBMP	then GUICtrlSetData($ColorMap_Label1, " Datei: "&$s_ColorMapBMP)
;~ 	if GUICtrlRead($HightMap_Label1) <> " Datei: "&$s_HightMapBMP	then GUICtrlSetData($HightMap_Label1, " Datei: "&$s_HightMapBMP)
;~ 	if GUICtrlRead($DetailMap_Label1) <> " Datei: "&$s_DetailMapBMP	then GUICtrlSetData($DetailMap_Label1, " Datei: "&$s_DetailMapBMP)
;~ 	if GUICtrlRead($Scaler_Label1) <> " Datei: "&$s_Map	then GUICtrlSetData($Scaler_Label1, " Datei: "&$s_Map)
;~ 	if GUICtrlRead($Starter_Label1) <> " Datei: "&$s_Map	then GUICtrlSetData($Starter_Label1, " Datei: "&$s_Map)

EndFunc

Func __GetMap()
	__ConsoleWrite("Mapper: __GetMap()"&@CRLF)
	_IrrShowMouse()
	Local $s_Return = FileOpenDialog($a_System[$e_Sys_GameName], $a_Path[$e_Path_Map], "Alle (*.map;*.jpg;*.bmp;*.jpg)|Maps (*.map)|Pics (*.jpg;*.bmp;*.jpg)")
	if @error = 1 then Exit
	$a_Return=StringSplit($s_Return, "\", 1)

	if StringInStr($a_Return[$a_Return[0]], ".map", 1) then
		__ReadMapfile($a_Return[$a_Return[0]])
	Else
		$s_MapName = "Mapper"
		__MakeMap($s_Return)
	EndIf

	Return $s_MapName
EndFunc

Func __CleanBackUp_Data()
	for $i = 0 to UBound($BackUp_Data)-1
		$BackUp_Data[$i] = ""
	Next
EndFunc

Func __Exit()
	Exit
EndFunc

Func Round2($fFloat,$iCount)
	; Der Round-Befehl läuft auf meinem XP nicht mehr.... ??
	if StringInStr($fFloat, ".", 1) then
		Local $tmp=StringSplit($fFloat, ".", 1)
		Local $fReturn = $tmp[1]&"."
		Return $fReturn & StringLeft($tmp[2], $iCount)
	Else
		Return $fFloat
	EndIf
EndFunc


#EndRegion -Unterfunktionen---------------------------------------------------------------------------------------------------------





; ----------------------------------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------------------
