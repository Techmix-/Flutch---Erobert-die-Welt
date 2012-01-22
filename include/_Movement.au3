#include "_Const.au3"
#include-once
#RequireAdmin

#cs ================================================================================================================================
==== ChangeLog =====================================================================================================================
====================================================================================================================================

 AutoIt Version: 	3.3.7.23 (beta)
 Skript:			_Movement.au3
 Author:         	Techmix

##	--------------------------------------------------------------------------------------------------------------------------------

	Playermovement

	Ausgelagerte Movement-Funktionen


##	--------------------------------------------------------------------------------------------------------------------------------

		V0.11:
	Auto-Movement zugefügt
	Joypad Steuerung zugefügt (ALPHA - Nur Digital)

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.10:
	Grundfunktionen erstellt

##	================================================================================================================================
#ce

#Region -UDF-Variablen--------------------------------------------------------------------------------------------------------------

Global $gravity[3], $velocity[3], $ellipsoidRadius[3], $aMousePos[2], $aPoint[3], $aDirect[3]
Global $a_CamRotation[2] = [-180, 70]
	$a_Camera[0][$e_Cam_Entfernung]=8

Enum $e_SwitchPlayer, $e_SwitchLevel, $e_SwitchView, $e_SwitchControl, $e_SwitchLast
Global $a_Switcher[$e_SwitchLast] = [1,1,1,1]
Global $a_PlayerFile[3]= ["flutch_grn", "flutch_geb", "flutch_red"]
Global $a_CamView[2] = ["FPS", "RPG"]
Global $a_Control[2] = ["FPS", "RPG"]
Global $a_Automatic_Movement[2], $i_Automatic_Waypoint=-1, $a_Automatic_Waypoints[1][1], $a_Automatic_Movement_Node[2]
Global $h_Joypad = _JoyInit(), $s_IsJoypad = _IsJoy()


#EndRegion -UDF-Variablen-----------------------------------------------------------------------------------------------------------


#Region -Hauptfunktionen-------------------------------------------------------------------------------------------------------------

Func _SetUp_FPS_Movement(ByRef $p_Camera)
	; FPS Cam
	Local $a_keyStruct
	$p_Camera = _IrrAddFPSCamera( _
		0, _   				; parent, none
		150.0, _           	; rotate speed
		$a_PlayerData[0][$e_Player_Geschwindigkeit]/20, _             	; move speed
		-1, _              	; camera ID
		__CreatePtrKeyMapArray($a_keyStruct, $KEY_KEY_W, $KEY_KEY_S, $KEY_KEY_A, $KEY_KEY_D, $KEY_SPACE), _ ; address of keyMap - using defaults for rest of params: $KEY_KEY_W,$KEY_KEY_S,$KEY_KEY_A,$KEY_KEY_D
		5, _               	; number of entries in the keymap
		8, _                ; vertical movement
		$a_PlayerData[0][$e_Player_Sprung] )              	; jumpspeed
	$a_keyStruct = 0 			; struct no longer needed
	$a_System[$e_Sys_MoveTyp] = "FPS"
	$a_Camera[0][$e_Cam_Node] = $p_Camera
	$a_Camera[0][$e_Cam_Collision]=_IrrAddCollisionAnimator($a_MapData[$e_Map_Collision], _
							$a_Camera[0][$e_Cam_Node], _
							30.0,30.0,30.0, _
							0.0,-9.8,0.0, _
							0.0,50.0,0.0 )

	__ConsoleWrite("_Movement: _SetUp_FPS_Movement: "&$a_System[$e_Sys_MoveTyp]&@CRLF)
EndFunc

Func _SetUp_RPG_Movement(ByRef $p_Camera)
	; RPG Cam
	dim $aPoint[3] = 			[0.0, 1500.0/40, 0.0]
	dim $gravity[3]  = 			[0.0, -0.1, 0.0]
	dim $velocity[3] = 			[0.0, 0.0, 0.0]
	dim $aCamPos[3] = 			[1750.0, 149.0, 1369.0]
	dim $ellipsoidRadius[3] = 	[0.25, 0.4, 0.25]

	$p_Camera = _IrrAddCamera($aCamPos[0], $aCamPos[1], $aCamPos[2], $aPoint[0], $aPoint[1], $aPoint[2])
	$a_Camera[0][$e_Cam_Node] = $p_Camera

	MouseMove( @DesktopWidth/2, @DesktopHeight/2, 0 )
	$aMousePos[0] = 0.0
	$aMousePos[1] = 0.0
	$a_System[$e_Sys_MoveTyp] = "RPG"
	__ConsoleWrite("_Movement: _SetUp_RPG_Movement: "&$a_System[$e_Sys_MoveTyp]&@CRLF)
EndFunc
Func _SetUp_RPG_Movement2(ByRef $p_Camera)
	; RPG Cam
	dim $gravity[3]  = 			[0.0, -0.1, 0.0]
	dim $velocity[3] = 			[0.0, 0.0, 0.0]
	dim $ellipsoidRadius[3] = 	[0.25, 0.4, 0.25]
	$aPoint = _IrrGetNodePosition($a_PlayerData[0][$e_Player_Node])

	$p_Camera = _IrrAddCamera(0,0,0, $aPoint[0], $aPoint[1], $aPoint[2])
	$a_Camera[0][$e_Cam_Node] = $p_Camera

	MouseMove( @DesktopWidth/2, @DesktopHeight/2, 0 )
	$aMousePos[0] = 0.0
	$aMousePos[1] = 0.0
	$a_System[$e_Sys_MoveTyp] = "RPG"
	__ConsoleWrite("_Movement: _SetUp_RPG_Movement: "&$a_System[$e_Sys_MoveTyp]&@CRLF)
EndFunc

Func _SetUp_CineCam(ByRef $p_Camera)
	; CineCam
	$a_CamPos = _IrrGetNodePosition($a_Camera[0][$e_Cam_Node])
	$p_Camera = _IrrAddCamera($a_CamPos[0], $a_CamPos[1], $a_CamPos[2], $aPoint[0], $aPoint[1], $aPoint[2])
	$a_Camera[0][$e_Cam_Node] = $p_Camera
	$a_System[$e_Sys_MoveTyp] = "CiC"
	__ConsoleWrite("_Movement: _SetUp_CineCam: "&$a_System[$e_Sys_MoveTyp]&@CRLF)
EndFunc

Func _Control()

	; Gravity
;~ 	$a_Vector = _IrrGetNodePosition($a_Camera[0][$e_Cam_Node])
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a_Vector[0] = ' & $a_Vector[0] & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a_Vector[1] = ' & $a_Vector[1] & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a_Vector[2] = ' & $a_Vector[2] & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
	If _IsPressed('20', $sys_IsPressed_dll) then 		; Space - Jump
;~ 		$a_Vector[1] += 5

	elseIf _IsPressed('20', $sys_IsPressed_dll) = 0 then 	; Anziehungskraft
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
	if $a_System[$e_Sys_GameDebug] = 1 then _FControl()
	if $a_System[$e_Sys_MoveTyp] = "RPG" then _RPG_Movement($a_Camera[0][$e_Cam_Node], $a_PlayerData[0][$e_Player_Node])
EndFunc

Func _RPG_Movement(ByRef $p_Camera, ByRef $p_CharakterNode)
	Local $pKeyEvent, $keyCode, $outHitPosition, $outFalling
	Local $f_MoveSpeed = $a_PlayerData[0][$e_Player_Geschwindigkeit]
	$aPoint = _IrrGetNodePosition($p_CharakterNode)
	$a_CamPos = _IrrGetNodePosition($a_Camera[0][$e_Cam_Node])

;~ 	_IrrGetCollisionResultPosition( _
;~         $a_PlayerData[0][$e_Player_Collision], _
;~         $aPoint, _
;~         $ellipsoidRadius, _
;~         $velocity, _
;~         $gravity, _
;~         0.0005, _
;~         $aPoint, _
;~         $outHitPosition, _
;~         $outFalling)

	; Maus Cam Kontrolle
	while _IrrMouseEventAvailable()
		$pMouseEvent = _IrrReadMouseEvent()
		if __getMouseEvt($pMouseEvent, $EVT_MOUSE_IACTION) = $IRR_EMIE_MOUSE_WHEEL then
			if (__getMouseEvt($pMouseEvent,$EVT_MOUSE_FDELTA) < 0 And $a_Camera[0][$e_Cam_Entfernung] < 48) Or _
			   (__getMouseEvt($pMouseEvent,$EVT_MOUSE_FDELTA) > 0 And $a_Camera[0][$e_Cam_Entfernung] > 4) then
			       $a_Camera[0][$e_Cam_Entfernung] -= __getMouseEvt($pMouseEvent, $EVT_MOUSE_FDELTA)/2
			endif
		endif
	wend

	; Maus Cam-Rotation
	$aMousePos = MouseGetPos()
	MouseMove( @DesktopWidth/2, @DesktopHeight/2, 0 )
	$aMousePos[0] -=  @DesktopWidth/2
	$aMousePos[1] -= @DesktopHeight/2
	Local $aDirectLength = ($aDirect[0]^2 + $aDirect[2]^2)^(1/2)
	Local $f_MoveSpeed = $a_PlayerData[0][$e_Player_Geschwindigkeit] / 8
	If $aMousePos[0] < 0 Then
		$a_CamRotation[0] -= $aMousePos[0]/15
		If $a_CamRotation[0] >= 180 Then $a_CamRotation[0] = -180
	ElseIf $aMousePos[0] >= 0 Then
		$a_CamRotation[0] -= $aMousePos[0]/15
		If $a_CamRotation[0] <= -180 Then $a_CamRotation[0] = 180
	EndIf
	If $aMousePos[1] < 0 Then
		If $a_CamRotation[1] <= 180 Then $a_CamRotation[1] -= $aMousePos[1]/15
	ElseIf $aMousePos[1] >= 0 Then
		If $a_CamRotation[1] >= 1 Then $a_CamRotation[1] -= $aMousePos[1]/15
	EndIf
	$aDirect[0] = $aPoint[0] - $a_CamPos[0]
	$aDirect[1] = $aPoint[1] - $a_CamPos[1]
	$aDirect[2] = $aPoint[2] - $a_CamPos[2]
	$velocity[0] = $aPoint[0]
	$velocity[2] = $aPoint[2]

	; Keyboard Movement
	If _IsPressed('10', $sys_IsPressed_dll) then 		; Shift - Laufen
		$f_MoveSpeed *= 2
	ElseIf _IsPressed('11', $sys_IsPressed_dll) then 	; Strg - Kriechen
		$f_MoveSpeed /= 1.5
	EndIf
	If _IsPressed("57", $sys_IsPressed_dll) Then 		; W - Vorwärts
		$aPoint[0] += $aDirect[0]/$aDirectLength*$f_MoveSpeed
		$aPoint[2] += $aDirect[2]/$aDirectLength*$f_MoveSpeed
		$a_PlayerData[0][$e_Player_Rotation] = 180-$a_CamRotation[0] + 90
	ElseIf _IsPressed("53", $sys_IsPressed_dll) Then 	; S - Rückwärts
		$aPoint[0] += -$aDirect[0]/$aDirectLength*$f_MoveSpeed
		$aPoint[2] += -$aDirect[2]/$aDirectLength*$f_MoveSpeed
		$a_PlayerData[0][$e_Player_Rotation] = 180-$a_CamRotation[0] - 90
	EndIf
	If _IsPressed("41", $sys_IsPressed_dll) Then 		; A - Links
		$aPoint[0] += -$aDirect[2]/$aDirectLength*($f_MoveSpeed/2)
		$aPoint[2] += $aDirect[0]/$aDirectLength*($f_MoveSpeed/2)
		$a_PlayerData[0][$e_Player_Rotation] = 180-$a_CamRotation[0]
	ElseIf _IsPressed("44", $sys_IsPressed_dll) Then 	; D - Rechts
		$aPoint[0] += $aDirect[2]/$aDirectLength*($f_MoveSpeed/2)
		$aPoint[2] += -$aDirect[0]/$aDirectLength*($f_MoveSpeed/2)
		$a_PlayerData[0][$e_Player_Rotation] = 180-$a_CamRotation[0] + 180
	EndIf

	; Joypad Movement
	if $s_IsJoypad = 1 then
		Local $_JoyData = _GetJoy($h_Joypad, 0)
		Local $_JoyButton = GetPressed($_JoyData[7])
		Local $_JoyAxisX = $_JoyData[0]
		Local $_JoyAxisY = $_JoyData[1]
		Local $_JoySpeed = 80

		If $_JoyButton = "(Y)" then 		; Shift - Laufen
			$f_MoveSpeed *= 2
		ElseIf $_JoyButton = "(A)" then 	; Strg - Kriechen
			$f_MoveSpeed /= 1.5
		EndIf
		If $_JoyButton = "(B)" then 		; Cam-Kontrol
			If $_JoyAxisX = 0 Then 			; Cam Links
				$aMousePos[0] = -($f_MoveSpeed*$_JoySpeed)
			elseIf $_JoyAxisX = 65535 Then 	; Cam Rechts
				$aMousePos[0] = ($f_MoveSpeed*$_JoySpeed)
			EndIf
			If $_JoyAxisY = 0 Then 			; Cam Oben
				$aMousePos[1] = ($f_MoveSpeed*$_JoySpeed)
			elseIf $_JoyAxisY = 65535 Then 	; Cam Unten
				$aMousePos[1] = -($f_MoveSpeed*$_JoySpeed)
			EndIf

			; Cam Position berrechnen
			If $aMousePos[0] < 0 Then
				$a_CamRotation[0] -= $aMousePos[0]/15
				If $a_CamRotation[0] >= 180 Then $a_CamRotation[0] = -180
			ElseIf $aMousePos[0] >= 0 Then
				$a_CamRotation[0] -= $aMousePos[0]/15
				If $a_CamRotation[0] <= -180 Then $a_CamRotation[0] = 180
			EndIf
			If $aMousePos[1] < 0 Then
				If $a_CamRotation[1] <= 180 Then $a_CamRotation[1] -= $aMousePos[1]/15
			ElseIf $aMousePos[1] >= 0 Then
				If $a_CamRotation[1] >= 1 Then $a_CamRotation[1] -= $aMousePos[1]/15
			EndIf
			$aDirect[0] = $aPoint[0] - $a_CamPos[0]
			$aDirect[1] = $aPoint[1] - $a_CamPos[1]
			$aDirect[2] = $aPoint[2] - $a_CamPos[2]
			$velocity[0] = $aPoint[0]
			$velocity[2] = $aPoint[2]

		Else
			If $_JoyAxisY = 0 Then 			; Vorwärts
				$aPoint[0] += $aDirect[0]/$aDirectLength*$f_MoveSpeed
				$aPoint[2] += $aDirect[2]/$aDirectLength*$f_MoveSpeed
				$a_PlayerData[0][$e_Player_Rotation] = 180-$a_CamRotation[0] + 90
			ElseIf $_JoyAxisY = 65535 Then 	; Rückwärts
				$aPoint[0] += -$aDirect[0]/$aDirectLength*$f_MoveSpeed
				$aPoint[2] += -$aDirect[2]/$aDirectLength*$f_MoveSpeed
				$a_PlayerData[0][$e_Player_Rotation] = 180-$a_CamRotation[0] - 90
			EndIf
			If $_JoyAxisX = 0 Then 			; Links
				$aPoint[0] += -$aDirect[2]/$aDirectLength*($f_MoveSpeed/2)
				$aPoint[2] += $aDirect[0]/$aDirectLength*($f_MoveSpeed/2)
				$a_PlayerData[0][$e_Player_Rotation] = 180-$a_CamRotation[0]
			ElseIf $_JoyAxisX = 65535 Then 	; Rechts
				$aPoint[0] += $aDirect[2]/$aDirectLength*($f_MoveSpeed/2)
				$aPoint[2] += -$aDirect[0]/$aDirectLength*($f_MoveSpeed/2)
				$a_PlayerData[0][$e_Player_Rotation] = 180-$a_CamRotation[0] + 180
			EndIf
		EndIf
	EndIf

	; Animation Abspielen
	If ($velocity[0] = $aPoint[0] And $velocity[2] = $aPoint[2]) and $a_PlayerData[0][$e_Player_Animation] <> "STAND" Then
		; Nicht bewegen
		_IrrPlayNodeMD2Animation($p_CharakterNode, $IRR_EMAT_STAND)
		$a_PlayerData[0][$e_Player_Animation] = "STAND"
	ElseIf ($velocity[0] <> $aPoint[0] And $velocity[2] <> $aPoint[2]) and $a_PlayerData[0][$e_Player_Animation] <> "RUN" Then
		; Bewegen
		_IrrPlayNodeMD2Animation($p_CharakterNode, $IRR_EMAT_RUN)
		$a_PlayerData[0][$e_Player_Animation] = "RUN"
	EndIf

	; Kameraposition ermitteln
    Local $pi = 3.14159, $deg2rad = $pi/180, $rad = $a_CamRotation[0] * $deg2rad
	$a_CamPos[0] = $a_Camera[0][$e_Cam_Entfernung] * Sin($a_CamRotation[1] * $deg2rad) * Cos($rad) + $aPoint[0]
	$a_CamPos[2] = $a_Camera[0][$e_Cam_Entfernung] * Sin($a_CamRotation[1] * $deg2rad) * Sin($rad) + $aPoint[2]
	$a_CamPos[1] = $a_Camera[0][$e_Cam_Entfernung] * Cos($a_CamRotation[1] * $deg2rad) + $aPoint[1]

	; Kamera und Player setzten
	_IrrSetNodePosition($p_Camera, $a_CamPos[0], $a_CamPos[1]+1.2+$a_Camera[0][$e_Cam_Entfernung]/6, $a_CamPos[2])
	_IrrSetCameraTarget($p_Camera, $aPoint[0], $aPoint[1], $aPoint[2])
	_IrrSetNodePosition($p_CharakterNode, $aPoint[0], $aPoint[1], $aPoint[2])
	_IrrSetNodeRotation($p_CharakterNode, 0, $a_PlayerData[0][$e_Player_Rotation], 0)

	; Kameratiefe Checken
	$a_Vector2 = _IrrGetNodePosition($p_Camera)
	$a_VectorHight = _IrrGetTerrainTileHeight($a_MapData[$e_Map_Node], $a_Vector2[0], $a_Vector2[2]) + 1.2
	if $a_Vector2[1] < $a_VectorHight then _IrrSetNodePosition($p_Camera, $a_Vector2[0], $a_VectorHight, $a_Vector2[2])

EndFunc

Func _FControl()
	; InGame
	If _IsPressed("70", $sys_IsPressed_dll) Then ; F1
		; F1: Switch Player
		$a_Switcher[$e_SwitchPlayer] += 1
		if $a_Switcher[$e_SwitchPlayer] = UBound($a_PlayerFile) then $a_Switcher[$e_SwitchPlayer] = 0
		$__ConsoleWrite = "_Movement: F1-Switch Player: "&$a_PlayerFile[$a_Switcher[$e_SwitchPlayer]]&@CRLF
		__ConsoleWrite($__ConsoleWrite)
		__DebugText($__ConsoleWrite)
		_LoadPlayer($a_PlayerFile[$a_Switcher[$e_SwitchPlayer]])
		_Camera($a_CamView[$a_Switcher[$e_SwitchView]])
		While _IsPressed("70", $sys_IsPressed_dll)
			Sleep(1)
		WEnd

	elseif _IsPressed("71", $sys_IsPressed_dll) Then ; F2
		; F2: Start-Position
		$__ConsoleWrite = "_Movement: F2-Switch Start-Position"&@CRLF
		__ConsoleWrite($__ConsoleWrite)
		__DebugText($__ConsoleWrite)
		__StartPos()
		While _IsPressed("71", $sys_IsPressed_dll)
			Sleep(1)
		WEnd

	elseif _IsPressed("7B", $sys_IsPressed_dll) Then ; F12
		; F12: Make Screenshot
		for $i = 0 to 255
			dim $s_File = @ScriptDir&"\ScreenShot_"&$i&".jpg"
			if not FileExists($s_File) Then
				$__ConsoleWrite = "_Movement: F12-Make Screenshot: "&$s_File&@CRLF
				__ConsoleWrite($__ConsoleWrite)
				__DebugText($__ConsoleWrite)
				_IrrSaveScreenShot($s_File)
				ExitLoop
			EndIf
		Next
	EndIf



EndFunc

Func _Automatic_Movement(ByRef $p_CharakterNode, $f_DestPosX=-1, $f_DestPosY=-1)
	Local $f_Distance = -1, $i__ScaleMap = $s_ScaleXY, $aPoint = _IrrGetNodePosition($p_CharakterNode)

	if ($f_DestPosX <> -1 and $f_DestPosY <> -1) or (int($aPoint[0]) = int($a_Automatic_Movement[0]) and int($aPoint[2]) = int($a_Automatic_Movement[1])) Then
		if $f_DestPosX <> -1 and $f_DestPosY <> -1 then
			__MakeWaypointArray($p_CharakterNode, $f_DestPosX, $f_DestPosY)
			$i_Automatic_Waypoint += 1
			$a_Automatic_Movement[0] = $a_Automatic_Waypoints[$i_Automatic_Waypoint][0]
			$a_Automatic_Movement[1] = $a_Automatic_Waypoints[$i_Automatic_Waypoint][1]
		EndIf
		if $a_Automatic_Movement_Node[0] <> "" then $f_Distance = _IrrGetDistanceBetweenNodes($a_Automatic_Movement_Node[0], $a_Automatic_Movement_Node[1])
		if ($f_Distance < 1 and $f_Distance <> -1) or (int($aPoint[0]) = int($a_Automatic_Movement[0]) and int($aPoint[2]) = int($a_Automatic_Movement[1])) Then
			if $i_Automatic_Waypoint < UBound($a_Automatic_Waypoints,1)-1 then
				$i_Automatic_Waypoint += 1
				$a_Automatic_Movement[0] = $a_Automatic_Waypoints[$i_Automatic_Waypoint][0]
				$a_Automatic_Movement[1] = $a_Automatic_Waypoints[$i_Automatic_Waypoint][1]
			Else
				$i_Automatic_Waypoint = -1
				ReDim $a_Automatic_Waypoints[1][1]
				Local $i_PosX, $i_PosY
				do
					$i_PosX = Random($aPoint[0]-25*$i__ScaleMap,$aPoint[0]+25*$i__ScaleMap,1)
					$i_PosY = Random($aPoint[2]-25*$i__ScaleMap,$aPoint[2]+25*$i__ScaleMap,1)
				Until ($i_PosX > 100*$i__ScaleMap and $i_PosX < 900*$i__ScaleMap) and ($i_PosY > 100*$i__ScaleMap and $i_PosY < 900*$i__ScaleMap)
				__MakeWaypointArray($p_CharakterNode, $i_PosX, $i_PosY)
				$i_Automatic_Waypoint += 1
				$a_Automatic_Movement[0] = $a_Automatic_Waypoints[$i_Automatic_Waypoint][0]
				$a_Automatic_Movement[1] = $a_Automatic_Waypoints[$i_Automatic_Waypoint][1]
			EndIf
			if $a_Automatic_Movement[0] <100 then $a_Automatic_Movement[0] = 100
			if $a_Automatic_Movement[0] >900*$i__ScaleMap then $a_Automatic_Movement[0] = 900*$i__ScaleMap
			if $a_Automatic_Movement[1] <100 then $a_Automatic_Movement[1] = 100
			if $a_Automatic_Movement[1] >900*$i__ScaleMap then $a_Automatic_Movement[1] = 900*$i__ScaleMap
			if $a_Automatic_Movement_Node[0] <> "" then _IrrRemoveNode($a_Automatic_Movement_Node[0])
			if $a_Automatic_Movement_Node[1] <> "" then _IrrRemoveNode($a_Automatic_Movement_Node[1])
		EndIf
		$a_Automatic_Movement_Node[0] = _IrrAddCubeSceneNode(1)
		$a_Automatic_Movement_Node[1] = _IrrAddCubeSceneNode(1)
		_IrrSetNodePosition($a_Automatic_Movement_Node[0], $aPoint[0], -1000, $aPoint[2]) ; Player Pos
		_IrrSetNodePosition($a_Automatic_Movement_Node[1], $a_Automatic_Movement[0], -1000, $a_Automatic_Movement[1]) ; Ziel Pos
		$f_MaxDist = int(220 * __GetDistance($a_Automatic_Movement_Node[0], $a_Automatic_Movement_Node[1]) * $a_PlayerData[0][$e_Player_Geschwindigkeit])
		_IrrAddFlyStraightAnimator($a_Automatic_Movement_Node[0], $aPoint[0],-1000,$aPoint[2], $a_Automatic_Movement[0],-1000,$a_Automatic_Movement[1], $f_MaxDist, $IRR_ONE_SHOT)
	EndIf

	$aPoint = _IrrGetNodePosition($a_Automatic_Movement_Node[0])
	$f_DestPosZ = _IrrGetTerrainTileHeight($a_MapData[$e_Map_Node], $aPoint[0], $aPoint[2]) + 1
	_IrrSetNodePosition($p_CharakterNode, $aPoint[0], $f_DestPosZ, $aPoint[2])
	_IrrSetNodeRotation($a_PlayerData[0][$e_Player_Node], 0, $a_PlayerData[0][$e_Player_Rotation], 0)
EndFunc


#EndRegion -Hauptfunktionen----------------------------------------------------------------------------------------------------------


#Region -Unterfunktionen------------------------------------------------------------------------------------------------------------

Func __GetDistance(ByRef $p_NodeA, ByRef $p_NodeB)
	Local $a_PosA = _IrrGetNodePosition($p_NodeA)
	Local $a_PosB = _IrrGetNodePosition($p_NodeB)
	Local $f_Scale = $s_ScaleXY
	Local $f_DistX = Abs($a_PosA[0]-$a_PosB[0]) / $f_Scale
	Local $f_DistY = Abs($a_PosA[1]-$a_PosB[1]) / $f_Scale
	Local $f_DistZ = Abs($a_PosA[2]-$a_PosB[2]) / $f_Scale

	; __ConsoleWrite("_Movement: __GetDistance="&($f_DistX+$f_DistY+$f_DistZ) / 3 & @crlf)
	Return ($f_DistX+$f_DistY+$f_DistZ) / 3
EndFunc

Func __MakeWaypointArray(ByRef $p_CharakterNode, $f_DestPosX=-1, $f_DestPosY=-1, $i_Points=96)
	Local $i__ScaleMap = $s_ScaleXY, $aPoint = _IrrGetNodePosition($p_CharakterNode)
	if $f_DestPosX < 50 or $f_DestPosX > 950 then $f_DestPosX = Random(100,900,1)
	if $f_DestPosY < 50 or $f_DestPosY > 950 then $f_DestPosY = Random(100,900,1)
	__ConsoleWrite("_Movement: __MakeWaypointArray($p_CharakterNode="&$p_CharakterNode&", $f_DestPosX="&int($f_DestPosX)&", $f_DestPosY="&int($f_DestPosY)&", $i_Points="&$i_Points&")"&@CRLF)
	Local $f_DistX=abs($aPoint[0] - $f_DestPosX*$i__ScaleMap) / $i_Points, $f_DistY=abs($aPoint[2] - $f_DestPosY*$i__ScaleMap) / $i_Points
	Local $f_DistanceX, $f_DistanceY, $f_X1, $f_X2, $f_Y1, $f_Y2
	if $aPoint[0] > $f_DestPosX*$i__ScaleMap Then $f_DistX = 0-$f_DistX
	if $aPoint[2] > $f_DestPosY*$i__ScaleMap Then $f_DistY = 0-$f_DistY
	ReDim $a_Automatic_Waypoints[$i_Points*2][2]
	for $i = 1 to $i_Points Step 2
		$f_DistanceX=$f_DistX*$i
		$f_DistanceY=$f_DistY*$i
		$f_X2=$f_DistX
		$f_Y2=$f_DistY
		$f_X1=0-$f_X2
		$f_Y1=0-$f_Y2
		if $i < $i_Points then
			$a_Automatic_Waypoints[$i-1][0] = $aPoint[0] + int($f_DistanceX + Random($f_X1,0))
			$a_Automatic_Waypoints[$i-1][1] = $aPoint[2] + int($f_DistanceY + Random($f_Y1,0))
			$a_Automatic_Waypoints[$i][0] = $aPoint[0] + int($f_DistanceX + Random(0,$f_X2))
			$a_Automatic_Waypoints[$i][1] = $aPoint[2] + int($f_DistanceY + Random(0,$f_Y2))
		Else
			$a_Automatic_Waypoints[$i-1][0] = $aPoint[0] + int($f_DistanceX + Random($f_X1,0))
			$a_Automatic_Waypoints[$i-1][1] = $aPoint[2] + int($f_DistanceY + Random($f_Y1,0))
			$a_Automatic_Waypoints[$i][0] = $f_DestPosX*$i__ScaleMap
			$a_Automatic_Waypoints[$i][1] = $f_DestPosY*$i__ScaleMap
		EndIf
	Next
EndFunc


#EndRegion -Unterfunktionen---------------------------------------------------------------------------------------------------------


#Region -Joypad---------------------------------------------------------------------------------------------------------------------

;======================================
;   _JoyInit()
;======================================
Func _JoyInit()
    Local $joy
    Global $JOYINFOEX_struct = "dword[13]"
    $joy = DllStructCreate($JOYINFOEX_struct)
    If @error Then Return 0
    DllStructSetData($joy, 1, DllStructGetSize($joy), 1);dwSize = sizeof(struct)
    DllStructSetData($joy, 1, 255, 2) ;dwFlags = GetAll
    Return $joy
EndFunc   ;==>_JoyInit

Func _IsJoy()
	Local $_JoyData = _GetJoy($h_Joypad, 0)
	Local $_JoyButton = GetPressed($_JoyData[7])
	Local $_JoyAxisX = $_JoyData[0]
	Local $_JoyAxisY = $_JoyData[1]
	if $_JoyAxisX > 0 and $_JoyAxisY > 0 then Return 1
	Return 0
EndFunc

;======================================
;   _GetJoy($lpJoy,$iJoy)
;   $lpJoy  Return from _JoyInit()
;   $iJoy   Joystick # 0-15
;   Return  Array containing X-Pos, Y-Pos, Z-Pos, R-Pos, U-Pos, V-Pos,POV
;           Buttons down
;
;           *POV This is a digital game pad, not analog Joystick
;           65535   = Not pressed
;           0       = U
;           4500    = UR
;           9000    = R
;           Goes around clockwise increasing 4500 for each position
;======================================
Func _GetJoy($lpJoy, $iJoy)
    Local $coor, $ret
    Dim $coor[8]
    DllCall("Winmm.dll", "int", "joyGetPosEx", _
            "int", $iJoy, _
            "ptr", DllStructGetPtr($lpJoy))
    If Not @error Then
        $coor[0] = DllStructGetData($lpJoy, 1, 3)
        $coor[1] = DllStructGetData($lpJoy, 1, 4)
        $coor[2] = DllStructGetData($lpJoy, 1, 5)
        $coor[3] = DllStructGetData($lpJoy, 1, 6)
        $coor[4] = DllStructGetData($lpJoy, 1, 7)
        $coor[5] = DllStructGetData($lpJoy, 1, 8)
        $coor[6] = DllStructGetData($lpJoy, 1, 11)
        $coor[7] = DllStructGetData($lpJoy, 1, 9)
    EndIf
    Return $coor
EndFunc   ;==>_GetJoy

Func GetPressed($Val)
    $SButtons = ''
    If BitAND($Val, 1) Then $SButtons &= '(A)'
    If BitAND($Val, 2) Then $SButtons &= '(B)'
    If BitAND($Val, 4) Then $SButtons &= '(X)'
    If BitAND($Val, 8) Then $SButtons &= '(Y)'
    If BitAND($Val, 16) Then $SButtons &= '(LB)'
    If BitAND($Val, 32) Then $SButtons &= '(RB)'
    If BitAND($Val, 64) Then $SButtons &= '(Back)'
    If BitAND($Val, 128) Then $SButtons &= '(Start)'
    If BitAND($Val, 256) Then $SButtons &= '(LS)'
    If BitAND($Val, 512) Then $SButtons &= '(RS)'
    Return $SButtons
EndFunc   ;==>GetPressed

#EndRegion -Joypad---------------------------------------------------------------------------------------------------------

