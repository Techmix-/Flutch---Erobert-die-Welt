#include "_Const.au3"
#include "GDIP.au3"
#include <GDIPlus.au3>
#include <GDIPlusConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <File.au3>
#include <Array.au3>
#Include <Color.au3>
#include-once
#RequireAdmin

#cs ================================================================================================================================
==== ChangeLog =====================================================================================================================
====================================================================================================================================

 AutoIt Version: 	3.3.7.23 (beta)
 Skript:			_Engine.au3
 Author:         	Techmix
					BadBunny

##	--------------------------------------------------------------------------------------------------------------------------------

	Enginefunctions

	Ausgelagerte Engine-Funktionen


##	--------------------------------------------------------------------------------------------------------------------------------

		V0.12:
	Etliche Konsturktor-Funktionen im Stil von UED zugefügt
	'Scaling' Bug behoben
	BadBunny´s GDI Header eingebaut
	Unzählige Änderungen durchgeführt...

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.11:
	Mappingsystem Integriert

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.10:
	Grundfunktionen erstellt

##	================================================================================================================================
#ce

#Region -UDF-Variablen--------------------------------------------------------------------------------------------------------------

Global $a_SkyboxTextures[6], $a_irr_SkyboxTextures[6]
Global $i__StartPos = -1, $s__DebugText, $i__ScaleMap, $__AutoFlipRotate[8]=[0,1,2,3,4,5,6,7]


#EndRegion -UDF-Variablen-----------------------------------------------------------------------------------------------------------


#Region -Hauptfunktionen-------------------------------------------------------------------------------------------------------------

Func _Camera($s_Mode="RPG")
	__ConsoleWrite("_Engine: _Camera($s_Mode="&$s_Mode&")"&@CRLF)

	; Remove Collision
	if $a_Camera[0][$e_Cam_Collision] <> "" then _IrrRemoveAnimator($a_Camera[0][$e_Cam_Node], $a_Camera[0][$e_Cam_Collision])
	if $a_Camera[0][$e_Cam_Node] <> "" then _IrrRemoveNode($a_Camera[0][$e_Cam_Node])

	; View-Mode
	if $s_Mode="FPS" then _SetUp_FPS_Movement($a_Camera[0][$e_Cam_Node])	; FPS-Movement
	if $s_Mode="RPG" then _SetUp_RPG_Movement($a_Camera[0][$e_Cam_Node])	; RPG-Movement
	if $s_Mode="CiC" then _SetUp_CineCam($a_Camera[0][$e_Cam_Node])			; CineCam

	_IrrSetCameraClipDistance($a_Camera[0][$e_Cam_Node], 32000)

;~ 	if IsArray($aVector3df) Then
;~ 		Local $aVector3df
;~ 		if $a_Camera[0][$e_Cam_Node] <> "" then $aVector3df = _IrrGetNodePosition($a_Camera[0][$e_Cam_Node])
;~ 		_IrrSetNodePosition($a_Camera[0][$e_Cam_Node], $aVector3df[0], $aVector3df[1], $aVector3df[2])
;~ 	Else
;~ 		_IrrSetNodePosition($a_Camera[0][$e_Cam_Node], 0, 60, 0)
;~ 	EndIf

EndFunc

Func _Camera2($s_Mode=-1)
	__ConsoleWrite("_Engine: _Camera($s_Mode="&$s_Mode&")"&@CRLF)

	if $s_Mode = -1 then
		; Remove Collision
;~ 		if $a_Camera[0][$e_Cam_Collision] <> "" then _IrrRemoveAnimator($a_Camera[0][$e_Cam_Node], $a_Camera[0][$e_Cam_Collision])
		if $a_Camera[0][$e_Cam_Node] <> "" then _IrrRemoveNode($a_Camera[0][$e_Cam_Node])

		; View-Mode
		if $s_Mode="FPS" then _SetUp_FPS_Movement($a_Camera[0][$e_Cam_Node])	; FPS-Movement
		if $s_Mode="RPG" then _SetUp_RPG_Movement($a_Camera[0][$e_Cam_Node])	; RPG-Movement
		if $s_Mode="CiC" then _SetUp_CineCam($a_Camera[0][$e_Cam_Node])			; CineCam

		_IrrSetCameraClipDistance($a_Camera[0][$e_Cam_Node], 32000)
	EndIf

	if $s_Mode = "FPS" Then
		_SetUp_FPS_Movement($a_Camera[0][$e_Cam_Node])

	elseif $s_Mode = "RPG" Then
		; Maus
		Local $aMousePos = MouseGetPos(), $a_CamRotation[2]
		$aMousePos[0] -= @DesktopWidth/2
		$aMousePos[1] -= @DesktopHeight/2
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

		; Kameraposition berrechnen
		Local $pi = 3.14159, $deg2rad = $pi/180, $rad = $a_CamRotation[0] * $deg2rad, $aPoint = _IrrGetNodePosition($a_PlayerData[0][$e_Player_Node]), $aCamPos[3]
		$aCamPos[0] = $a_Camera[0][$e_Cam_Entfernung] * Sin($a_CamRotation[1] * $deg2rad) * Cos($rad) + $aPoint[0]
		$aCamPos[2] = $a_Camera[0][$e_Cam_Entfernung] * Sin($a_CamRotation[1] * $deg2rad) * Sin($rad) + $aPoint[2]
		$aCamPos[1] = $a_Camera[0][$e_Cam_Entfernung] * Cos($a_CamRotation[1] * $deg2rad) + $aPoint[1]
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aCamPos[1] = ' & $aCamPos[1] & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

		; Kamera setzten
		_IrrSetNodePosition($a_Camera[0][$e_Cam_Node], $aCamPos[0], $aCamPos[1]+1+$a_Camera[0][$e_Cam_Entfernung]/6, $aCamPos[2])
		_IrrSetCameraTarget($a_Camera[0][$e_Cam_Node], $aPoint[0], $aPoint[1], $aPoint[2])
	endif
EndFunc

Func _Smoke()
;~ 	__ConsoleWrite("_Engine: _Smoke()"&@CRLF)
;~ 	$a_SfxPartikel[$e_SmokeParticles] = _IrrAddParticleSystemToScene($IRR_NO_EMITTER)

;~ 	$a_SfxPartikel[$e_SmokeParticlesSettings] = __CreateParticleSettings(-1.7, 1.7, -1.7, 1.7, 1.7, 1.7, _
;~ 											0, 0, 0, 200, 200, 255, 255, 255, _
;~ 											255, 255, 255, 50, 100, 5.5, 5.5, _
;~ 											5.5, 5.5, 1)

;~ 	$a_SfxPartikel[$e_SmokeEmitter] = _IrrAddParticleEmitter($a_SfxPartikel[$e_SmokeParticles], $a_SfxPartikel[$e_SmokeParticlesSettings])
;~ 	_IrrAddFadeOutParticleAffector($a_SfxPartikel[$e_SmokeParticles], 2000, 16,8,0 )

;~ 	_IrrAddParticlePushAffector($a_SfxPartikel[$e_SmokeParticles], 0, 0, 0, 300, 300, 300, 50, 0.0, 0.0, $IRR_ON)
EndFunc

Func _LoadPlayer($s_Player="")
	Local $tmp_Pos
	if $a_PlayerData[0][$e_Player_Collision] <> "" then _IrrRemoveAnimator($a_PlayerData[0][$e_Player_Node], $a_PlayerData[0][$e_Player_Collision])
	if $a_PlayerData[0][$e_Player_Mesh] <> "" then _IrrRemoveMesh($a_PlayerData[0][$e_Player_Mesh])
	if $a_PlayerData[0][$e_Player_Tex0] <> "" then _IrrRemoveTexture($a_PlayerData[0][$e_Player_Tex0])
	if $a_PlayerData[0][$e_Player_Tex1] <> "" then _IrrRemoveTexture($a_PlayerData[0][$e_Player_Tex1])
	if $a_PlayerData[0][$e_Player_Node] <> "" then $tmp_Pos = _IrrGetNodePosition($a_PlayerData[0][$e_Player_Node])
	if $a_PlayerData[0][$e_Player_Node] <> "" then _IrrRemoveNode($a_PlayerData[0][$e_Player_Node])
	for $i = $e_Player_Mesh To $e_Player_Collision
		$a_PlayerData[0][$i] = ""
	Next
	if $s_Player = "" then Return

;~ 	_IrrSetParticleEmitterMinParticlesPerSecond($a_SfxPartikel[$e_SmokeEmitter], 1000)
;~ 	_IrrSetParticleEmitterMaxParticlesPerSecond($a_SfxPartikel[$e_SmokeEmitter], 1000)

	if not StringInStr($s_Player, "\", 1) then
		; Getting SQLight
		$a_PlayerData[0][$e_Player_Name] 			= _GettingData("$e_Player_Name", $s_Player)
		$a_PlayerData[0][$e_Player_Path]			= _GettingData("$e_Player_Path", $s_Player)
		$a_PlayerData[0][$e_Player_Position]		= _GettingData("$e_Player_Position", $s_Player)
		$a_PlayerData[0][$e_Player_Rotation]		= _GettingData("$e_Player_Rotation", $s_Player)
		$a_PlayerData[0][$e_Player_Energie]			= _GettingData("$e_Player_Energie", $s_Player)
		$a_PlayerData[0][$e_Player_Staerke]			= _GettingData("$e_Player_Staerke", $s_Player)
		$a_PlayerData[0][$e_Player_Sprung]			= _GettingData("$e_Player_Sprung", $s_Player)
		$a_PlayerData[0][$e_Player_Geschwindigkeit]	= _GettingData("$e_Player_Geschwindigkeit", $s_Player)
		$a_PlayerData[0][$e_Player_Animation]		= _GettingData("$e_Player_Animation", $s_Player)
		$a_PlayerData[0][$e_Player_Scale]			= _GettingData("$e_Player_Scale", $s_Player)
		$s_Player = $a_Path[$e_Path_Mesh]&$a_PlayerData[0][$e_Player_Path]&"\"
	Else
		$a_PlayerData[0][$e_Player_Name] 			= ""
		$a_PlayerData[0][$e_Player_Position]		= "100:0:100"
		$a_PlayerData[0][$e_Player_Rotation]		= "0:0:0"
		$a_PlayerData[0][$e_Player_Energie]			= "8:8"
		$a_PlayerData[0][$e_Player_Staerke]			= "4"
		$a_PlayerData[0][$e_Player_Sprung]			= "6"
		$a_PlayerData[0][$e_Player_Geschwindigkeit]	= "5"
		$a_PlayerData[0][$e_Player_Animation]		= "0"
		$a_PlayerData[0][$e_Player_Scale]			= "0.3"
		$a_PlayerData[0][$e_Player_Path]			= StringReplace($s_Player, $a_Path[$e_Path_Mesh], 1,1)
		$s_Player &= "\"
	EndIf

	Local $s_irrMap, $s_irrTex
	Local $a_MapFileList, $a_TexturList, _
		$a_MeshTypList[4]=["*.md2", "*.md3", "*.x", "*.obj"], _
		$a_TexturTypList[3]=["*.bmp", "*.png", "*.jpg"]
	for $i = 0 to UBound($a_MeshTypList)-1
		if FileExists($s_Player&$a_MeshTypList[$i]) then
			$a_MeshFileList = _FileListToArray($s_Player, $a_MeshTypList[$i])
			ExitLoop
		EndIf
	next
	for $i = 0 to UBound($a_TexturTypList)-1
		if FileExists($s_Player&$a_TexturTypList[$i]) then
			$a_TexturList = _FileListToArray($s_Player, $a_TexturTypList[$i])
			ExitLoop
		EndIf
	next
	$s_irrMesh = $s_Player & $a_MeshFileList[1]
	$s_irrTex = $s_Player & $a_TexturList[1]

	$a_PlayerData[0][$e_Player_Mesh] = _IrrGetMesh($s_irrMesh)
	$a_PlayerData[0][$e_Player_Tex0] = _IrrGetTexture($s_irrTex)
	$a_PlayerData[0][$e_Player_Node] = _IrrAddMeshToScene($a_PlayerData[0][$e_Player_Mesh])
	_IrrSetNodeMaterialTexture($a_PlayerData[0][$e_Player_Node], $a_PlayerData[0][$e_Player_Tex0], 0 )
	_IrrSetNodeMaterialFlag($a_PlayerData[0][$e_Player_Node], $IRR_EMF_LIGHTING, $IRR_OFF)
	if $a_PlayerData[0][$e_Player_Scale] <> 0 then _IrrSetNodeScale($a_PlayerData[0][$e_Player_Node], $a_PlayerData[0][$e_Player_Scale], $a_PlayerData[0][$e_Player_Scale], $a_PlayerData[0][$e_Player_Scale])
	$a_PlayerData[0][$e_Player_Animation] = "STAND"
	_IrrSetNodeAnimationSpeed($a_PlayerData[0][$e_Player_Node], 120)
	_IrrPlayNodeMD2Animation($a_PlayerData[0][$e_Player_Node], $a_PlayerData[0][$e_Player_Animation])

	; Switch Player
	if IsArray($tmp_Pos) Then
		$i_TerrainHeight = _IrrGetTerrainTileHeight($a_MapData[$e_Map_Node], $tmp_Pos[1], $tmp_Pos[2]) + 1
		_IrrSetNodePosition($a_PlayerData[0][$e_Player_Node], $tmp_Pos[0], $i_TerrainHeight, $tmp_Pos[2])
	EndIf

	; Collision
;~ 	$a_PlayerData[0][$e_Player_Collision]=_IrrAddCollisionAnimator($a_MapData[$e_Map_Collision], _
;~ 							 $a_PlayerData[0][$e_Player_Node], _
;~ 							 30.0,22.0,30.0, _
;~ 							 0.0,-9.8,0.0, _
;~ 							 0.0,-22.0,0.0 )


	$__ConsoleWrite = "_Engine: _LoadPlayer: "&$s_Player&@CRLF
	__ConsoleWrite($__ConsoleWrite)
	__DebugText($__ConsoleWrite)
EndFunc

Func _LoadLevel($s_Map="", $i_StartPos=-1)
	; Clear Scene
	if $s_Map = "" then Return

	__ConsoleWrite("_Engine: _LoadLevel($s_Map="&$s_Map&")"&@CRLF)

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
	_LoadPlayer("Green")
	__ScaleMap()

	; StartPos
	__StartPos()

	$__ConsoleWrite = "_Engine: _LoadLevel: "&$s_Map&@CRLF
	__ConsoleWrite($__ConsoleWrite)
	__DebugText($__ConsoleWrite)
EndFunc

#EndRegion -Hauptfunktionen----------------------------------------------------------------------------------------------------------


#Region -Unterfunktionen 1----------------------------------------------------------------------------------------------------------

Func __LoadMap($s_File="")
	if $s_File = "" then Return

	; Layer 1
	__ConsoleWrite("_Engine: __LoadMap($s_File="&$s_File&")"&@CRLF)
	__ConsoleWrite("_Engine:   Layer 1"&@CRLF)

	__ReleaseMap()
	__ReadMapfile($s_File)

	; Map Checken
	Local $a_MapPath=$a_Path[$e_Path_Map]&$s_File&"\"
	$tmp= StringSplit($s_File, ".", 1)
	$s_OutPath = $a_Path[$e_Path_Map] & $s_MapName & "\"
	if not FileExists($s_OutPath) then
		DirCreate($s_OutPath)
		__MakeMap($s_File)
	EndIf

	; Skybox
	Local $a_SkyboxList[1]
	$a_SkyboxList = _FileListToArray($a_Path[$e_Path_Sky]&$s_SkyBox)
	for $i = 1 to UBound($a_SkyboxList)-1
		if StringInStr($a_SkyboxList[$i], "_dn", 1) or StringInStr($a_SkyboxList[$i], "_ny", 1) then
			; down
			$a_SkyboxTextures[1] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		elseif StringInStr($a_SkyboxList[$i], "_rt", 1) or StringInStr($a_SkyboxList[$i], "_pz", 1) then
			; left
			$a_SkyboxTextures[2] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		elseif StringInStr($a_SkyboxList[$i], "_lf", 1) or StringInStr($a_SkyboxList[$i], "_nz", 1) then
			; right
			$a_SkyboxTextures[3] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		elseif StringInStr($a_SkyboxList[$i], "_ft", 1) or StringInStr($a_SkyboxList[$i], "_px", 1) then
			; front
			$a_SkyboxTextures[4] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		elseif StringInStr($a_SkyboxList[$i], "_bk", 1) or StringInStr($a_SkyboxList[$i], "_nx", 1) then
			; back
			$a_SkyboxTextures[5] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		elseif StringInStr($a_SkyboxList[$i], "_up", 1) or StringInStr($a_SkyboxList[$i], "_py", 1) then
			; up
			$a_SkyboxTextures[0] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		EndIf
	next
	$a_MapData[$e_Map_SkyTex0] = _IrrGetTexture($a_SkyboxTextures[0])
	$a_MapData[$e_Map_SkyTex1] = _IrrGetTexture($a_SkyboxTextures[1])
	$a_MapData[$e_Map_SkyTex2] = _IrrGetTexture($a_SkyboxTextures[2])
	$a_MapData[$e_Map_SkyTex3] = _IrrGetTexture($a_SkyboxTextures[3])
	$a_MapData[$e_Map_SkyTex4] = _IrrGetTexture($a_SkyboxTextures[4])
	$a_MapData[$e_Map_SkyTex5] = _IrrGetTexture($a_SkyboxTextures[5])
	$a_MapData[$e_Map_Sky] = _IrrAddSkyBoxToScene( _
		$a_MapData[$e_Map_SkyTex0], _
		$a_MapData[$e_Map_SkyTex1], _
		$a_MapData[$e_Map_SkyTex2], _
		$a_MapData[$e_Map_SkyTex3], _
		$a_MapData[$e_Map_SkyTex4], _
		$a_MapData[$e_Map_SkyTex5])


	; Map-Node auslesen
	Local $irr_ColorMap, $irr_HightMap, $irr_DetailMap
	if StringInStr($s_MapConfig, ";", 1) then
		$a_MapConfig = StringSplit($s_MapConfig, ";", 1)
		for $i = 1 to $a_MapConfig[0]
			if StringInStr($a_MapConfig[$i], "Cmap:", 1) then
				$irr_ColorMap = StringReplace($a_MapConfig[$i], "Cmap:", "", 1,1)
			elseif StringInStr($a_MapConfig[$i], "Hmap:", 1) then
				$irr_HightMap = StringReplace($a_MapConfig[$i], "Hmap:", "", 1,1)
			elseif StringInStr($a_MapConfig[$i], "Dmap:", 1) then
				$irr_DetailMap = StringReplace($a_MapConfig[$i], "Dmap:", "", 1,1)
			EndIf
		next
	EndIf
	if $irr_ColorMap = "" then $irr_ColorMap = "_ColorMap.jpg"
	if $irr_HightMap = "" then $irr_HightMap = "_HightMap.jpg"
	if $irr_DetailMap = "" then $irr_DetailMap = "_DetailMap.jpg"

	; Map-Node erstellen
;~ 	$a_MapData[$e_Map_HightMap] = _IrrGetImage($s_OutPath&$irr_HightMap)
;~ 	$a_MapData[$e_Map_Node] 	= _IrrAddTerrainTile($a_MapData[$e_Map_HightMap], 256, 0,0, 0,0,0, 0,0,0, 1,1,1, 1,6,$ETPS_65)
	$a_MapData[$e_Map_Node] 	= _IrrAddTerrain($s_OutPath&$irr_HightMap, 0,0,0, 0,0,0, 1,1,1, 255,255,255,255, 1,5,$ETPS_33)
	$a_MapData[$e_Map_ColorMap] = _IrrGetTexture($s_OutPath&$irr_ColorMap)
	$a_MapData[$e_Map_DetailMap]= _IrrGetTexture($s_OutPath&$irr_DetailMap)
	_IrrSetNodeMaterialTexture($a_MapData[$e_Map_Node], $a_MapData[$e_Map_ColorMap], 0)
	_IrrSetNodeMaterialTexture($a_MapData[$e_Map_Node], $a_MapData[$e_Map_DetailMap], 1 )
	_IrrSetNodeMaterialType($a_MapData[$e_Map_Node], $IRR_EMT_DETAIL_MAP)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_LIGHTING, $IRR_OFF)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_GOURAUD_SHADING, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_ZBUFFER, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_ZWRITE_ENABLE, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_BILINEAR_FILTER, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_TRILINEAR_FILTER, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_ANISOTROPIC_FILTER, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_BACK_FACE_CULLING, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_FOG_ENABLE, $IRR_ON)
	_IrrSetFog(240,255,255, $IRR_EXPONENTIAL_FOG, 0.0,0.0, 0.00007)
;~ 	$a_MapData[$e_Map_Collision] = _IrrGetCollisionGroupFromTerrain($a_MapData[$e_Map_Node], 0)

;~ 	_IrrDebugDataVisible($a_MapData[$e_Map_Node], $EDS_FULL )
;~ 	if not FileExists($s_OutPath&$s_MapName&".irrmesh") then _IrrWriteMesh($a_MapData[$e_Map_Node], $EMWT_IRR_MESH, $s_OutPath&$s_MapName&".irrmesh")
;~ 	if not FileExists($s_OutPath&$s_MapName&".irr") then _IrrSaveScene($s_OutPath&$s_MapName&".irr")
	; Layer 2
;~ 	__ConsoleWrite("_Engine:   Layer 2"&@CRLF)

EndFunc

Func __ReleaseMap()
	__ConsoleWrite("_Engine: __ReleaseMap()"&@CRLF)

	if $a_MapData[$e_Map_Collision] <> ""	then _IrrRemoveCollisionGroup($a_MapData[$e_Map_Collision], $a_MapData[$e_Map_Node])
	if $a_MapData[$e_Map_Node] <> "" 		then _IrrRemoveNode($a_MapData[$e_Map_Node])
	if $a_MapData[$e_Map_DetailMap] <>"" 	then _IrrRemoveTexture(	$a_MapData[$e_Map_DetailMap])
	if $a_MapData[$e_Map_ColorMap] <> "" 	then _IrrRemoveTexture($a_MapData[$e_Map_ColorMap])
	if $a_MapData[$e_Map_HightMap] <> "" 	then _IrrRemoveImage($a_MapData[$e_Map_HightMap])
	if $a_MapData[$e_Map_VerticiesMap] <> ""then _IrrRemoveImage($a_MapData[$e_Map_VerticiesMap])
	if $a_MapData[$e_Map_SkyTex0] <> "" 	then _IrrRemoveTexture($a_MapData[$e_Map_SkyTex0])
	if $a_MapData[$e_Map_SkyTex1] <> "" 	then _IrrRemoveTexture($a_MapData[$e_Map_SkyTex1])
	if $a_MapData[$e_Map_SkyTex2] <> "" 	then _IrrRemoveTexture($a_MapData[$e_Map_SkyTex2])
	if $a_MapData[$e_Map_SkyTex3] <> "" 	then _IrrRemoveTexture($a_MapData[$e_Map_SkyTex3])
	if $a_MapData[$e_Map_SkyTex4] <> "" 	then _IrrRemoveTexture($a_MapData[$e_Map_SkyTex4])
	if $a_MapData[$e_Map_SkyTex5] <> "" 	then _IrrRemoveTexture($a_MapData[$e_Map_SkyTex5])
	if $a_MapData[$e_Map_Sky] <> "" 		then _IrrRemoveNode($a_MapData[$e_Map_Sky])
	if $a_Light[0] <> "" 					then _IrrRemoveNode($a_Light[0])
	if $a_Light[1] <> "" 					then _IrrRemoveNode($a_Light[1])
	for $i = $e_Map_Mesh To $e_Map_Last-1
		$a_MapData[$i] = ""
	Next
;~ 	_IrrRemoveAllNodes()
EndFunc

Func __ResetMap()
	__ConsoleWrite("_Engine: __ResetMap()"&@CRLF)

	__ReleaseMap()
	; Skybox
	Local $a_SkyboxList[1]
	$a_SkyboxList = _FileListToArray($a_Path[$e_Path_Sky]&$s_SkyBox)
	for $i = 1 to UBound($a_SkyboxList)-1
		if StringInStr($a_SkyboxList[$i], "_dn", 1) or StringInStr($a_SkyboxList[$i], "_ny", 1) then
			; down
			$a_SkyboxTextures[1] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		elseif StringInStr($a_SkyboxList[$i], "_rt", 1) or StringInStr($a_SkyboxList[$i], "_pz", 1) then
			; left
			$a_SkyboxTextures[2] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		elseif StringInStr($a_SkyboxList[$i], "_lf", 1) or StringInStr($a_SkyboxList[$i], "_nz", 1) then
			; right
			$a_SkyboxTextures[3] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		elseif StringInStr($a_SkyboxList[$i], "_ft", 1) or StringInStr($a_SkyboxList[$i], "_px", 1) then
			; front
			$a_SkyboxTextures[4] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		elseif StringInStr($a_SkyboxList[$i], "_bk", 1) or StringInStr($a_SkyboxList[$i], "_nx", 1) then
			; back
			$a_SkyboxTextures[5] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		elseif StringInStr($a_SkyboxList[$i], "_up", 1) or StringInStr($a_SkyboxList[$i], "_py", 1) then
			; up
			$a_SkyboxTextures[0] = $a_Path[$e_Path_Sky] & $s_SkyBox & "\" & $a_SkyboxList[$i]
		EndIf
	next
	$a_MapData[$e_Map_SkyTex0] = _IrrGetTexture($a_SkyboxTextures[0])
	$a_MapData[$e_Map_SkyTex1] = _IrrGetTexture($a_SkyboxTextures[1])
	$a_MapData[$e_Map_SkyTex2] = _IrrGetTexture($a_SkyboxTextures[2])
	$a_MapData[$e_Map_SkyTex3] = _IrrGetTexture($a_SkyboxTextures[3])
	$a_MapData[$e_Map_SkyTex4] = _IrrGetTexture($a_SkyboxTextures[4])
	$a_MapData[$e_Map_SkyTex5] = _IrrGetTexture($a_SkyboxTextures[5])
	$a_MapData[$e_Map_Sky] = _IrrAddSkyBoxToScene( _
		$a_MapData[$e_Map_SkyTex0], _
		$a_MapData[$e_Map_SkyTex1], _
		$a_MapData[$e_Map_SkyTex2], _
		$a_MapData[$e_Map_SkyTex3], _
		$a_MapData[$e_Map_SkyTex4], _
		$a_MapData[$e_Map_SkyTex5])

	; Map-Node auslesen
	Local $irr_ColorMap, $irr_HightMap, $irr_DetailMap
	if StringInStr($s_MapConfig, ";", 1) then
		$a_MapConfig = StringSplit($s_MapConfig, ";", 1)
		for $i = 1 to $a_MapConfig[0]
			if StringInStr($a_MapConfig[$i], "Cmap:", 1) then
				$irr_ColorMap = StringReplace($a_MapConfig[$i], "Cmap:", "", 1,1)
			elseif StringInStr($a_MapConfig[$i], "Hmap:", 1) then
				$irr_HightMap = StringReplace($a_MapConfig[$i], "Hmap:", "", 1,1)
			elseif StringInStr($a_MapConfig[$i], "Dmap:", 1) then
				$irr_DetailMap = StringReplace($a_MapConfig[$i], "Dmap:", "", 1,1)
			EndIf
		next
	EndIf
	if $irr_ColorMap = "" then $irr_ColorMap = "_ColorMap.jpg"
	if $irr_HightMap = "" then $irr_HightMap = "_HightMap.jpg"
	if $irr_DetailMap = "" then $irr_DetailMap = "_DetailMap.jpg"
	$s_OutPath = $a_Path[$e_Path_Map] & $s_MapName & "\"

	$a_MapData[$e_Map_Node] 	= _IrrAddTerrain($s_OutPath&$irr_HightMap, 0,0,0, 0,0,0, 1,1,1, 255,255,255,255, 1,5,$ETPS_33)
	$a_MapData[$e_Map_ColorMap] = _IrrGetTexture($s_OutPath&$irr_ColorMap)
	$a_MapData[$e_Map_DetailMap]= _IrrGetTexture($s_OutPath&$irr_DetailMap)
	_IrrSetNodeMaterialTexture($a_MapData[$e_Map_Node], $a_MapData[$e_Map_ColorMap], 0)
	_IrrSetNodeMaterialTexture($a_MapData[$e_Map_Node], $a_MapData[$e_Map_DetailMap], 1 )
	_IrrSetNodeMaterialType($a_MapData[$e_Map_Node], $IRR_EMT_DETAIL_MAP)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_LIGHTING, $IRR_OFF)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_GOURAUD_SHADING, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_ZBUFFER, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_ZWRITE_ENABLE, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_BILINEAR_FILTER, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_TRILINEAR_FILTER, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_ANISOTROPIC_FILTER, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_BACK_FACE_CULLING, $IRR_ON)
	_IrrSetNodeMaterialFlag($a_MapData[$e_Map_Node], $IRR_EMF_FOG_ENABLE, $IRR_ON)
	_IrrSetFog(240,255,255, $IRR_EXPONENTIAL_FOG, 0.0,0.0, 0.00007)

	_LoadPlayer("Green")
	__ScaleMap()
	__StartPos()

EndFunc

Func __StartPos($i_StartPos=-1)
	if $i_StartPos = -1 and $i__StartPos <> -1 then $i_StartPos = $i__StartPos+1
	if $i_StartPos = -1 then $i_StartPos = Random(0,UBound($a_Startpoints,1),1)
	if $i_StartPos = -1 then $i_StartPos = 0
	if $i_StartPos > UBound($a_Startpoints,1)-1 then $i_StartPos = 0
	Local $i_PosX = $a_Startpoints[$i_StartPos][0], $i_PosY = $a_Startpoints[$i_StartPos][1]

	$i_TerrainHeight = _IrrGetTerrainTileHeight($a_MapData[$e_Map_Node], $i_PosX, $i_PosY) + 1
	_IrrSetNodePosition($a_PlayerData[0][$e_Player_Node], $i_PosX*$s_ScaleXY, $i_TerrainHeight, $i_PosY*$s_ScaleXY)
	$i__StartPos = $i_StartPos
	$__ConsoleWrite = "_Engine: __StartPos: Nr="&$i_StartPos&"  X="&int($i_PosX)&"  Y="&int($i_PosY)&@CRLF
	__ConsoleWrite($__ConsoleWrite)
	__DebugText($__ConsoleWrite)

EndFunc

Func __ScaleMap()
	_IrrSetNodeScale($a_MapData[$e_Map_Node], Number($s_ScaleXY), Number($s_ScaleZ), Number($s_ScaleXY))
	_IrrScaleTexture($a_MapData[$e_Map_Node], 1, Number($s_ScaleD))	; Detail Textur grösse
	$__ConsoleWrite = "_Engine: __ScaleMap: X/Y-Scale="&$s_ScaleXY&"  Hight-Scale="&$s_ScaleZ&"  Detail-Scale="&$s_ScaleD&@CRLF
	__ConsoleWrite($__ConsoleWrite)
	__DebugText($__ConsoleWrite)
EndFunc

Func __MakeMap($s_File="")
	__ConsoleWrite("_Engine: __MakeMap($s_File="&$s_File&")"&@CRLF)

	if $s_MapName = "Mapper" Then
		DirRemove($a_Path[$e_Path_Map] & "Mapper", 1)
		_FileDelete($a_Path[$e_Path_Map] & "Mapper.map")
	EndIf

	; Daten erfassen
	if StringInStr($s_File,"\",1) then
		$a_File=StringSplit($s_File, "\", 1)
		$s_BaseMap = $a_File[$a_File[0]]
	EndIf

	; Layer 1
	__ConsoleWrite("_Engine:   Layer 1"&@CRLF)

	; Map erstellen
	$s_OutPath = $a_Path[$e_Path_Map] & $s_MapName & "\"
	if not FileExists($s_OutPath) then DirCreate($s_OutPath)
	__MakeAllMaps($s_BaseMap)

	; Map-Konfigfile Speichern
	if not FileExists($a_Path[$e_Path_Map] & $s_MapName & ".map") then __WriteMAPfile($s_MapName)

	; Layer 2
;~ 	__ConsoleWrite("_Engine:   Layer 2"&@CRLF)
	; Ab hier kommen die 2.ten Layer:
	; 2a: Wiese als Billboard-Texturen (Wiese, Weide, Blume)
	; 2b: Sträucher und Bäume als 3D-Modelle (Nadel, Laub, Busch)
	; 2c: Kleine Steine als Billboard-Texturen
	; 2d: Steine und Felsen als 3D-Modelle
	; Verteilung:
	; Bei den Billboards (2a & 2c) kann man nur auf unterschiedliche Texturen zugreifen und diese in verschiedenen Grössen Verteilen
	; Bei den 3D-Modellen (2b & 2d) kann man unterschiedliche Drehungen, Winkel und Grössen berücksichtigen und diese Verteilen


EndFunc

Func __ReadMapfile($s_File)
	__ConsoleWrite("_Engine: __ReadMapfile($s_File="&$s_File&")"&@CRLF)
	; .Map Datei auslesen
	if not StringInStr($s_File, "\", 1) then $s_File = $a_Path[$e_Path_Map]&$s_File
	_FileReadToArray($s_File, $a_MapConfigFile)
	for $i = 1 to $a_MapConfigFile[0]
		$tmp_Split 	= StringSplit($a_MapConfigFile[$i], ";")
		if StringInStr($a_MapConfigFile[$i],"BaseMap=",1) Then
			$s_BaseMap = StringReplace($a_MapConfigFile[$i], "BaseMap=", "", 0,1)

		Elseif StringInStr($a_MapConfigFile[$i],"MapName=",1) Then
			$s_MapName = StringReplace($a_MapConfigFile[$i], "MapName=", "", 1,1)

		Elseif StringInStr($a_MapConfigFile[$i],"SkyBox=",1) Then
			$s_SkyBox = StringReplace($a_MapConfigFile[$i], "SkyBox=", "", 1,1)

		Elseif StringInStr($a_MapConfigFile[$i],"Scale=",1) Then
			$tmp = StringSplit(StringReplace($a_MapConfigFile[$i], "Scale=", "", 1,1), ",")
			$s_ScaleXY = $tmp[1]
			$s_ScaleZ = $tmp[2]
			$s_ScaleD = $tmp[3]

		Elseif StringInStr($a_MapConfigFile[$i],"Startpoints=",1) Then
			$tmp = StringSplit(StringReplace($a_MapConfigFile[$i], "Startpoints=", "", 1,1), ":", 1)
			for $j = 1 To $tmp[0]
				ReDim $a_Startpoints[$j][2]
				$a_tmp = StringSplit($tmp[$j], ",", 1)
				$a_Startpoints[$j-1][0] = $a_tmp[1]
				$a_Startpoints[$j-1][1] = $a_tmp[2]
			Next

		Elseif StringInStr($a_MapConfigFile[$i],"MapConfig=",1) Then
			$s_MapConfig = StringReplace($a_MapConfigFile[$i], "MapConfig=", "", 1,1)

		Elseif StringInStr($a_MapConfigFile[$i],"HightMap=",1) Then
;~ 			HightMap=_HightMap.jpg;Blur=0.12,3;Invert=0;SizeX=256;SizeY=256
;~ 			__MakeHightMap($s_File, $s__Blur1=0.12, $s__Blur2=3, $s__Invert=0, $s__SizeX=256, $s__SizeY=256)
			$s_HightMapBMP		= StringReplace($tmp_Split[1], "HightMap=", "", 1,1)
			for $j = 2 to $tmp_Split[0]
				if StringInStr($tmp_Split[$j], "Blur=", 1) then
					if StringInStr($tmp_Split[$j], ",", 1) then
						$tmp = StringSplit(StringReplace($tmp_Split[$j], "Blur=", "", 1,1), ",")
						$s_HightMapBlur1 = $tmp[1]
						$s_HightMapBlur2 = $tmp[2]
					EndIf
				Elseif StringInStr($tmp_Split[$j], "Invert=", 1) then
					$s_HightMapInvert = StringReplace($tmp_Split[$j], "Invert=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "SizeX=", 1) then
					$s_HightMapSizeX = StringReplace($tmp_Split[$j], "SizeX=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "SizeY=", 1) then
					$s_HightMapSizeX = StringReplace($tmp_Split[$j], "SizeY=", "", 1,1)
				EndIf
			Next

		Elseif StringInStr($a_MapConfigFile[$i],"NormalMap=",1) Then
;~ 			NormalMap=_NormalMap.jpg;FileA=_ColorMap.jpg;FileB=_DetailMap.jpg;Prozent=50;SizeX=4096;SizeY=4096
;~ 			__MakeNormalMap($s__FileA, $s__FileB="", $s__Prozent=50, $s__SizeX=4096, $s__SizeY=4096)
			$s_NormalMapBMP		= StringReplace($tmp_Split[1], "NormalMap=", "", 1,1)
			for $j = 2 to $tmp_Split[0]
				If StringInStr($tmp_Split[$j], "FileA=", 1) then
					$s_NormalMapFileA = StringReplace($tmp_Split[$j], "FileA=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "FileB=", 1) then
					$s_NormalMapFileB = StringReplace($tmp_Split[$j], "FileB=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "Prozent=", 1) then
					$s_NormalMapProzent = StringReplace($tmp_Split[$j], "Prozent=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeX=", 1) then
					$s_NormalMapSizeX = StringReplace($tmp_Split[$j], "SizeX=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeY=", 1) then
					$s_NormalMapSizeY = StringReplace($tmp_Split[$j], "SizeY=", "", 1,1)
				EndIf
			Next

		Elseif StringInStr($a_MapConfigFile[$i],"MixedMap=",1) Then
;~ 			MixedMap=_MixedMap.jpg;FileA=_DetailMap.jpg;FileB=_NormalMapA.jpg;Mask=DGSuperMask.gif;Prozent=50;SizeX=4096;SizeY=4096
;~ 			__MakeMixedMap($s__FileA, $s__FileB, $s__Mask, $s__Prozent=50, $s__SizeX=4096, $s__SizeY=4096)
			$s_MixedMapBMP			= StringReplace($tmp_Split[1], "MixedMap=", "", 1,1)
			for $j = 2 to $tmp_Split[0]
				If StringInStr($tmp_Split[$j], "FileA=", 1) then
					$s_MixedMapFileA = StringReplace($tmp_Split[$j], "FileA=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "FileB=", 1) then
					$s_MixedMapFileB = StringReplace($tmp_Split[$j], "FileB=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "Mask=", 1) then
					$s_MixedMapMask = StringReplace($tmp_Split[$j], "Mask=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "Prozent=", 1) then
					$s_MixedMapProzent = StringReplace($tmp_Split[$j], "Prozent=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeX=", 1) then
					$s_MixedMapSizeX = StringReplace($tmp_Split[$j], "SizeX=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeY=", 1) then
					$s_MixedMapSizeY = StringReplace($tmp_Split[$j], "SizeY=", "", 1,1)
				EndIf
			Next

		Elseif StringInStr($a_MapConfigFile[$i],"ColorMap=",1) Then
;~ 			ColorMap=_ColorMap.jpg;Blur=0.6,2;DiffuseUV=1;SizeX=2048;SizeY=2048
;~ 			__MakeColorMap($s_File, $s__Blur1=0.60, $s__Blur2=2, $s__DiffuseUV=0, $s__SizeX=4096, $s__SizeY=4096)
			$s_ColorMapBMP 		= StringReplace($tmp_Split[1], "ColorMap=", "", 1,1)
			for $j = 2 to $tmp_Split[0]
				if StringInStr($tmp_Split[$j], "Blur=", 1) then
					if StringInStr($tmp_Split[$j], ",", 1) then
						$tmp = StringSplit(StringReplace($tmp_Split[$j], "Blur=", "", 1,1), ",")
						$s_ColorMapBlur1 = $tmp[1]
						$s_ColorMapBlur2 = $tmp[2]
					EndIf
				Elseif StringInStr($tmp_Split[$j], "DiffuseUV=", 1) then
					$s_ColorMapDiffuseUV = StringReplace($tmp_Split[$j], "DiffuseUV=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeX=", 1) then
					$s_ColorMapSizeX = StringReplace($tmp_Split[$j], "SizeX=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeY=", 1) then
					$s_ColorMapSizeY = StringReplace($tmp_Split[$j], "SizeY=", "", 1,1)
				EndIf
			Next

		Elseif StringInStr($a_MapConfigFile[$i],"MixedMacroMap=",1) Then
;~ 			MixedMacroMap=_MixedMacroMap.jpg;File=_ColorMap.jpg;Mask=DGSuperMask.gif;Tex1=green3.jpg;Tex2=land_default.jpg;Tex3=rockwall.jpg;Tex4=stones.jpg;DiffuseUV=0;FillFX=1;Prozent=50;SizeX=4096;SizeY=4096
;~ 			__MakeMixedMacroMap($s__File, $s__Mask, $s__Tex1, $s__Tex2, $s__Tex3, $s__Tex4, $s__DiffuseUV=0, $s__Prozent=50, $s__AutoFlipRotate=1, $s__SizeX=4096, $s__SizeY=4096)
			$s_MixedMacroMapBMP			= StringReplace($tmp_Split[1], "MixedMacroMap=", "", 1,1)
			for $j = 2 to $tmp_Split[0]
				If StringInStr($tmp_Split[$j], "File=", 1) then
					$s_MixedMacroMapFile = StringReplace($tmp_Split[$j], "File=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "Mask=", 1) then
					$s_MixedMacroMapMask = StringReplace($tmp_Split[$j], "Mask=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "Tex1=", 1) then
					$s_MixedMacroMapTex1 = StringReplace($tmp_Split[$j], "Tex1=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "Tex2=", 1) then
					$s_MixedMacroMapTex2 = StringReplace($tmp_Split[$j], "Tex2=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "Tex3=", 1) then
					$s_MixedMacroMapTex3 = StringReplace($tmp_Split[$j], "Tex3=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "Tex4=", 1) then
					$s_MixedMacroMapTex4 = StringReplace($tmp_Split[$j], "Tex4=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "DiffuseUV=", 1) then
					$s_MixedMacroMapDiffuseUV = StringReplace($tmp_Split[$j], "DiffuseUV=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "Prozent=", 1) then
					$s_MixedMacroMapProzent = StringReplace($tmp_Split[$j], "Prozent=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "FillFX=", 1) then
					$s_MixedMacroMapAutoFlipRotate = StringReplace($tmp_Split[$j], "FillFX=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeX=", 1) then
					$s_MixedMacroMapSizeX = StringReplace($tmp_Split[$j], "SizeX=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeY=", 1) then
					$s_MixedMacroMapSizeY = StringReplace($tmp_Split[$j], "SizeY=", "", 1,1)
				EndIf
			Next

		Elseif StringInStr($a_MapConfigFile[$i],"MacroMap=",1) Then
;~ 			MacroMap=_MacroMap.jpg;FileA=_ColorMap.jpg;FileB=land_default.jpg;Mask=DGSuperMask.gif;DiffuseUV=0;FillFX=1;Prozent=50;SizeX=4096;SizeY=4096
;~ 			__MakeMacroMap($s__FileA, $s__FileB, $s__Mask, $s__DiffuseUV=0, $s__Prozent=50, $s__AutoFlipRotate=1, $s__SizeX=4096, $s__SizeY=4096)
			$s_MacroMapBMP			= StringReplace($tmp_Split[1], "MacroMap=", "", 1,1)
			for $j = 2 to $tmp_Split[0]
				If StringInStr($tmp_Split[$j], "FileA=", 1) then
					$s_MacroMapFileA = StringReplace($tmp_Split[$j], "FileA=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "FileB=", 1) then
					$s_MacroMapFileB = StringReplace($tmp_Split[$j], "FileB=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "Mask=", 1) then
					$s_MacroMapMask = StringReplace($tmp_Split[$j], "Mask=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "DiffuseUV=", 1) then
					$s_MacroMapDiffuseUV = StringReplace($tmp_Split[$j], "DiffuseUV=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "Prozent=", 1) then
					$s_MacroMapProzent = StringReplace($tmp_Split[$j], "Prozent=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "FillFX=", 1) then
					$s_MacroMapAutoFlipRotate = StringReplace($tmp_Split[$j], "FillFX=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeX=", 1) then
					$s_MacroMapSizeX = StringReplace($tmp_Split[$j], "SizeX=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeY=", 1) then
					$s_MacroMapSizeY = StringReplace($tmp_Split[$j], "SizeY=", "", 1,1)
				EndIf
			Next

		Elseif StringInStr($a_MapConfigFile[$i],"DetailMap=",1) Then
;~ 			DetailMap=_DetailMap.jpg;File=detailmap3.jpg;Alpha=0;Invert=0;DiffuseUV=0;FillFX=1;SizeX=2048;SizeY=2048
;~ 			__MakeDetailMap($s__File, $s__Blur1=0, $s__Blur2=0, $s__Alpha=0, $s__Invert=0, $s__DiffuseUV=0, $s__AutoFlipRotate=1, $s__SizeX=4096, $s__SizeY=4096)
			$s_DetailMapBMP		= StringReplace($tmp_Split[1], "DetailMap=", "", 1,1)
			for $j = 2 to $tmp_Split[0]
				if StringInStr($tmp_Split[$j], "Blur=", 1) then
					if StringInStr($tmp_Split[$j], ",", 1) then
						$tmp = StringSplit(StringReplace($tmp_Split[$j], "Blur=", "", 1,1), ",")
						$s_DetailMapBlur1 = $tmp[1]
						$s_DetailMapBlur2 = $tmp[2]
					EndIf
				Elseif StringInStr($tmp_Split[$j], "File=", 1) then
					$s_DetailMapFile = StringReplace($tmp_Split[$j], "File=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "Alpha=", 1) then
					$s_DetailMapAlpha = StringReplace($tmp_Split[$j], "Alpha=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "Alpha=", 1) then
					$s_DetailMapAlpha = StringReplace($tmp_Split[$j], "Alpha=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "DiffuseUV=", 1) then
					$s_DetailMapDiffuseUV = StringReplace($tmp_Split[$j], "DiffuseUV=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "FillFX=", 1) then
					$s_DetailMapAutoFlipRotate = StringReplace($tmp_Split[$j], "FillFX=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeX=", 1) then
					$s_DetailMapSizeX = StringReplace($tmp_Split[$j], "SizeX=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "SizeY=", 1) then
					$s_DetailMapSizeY = StringReplace($tmp_Split[$j], "SizeY=", "", 1,1)
				EndIf
			Next

		Elseif StringInStr($a_MapConfigFile[$i],"BitplaneMap=",1) Then
;~ 			BitplaneMap=_Bitplane.jpg;Tex1=UE3DetailRock.jpg;Tex2=UE3DetailGrass.jpg;Tex3=UE3DetailRust.jpg;Tex4=UE3DetailMarble.jpg;DiffuseUV=0;FillFX=1;SizeX=4096;SizeY=4096
;~ 			__MakeBitplaneMap($s__Tex1, $s__Tex2, $s__Tex3, $s__Tex4, $s__Alpha=0, $s__DiffuseUV=0, $s__AutoFlipRotate=1, $s__SizeX=4096, $s__SizeY=4096)
			$s_BitplanesBMP		= StringReplace($tmp_Split[1], "BitplaneMap=", "", 1,1)
			for $j = 2 to $tmp_Split[0]
				If StringInStr($tmp_Split[$j], "Tex1=", 1) then
					$s_BitplanesTex1 = StringReplace($tmp_Split[$j], "Tex1=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "Tex2=", 1) then
					$s_BitplanesTex2 = StringReplace($tmp_Split[$j], "Tex2=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "Tex3=", 1) then
					$s_BitplanesTex3 = StringReplace($tmp_Split[$j], "Tex3=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "Tex4=", 1) then
					$s_BitplanesTex4 = StringReplace($tmp_Split[$j], "Tex4=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "Alpha=", 1) then
					$s_BitplanesAlpha = StringReplace($tmp_Split[$j], "Alpha=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "DiffuseUV=", 1) then
					$s_BitplanesDiffuseUV = StringReplace($tmp_Split[$j], "DiffuseUV=", "", 1,1)
				ElseIf StringInStr($tmp_Split[$j], "FillFX=", 1) then
					$s_BitplanesAutoFlipRotate = StringReplace($tmp_Split[$j], "FillFX=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "SizeX=", 1) then
					$s_BitplanesSizeX = StringReplace($tmp_Split[$j], "SizeX=", "", 1,1)
				Elseif StringInStr($tmp_Split[$j], "SizeY=", 1) then
					$s_BitplanesSizeY = StringReplace($tmp_Split[$j], "SizeY=", "", 1,1)
				EndIf
			Next


		EndIf
	Next
EndFunc

Func __WriteMAPfile($s_File)
	__ConsoleWrite("_Engine: __WriteMAPfile($s_File="&$s_File&")"&@CRLF)
	if StringInStr($s_File,".map",1) then $s_File = StringReplace($s_File, ".map", "", 1)
	if $s_MapName = "" then $s_MapName=$s_File
	Local $s_MapConfigFile, $s_OutPath = $a_Path[$e_Path_Map] & $s_File & "\"
	if not FileExists($s_OutPath) then DirCreate($s_OutPath)
	if $a_Startpoints[0][0] = "" then $a_Startpoints[0][0]=100
	if $a_Startpoints[0][1] = "" then $a_Startpoints[0][1]=100


	; Configfile Speichern
	$s_MapConfigFile &= "" & _
		"BaseMap="& $s_BaseMap & @CRLF
		$s_MapConfigFile &= "" & _
		"MapName="&$s_MapName & @CRLF & _
		"SkyBox="&$s_SkyBox & @CRLF & _
		"Scale="&$s_ScaleXY&","&$s_ScaleZ&","&$s_ScaleD & @CRLF & _
		"Startpoints="
		for $i = 0 to UBound($a_Startpoints,1)-1
			$s_MapConfigFile &= $a_Startpoints[$i][0] &","& $a_Startpoints[$i][1]&":"
		Next
		$s_MapConfigFile = StringTrimRight($s_MapConfigFile, 1)& @CRLF
		$s_MapConfigFile &= "MapConfig="&$s_MapConfig & @CRLF & _
		$s_MapConfig = "Cmap:"&$s_ColorMapBMP
		$s_MapConfig &= ";Hmap:"&$s_HightMapBMP
		$s_MapConfig &= ";Dmap:"&$s_DetailMapBMP
;~ 		if GUICtrlRead($DetailMap_Checkbox1) = $GUI_CHECKED then $s_MapConfig &= ";Dmap:"&$s_DetailMapBMP
;~ 		if GUICtrlRead($DetailMap_Checkbox2) = $GUI_CHECKED then $s_MapConfig &= ";Dmap:"&$s_BitplanesBMP


		if $s_HightMapBMP <> "" then
;~ 			HightMap=_HightMap.jpg;Blur=0.12,3;Invert=0;SizeX=256;SizeY=256
			$s_MapConfigFile &= "HightMap="&$s_HightMapBMP
			$s_MapConfigFile &= ";Blur="&$s_HightMapBlur1&","&$s_HightMapBlur2
			$s_MapConfigFile &= ";Invert="&$s_HightMapInvert
			$s_MapConfigFile &= ";SizeX="&$s_HightMapSizeX&";SizeY="&$s_HightMapSizeY
			$s_MapConfigFile &= @CRLF
		EndIf

		if $s_NormalMapBMP <> "" then
;~ 			NormalMap=_NormalMap.jpg;FileA=_ColorMap.jpg;FileB=_DetailMap.jpg;Prozent=50;SizeX=4096;SizeY=4096
			$s_MapConfigFile &= "NormalMap="&$s_NormalMapBMP
			$s_MapConfigFile &= ";FileA="&$s_NormalMapFileA&";FileB="&$s_NormalMapFileB
			$s_MapConfigFile &= ";Prozent="&$s_NormalMapProzent
			$s_MapConfigFile &= ";SizeX="&$s_NormalMapSizeX&";SizeY="&$s_NormalMapSizeY
			$s_MapConfigFile &= @CRLF
		EndIf

		if $s_MixedMapBMP <> "" then
;~ 			MixedMap=_MixedMap.jpg;FileA=_DetailMap.jpg;FileB=_NormalMapA.jpg;Mask=DGSuperMask.gif;Prozent=50;SizeX=4096;SizeY=4096
			$s_MapConfigFile &= "MixedMap="&$s_MixedMapBMP
			$s_MapConfigFile &= ";FileA="&$s_MixedMapFileA&";FileB="&$s_MixedMapFileB
			$s_MapConfigFile &= ";Mask="&$s_MixedMapMask&";Prozent="&$s_MixedMapProzent
			$s_MapConfigFile &= ";SizeX="&$s_MixedMapSizeX&";SizeY="&$s_MixedMapSizeY
			$s_MapConfigFile &= @CRLF
		EndIf

		if $s_ColorMapBMP <> "" then
;~ 			ColorMap=_ColorMap.jpg;Blur=0.6,2;DiffuseUV=1;SizeX=2048;SizeY=2048
			$s_MapConfigFile &= "ColorMap="&$s_ColorMapBMP
			$s_MapConfigFile &= ";Blur="&$s_ColorMapBlur1&","&$s_ColorMapBlur2
			$s_MapConfigFile &= ";DiffuseUV="&$s_ColorMapDiffuseUV
			$s_MapConfigFile &= ";SizeX="&$s_ColorMapSizeX&";SizeY="&$s_ColorMapSizeY
			$s_MapConfigFile &= @CRLF
		EndIf

		if $s_MacroMapBMP <> "" then
;~ 			MacroMap=_MacroMap.jpg;FileA=_ColorMap.jpg;FileB=land_default.jpg;Mask=DGSuperMask.gif;DiffuseUV=0;FillFX=1;Prozent=50;SizeX=4096;SizeY=4096
			$s_MapConfigFile &= "MacroMap="&$s_MacroMapBMP
			$s_MapConfigFile &= ";FileA="&$s_MacroMapFileA&";FileB="&$s_MacroMapFileB
			$s_MapConfigFile &= ";Mask="&$s_MacroMapMask&";Prozent="&$s_MacroMapProzent
			$s_MapConfigFile &= ";DiffuseUV="&$s_MacroMapDiffuseUV
			$s_MapConfigFile &= ";FillFX="&$s_MacroMapAutoFlipRotate
			$s_MapConfigFile &= ";SizeX="&$s_MacroMapSizeX&";SizeY="&$s_MacroMapSizeY
			$s_MapConfigFile &= @CRLF
		EndIf

		if $s_MixedMacroMapBMP <> "" then
;~ 			MixedMacroMap=_MixedMacroMap.jpg;File=_ColorMap.jpg;Mask=DGSuperMask.gif;Tex1=green3.jpg;Tex2=land_default.jpg;Tex3=rockwall.jpg;Tex4=stones.jpg;DiffuseUV=0;FillFX=1;Prozent=50;SizeX=4096;SizeY=4096
			$s_MapConfigFile &= "MixedMacroMap="&$s_MixedMacroMapBMP
			$s_MapConfigFile &= ";File="&$s_MixedMacroMapFile&";Mask="&$s_MixedMacroMapMask
			$s_MapConfigFile &= ";Tex1="&$s_MixedMacroMapTex1&";Tex2="&$s_MixedMacroMapTex2&";Tex3="&$s_MixedMacroMapTex3&";Tex4="&$s_MixedMacroMapTex4
			$s_MapConfigFile &= ";DiffuseUV="&$s_MixedMacroMapDiffuseUV
			$s_MapConfigFile &= ";FillFX="&$s_MixedMacroMapAutoFlipRotate
			$s_MapConfigFile &= ";Prozent="&$s_MixedMacroMapProzent
			$s_MapConfigFile &= ";SizeX="&$s_MixedMacroMapSizeX&";SizeY="&$s_MixedMacroMapSizeY
			$s_MapConfigFile &= @CRLF
		EndIf

		if $s_DetailMapBMP <> "" then
;~ 			DetailMap=_DetailMap.jpg;File=detailmap3.jpg;Alpha=0;Invert=0;DiffuseUV=0;FillFX=1;SizeX=2048;SizeY=2048
			$s_MapConfigFile &= "DetailMap="&$s_DetailMapBMP
			$s_MapConfigFile &= ";File="&$s_DetailMapFile
			$s_MapConfigFile &= ";Alpha="&$s_DetailMapAlpha
			$s_MapConfigFile &= ";DiffuseUV="&$s_DetailMapDiffuseUV
			$s_MapConfigFile &= ";Invert="&$s_DetailMapInvert
			$s_MapConfigFile &= ";FillFX="&$s_DetailMapAutoFlipRotate
			$s_MapConfigFile &= ";SizeX="&$s_DetailMapSizeX&";SizeY="&$s_DetailMapSizeY
			$s_MapConfigFile &= @CRLF
		EndIf

		if $s_BitplanesBMP <> "" then
;~ 			BitplaneMap=_Bitplane.jpg;Tex1=UE3DetailRock.jpg;Tex2=UE3DetailGrass.jpg;Tex3=UE3DetailRust.jpg;Tex4=UE3DetailMarble.jpg;Alpha=0;DiffuseUV=0;FillFX=1;SizeX=4096;SizeY=4096
			$s_MapConfigFile &= "BitplaneMap="&$s_BitplanesBMP
			$s_MapConfigFile &= ";Tex1="&$s_BitplanesTex1&";Tex2="&$s_BitplanesTex2&";Tex3="&$s_BitplanesTex3&";Tex4="&$s_BitplanesTex4
			$s_MapConfigFile &= ";Alpha="&$s_BitplanesAlpha
			$s_MapConfigFile &= ";DiffuseUV="&$s_BitplanesDiffuseUV
			$s_MapConfigFile &= ";FillFX="&$s_BitplanesAutoFlipRotate
			$s_MapConfigFile &= ";SizeX="&$s_BitplanesSizeX&";SizeY="&$s_BitplanesSizeY
			$s_MapConfigFile &= @CRLF
		EndIf

	Local $h_File=FileOpen($a_Path[$e_Path_Map]&$s_File&".map", 10)
	FileWrite($h_File, $s_MapConfigFile)
	FileClose($h_File)

EndFunc

Func __DebugText($s_Text="")
	Local $_PosX=$a_System[$e_Sys_ScreenWidth]/2, $_PosY=$a_System[$e_Sys_ScreenHeight]-104
	If $a_System[$e_Sys_GameDebug] = 1 Then
		if $a_System[$e_Sys_GameName] = "Mapper" Then
			; MapViewer
			if $s__DebugText = "" then
				$s__DebugText = @CRLF& @CRLF & _
				"F1: Load Level  F2: Respawn"&@CRLF& @CRLF & _
				$a_System[$e_Sys_GameName]&@CRLF& _
				" "&$a_System[$e_Sys_GameVersion]&@CRLF&@CRLF
			EndIf
		Else
			; InGame
			if $s__DebugText = "" then
				$s__DebugText = @CRLF& @CRLF & _
				"F1: Switch Player  F2: Respawn"&@CRLF& @CRLF & _
				$a_System[$e_Sys_GameName]&@CRLF& _
				" "&$a_System[$e_Sys_GameVersion]&@CRLF&@CRLF& _
				"DebugMode = "&$a_System[$e_Sys_GameDebug]
			EndIf
		EndIf
		If $s_Text = "" Then
			; Text Ausgeben
			_Irr2DFontDraw($a_System[$e_Sys_FontSmall], $s__DebugText, $_PosX, $_PosY, $a_System[$e_Sys_ScreenWidth], $a_System[$e_Sys_ScreenHeight])
		Else
			; Text Verlängern
			$s__DebugText = $s_Text & $s__DebugText
		EndIf

		; Show FPS
		$a_Pos = _IrrGetNodePosition($a_PlayerData[0][$e_Player_Node])
		$tmp_Txt = "FPS: " & _IrrGetFPS() & @CRLF & _
			"Player Position:"&@CRLF&"X="&int($a_Pos[0]/$i__ScaleMap)&" Y="&Int($a_Pos[2]/$i__ScaleMap)
		_Irr2DFontDraw($a_System[$e_Sys_FontSmall], $tmp_Txt, 10, 10, 150, 100)
	EndIf

EndFunc

#EndRegion -Unterfunktionen 1-------------------------------------------------------------------------------------------------------


#Region -Unterfunktionen 2----------------------------------------------------------------------------------------------------------

;~ 	UE3-Like Grafik Konstructor-Funktionen

Func __MakeAllMaps($s_File)
	if $s_MapName = "Mapper" Then
		DirRemove($a_Path[$e_Path_Map] & "Mapper", 1)
		_FileDelete($a_Path[$e_Path_Map] & "Mapper.map")
	EndIf
	if StringInStr($s_File, "\", 1) then
		$a_File=StringSplit($s_File, "\", 1)
		$s_BaseMap = $a_File[$a_File[0]]
	Else
		$s_BaseMap = $s_File
	EndIf
	$s_OutPath = $a_Path[$e_Path_Map] & $s_MapName & "\"
	if not FileExists($s_OutPath) then DirCreate($s_OutPath)
	FileCopy($s_File, $a_Path[$e_Path_Map] & $s_BaseMap, 9)

	; CMap: ColorMap, MacroMap, MixedMacroMap
	Local $sColorMapBlur1, $sColorMapBlur2, $sColorMapDiffuseUV, $sColorMapSizeX, $sColorMapSizeY
	if $s_ColorMapBlur1 = "" then
		$sColorMapBlur1 = 0.60
		$sColorMapBlur2 = 2
	Else
		$sColorMapBlur1 = $s_ColorMapBlur1
		$sColorMapBlur2 = $s_ColorMapBlur2
	EndIf
	if $s_ColorMapDiffuseUV = "" then
		$sColorMapDiffuseUV = 1
	Else
		$sColorMapDiffuseUV = $s_ColorMapDiffuseUV
	EndIf
	if $s_ColorMapSizeX = "" then
		$sColorMapSizeX = 1024
		$sColorMapSizeY = 1024
	Else
		$sColorMapSizeX = $s_ColorMapSizeX
		$sColorMapSizeY = $s_ColorMapSizeY
	EndIf
	$s_ColorMapBMP 		= __MakeColorMap($s_BaseMap, $sColorMapBlur1, $sColorMapBlur2, $sColorMapDiffuseUV, $sColorMapSizeX, $sColorMapSizeY)
	;
	Local $sMacroMapFileA, $sMacroMapFileB, $sMacroMapMask, $sMacroMapAutoFlipRotate, $sMacroMapDiffuseUV, $sMacroMapProzent, $sMacroMapSizeX, $sMacroMapSizeY
	if $s_MacroMapFileA = "" then
		dim $sMacroMapFileA=$s_ColorMapBMP, $sMacroMapFileB="green3.png", $sMacroMapMask="DGSuperMask.gif"
	Else
		dim $sMacroMapFileA=$s_MacroMapFileA, $sMacroMapFileB=$s_MacroMapFileB, $sMacroMapMask=$s_MacroMapMask
	EndIf
	if $s_MacroMapDiffuseUV = "" then
		$sMacroMapDiffuseUV = 0
	Else
		$sMacroMapDiffuseUV = $s_MacroMapDiffuseUV
	EndIf
	if $s_MacroMapProzent = "" then
		$sMacroMapProzent = 50
	Else
		$sMacroMapProzent = $s_MacroMapProzent
	EndIf
	if $s_MacroMapAutoFlipRotate = "" then
		$sMacroMapAutoFlipRotate = 1
	Else
		$sMacroMapAutoFlipRotate = $s_MacroMapAutoFlipRotate
	EndIf
	if $s_MacroMapSizeX = "" then
		$sMacroMapSizeX = 1024
		$sMacroMapSizeY = 1024
	Else
		$sMacroMapSizeX = $s_MacroMapSizeX
		$sMacroMapSizeY = $s_MacroMapSizeY
	EndIf
	$s_MacroMapBMP 		= __MakeMacroMap($sMacroMapFileA, $sMacroMapFileB, $sMacroMapMask, $sMacroMapDiffuseUV, $sMacroMapProzent, $sMacroMapAutoFlipRotate, $sMacroMapSizeX, $sMacroMapSizeY)
	;
	Local $sMixedMacroMapFile, $sMixedMacroMapMask, $sMixedMacroMapTex1, $sMixedMacroMapTex2, $sMixedMacroMapTex3, $sMixedMacroMapTex4, $sMixedMacroMapDiffuseUV, $sMixedMacroMapProzent, $sMixedMacroMapAutoFlipRotate, $sMixedMacroMapSizeX, $sMacroMixedMapSizeY
	if $s_MixedMacroMapFile = "" then
		dim $sMixedMacroMapFile=$s_ColorMapBMP, $sMixedMacroMapMask="DGSuperMask.gif", $sMixedMacroMapTex1="UE3DetailRock.png", $sMixedMacroMapTex2="UE3DetailGrass.png", $sMixedMacroMapTex3="UE3DetailRust.png", $sMixedMacroMapTex4="UE3DetailMarble.png"
	Else
		dim $sMixedMacroMapFile=$s_MixedMacroMapFile, $sMixedMacroMapMask=$s_MixedMacroMapMask, $sMixedMacroMapTex1=$s_MixedMacroMapTex1, $sMixedMacroMapTex2=$s_MixedMacroMapTex2, $sMixedMacroMapTex3=$s_MixedMacroMapTex3, $sMixedMacroMapTex4=$s_MixedMacroMapTex4
	EndIf
	if $s_MixedMacroMapDiffuseUV = "" then
		$sMixedMacroMapDiffuseUV = 0
	Else
		$sMixedMacroMapDiffuseUV = $s_MixedMacroMapDiffuseUV
	EndIf
	if $s_MixedMacroMapProzent = "" then
		$sMixedMacroMapProzent = 50
	Else
		$sMixedMacroMapProzent = $s_MixedMacroMapProzent
	EndIf
	if $s_MixedMacroMapAutoFlipRotate = "" then
		$sMixedMacroMapAutoFlipRotate = 1
	Else
		$sMixedMacroMapAutoFlipRotate = $s_MixedMacroMapAutoFlipRotate
	EndIf
	if $s_MixedMacroMapSizeX = "" then
		$sMixedMacroMapSizeX = 1024
		$sMixedMacroMapSizeY = 1024
	Else
		$sMixedMacroMapSizeX = $s_MixedMacroMapSizeX
		$sMixedMacroMapSizeY = $s_MixedMacroMapSizeY
	EndIf
	$s_MixedMacroMapBMP = __MakeMixedMacroMap($sMixedMacroMapFile, $sMixedMacroMapMask, $sMixedMacroMapTex1, $sMixedMacroMapTex2, $sMixedMacroMapTex3, $sMixedMacroMapTex4, $sMixedMacroMapDiffuseUV, $sMixedMacroMapProzent, $sMixedMacroMapAutoFlipRotate, $sMixedMacroMapSizeX, $sMacroMixedMapSizeY)


	; DMap: Detailmap, Bitplane
	Local $sDetailMapFile, $sDetailMapBlur1, $sDetailMapBlur2, $sDetailMapAlpha, $sDetailMapInvert, $sDetailMapDiffuseUV, $sDetailMapAutoFlipRotate, $sDetailMapSizeX, $sDetailMapSizeY
	if $s_DetailMapFile = "" then
		dim $sDetailMapFile="detailmap3.jpg"
	Else
		dim $sDetailMapFile=$s_DetailMapFile
	EndIf
	if $s_DetailMapBlur1 = "" then
		$sDetailMapBlur1 = 0
		$sDetailMapBlur2 = 0
	Else
		$sDetailMapBlur1 = $s_DetailMapBlur1
		$sDetailMapBlur2 = $s_DetailMapBlur2
	EndIf
	if $s_DetailMapDiffuseUV = "" then
		$sDetailMapDiffuseUV = 0
	Else
		$sDetailMapDiffuseUV = $s_DetailMapDiffuseUV
	EndIf
	if $s_DetailMapAlpha = "" then
		$sDetailMapAlpha = 0
	Else
		$sDetailMapAlpha = $s_DetailMapAlpha
	EndIf
	if $s_DetailMapInvert = "" then
		$sDetailMapInvert = 0
	Else
		$sDetailMapInvert = $s_DetailMapInvert
	EndIf
	if $s_DetailMapAutoFlipRotate = "" then
		$sDetailMapAutoFlipRotate = 1
	Else
		$sDetailMapAutoFlipRotate = $s_DetailMapAutoFlipRotate
	EndIf
	if $s_DetailMapSizeX = "" then
		$sDetailMapSizeX = 2048
		$sDetailMapSizeY = 2048
	Else
		$sDetailMapSizeX = $s_DetailMapSizeX
		$sDetailMapSizeY = $s_DetailMapSizeY
	EndIf
	$s_DetailMapBMP 	= __MakeDetailMap($sDetailMapFile, $sDetailMapBlur1, $sDetailMapBlur2, $sDetailMapAlpha, $sDetailMapInvert, $sDetailMapDiffuseUV, $sDetailMapAutoFlipRotate, $sDetailMapSizeX, $sDetailMapSizeY)
	;
	Local $sBitplanesTex1, $sBitplanesTex2, $sBitplanesTex3, $sBitplanesTex4, $sBitplanesAlpha, $sBitplanesDiffuseUV, $sBitplanesInvert, $sBitplanesAutoFlipRotate, $sBitplanesSizeX, $sBitplanesSizeY
	if $s_BitplanesTex1 = "" then
		dim $sBitplanesTex1="UE3DetailRock.png", $sBitplanesTex2="UE3DetailGrass.png", $sBitplanesTex3="UE3DetailRust.png", $sBitplanesTex4="UE3DetailMarble.png"
	Else
		dim $sBitplanesTex1=$s_BitplanesTex1, $sBitplanesTex2=$s_BitplanesTex2, $sBitplanesTex3=$s_BitplanesTex3, $sBitplanesTex4=$s_BitplanesTex4
	EndIf
	if $s_BitplanesDiffuseUV = "" then
		$sBitplanesDiffuseUV = 0
	Else
		$sBitplanesDiffuseUV = $s_BitplanesDiffuseUV
	EndIf
	if $s_BitplanesAlpha = "" then
		$sBitplanesAlpha = 0
	Else
		$sBitplanesAlpha = $s_BitplanesAlpha
	EndIf
	if $s_BitplanesInvert = "" then
		$sBitplanesInvert=0
	Else
		$sBitplanesInvert=$s_BitplanesInvert
	EndIf
	if $s_BitplanesAutoFlipRotate = "" then
		$sBitplanesAutoFlipRotate = 1
	Else
		$sBitplanesAutoFlipRotate = $s_BitplanesAutoFlipRotate
	EndIf
	if $s_BitplanesSizeX = "" then
		$sBitplanesSizeX = 2048
		$sBitplanesSizeY = 2048
	Else
		$sBitplanesSizeX = $s_BitplanesSizeX
		$sBitplanesSizeY = $s_BitplanesSizeY
	EndIf
	$s_BitplanesBMP 	= __MakeBitplaneMap($sBitplanesTex1, $sBitplanesTex2, $sBitplanesTex3, $sBitplanesTex4, $sBitplanesAlpha, $sBitplanesDiffuseUV, $sBitplanesInvert, $sBitplanesAutoFlipRotate, $sBitplanesSizeX, $sBitplanesSizeY)


	; HMap: HightMap, NormalMap, MixedMap
	Local $sHightMapBlur1, $sHightMapBlur2, $sHightMapInvert, $sHightMapSizeX, $sHightMapSizeY
	if $s_HightMapBlur1 = "" then
		$sHightMapBlur1 = 0.12
		$sHightMapBlur2 = 3
	Else
		$sHightMapBlur1 = $s_HightMapBlur1
		$sHightMapBlur2 = $s_HightMapBlur2
	EndIf
	if $sHightMapInvert = "" then
		$sHightMapInvert = 0
	Else
		$sHightMapInvert = $s_HightMapInvert
	EndIf
	if $s_HightMapSizeX = "" then
		$sHightMapSizeX = 256
		$sHightMapSizeY = 256
	Else
		$sHightMapSizeX = $s_HightMapSizeX
		$sHightMapSizeY = $s_HightMapSizeY
	EndIf
	$s_HightMapBMP 		= __MakeHightMap($s_BaseMap, $sHightMapBlur1, $sHightMapBlur2, $sHightMapInvert, $sHightMapSizeX, $sHightMapSizeY)
	;
	Local $sNormalMapFileA, $sNormalMapFileB, $sNormalMapProzent, $sNormalMapSizeX, $sNormalMapSizeY
	if $s_NormalMapFileA = "" then
		$sNormalMapFileA = $s_ColorMapBMP
		$sNormalMapFileB = $s_DetailMapBMP
	Else
		$sNormalMapFileA = $s_NormalMapFileA
		$sNormalMapFileB = $s_NormalMapFileB
	EndIf
	if $s_NormalMapProzent = "" then
		$sNormalMapProzent = 50
	Else
		$sNormalMapProzent = $s_NormalMapProzent
	EndIf
	if $s_NormalMapSizeX = "" then
		$s_NormalMapSizeX = 2048
		$s_NormalMapSizeY = 2048
	Else
		$sNormalMapSizeX = $s_NormalMapSizeX
		$sNormalMapSizeY = $s_NormalMapSizeY
	EndIf
	$s_NormalMapBMP 	= __MakeNormalMap($sNormalMapFileA, $sNormalMapFileB, $sNormalMapProzent, $sNormalMapSizeX, $sNormalMapSizeY)
	;
	Local $sMixedMapFileA, $sMixedMapFileB, $sMixedMapMask, $sMixedMapProzent, $sMixedMapSizeX, $sMixedMapSizeY
	if $s_MixedMapFileA = "" then
		$sMixedMapFileA = $s_NormalMapBMP
		$sMixedMapFileB = $s_DetailMapBMP
		$sMixedMapMask = "DGSuperMask.gif"
	Else
		$sMixedMapFileA = $s_MixedMapFileA
		$sMixedMapFileB = $s_MixedMapFileB
		$sMixedMapMask = $s_MixedMapMask
	EndIf
	if $s_MixedMapProzent = "" then
		$sMixedMapProzent = 50
	Else
		$sMixedMapProzent = $s_MixedMapProzent
	EndIf
	if $s_MixedMapSizeX = "" then
		$sMixedMapSizeX = 2048
		$sMixedMapSizeY = 2048
	Else
		$sMixedMapSizeX = $s_MixedMapSizeX
		$sMixedMapSizeY = $s_MixedMapSizeY
	EndIf
	$s_MixedMapBMP		= __MakeMixedMap($sMixedMapFileA, $sMixedMapFileB, $sMixedMapMask, $sMixedMapProzent, $sMixedMapSizeX, $sMixedMapSizeY)

	__ConsoleWrite("_Engine: __MakeAllMaps($s_File="&$s_BaseMap&")"&@CRLF)
EndFunc

;~ 	$s_HightMapBMP, $s_HightMapBlur1=0.12, $s_HightMapBlur2=3, $s_HightMapInvert=0, $s_HightMapSizeX=256, $s_HightMapSizeY=256
Func __MakeHightMap($s_File, $s__Blur1=0.12, $s__Blur2=3, $s__Invert=0, $s__SizeX=256, $s__SizeY=256)
	__ConsoleWrite("_Engine: __MakeHightMap($s_File="&$s_File&")"&@CRLF)
	; $s_File = Base-Pic
	$s_HightMapBMP="_HightMap.jpg"
	$s_OutFile = $a_Path[$e_Path_Map] & $s_MapName & "\" & $s_HightMapBMP

	$s_HightMapBlur1 	= $s__Blur1
	$s_HightMapBlur2 	= $s__Blur2
	$s_HightMapSizeX 	= $s__SizeX
	$s_HightMapSizeY 	= $s__SizeY
	$s_HightMapInvert 	= $s__Invert
	if not StringInStr($s_File, "\", 1) then $s_File=$a_Path[$e_Path_Map]&$s_File

;~ 	HightMap	-> Self: Die aus dem Map-Pic erstellte HightMap (Blurred, Invert)
;~ 	Global $s_HightMapBMP, $s_HightMapBlur1=0.12, $s_HightMapBlur2=3, $s_HightMapInvert=0, $s_HightMapSizeX=256, $s_HightMapSizeY=256
	_GDIPlus_Startup()
	$hBitmap = _GDIPlus_ImageLoadFromFile($s_File)
	_FileDelete($s_OutFile)
		$hBitmap = __ASM_BitmapBnW($hBitmap, 98, 0, 1)
		if $s_HightMapBlur1 > 0 and $s_HightMapBlur2 > 0 then $hBitmap = __Blur($hBitmap, $s_HightMapBlur1, $s_HightMapBlur2)
		if $s_HightMapInvert = 1 then $hBitmap = __Invert($hBitmap)
		$hBitmap = __Resize($hBitmap, $s_HightMapSizeX, $s_HightMapSizeY)
	$sCLSID = _GDIPlus_EncodersGetCLSID("JPG")
	_GDIPlus_ImageSaveToFileEx($hBitmap, $s_OutFile, $sCLSID)
    _GDIPlus_ImageDispose($hBitmap)
	_GDIPlus_Shutdown()

	Return $s_HightMapBMP
EndFunc
;~ 	$s_NormalMapBMP, $s_NormalMapFileA, $s_NormalMapFileB="", $s_NormalMapProzent=50, $s_NormalMapSizeX=4096, $s_NormalMapSizeY=4096
Func __MakeNormalMap($s__FileA, $s__FileB="_DetailMap.jpg", $s__Prozent=50, $s__SizeX=4096, $s__SizeY=4096)
	__ConsoleWrite("_Engine: __MakeNormalMap($s_File="&$s__FileA&")"&@CRLF)
	; $s__FileA = ColorMap / HightMap
	; $s__FileB = DetailMap / BitplaneMap
	$s_NormalMapBMP="_NormalMap.jpg"
	$s_OutFile = $a_Path[$e_Path_Map] & $s_MapName & "\" & $s_NormalMapBMP

	$s_NormalMapFileA 	= $s__FileA
	$s_NormalMapFileB 	= $s__FileB
	$s_NormalMapSizeX 	= $s__SizeX
	$s_NormalMapSizeY 	= $s__SizeY
	$s_NormalMapProzent = $s__Prozent
	if not StringInStr($s__FileA, "\", 1) then $s__FileA=$a_Path[$e_Path_Map] & $s_MapName & "\" & $s__FileA
	if not StringInStr($s__FileB, "\", 1) then $s__FileB=$a_Path[$e_Path_Map] & $s_MapName & "\" & $s__FileB
	$s_OutTex = $a_Path[$e_Path_Map] & $s_MapName & "\" & $s__FileB
	if FileExists($s_OutTex) = 0 then FileCopy($s__FileB, $s_OutTex, 9)

;~ 	NormalMap	-> UT3: Selber erstellen, Zwei vorgegebene Texturen zu einer Mischen unter Angabe der Grösse
;~ 	Global $s_NormalMapBMP, $s_NormalMapSizeX=4096, $s_NormalMapSizeY=4096, $s_NormalMapIntense=8, $s_NormalMapScale=1, _
;~ 		$s_NormalMapFileA, $s_NormalMapFileB, $s_NormalMapAProzent=50, $s_NormalMapBProzent=50
	_GDIPlus_Startup()
	$hBitmap1 = _GDIPlus_ImageLoadFromFile($s__FileA)
	$hBitmap2 = _GDIPlus_ImageLoadFromFile($s__FileB)
	_FileDelete($s_OutFile)
;~ 		$hBitmap2 	= __MakeAlpha($hBitmap2, $s_NormalMapProzent)
		$hBitmap2 	= __Resize($hBitmap2, $s_NormalMapSizeX, $s_NormalMapSizeY)
;~ 		$hBitmap1 	= __MakeAlpha($hBitmap1, 100-$s_NormalMapProzent)
		$hBitmap1 	= __Resize($hBitmap1, $s_NormalMapSizeX, $s_NormalMapSizeY)
		$hImage 	= __CombineBitmaps2to1($hBitmap1, $hBitmap2)
	$sCLSID = _GDIPlus_EncodersGetCLSID("JPG")
	_GDIPlus_ImageSaveToFileEx($hImage, $s_OutFile, $sCLSID)
    _GDIPlus_ImageDispose($hBitmap1)
	_GDIPlus_ImageDispose($hBitmap2)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()

	Return $s_NormalMapBMP
EndFunc
;~ 	$s_MixedMapBMP, $s_MixedMapFileA, $s_MixedMapFileB, $s_MixedMapMask, $s_MixedMapProzent=50, $s_MixedMapSizeX=4096, $s_MixedMapSizeY=4096
Func __MakeMixedMap($s__FileA, $s__FileB, $s__Mask, $s__Prozent=50, $s__SizeX=4096, $s__SizeY=4096)
	__ConsoleWrite("_Engine: __MakeMixedMap($s_File="&$s__FileA&")"&@CRLF)
	; $s__FileA = NormalMap
	; $s__FileB = DetailMap
	; $s__Mask  = UT3 Supermask
	$s_MixedMapBMP="_MixedMap.jpg"
	$s_OutFile = $a_Path[$e_Path_Map] & $s_MapName & "\" & $s_MixedMapBMP

	$s_MixedMapFileA	= $s__FileA
	$s_MixedMapFileB	= $s__FileB
	$s_MixedMapMask		= $s__Mask
	$s_MixedMapProzent	= $s__Prozent
	$s_MixedMapSizeX	= $s__SizeX
	$s_MixedMapSizeY	= $s__SizeY
	if not StringInStr($s__FileA, "\", 1) then $s__FileA=$a_Path[$e_Path_Map] & $s_MapName & "\" & $s__FileA
	if not StringInStr($s__FileB, "\", 1) then $s__FileB=$a_Path[$e_Path_Map] & $s_MapName & "\" & $s__FileB
	$s_OutTex = $a_Path[$e_Path_Map] & $s_MapName & "\" & $s__FileB
	if FileExists($s_OutTex) = 0 then FileCopy($s__FileB, $s_OutTex, 9)
	if not StringInStr($s__Mask, "\", 1) then $s__Mask=$a_Path[$e_Path_Masks] & $s__Mask
	$s_OutTex = $a_Path[$e_Path_Masks] & $s__Mask
	if FileExists($s_OutTex) = 0 then FileCopy($s__Mask, $s_OutTex, 9)

;~ 	MixedMap	-> UT3: Die NormalMap und die DetailMap zu einem Prozentsatz Mixen
;~ 	Global $s_MixedMapBMP, $s_MixedMapSizeX=4096, $s_MixedMapSizeY=4096, $s_MixedMapFileA, $s_MixedMapFileB, $s_MixedMapProzent=50
;~ 	_GDIPlus_Startup()
;~ 	$hBitmap1 = _GDIPlus_ImageLoadFromFile($s__FileA)
;~ 	$hBitmap2 = _GDIPlus_ImageLoadFromFile($s__FileB)
;~ 	_FileDelete($s_OutFile)
;~ 		$hBitmap1 	= __Resize($hBitmap1, $s_NormalMapSizeX, $s_NormalMapSizeY)
;~ 		$hBitmap2 	= __Resize($hBitmap2, $s_NormalMapSizeX, $s_NormalMapSizeY)
;~ 		$hImage 	= __CombineBitmaps2to1($hBitmap1, $hBitmap2)
;~ 	$sCLSID = _GDIPlus_EncodersGetCLSID("JPG")
;~ 	_GDIPlus_ImageSaveToFileEx($hImage, $s_OutFile, $sCLSID)
;~     _GDIPlus_ImageDispose($hBitmap1)
;~ 	_GDIPlus_ImageDispose($hBitmap2)
;~ 	_GDIPlus_ImageDispose($hImage)
;~ 	_GDIPlus_Shutdown()

	Return $s_MixedMapBMP
EndFunc

;~ 	$s_ColorMapBMP, $s_ColorMapBlur1=0.60, $s_ColorMapBlur2=2, $s_ColorMapDiffuseUV=0, $s_ColorMapSizeX=4096, $s_ColorMapSizeY=4096
Func __MakeColorMap($s_File, $s__Blur1=0.60, $s__Blur2=2, $s__DiffuseUV=0, $s__SizeX=4096, $s__SizeY=4096)
	__ConsoleWrite("_Engine: __MakeColorMap($s_File="&$s_File&")"&@CRLF)
	; $s_File = Base-Pic
	$s_ColorMapBMP="_ColorMap.jpg"
	$s_OutFile = $a_Path[$e_Path_Map] & $s_MapName & "\" & $s_ColorMapBMP

	$s_ColorMapBlur1 		= $s__Blur1
	$s_ColorMapBlur2 		= $s__Blur2
	$s_ColorMapDiffuseUV 	= $s__DiffuseUV
	$s_ColorMapSizeX 		= $s__SizeX
	$s_ColorMapSizeY 		= $s__SizeY
	if not StringInStr($s_File, "\", 1) then $s_File=$a_Path[$e_Path_Map]&$s_File

;~ 	ColorMap	-> Self: Das Map-Pic als Vorgabe (Blured, DiffuseUV (UT3))
;~ 	Global $s_ColorMapBMP, $s_ColorMapSizeX=4096, $s_ColorMapSizeY=4096, $s_ColorMapBlur1=0.60, $s_ColorMapBlur2=2, _
;~ 		$s_ColorMapDiffuseUV=0
	_GDIPlus_Startup()
	$hBitmap = _GDIPlus_ImageLoadFromFile($s_File)
	_FileDelete($s_OutFile)
		$hBitmap = __Resize($hBitmap, $s_ColorMapSizeX, $s_ColorMapSizeY)
		if $s__DiffuseUV <> 0 then $hBitmap = __DiffuseUV($hBitmap, $s__DiffuseUV)
		if $s_ColorMapBlur1 > 0 and $s_ColorMapBlur2 > 0 then $hBitmap = __Blur($hBitmap, $s_ColorMapBlur1, $s_ColorMapBlur2)
	$sCLSID = _GDIPlus_EncodersGetCLSID("JPG")
	_GDIPlus_ImageSaveToFileEx($hBitmap, $s_OutFile, $sCLSID)
    _GDIPlus_ImageDispose($hBitmap)
	_GDIPlus_Shutdown()

	Return $s_ColorMapBMP
EndFunc
;~ 	$s_MacroMapBMP, $s_MacroMapFileA, $s_MacroMapFileB, $s_MacroMapMask, $s_MacroMapAutoFlipRotate=1, $s_MacroMapDiffuseUV=0, $s_MacroMapProzent=50, $s_MacroMapSizeX=4096, $s_MacroMapSizeY=4096
Func __MakeMacroMap($s__FileA, $s__FileB, $s__Mask, $s__DiffuseUV=0, $s__Prozent=50, $s__AutoFlipRotate=1, $s__SizeX=4096, $s__SizeY=4096)
	__ConsoleWrite("_Engine: __MakeMacroMap($s_File="&$s__FileA&")"&@CRLF)
	; $s__FileA = ColorMap
	; $s__FileB = Grundtextur
	; $s__Mask  = UT3 Supermask
	$s_MacroMapBMP="_MacroMap.jpg"
	$s_OutFile = $a_Path[$e_Path_Map] & $s_MapName & "\" & $s_MacroMapBMP

	$s_MacroMapFileA	= $s__FileA
	$s_MacroMapFileB	= $s__FileB
	$s_MacroMapMask		= $s__Mask
	$s_MacroMapAutoFlipRotate= $s__AutoFlipRotate
	$s_MacroMapDiffuseUV= $s__DiffuseUV
	$s_MacroMapSizeX	= $s__SizeX
	$s_MacroMapSizeY	= $s__SizeY
	if not StringInStr($s__FileA, "\", 1) then $s__FileA=$a_Path[$e_Path_Map] & $s_MapName & "\" & $s__FileA
	if not StringInStr($s__FileB, "\", 1) then $s__FileB=$a_Path[$e_Path_Texturen]& $s__FileB
	if not StringInStr($s__Mask, "\", 1) then $s__Mask=$a_Path[$e_Path_Masks]& $s__Mask

;~ 	MakroMap	-> UT3: Eine Mischung aus 2 Texturen die durch einer SuperMask vermischt wird, einmal die ColorMap und
;~ 				   eine Grundtextur
;~ 	Global $s_MacroMapBMP, $s_MacroMapSizeX=4096, $s_MacroMapSizeY=4096, $s_MacroMapFileA, $s_MacroMapFileB, $s_MacroMapMask, _
;~ 		$s_MacroMapProzent=50, $s_MacroMapAutoFlipRotate=1
;~ 	__Resize2($s_OutFile, $s_MacroMapSizeX, $s_MacroMapSizeY)
;~ 	$sCLSID = _GDIPlus_EncodersGetCLSID("JPG")
;~ 	_GDIPlus_ImageSaveToFileEx($hBitmap, $s_OutFile, $sCLSID)

	Return $s_MacroMapBMP
EndFunc
;~ 	$s_MixedMacroMapBMP, $s_MixedMacroMapFile, $s_MixedMacroMapMask, $s_MixedMacroMapTex1, $s_MixedMacroMapTex2, $s_MixedMacroMapTex3, $s_MixedMacroMapTex4, $s_MixedMacroMapAutoFlipRotate=1, $s_MixedMacroMapDiffuseUV=0, $s_MixedMacroMapProzent=50, $s_MixedMacroMapSizeX=4096, $s_MacroMixedMapSizeY=4096
Func __MakeMixedMacroMap($s__File, $s__Mask, $s__Tex1, $s__Tex2, $s__Tex3, $s__Tex4, $s__DiffuseUV=0, $s__Prozent=50, $s__AutoFlipRotate=1, $s__SizeX=4096, $s__SizeY=4096)
	__ConsoleWrite("_Engine: __MakeMixedMacroMap($s_File="&$s__File&")"&@CRLF)
	; $s__FileA = ColorMap
	; $s__Mask  = UT3 Supermask
	; $s__TexX  = Textur 1-4
	$s_MixedMacroMapBMP="_MixedMacroMap.jpg"
	$s_OutFile = $a_Path[$e_Path_Map] & $s_MapName & "\" & $s_MixedMacroMapBMP

	$s_MixedMacroMapFile	= $s__File
	$s_MixedMacroMapMask	= $s__Mask
	$s_MixedMacroMapTex1	= $s__Tex1
	$s_MixedMacroMapTex2	= $s__Tex2
	$s_MixedMacroMapTex3	= $s__Tex3
	$s_MixedMacroMapTex4	= $s__Tex4
	$s_MixedMacroMapProzent	= $s__Prozent
	$s_MixedMacroMapDiffuseUV	= $s__DiffuseUV
	$s_MixedMacroMapAutoFlipRotate	= $s__AutoFlipRotate
	$s_MixedMacroMapSizeX	= $s__SizeX
	$s_MixedMacroMapSizeY	= $s__SizeY
	if not StringInStr($s__File, "\", 1) then $s__File=$a_Path[$e_Path_Map] & $s_MapName & "\" & $s__File
	if not StringInStr($s__Mask, "\", 1) then $s__Mask=$a_Path[$e_Path_Masks]& $s__Mask
	if not StringInStr($s__Tex1, "\", 1) then $s__Tex1=$a_Path[$e_Path_Texturen]& $s__Tex1
	if not StringInStr($s__Tex2, "\", 1) then $s__Tex2=$a_Path[$e_Path_Texturen]& $s__Tex2
	if not StringInStr($s__Tex3, "\", 1) then $s__Tex3=$a_Path[$e_Path_Texturen]& $s__Tex3
	if not StringInStr($s__Tex4, "\", 1) then $s__Tex4=$a_Path[$e_Path_Texturen]& $s__Tex4

;~ 	MixedMacroMap-> UT3: Eine Mischung aus 2 Texturen die durch einer SuperMask vermischt wird, wobei eine Grundtextur aus 4
;~ 				   verschiedenen Materialtexturen besteht. Die Supermask besteht nur aus Weiß (Transparent) und Schwarz (Deckend)
;~ 				   und deren Abstufungen.
;~ 	Global $s_MixedMacroMapBMP, $s_MixedMacroMapSizeX=4096, $s_MixedMacroMapSizeY=4096, $s_MixedMacroMapAutoFlipRotate=1, _
;~ 		$s_MixedMacroMapTex1, $s_MixedMacroMapTex2, $s_MixedMacroMapTex3, $s_MixedMacroMapTex4, _
;~ 		$s_MixedMacroMapMask, $s_MixedMacroMapProzent=50
;~ 	__Resize2($s_OutFile, $s_MixedMacroMapSizeX, $s_MixedMacroMapSizeY)
;~ 	$sCLSID = _GDIPlus_EncodersGetCLSID("JPG")
;~ 	_GDIPlus_ImageSaveToFileEx($hBitmap, $s_OutFile, $sCLSID)

	Return $s_MixedMacroMapBMP
EndFunc

;~ 	$s_DetailMapBMP, $s_DetailMapFile, $s_DetailMapBlur1=0, $s_DetailMapBlur2=0, $s_DetailMapAlpha=0, $s_DetailMapInvert=0, $s_DetailMapDiffuseUV=0, $s_DetailMapAutoFlipRotate=1, $s_DetailMapSizeX=4096, $s_DetailMapSizeY=4096
Func __MakeDetailMap($s__File, $s__Blur1=0, $s__Blur2=0, $s__Alpha=0, $s__Invert=0, $s__DiffuseUV=0, $s__AutoFlipRotate=1, $s__SizeX=4096, $s__SizeY=4096)
	__ConsoleWrite("_Engine: __MakeDetailMap($s_File="&$s__File&")"&@CRLF)
	; $s_File = Single Detailmap
	$s_DetailMapBMP="_DetailMap.png"
	$s_OutFile = $a_Path[$e_Path_Map] & $s_MapName & "\" & $s_DetailMapBMP

	$s_DetailMapFile 			= $s__File
	$s_DetailMapBlur1 			= $s__Blur1
	$s_DetailMapBlur2 			= $s__Blur2
	$s_DetailMapAlpha 			= $s__Alpha
	$s_DetailMapDiffuseUV 		= $s__DiffuseUV
	$s_DetailMapInvert 			= $s__Invert
	$s_DetailMapSizeX 			= $s__SizeX
	$s_DetailMapSizeY 			= $s__SizeY
	$s_DetailMapAutoFlipRotate 	= $s__AutoFlipRotate
	if not StringInStr($s_DetailMapFile, "\", 1) then $s_DetailMapFile=$a_Path[$e_Path_Detail]&$s_DetailMapFile
	$s_OutTex = $a_Path[$e_Path_Detail] & $s_DetailMapFile
	if FileExists($s_OutTex) = 0 then FileCopy($s_DetailMapFile, $s_OutTex, 9)

;~ 	DetailMap 	-> Self: Eine einfache Detailmap - wie zuvor in Flutch...
;~ 	Global $s_DetailMapBMP, $s_DetailMapSizeX=4096, $s_DetailMapSizeY=4096, $s_DetailMapFile, $s_DetailMapAutoFlipRotate=1, _
;~ 		$s_DetailMapAlpha=0, $s_DetailMapDiffuseUV=0, $s_DetailMapInvert=0
	_GDIPlus_Startup()
	$hBitmap = _GDIPlus_ImageLoadFromFile($s_DetailMapFile)
	_FileDelete($s_OutFile)
;~ 		if $s_DetailMapAlpha > 0 then $hBitmap = __MakeAlpha($hBitmap, $s_DetailMapAlpha)
		if $s_DetailMapAutoFlipRotate = 0 then $hBitmap = __Resize($hBitmap, $s_ColorMapSizeX, $s_ColorMapSizeY)
		if $s_DetailMapAutoFlipRotate = 1 then $hBitmap = __FillAutoFlipRotate($hBitmap, $s_DetailMapSizeX, $s_DetailMapSizeY)
		if $s_DetailMapBlur1 > 0 and $s_DetailMapBlur2 > 0 then $hBitmap = __Blur($hBitmap, $s_DetailMapBlur1, $s_DetailMapBlur2)
		if $s_DetailMapInvert = 1 then $hBitmap = __Invert($hBitmap)
	$sCLSID = _GDIPlus_EncodersGetCLSID("PNG")
	_GDIPlus_ImageSaveToFileEx($hBitmap, $s_OutFile, $sCLSID)
    _GDIPlus_ImageDispose($hBitmap)
	_GDIPlus_Shutdown()

	Return $s_DetailMapBMP
EndFunc
;~ 	$s_BitplanesBMP, $s_BitplanesTex1, $s_BitplanesTex2, $s_BitplanesTex3, $s_BitplanesTex4, $s_BitplanesAlpha=0, $s_BitplanesDiffuseUV=0, $s_BitplanesInvert=0, $s_BitplanesAutoFlipRotate=1, $s_BitplanesSizeX=4096, $s_BitplanesSizeY=4096
Func __MakeBitplaneMap($s__Tex1, $s__Tex2, $s__Tex3, $s__Tex4, $s__Alpha=0, $s__DiffuseUV=0, $s__BitplanesInvert=0, $s__AutoFlipRotate=1, $s__SizeX=4096, $s__SizeY=4096)
	__ConsoleWrite("_Engine: __MakeBitplaneMap($s__Tex1="&$s__Tex1&"))"&@CRLF)
	$s_BitplanesBMP="_Bitplane.png"
	$s_OutFile = $a_Path[$e_Path_Map] & $s_MapName & "\" & $s_BitplanesBMP

	$s_BitplanesTex1			= $s__Tex1
	$s_BitplanesTex2			= $s__Tex2
	$s_BitplanesTex3			= $s__Tex3
	$s_BitplanesTex4			= $s__Tex4
	$s_BitplanesAlpha			= $s__Alpha
	$s_BitplanesDiffuseUV		= $s__DiffuseUV
	$s_BitplanesSizeX			= $s__SizeX
	$s_BitplanesSizeY			= $s__SizeY
	$s_BitplanesInvert			= $s__BitplanesInvert
	$s_BitplanesAutoFlipRotate	= $s__AutoFlipRotate

	if not StringInStr($s_BitplanesTex1, "\", 1) then $s_BitplanesTex1=$a_Path[$e_Path_Detail]&$s__Tex1
	if not StringInStr($s_BitplanesTex2, "\", 1) then $s_BitplanesTex2=$a_Path[$e_Path_Detail]&$s__Tex2
	if not StringInStr($s_BitplanesTex3, "\", 1) then $s_BitplanesTex3=$a_Path[$e_Path_Detail]&$s__Tex3
	if not StringInStr($s_BitplanesTex4, "\", 1) then $s_BitplanesTex4=$a_Path[$e_Path_Detail]&$s__Tex4
	$s_OutTex1 = $a_Path[$e_Path_Detail] & $s_BitplanesTex1
	$s_OutTex2 = $a_Path[$e_Path_Detail] & $s_BitplanesTex2
	$s_OutTex3 = $a_Path[$e_Path_Detail] & $s_BitplanesTex3
	$s_OutTex4 = $a_Path[$e_Path_Detail] & $s_BitplanesTex4
	if FileExists($s_OutTex1) = 0 then FileCopy($s_BitplanesTex1, $s_OutTex1, 9)
	if FileExists($s_OutTex2) = 0 then FileCopy($s_BitplanesTex2, $s_OutTex2, 9)
	if FileExists($s_OutTex3) = 0 then FileCopy($s_BitplanesTex3, $s_OutTex3, 9)
	if FileExists($s_OutTex4) = 0 then FileCopy($s_BitplanesTex4, $s_OutTex4, 9)

;~ 	BitplaneMap	   -> UT3: Packet aus 4 Pics wobei bei allen nur ein Farb-Kanal genommen wird (A-R-G-B) und dieses
;~ 				   anschliessend in der vorgegebenen Größe (in Randomize) anreihen.
;~ 	Global $s_BitplanesBMP, $s_BitplanesSizeX=4096, $s_BitplanesSizeY=4096, $s_BitplanesDiffuseUV=0, $s_BitplanesAutoFlipRotate=1, _
;~ 		$s_BitplanesTex1, $s_BitplanesTex2, $s_BitplanesTex3, $s_BitplanesTex4, $s_BitplanesAlpha=0, $s_BitplanesInvert=0
	_GDIPlus_Startup()
	$hBitmap1 = _GDIPlus_ImageLoadFromFile($s_BitplanesTex1)
	$hBitmap2 = _GDIPlus_ImageLoadFromFile($s_BitplanesTex2)
	$hBitmap3 = _GDIPlus_ImageLoadFromFile($s_BitplanesTex3)
	$hBitmap4 = _GDIPlus_ImageLoadFromFile($s_BitplanesTex4)
	_FileDelete($s_OutFile)
	$sCLSID = _GDIPlus_EncodersGetCLSID("PNG")
		if $s_BitplanesAutoFlipRotate = 0 then
			$hImage = __CombineBitmaps4to1($hBitmap1, $hBitmap2, $hBitmap3, $hBitmap4, $s_BitplanesAlpha)
			$hImage = __Resize($hImage, $s_DetailMapSizeX, $s_DetailMapSizeY)
		Else
			$hImage = __CombineBitmaps4to1($hBitmap1, $hBitmap2, $hBitmap3, $hBitmap4, $s_BitplanesAlpha)
;~ 			$hImage = __MosaikMix($hImage, 8, 8)
;~ 	_GDIPlus_ImageSaveToFileEx($hImage, $s_OutFile&".png", $sCLSID)
			$hImage = __FillAutoFlipRotate($hImage, $s_DetailMapSizeX, $s_DetailMapSizeY)
;~ 			$hImage = __FillAutoFlipRotate2($s_DetailMapSizeX, $s_DetailMapSizeY, $hBitmap1, $hBitmap2, $hBitmap3, $hBitmap4)
		EndIf
		if $s_BitplanesInvert = 1 then $hImage = __Invert($hImage)
;~ 		if $s_BitplanesAlpha > 0 then $hImage = __MakeAlpha($hImage, $s_BitplanesAlpha)
;~ 		$hImage = _Mosaik2($hImage, $s_DetailMapSizeX/12)
	_GDIPlus_ImageSaveToFileEx($hImage, $s_OutFile, $sCLSID)
	_GDIPlus_ImageDispose($hBitmap1)
	_GDIPlus_ImageDispose($hBitmap2)
    _GDIPlus_ImageDispose($hBitmap3)
	_GDIPlus_ImageDispose($hBitmap4)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()

	Return $s_BitplanesBMP
EndFunc

; ----------------------------------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------------------

;~ 	UE3-Like Grafik Konstructor-Unterfunktionen

Func __Blur($hBitmap, $fScale=0.2, $iInterpolationMode=2)
	__ConsoleWrite("_Engine:   __Blur($fScale="&$fScale&", $iInterpolationMode="&$iInterpolationMode&")"&@CRLF)
    Local $iW = _GDIPlus_ImageGetWidth($hBitmap)
    Local $iH = _GDIPlus_ImageGetHeight($hBitmap)
    Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND(_WinAPI_GetDesktopWindow())
    Local $hBmpSmall = _GDIPlus_BitmapCreateFromGraphics($iW, $iH, $hGraphics)
    Local $hGfxSmall = _GDIPlus_ImageGetGraphicsContext($hBmpSmall)
    _GDIPlus_GraphicsSetSmoothingMode($hGfxSmall, 2)
    Local $hBmpBig = _GDIPlus_BitmapCreateFromGraphics($iW, $iH, $hGraphics)
    Local $hGfxBig = _GDIPlus_ImageGetGraphicsContext($hBmpBig)
    _GDIPlus_GraphicsSetSmoothingMode($hGfxBig, 2)

    _GDIPlus_GraphicsScaleTransform($hGfxSmall, $fScale, $fScale)
    _GDIPlus_GraphicsSetInterpolationMode($hGfxSmall, $iInterpolationMode)
    _GDIPlus_GraphicsScaleTransform($hGfxBig, 1 / $fScale, 1 / $fScale)
    _GDIPlus_GraphicsSetInterpolationMode($hGfxBig, $iInterpolationMode)

    _GDIPlus_GraphicsDrawImage($hGfxSmall, $hBitmap, 0, 0)
    _GDIPlus_GraphicsDrawImage($hGfxBig, $hBmpSmall, 0, 0)

	_GDIPlus_ImageDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hGraphics)
    _GDIPlus_GraphicsDispose($hGfxSmall)
    _GDIPlus_BitmapDispose($hBmpSmall)
    _GDIPlus_GraphicsDispose($hGfxBig)
	Return $hBmpBig
EndFunc

Func __ASM_BitmapBnW($hBitmap, $iLight, $iBlackAndWhite=0, $iSmooth=0)
	__ConsoleWrite("_Engine:   __ASM_BitmapBnW($iLight="&$iLight&", $iBlackAndWhite="&$iBlackAndWhite&", $iSmooth="&$iSmooth&")"&@CRLF)
	; Diese Funktion habe ich mir aus dem 'Mona-Lisa-V2' Script von Seubo genommen.
	; Diese hier ist sooo schnell das eine Neu-Programmierung meinerseits keinen Sinn ergibt!
	; Hoch lebe ASSEMBLER!!
	;
	; Schwarzweiß:
	;	__ASM_BitmapBnW(@ScriptDir & "\mona-lisa.jpg", 100, 1, @ScriptDir & "\mona-lisa-sw.bmp")

	; Graustufen:						 			   %
	;	__ASM_BitmapBnW(@ScriptDir & "\mona-lisa.jpg", 90, 0, @ScriptDir & "\mona-lisa-bnw.bmp")

	Local $iTimer
	Local $iWidth, $iHeight, $hBitmapData, $Scan, $Stride, $tPixelData, $pPixelStruct

	if $iSmooth=1 then
		_GDIPlus_GraphicsSetSmoothingMode($hBitmap, 2)
	Else
		_GDIPlus_GraphicsSetSmoothingMode($hBitmap, 0)
	EndIf

	$iWidth = _GDIPlus_ImageGetWidth($hBitmap)
	$iHeight = _GDIPlus_ImageGetHeight($hBitmap)

	$hBitmapData = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $iWidth, $iHeight, BitOR($GDIP_ILMREAD, $GDIP_ILMWRITE), $GDIP_PXF32RGB)
	$Scan = DllStructGetData($hBitmapData, "Scan0")
	$Stride = DllStructGetData($hBitmapData, "Stride")
	$tPixelData = DllStructCreate("dword[" & (Abs($Stride * $iHeight)) & "]", $Scan)

	;ASM Bytecode aufrufen
	$bytecode = "0x8B7C24048B5424088B5C240CB900000000C1E202575352518B040FBA00000000BB00000000B90000000088C2C1E80888C3C1E80888C18B44240883F800772FB85555000001CB01D3F7E3C1E810BB00000000B3FFC1E30888C3C1E30888C3C1E30888C389D8595A5B5F89040FEB3B89C839C3720289D839C2720289D05089F839C3770289D839C2770289D05B01D8BBDC780000F7E3C1E810595A5B5F3B4424107213C7040FFFFFFF0083C10439D1730EE95FFFFFFFC7040F00000000EBEBC3"

	$tCodebuffer = DllStructCreate("byte[" & StringLen($bytecode) / 2 - 1 & "]") ;Speicher für den Bytecode reservieren
	DllStructSetData($tCodebuffer, 1, $bytecode) ;Bytecode in den Speicher schreiben
	$Ret = DllCall("user32.dll", "int", "CallWindowProcW", "ptr", DllStructGetPtr($tCodebuffer), "ptr", DllStructGetPtr($tPixelData), "int", $iWidth * $iHeight, "int", $iBlackAndWhite, "int", $iLight);
	If @error Then Return SetError(2)

	_GDIPlus_BitmapUnlockBits($hBitmap, $hBitmapData)
	Local $iWidth, $iHeigth, $hBitmap_New, $hBitmap_Old
	Local $hDC_Source, $hDC_Dest

	$iWidth = _GDIPlus_ImageGetWidth($hBitmap)
	$iHeigth = _GDIPlus_ImageGetHeight($hBitmap)

	$hDC_Source = _WinAPI_CreateCompatibleDC(0)
	$hBitmap_Old = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)

	_WinAPI_SelectObject($hDC_Source, $hBitmap_Old)
	_WinAPI_BitBlt($hDC_Source, 0, 0, $iWidth, $iHeigth, $hDC_Source, 0, 0, $SRCCOPY)
	_GDIPlus_BitmapDispose($hBitmap)
	_WinAPI_DeleteDC($hDC_Source)
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap_Old)
	_WinAPI_DeleteObject($hBitmap_Old)

	Return $hBitmap
EndFunc

Func __Invert($hBitmap)
	__ConsoleWrite("_Engine:   __Invert()"&@CRLF)
	Local $iWidth, $iHeight, $hBitmap_New, $hBitmap_Old, $hDC_Source, $hDC_Dest

	$iWidth = _GDIPlus_ImageGetWidth($hBitmap)
	$iHeight = _GDIPlus_ImageGetHeight($hBitmap)
	$hDC_Source = _WinAPI_CreateCompatibleDC(0)
	$hBitmap_Old = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
	_WinAPI_SelectObject($hDC_Source, $hBitmap_Old)
	_WinAPI_BitBlt($hDC_Source, 0, 0, $iWidth, $iHeight, $hDC_Source, 0, 0, $dstinvert)
	_WinAPI_DeleteDC($hDC_Source)
    _GDIPlus_BitmapDispose($hBitmap)
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap_Old)
	_WinAPI_DeleteObject($hBitmap_Old)
	Return $hBitmap
EndFunc

Func __ConvertBMP2JPG($sFileName)
	__ConsoleWrite("_Engine:   __ConvertBMP2JPG($sFileName="&$sFileName&")"&@CRLF)
	; by eukalyptus
	_GDIPlus_Startup()
	Local $tGUID = _WinAPI_GUIDFromString("{557CF401-1A04-11D3-9A73-0000F81EF32E}")
	Local $pGUID = DllStructGetPtr($tGUID)
	Local $tParams = _GDIPlus_ParamInit(1)
	Local $pParams = DllStructGetPtr($tParams)
	Local $tData = DllStructCreate("int Quality")
	DllStructSetData($tData, "Quality", 90)
	_GDIPlus_ParamAdd($tParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, DllStructGetPtr($tData))

    Local $aResult = DllCall($ghGDIPDll, "int", "GdipLoadImageFromFile", "wstr", $sFileName, "ptr*", 0)
	$aFileName = StringSplit($sFileName, "\", 1)
	if not FileExists($s_MapperBMPpath) then DirCreate($s_MapperBMPpath)
	if FileExists($sFileName) then _FileDelete($sFileName)
	$sFileName = $s_MapperBMPpath & StringTrimRight($aFileName[$aFileName[0]], 3) & "jpg"
    DllCall($ghGDIPDll, "int", "GdipSaveImageToFile", "handle", $aResult[2], "wstr", $sFileName, "ptr", $pGUID, "ptr", $pParams)
    DllCall($ghGDIPDll, "int", "GdipDisposeImage", "handle", $aResult[2])
	_GDIPlus_Shutdown()
	Return $sFileName
EndFunc

Func __Resize($hImage, $iSizeX=256, $iSizeY=256)
	__ConsoleWrite("_Engine:   __Resize($iSizeX="&$iSizeX&", $iSizeY="&$iSizeY&")"&@CRLF)
	; Resize function
    Local $sOutImage, $iW=$iSizeX, $iH=$iSizeY
    Local $hWnd, $hDC, $hBMP, $hImage1, $hGraphic, $CLSID

	$hImage1 = _GDIPlus_BitmapCreateFromScan0($iSizeX, $iSizeY)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage1)
	$iWidth = _GDIPlus_ImageGetWidth($hImage)
	$iHeight = _GDIPlus_ImageGetHeight($hImage)
	_GDIPlus_GraphicsDrawImageRectRect($hGraphic, $hImage, 0, 0, $iWidth, $iHeight, 0, 0, $iW, $iH)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_GraphicsDispose($hGraphic)
	Return $hImage1
EndFunc

Func __FillAutoFlipRotate($hImage2, $iSizeX=1024, $iSizeY=1024)
	__ConsoleWrite("_Engine:   __FillAutoFlipRotate($iSizeX="&$iSizeX&", $iSizeY="&$iSizeY&")"&@CRLF)
	Local $hImage1, $iWidth, $iHeight, $hGraphic, $hImage2Copy
	Local $hWnd, $hDC, $hBMP

	$hImage1 = _GDIPlus_BitmapCreateFromScan0($iSizeX, $iSizeY)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage1)

	$iWidth = _GDIPlus_ImageGetWidth($hImage2)
	$iHeight = _GDIPlus_ImageGetHeight($hImage2)

	Local $iRotateDegre, $iFlipDegre, $iRandom
	Local $i_FillX = int($iSizeX / $iWidth), $i_FillY = int($iSizeY / $iHeight)
	for $j = 0 to $i_FillY
		$a= $j&" / "&$i_FillY
		for $i = 0 to $i_FillX
			$hImage2Copy = _GDIPlus_BitmapCloneArea($hImage2, 0, 0, $iWidth, $iHeight, $GDIP_PXF32ARGB)
			; $__AutoFlipRotate[8]=[0,1,2,3,4,5,6,7]
			$iRandom=Random(0,UBound($__AutoFlipRotate)-1,1)
			$iFlipDegre=$__AutoFlipRotate[$iRandom]
			_ArrayDelete($__AutoFlipRotate, $iRandom)
			ReDim $__AutoFlipRotate[UBound($__AutoFlipRotate)+1]
			$__AutoFlipRotate[UBound($__AutoFlipRotate)-1]=$iFlipDegre
			_GDIPlus_ImageRotateFlip($hImage2Copy, $iFlipDegre)
			_GDIPlus_GraphicsDrawImageRect($hGraphic, $hImage2Copy, $iWidth*$i, $iHeight*$j, $iWidth, $iHeight)
			_GDIPlus_BitmapDispose($hImage2Copy)
		Next
	Next
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_ImageDispose($hImage2)
	Return $hImage1
EndFunc
Func __FillAutoFlipRotate2($iSizeX=1024, $iSizeY=1024, $hBitmap1="", $hBitmap2="", $hBitmap3="", $hBitmap4="")
	__ConsoleWrite("_Engine:   __FillAutoFlipRotate2($iSizeX="&$iSizeX&", $iSizeY="&$iSizeY&")"&@CRLF)
	Local $hImage1, $hImage2, $hImage3, $hImage4, $aBitmap[4] = [$hBitmap1, $hBitmap2, $hBitmap3, $hBitmap4]
	$hImage5 = __CombineBitmaps4to1($aBitmap[0], $aBitmap[1], $aBitmap[2], $aBitmap[3])
	$hImage1 = __MosaikMix($hImage5, 8,8)
	$hImage2 = __MosaikMix($hImage5, 4,4)
	$hImage3 = __MosaikMix($hImage5, 16,16)
	$hImage4 = __MosaikMix($hImage5, 8,8)
	Local $hImage, $iWidth, $iHeight, $hGraphic, $hImage2Copy, $aImage[4] = [$hImage1, $hImage2, $hImage3, $hImage4]
	Local $hWnd, $hDC, $hBMP

	$hImage = _GDIPlus_BitmapCreateFromScan0($iSizeX, $iSizeY)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage)

	$iWidth = _GDIPlus_ImageGetWidth($hImage1)
	$iHeight = _GDIPlus_ImageGetHeight($hImage1)

	Local $iRotateDegre, $iFlipDegre, $iRandom
	Local $i_FillX = int($iSizeX / $iWidth), $i_FillY = int($iSizeY / $iHeight)
	for $j = 0 to $i_FillY
		$a= $j&" / "&$i_FillY
		for $i = 0 to $i_FillX
			$hImageCopy = _GDIPlus_BitmapCloneArea($aImage[Random(0,3,1)], 0, 0, $iWidth, $iHeight, $GDIP_PXF32ARGB)
			; $__AutoFlipRotate[8]=[0,1,2,3,4,5,6,7]
			$iRandom=Random(0,UBound($__AutoFlipRotate)-1,1)
			$iFlipDegre=$__AutoFlipRotate[$iRandom]
			_ArrayDelete($__AutoFlipRotate, $iRandom)
			ReDim $__AutoFlipRotate[UBound($__AutoFlipRotate)+1]
			$__AutoFlipRotate[UBound($__AutoFlipRotate)-1]=$iFlipDegre
			_GDIPlus_ImageRotateFlip($hImageCopy, $iFlipDegre)
			_GDIPlus_GraphicsDrawImageRect($hGraphic, $hImageCopy, $iWidth*$i, $iHeight*$j, $iWidth, $iHeight)
			_GDIPlus_BitmapDispose($hImageCopy)
		Next
	Next
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_ImageDispose($hImage2)
	_GDIPlus_ImageDispose($hImage3)
	_GDIPlus_ImageDispose($hImage4)
	_GDIPlus_ImageDispose($hImage5)
	Return $hImage
EndFunc

Func __CombineBitmaps2to1($hBitmap1, $hBitmap2)
	__ConsoleWrite("_Engine:   __CombineBitmaps2to1()"&@CRLF)
	Return _or($hBitmap1, $hBitmap2)
EndFunc

Func __CombineBitmaps4to1($hBitmap1, $hBitmap2, $hBitmap3, $hBitmap4, $iBitplanesAlpha=0)
	; Kombiniert 4 Images zu einem neuen Image
	__ConsoleWrite("_Engine:   __CombineBitmaps4to1()"&@CRLF)
	Local $h_Bitmap[4] = [$hBitmap1, $hBitmap2, $hBitmap3, $hBitmap4], $rnd_Bitmap="0123"
	Local $hImageA, $hImageR, $hImageG, $hImageB, $hImage, $hImage1, $hImage2
	Local $BitmapData1, $BitmapData2, $BitmapData3
    Local $w = _GDIPlus_ImageGetWidth($hBitmap1), $h = _GDIPlus_ImageGetHeight($hBitmap1)
	Local $aData[$w][$h]
	$iBitplanesAlpha = (255/100) * (100-$iBitplanesAlpha)

	; Reihenfolge Setzen
	Local $tmp, $tmp2, $tmp3
	$tmp2 = StringSplit($rnd_Bitmap, "",1)
	$rnd_Bitmap = ""
	for $i = 1 to $tmp2[0]
		$a=UBound($tmp2)-1
		SRandom(Random((-1024*8),(1024*8),1))
		if $a > 1 then $tmp3 = Random(1, $a,1)
		if $a = 1 then $tmp3 = 1
		$tmp = $tmp2[$tmp3]
		_ArrayDelete($tmp2, $tmp3)
		$rnd_Bitmap &= $tmp
	Next

	; A-R-G-B Reihenfolge bestimmen
;~ 		$tmp2 = StringSplit($rnd_Bitmap, "",1)
;~ 		for $i = 1 to $tmp2[0]
;~ 			Switch (($tmp2[0]-1)-$tmp2[$i])
;~ 				Case 0 ; Alpha
;~ 					$hImageA 	= __Invert($h_Bitmap[$i-1])
;~ 					$hImageA 	= _Schwarzweiss($hImageA)
;~ 	;~ 				$hImageA 	= __MakeAlpha($hImageA, $s_BitplanesAlpha)
;~ 				Case 1 ; R
;~ 					$hImageR 	= _PlusMinus($h_Bitmap[$i-1],"0x000000","0x00FFFF")
;~ 	;~ 				$hImageR 	= __MakeAlpha($hImageR, $s_BitplanesAlpha)
;~ 				Case 2 ; G
;~ 					$hImageG 	= _PlusMinus($h_Bitmap[$i-1],"0x000000","0xFF00FF")
;~ 	;~ 				$hImageG 	= __MakeAlpha($hImageG, $s_BitplanesAlpha)
;~ 				Case 3 ; B
;~ 					$hImageB 	= _PlusMinus($h_Bitmap[$i-1],"0x000000","0xFFFF00")
;~ 	;~ 				$hImageB 	= __MakeAlpha($hImageB, $s_BitplanesAlpha)
;~ 			EndSwitch
;~ 		Next

;~ 	$hImageA 	= __Invert($h_Bitmap[0])
;~ 	$hImageA 	= _Schwarzweiss($hImageA)
	$hImageA 	= _Schwarzweiss($h_Bitmap[0])
	$hImageR 	= _PlusMinus($h_Bitmap[1],"0x000000","0x00FFFF")
	$hImageG 	= _PlusMinus($h_Bitmap[2],"0x000000","0xFF00FF")
	$hImageB 	= _PlusMinus($h_Bitmap[3],"0x000000","0xFFFF00")

	; Images Mischen
	$hImage1 	= _or($hImageR, $hImageG)
	$hImage2 	= _or($hImage1, $hImageB)

	; ARGB Vorbereiten
	$BitmapData1 	= _GDIPlus_BitmapLockBits($hImage2, 0, 0, $w, $h, $GDIP_ILMREAD, $GDIP_PXF32RGB)
	$Stride1 		= DllStructGetData($BitmapData1, "Stride")
	$Scan01 		= DllStructGetData($BitmapData1, "Scan0")
	$BitmapData2 	= _GDIPlus_BitmapLockBits($hImageA, 0, 0, $w, $h, $GDIP_ILMREAD, $GDIP_PXF32RGB)
	$Stride2 		= DllStructGetData($BitmapData2, "Stride")
	$Scan02 		= DllStructGetData($BitmapData2, "Scan0")
	; Neues ARGB Bitplane schreiben
	$hImage = _GDIPlus_BitmapCreateFromScan0($w, $h, 0, $GDIP_PXF32ARGB)
    $BitmapData3 = _GDIPlus_BitmapLockBits($hImage, 0, 0, $w, $h, $GDIP_ILMWRITE, $GDIP_PXF32ARGB)
    $Stride3 = DllStructGetData($BitmapData3, "Stride")
    $Scan03 = DllStructGetData($BitmapData3, "Scan0")
	For $row = 0 To $h - 1
		For $col = 0 To $w - 1
			; RGB Lesen
			$pixel1 	= DllStructCreate("dword", $Scan01 + $row * $Stride1 + $col * 4)
			$temp1 		= "0x" & Hex((DllStructGetData($pixel1, 1)))
			$averageRGB	= Hex(_ColorGetRed($temp1),2) & Hex(_ColorGetGreen($temp1),2) & Hex(_ColorGetBlue($temp1),2)
			; A Lesen
			$pixel2 	= DllStructCreate("dword", $Scan02 + $row * $Stride2 + $col * 4)
			$temp2 		= "0x" & Hex((DllStructGetData($pixel2, 1)))
			$averageA 	= Hex((_ColorGetRed($temp2) + _ColorGetGreen($temp2) + _ColorGetBlue($temp2)) / 3, 2)
			$averageA 	= hex(BitOR($averageA,Hex($iBitplanesAlpha,2)),2)
			$aData[$col][$row] = "0x" & $averageA & $averageRGB
			; Alles Schreiben
            $pixel3 = DllStructCreate("dword", $Scan03 + $row * $Stride3 + $col * 4)
            DllStructSetData($pixel3, 1, $aData[$col][$row])
		Next
	Next
	_GDIPlus_BitmapUnlockBits($hImage2, $BitmapData1)
	_GDIPlus_BitmapUnlockBits($hImageA, $BitmapData2)
    _GDIPlus_BitmapUnlockBits($hImage, $BitmapData3)

	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_ImageDispose($hImage2)

	Return $hImage
EndFunc

Func __MosaikMix($hBitmap, $iSizeX=8, $iSizeY=8)
	; Mischt ein Image im Mosaiksytle neu an.
	__ConsoleWrite("_Engine:   __MosaikMix($iSizeX="&$iSizeX&" $iSizeY="&$iSizeY&")"&@CRLF)
    Local $w = _GDIPlus_ImageGetWidth($hBitmap), $h = _GDIPlus_ImageGetHeight($hBitmap)
	Local $iBitmapAnzX = int($w/$iSizeX), $iBitmapAnzY = int($h/$iSizeY)
	Local $rnd_Bitmap, $hImage

	; Reihenfolge Setzen
	Local $tmp, $tmp2, $tmp3
	for $i = 1 to $iBitmapAnzY*$iBitmapAnzX
		$rnd_Bitmap &= $i & ","
	Next
	$rnd_Bitmap = StringTrimRight($rnd_Bitmap, 1)
	$tmp2 = StringSplit($rnd_Bitmap, ",",1)
	$rnd_Bitmap = ""
	for $i = 1 to $tmp2[0]
		$a=UBound($tmp2)-1
		SRandom(Random((-1024*8),(1024*8),1))
		if $a > 1 then $tmp3 = Random(1, $a,1)
		if $a = 1 then $tmp3 = 1
		$tmp = $tmp2[$tmp3]
		_ArrayDelete($tmp2, $tmp3)
		$rnd_Bitmap &= $tmp&","
	Next
	$rnd_Bitmap = StringTrimRight($rnd_Bitmap, 1)

	; Neues ARGB Bitplane schreiben
	$hImage = _GDIPlus_BitmapCreateFromScan0($w, $h, 0, $GDIP_PXF32ARGB)
	$tmp = StringSplit($rnd_Bitmap, ",",1)
	$k = 1
	for $i = 1 to $iBitmapAnzY
		for $j = 1 to $iBitmapAnzX
			Local $iPosX1, $iPosY1, $iPosX2, $iPosY2
			$iPosY1 = int($tmp[$k] / $iBitmapAnzY) * $iSizeY
			$iPosX1 = int(($tmp[$k]-($iPosY1/$iSizeY))*$iBitmapAnzY) * $iSizeX
			$iPosY2 = ($i-1) * $iSizeY
			$iPosX2 = ($j-1) * $iSizeX
			_GDIPlus_GraphicsDrawImageRectRect($hImage, $hBitmap, $iPosX1, $iPosY1, $iSizeX, $iSizeY, $iPosX2, $iPosY2, $iSizeX, $iSizeY)
			$k += 1
		Next
	Next

	_GDIPlus_ImageDispose($hBitmap)

	Return $hImage
EndFunc

Func __MakeAlpha($hImage, $iAlpha)
	__ConsoleWrite("_Engine:   __MakeAlpha($iAlpha="&$iAlpha&") - Slow!"&@CRLF)
	; ASM-Funktion....
;~ 	$iAlpha = (1/100)*(100-$iAlpha)
;~ 	Return _PlusMinus($hImage,0x000000,"0x"&Hex($iAlpha, 2)&Hex($iAlpha, 2)&Hex($iAlpha, 2))

	; Alternativ GDI
;~ 	$iW = _GDIPlus_ImageGetWidth($hImage)
;~ 	$iH = _GDIPlus_ImageGetHeight($hImage)
;~ 	$hBitmap = _GDIPlus_BitmapCreateFromScan0($iW, $iH, 0, $GDIP_PXF32ARGB)
;~ 	$iAlpha = (1/100)*$iAlpha
;~ 	$hAttribute_Alpha = _GDIPlus_ImageAttributesCreate()
;~ 	$tColorMatrix = _GDIPlus_ColorMatrixCreateTranslate(0, 0, 0, 0-$iAlpha) ;set alpha channel value
;~ 	$pColorMatrix = DllStructGetPtr($tColorMatrix)
;~ 	_GDIPlus_ImageAttributesSetColorMatrix($hAttribute_Alpha, 0, True, $pColorMatrix)
;~     _GDIPlus_GraphicsDrawImageRectRectIA($hBitmap, $hImage, 0, 0, $iW, $iH, 0, 0, $iW, $iH, $hAttribute_Alpha)
;~     _GDIPlus_ImageAttributesDispose($hAttribute_Alpha)
;~ 	_GDIPlus_ImageDispose($hImage)
;~ 	Return $hBitmap

	; GDI Func
    Local $w = _GDIPlus_ImageGetWidth($hImage), $h = _GDIPlus_ImageGetHeight($hImage)
	Local $aData[$w][$h]
    Local $BitmapData, $BitmapData2
	$iAlpha = (255/100)*(100-$iAlpha)
	$BitmapData = _GDIPlus_BitmapLockBits($hImage, 0, 0, $w, $h, $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	$Stride 	= DllStructGetData($BitmapData, "Stride")
	$Scan0 		= DllStructGetData($BitmapData, "Scan0")
	$hImage2 = _GDIPlus_BitmapCreateFromScan0($w, $h, 0, $GDIP_PXF32ARGB)
    $BitmapData2 = _GDIPlus_BitmapLockBits($hImage2, 0, 0, $w, $h, $GDIP_ILMWRITE, $GDIP_PXF32ARGB)
    $Stride2 = DllStructGetData($BitmapData, "Stride")
    $Scan02 = DllStructGetData($BitmapData, "Scan0")
	For $row = 0 To $h - 1
		For $col = 0 To $w - 1
			$pixel = DllStructCreate("dword", $Scan0 + $row * $Stride + $col * 4)
			$temp = "0x" & Hex((DllStructGetData($pixel, 1)))
			$RGB = Hex(_ColorGetRed($temp), 2) & Hex(_ColorGetGreen($temp), 2) & Hex(_ColorGetBlue($temp), 2)
			$A = StringMid($temp, 3,2)
			$aData[$col][$row] = "0x" & hex(BitOR($iAlpha,$A),2) & $RGB

            $pixel2 = DllStructCreate("dword", $Scan02 + $row * $Stride2 + $col * 4)
            DllStructSetData($pixel2, 1, $aData[$col][$row])
		Next
	Next
	_GDIPlus_BitmapUnlockBits($hImage, $BitmapData)
    _GDIPlus_BitmapUnlockBits($hImage2, $BitmapData2)

	Return $hImage2
EndFunc

Func __DiffuseUV($sFileName, $iDiffuseUV)
	__ConsoleWrite("_Engine:   __DiffuseUV($sFileName="&$sFileName&", $iDiffuseUV="&$iDiffuseUV&")"&@CRLF)
	; Platzhalter
	Return $sFileName
EndFunc

Func _FileDelete($sFileName)
	FileDelete($sFileName)
	Do
		Sleep(1)
	Until FileExists($sFileName) = 0
EndFunc

#EndRegion -Unterfunktionen 2-------------------------------------------------------------------------------------------------------

