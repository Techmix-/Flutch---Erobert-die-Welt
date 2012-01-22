#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_outfile=Flutch.exe
#AutoIt3Wrapper_Res_Description=Part of Flutch
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_Field=Programmversion|V0.06
#AutoIt3Wrapper_Res_Field=by|Team ???
#AutoIt3Wrapper_Res_Field=Original Name|Character.exe
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
 Skript:			Character.au3
 Author:         	Techmix

##	--------------------------------------------------------------------------------------------------------------------------------

	Main-Script

	Hauptfunktionen von Character


##	--------------------------------------------------------------------------------------------------------------------------------

		V0.06:
	Character Basis-Funktionen

##	================================================================================================================================
#ce

;~ opt("MustDeclareVars", True)
HotKeySet("{ESC}", "__Exit")

#Region -Variablen------------------------------------------------------------------------------------------------------------------

; ----------------------------------------------------------------------------------------------------------------------------------
;	Globals
; ----------------------------------------------------------------------------------------------------------------------------------

Global $a_Animation

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
;~ 	_MainMenu()
	_IrrHideMouse()
	_Camera("RPG")
	_CharacterLoadLevel("TitleMap.map")
	_RPG_Movement($a_Camera[0][$e_Cam_Node], $a_PlayerData[0][$e_Player_Node])

EndFunc

Func _MainLoop()
	; Main Loop
	WHILE _IrrRunning()
		_IrrBeginSceneAdvanced(_IrrMakeARGB(0, 0, 0, 0))
		_IrrDrawScene()

		_IrrEndScene()

		; Steuerung
		_CharacterControl()

	WEND
EndFunc


#EndRegion -Hauptfunktionen----------------------------------------------------------------------------------------------------------


#Region -Unterfunktionen------------------------------------------------------------------------------------------------------------

Func _CharacterControl()
	_RPG_Movement($a_Camera[0][$e_Cam_Node], $a_PlayerData[0][$e_Player_Node])

	; Animation Abspielen
	If _IsPressed("70", $sys_IsPressed_dll) Then		; F1
		_CharacterLoadLevel("TitleMap.map")
	ElseIf _IsPressed("31", $sys_IsPressed_dll) Then	; 1
		if StringInStr($a_Animation[1][1], "-", 1) then
			Local $iSplit = StringSplit($a_Animation[1][1], "-", 1)
			_IrrSetNodeAnimationRange($a_PlayerData[0][$e_Player_Node], $iSplit[1], $iSplit[2])
		EndIf
	ElseIf _IsPressed("32", $sys_IsPressed_dll) Then	; 2
		if StringInStr($a_Animation[2][1], "-", 1) then
			Local $iSplit = StringSplit($a_Animation[2][1], "-", 1)
			_IrrSetNodeAnimationRange($a_PlayerData[0][$e_Player_Node], $iSplit[1], $iSplit[2])
		EndIf
	ElseIf _IsPressed("33", $sys_IsPressed_dll) Then	; 3
		if StringInStr($a_Animation[3][1], "-", 1) then
			Local $iSplit = StringSplit($a_Animation[3][1], "-", 1)
			_IrrSetNodeAnimationRange($a_PlayerData[0][$e_Player_Node], $iSplit[1], $iSplit[2])
		EndIf
	ElseIf _IsPressed("34", $sys_IsPressed_dll) Then	; 4
		if StringInStr($a_Animation[4][1], "-", 1) then
			Local $iSplit = StringSplit($a_Animation[4][1], "-", 1)
			_IrrSetNodeAnimationRange($a_PlayerData[0][$e_Player_Node], $iSplit[1], $iSplit[2])
		EndIf
	ElseIf _IsPressed("35", $sys_IsPressed_dll) Then	; 5
		if StringInStr($a_Animation[5][1], "-", 1) then
			Local $iSplit = StringSplit($a_Animation[5][1], "-", 1)
			_IrrSetNodeAnimationRange($a_PlayerData[0][$e_Player_Node], $iSplit[1], $iSplit[2])
		EndIf
	ElseIf _IsPressed("36", $sys_IsPressed_dll) Then	; 6
		if StringInStr($a_Animation[6][1], "-", 1) then
			Local $iSplit = StringSplit($a_Animation[6][1], "-", 1)
			_IrrSetNodeAnimationRange($a_PlayerData[0][$e_Player_Node], $iSplit[1], $iSplit[2])
		EndIf
	ElseIf _IsPressed("37", $sys_IsPressed_dll) Then	; 7
		if StringInStr($a_Animation[7][1], "-", 1) then
			Local $iSplit = StringSplit($a_Animation[7][1], "-", 1)
			_IrrSetNodeAnimationRange($a_PlayerData[0][$e_Player_Node], $iSplit[1], $iSplit[2])
		EndIf
	ElseIf _IsPressed("38", $sys_IsPressed_dll) Then	; 8
		if StringInStr($a_Animation[8][1], "-", 1) then
			Local $iSplit = StringSplit($a_Animation[8][1], "-", 1)
			_IrrSetNodeAnimationRange($a_PlayerData[0][$e_Player_Node], $iSplit[1], $iSplit[2])
		EndIf
	ElseIf _IsPressed("39", $sys_IsPressed_dll) Then	; 9
		if StringInStr($a_Animation[9][1], "-", 1) then
			Local $iSplit = StringSplit($a_Animation[9][1], "-", 1)
			_IrrSetNodeAnimationRange($a_PlayerData[0][$e_Player_Node], $iSplit[1], $iSplit[2])
		EndIf
	ElseIf _IsPressed("30", $sys_IsPressed_dll) Then	; 0
		if StringInStr($a_Animation[10][1], "-", 1) then
			Local $iSplit = StringSplit($a_Animation[10][1], "-", 1)
			_IrrSetNodeAnimationRange($a_PlayerData[0][$e_Player_Node], $iSplit[1], $iSplit[2])
		EndIf
	EndIf

EndFunc

Func _CharacterLoadLevel($s_Map="", $i_StartPos=-1)
	; Clear Scene
	if $s_Map = "" then Return

	__ConsoleWrite("_Engine: _CharacterLoadLevel($s_Map="&$s_Map&")"&@CRLF)

	; Map Name
	Local $sData1, $sData2
	if StringInStr($s_Map, ".map", 1) Then
		$sData1 = StringReplace($s_Map, ".map", "")
		$sData2 = $s_Map
	Else
		$sData1 = $s_Map
		$sData2 = $s_Map & ".map"
	EndIf
	$s_MapName = $sData1
	$a_MapData[$e_Map_Name] 	= $sData1
	$a_MapData[$e_Map_File]		= $sData2

	__LoadMap($a_MapData[$e_Map_File])
;~ 	_LoadPlayer("Green")
	_LoadPlayer(__GetPlayer())
	__ScaleMap()

	; StartPos
	__StartPos()

	$__ConsoleWrite = "_Engine: _LoadLevel: "&$s_Map&@CRLF
	__ConsoleWrite($__ConsoleWrite)
	__DebugText($__ConsoleWrite)
EndFunc

Func __GetPlayer()
	_IrrShowMouse()
	Local $sPath
	$sPath = FileSelectFolder("Character Ordner wählen", $a_Path[$e_Path_Mesh])
	$a_Animation = IniReadSection($sPath&"\Animation.ini", "Animation")
	ReDim $a_Animation[11][2]
	_IrrHideMouse()
	Return $sPath
EndFunc

Func __Exit()
	Exit
EndFunc

#EndRegion -Unterfunktionen---------------------------------------------------------------------------------------------------------






; ----------------------------------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------------------
