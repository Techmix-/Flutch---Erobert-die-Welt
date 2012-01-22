#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_outfile=Flutch.exe
#AutoIt3Wrapper_Res_Description=Flutch
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_Field=Programmversion|V0.06
#AutoIt3Wrapper_Res_Field=by|Team ???
#AutoIt3Wrapper_Res_Field=Original Name|Flutch.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#RequireAdmin
#include <Array.au3>
#include <Misc.au3>
#include <File.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include "include\IncludeAll.au3"
#include-once

#cs ================================================================================================================================
==== ChangeLog =====================================================================================================================
====================================================================================================================================

 AutoIt Version: 	3.3.7.23 (beta)
 Skript:			Main.au3
 Author:         	Techmix

##	--------------------------------------------------------------------------------------------------------------------------------

	Main-Script

	Hauptfunktionen von Flutch


##	--------------------------------------------------------------------------------------------------------------------------------

		ToDo: V0.10:
	Mapping Layer-2 (Beta)
	Mapping Layer-2a Flora klein (Alpha)
	Mapping Layer-2b Flora groß (Alpha)
	Mapping Layer-2c Terrain klein (Alpha)
	Mapping Layer-2d Terrain groß (Alpha)
	Main-Title (Alpha)
	Auto-Movement (Beta)
	Cine-Cam (Alpha)

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.06:
	Mappingsystem erweitert und verbessert
	Mapper.au3 zugefügt
	Character.au3 zugefügt
	Joypad Support (ALPHA)

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.05:
	Mapper.au3 zugefügt
	Etliche Konstuctor-Funktionen zugefügt
	SQLight Daten-Management DeBut

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.04b:
	Ansichten sind jetzt Buggy (Umschalten entfernt)
	RPG Maussteuerungen fast komplett fertig (Auch Map-Kollision mit der Kammera)
	First-Start Screen eingebaut (Data SetUp)
	SQLight Daten-Management verbessert
	Mapping Layer-1 (Beta)
	Auto-Movement (Alpha)
	InGame Debug-Text

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.04:
	Verschiedene Ansichten
	Verschiedene Maussteuerungen
	SetUp Panel
	SQLight Daten-Management
	Mapping System (Alpha)

##	--------------------------------------------------------------------------------------------------------------------------------

		Bugs:
	Die 'externen' Funktionen laufen noch nicht richtig...
	Das Mapping System ist noch Fehlerhaft

##	================================================================================================================================
#ce

;~ opt("MustDeclareVars", True)
HotKeySet("{ESC}", "__Exit")

#Region -Variablen------------------------------------------------------------------------------------------------------------------

; ----------------------------------------------------------------------------------------------------------------------------------
;	Globals
; ----------------------------------------------------------------------------------------------------------------------------------

;~ $s_MakeAllMaps = 1


#EndRegion -Variablen---------------------------------------------------------------------------------------------------------------

_SetUP()
_MainLoop()

#Region -Hauptfunktionen-------------------------------------------------------------------------------------------------------------

Func _SetUP()
	__ConsoleWrite("Main: _SetUP()"&@CRLF)

	; Engine StartUp
	_FirstStart()
	if $a_System[$e_Sys_ShowPanel] = 1 then _ShowPanel()
	_IrrStartAdvanced($a_System[$e_Sys_DeviceType], $a_System[$e_Sys_ScreenWidth], $a_System[$e_Sys_ScreenHeight], $a_System[$e_Sys_Use32Bit], _
			$a_System[$e_Sys_Fullscreen], $a_System[$e_Sys_Shadows], $IRR_CAPTURE_EVENTS, $a_System[$e_Sys_VSync], _
			0, $a_System[$e_Sys_DoubleBuffer], $a_System[$e_Sys_Antialias], $a_System[$e_Sys_HighPrecisionFpu])
	_IrrSetWindowCaption($a_System[$e_Sys_GameName]&" "&$a_System[$e_Sys_GameVersion])
	$a_System[$e_Sys_FontSmall]	= _IrrGetFont($a_Path[$e_Path_Font] & "Small.xml")
	$a_System[$e_Sys_FontBig] 	= _IrrGetFont($a_Path[$e_Path_Font] & "Big.xml")
	_IrrTransparentZWrite()
	_Smoke()

	; Game StartUp
	_MainMenu()
	Exit
	_IrrHideMouse()
	_Camera("RPG")
	_LoadLevel("WorldMap.map")

EndFunc

Func _MainLoop()
	; Main Loop
	WHILE _IrrRunning()
		_IrrBeginSceneAdvanced(_IrrMakeARGB(0, 0, 0, 0))
		_IrrDrawScene()

		; In-Game HUD
;~ 		_HUD()

		if $a_System[$e_Sys_GameDebug] = 1 then __DebugText()
		_IrrEndScene()

		; Steuerung
		_Control()

	WEND
EndFunc


#EndRegion -Hauptfunktionen----------------------------------------------------------------------------------------------------------


#Region -Unterfunktionen------------------------------------------------------------------------------------------------------------

Func __Exit()
	Exit
EndFunc

#EndRegion -Unterfunktionen---------------------------------------------------------------------------------------------------------






; ----------------------------------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------------------
