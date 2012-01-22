#include-once

#cs ================================================================================================================================
==== ChangeLog =====================================================================================================================
====================================================================================================================================

 AutoIt Version: 	3.3.7.23 (beta)
 Skript:			_Const.au3
 Author:         	Techmix

##	--------------------------------------------------------------------------------------------------------------------------------

	Global & Const

	Ausgelagerte Globale Deklarationen

##	================================================================================================================================
#ce

#Region -Main-Variablen-------------------------------------------------------------------------------------------------------------

; Main Globals
Global $sys_IsPressed_dll = DllOpen("user32.dll")

; Camera Data
Global $i_MaxCams=4
Enum $e_Cam_Mesh, $e_Cam_Node, $e_Cam_Entfernung, $e_Cam_Position, $e_Cam_Collision, $e_Cam_Last
Global $a_Camera[$i_MaxCams][$e_Cam_Last]

; Light Data
Global $i_MaxLights=64
Global $a_Light[$i_MaxLights]

; System Data
Enum $e_Sys_GameName, $e_Sys_GameVersion, $e_Sys_GameDebug, $e_Sys_ShowPanel, $e_Sys_Fullscreen, $e_Sys_ScreenWidth, $e_Sys_ScreenHeight, _
	$e_Sys_DeviceType, $e_Sys_Use32Bit, $e_Sys_Shadows, $e_Sys_VSync, $e_Sys_DoubleBuffer, $e_Sys_Antialias, $e_Sys_HighPrecisionFpu, $e_Sys_ExtendedShaders, _
	$e_Sys_FontSmall, $e_Sys_FontBig, $e_Sys_MoveTyp, $e_Sys_Last
Global $a_System[$e_Sys_Last]

; Path Data
Enum $e_Path_Main, $e_Path_Map, $e_Path_Mesh, $e_Path_Item, $e_Path_Sky, $e_Path_Hud, $e_Path_Vid, $e_Path_Gfx, $e_Path_Font, _
	$e_Path_Detail, $e_Path_Texturen, $e_Path_Masks, $e_Path_Data, $e_Path_Script, $e_Path_Last
Global $a_Path[$e_Path_Last]

; Player Data
Global $i_MaxPlayer=8
Enum $e_Player_Name, $e_Player_Path, $e_Player_Position, $e_Player_Rotation, $e_Player_Energie, $e_Player_Staerke, $e_Player_Sprung, $e_Player_Geschwindigkeit, $e_Player_Animation, $e_Player_Scale, _
	$e_Player_Mesh, $e_Player_Node, $e_Player_Tex0, $e_Player_Tex1, $e_Player_Collision, $e_Player_Last
Global $a_PlayerData[$i_MaxPlayer][$e_Player_Last]

; Item Data
Global $i_MaxItem=256
Enum $e_Item_Name, $e_Item_Path, $e_Item_Position, $e_Item_Rotation, $e_Item_Data, _
	$e_Item_Mesh, $e_Item_Node, $e_Item_Tex0, $e_Item_Tex1, $e_Item_Collision, $e_Item_Last
Global $a_ItemData[$i_MaxItem][$e_Item_Last]

; Objekt Data
Global $i_MaxObjekt=256
Enum $e_Objekt_Name, $e_Objekt_Path, $e_Objekt_Position, $e_Objekt_Rotation, $e_Objekt_Data, _
	$e_Objekt_Mesh, $e_Objekt_Node, $e_Objekt_Tex0, $e_Objekt_Tex1, $e_Objekt_Collision, $e_Objekt_Last
Global $a_ObjektData[$i_MaxObjekt][$e_Objekt_Last]

; Map Data
Enum $e_Map_Name, $e_Map_File, _
	$e_Map_Mesh, $e_Map_Node, $e_Map_ColorMap, $e_Map_HightMap, $e_Map_DetailMap, $e_Map_VerticiesMap, $e_Map_Collision, $e_Map_CollisionAnimator, _
	$e_Map_Sky, $e_Map_SkyTex0, $e_Map_SkyTex1, $e_Map_SkyTex2, $e_Map_SkyTex3, $e_Map_SkyTex4, $e_Map_SkyTex5, $e_Map_Last
Global $a_MapData[$e_Map_Last]

; Spezial FX
Enum $e_SmokeParticles, $e_SmokeParticlesSettings, $e_SmokeEmitter, $e_SmokeLast
Global $a_SfxPartikel[$e_SmokeLast]

; Hud Data
Global $irr_HUD_Energy=0, $irr_HUD_Armour=0, $irr_HUD_Ammu=0
Global $irr_HUDfile_Energy[4], $irr_HUDfile_Armour[4], $irr_HUDfile_Ammu[4], $irr_HUDfile_Digits[10], _
	$irr_HUDtex_Energy[4], $irr_HUDtex_Armour[4], $irr_HUDtex_Ammu[4], $irr_HUDtex_Digits[10], _
	$irr_HUDsprite_Energy[4], $irr_HUDsprite_Armour[4], $irr_HUDsprite_Ammu[4], $irr_HUDsprite_Digits[10]

; Mapper Globals
Global $s_MakeAllMaps=0,$a_MapConfigFile[1][2], $a_Startpoints[1][2]
Global $s_MapperBMPpath=@ScriptDir&"\data\maps\TempPics\", $s_MapConfig, $s_BaseMap, $s_MapName="Mapper", $s_ScaleXY=1, $s_ScaleZ=1, $s_ScaleD=1, $s_SkyBox="3impact"
Global $s_HightMapBMP, $s_HightMapBlur1=0.12, $s_HightMapBlur2=3, $s_HightMapInvert=0, $s_HightMapSizeX=256, $s_HightMapSizeY=256
Global $s_NormalMapBMP, $s_NormalMapFileA, $s_NormalMapFileB="", $s_NormalMapIntense=5, $s_NormalMapProzent=50, $s_NormalMapSizeX=4096, $s_NormalMapSizeY=4096
Global $s_MixedMapBMP, $s_MixedMapFileA, $s_MixedMapFileB, $s_MixedMapMask, $s_MixedMapIntense=5, $s_MixedMapProzent=50, $s_MixedMapSizeX=4096, $s_MixedMapSizeY=4096
Global $s_ColorMapBMP, $s_ColorMapBlur1=0.60, $s_ColorMapBlur2=2, $s_ColorMapDiffuseUV=0, $s_ColorMapSizeX=4096, $s_ColorMapSizeY=4096
Global $s_MacroMapBMP, $s_MacroMapFileA, $s_MacroMapFileB, $s_MacroMapMask, $s_MacroMapAutoFlipRotate=1, $s_MacroMapDiffuseUV=0, $s_MacroMapProzent=50, $s_MacroMapSizeX=4096, $s_MacroMapSizeY=4096
Global $s_MixedMacroMapBMP, $s_MixedMacroMapFile, $s_MixedMacroMapMask, $s_MixedMacroMapTex1, $s_MixedMacroMapTex2, $s_MixedMacroMapTex3, $s_MixedMacroMapTex4, $s_MixedMacroMapAutoFlipRotate=1, $s_MixedMacroMapDiffuseUV=0, $s_MixedMacroMapProzent=50, $s_MixedMacroMapSizeX=4096, $s_MixedMacroMapSizeY=4096
Global $s_DetailMapBMP, $s_DetailMapFile, $s_DetailMapBlur1=0, $s_DetailMapBlur2=0, $s_DetailMapAlpha=0, $s_DetailMapInvert=0, $s_DetailMapDiffuseUV=0, $s_DetailMapAutoFlipRotate=1, $s_DetailMapSizeX=4096, $s_DetailMapSizeY=4096
Global $s_BitplanesBMP, $s_BitplanesTex1, $s_BitplanesTex2, $s_BitplanesTex3, $s_BitplanesTex4, $s_BitplanesAlpha=0, $s_BitplanesDiffuseUV=0, $s_BitplanesAutoFlipRotate=1, $s_BitplanesSizeX=4096, $s_BitplanesSizeY=4096,$s_BitplanesInvert=0

;~ ; Mapper Globals
;~ Global $a_MapConfigFile[1][2], $a_Startpoints[1][2], $s_MapConfig, $s_MapperBMPpath=@ScriptDir&"\data\maps\TempPics\", _
;~ 	$s_BaseMap, $s_MapName="Mapper", $s_ScaleXY=1, $s_ScaleZ=1, $s_ScaleD=1, $s_SkyBox="3impact"
;~ ; HightMap
;~ Global $s_HightMapBMP, $s_HightMapBlur1=0.12, $s_HightMapBlur2=3, $s_HightMapInvert=0, $s_HightMapSizeX=256, $s_HightMapSizeY=256
;~ Global $s_NormalMapBMP, $s_NormalMapSizeX=4096, $s_NormalMapSizeY=4096, $s_NormalMapIntense=8, $s_NormalMapScale=1, _
;~ 	$s_NormalMapFileA, $s_NormalMapFileB, $s_NormalMapAProzent=50, $s_NormalMapBProzent=50
;~ Global $s_MixedMapBMP, $s_MixedMapSizeX=4096, $s_MixedMapSizeY=4096, $s_MixedMapFileA, $s_MixedMapFileB, $s_MixedMapProzent=50
;~ ; ColorMap
;~ Global $s_ColorMapBMP, $s_ColorMapSizeX=4096, $s_ColorMapSizeY=4096, $s_ColorMapBlur1=0.60, $s_ColorMapBlur2=2, _
;~ 	$s_ColorMapDiffuseUV=0
;~ Global $s_MacroMapBMP, $s_MacroMapSizeX=4096, $s_MacroMapSizeY=4096, $s_MacroMapFileA, $s_MacroMapFileB, $s_MacroMapMask, _
;~ 	$s_MacroMapProzent=50, $s_MacroMapAutoFlipRotate=1
;~ Global $s_MixedMacroMapBMP, $s_MixedMacroMapSizeX=4096, $s_MixedMacroMapSizeY=4096, $s_MixedMacroMapAutoFlipRotate=1, _
;~ 	$s_MixedMacroMapTex1, $s_MixedMacroMapTex2, $s_MixedMacroMapTex3, $s_MixedMacroMapTex4, _
;~ 	$s_MixedMacroMapMask, $s_MixedMacroMapProzent=50
;~ ; DetailMap
;~ Global $s_DetailMapBMP, $s_DetailMapSizeX=4096, $s_DetailMapSizeY=4096, $s_DetailMapFile, $s_DetailMapAutoFlipRotate=1, _
;~ 	$s_DetailMapAlpha=0, $s_DetailMapDiffuseUV=0, $s_DetailMapInvert=0
;~ Global $s_BitplanesBMP, $s_BitplanesSizeX=4096, $s_BitplanesSizeY=4096, $s_BitplanesDiffuseUV=0, $s_BitplanesAutoFlipRotate=1, _
;~ 	$s_BitplanesTex1, $s_BitplanesTex2, $s_BitplanesTex3, $s_BitplanesTex4, $s_BitplanesAlpha=0, $s_BitplanesInvert=0



#EndRegion -Main-Variablen----------------------------------------------------------------------------------------------------------


#Region -Unterfunktionen------------------------------------------------------------------------------------------------------------

Func __ArrayMath($a_ArrayA, $a_ArrayB, $s_Opperator="=")
	if UBound($a_ArrayA, 0) = 1 Then
		; 1D Array
		Local $i_Len, $i_LenA=UBound($a_ArrayA)-1, $i_LenB=UBound($a_ArrayB)-1
		if $i_LenA <= $i_LenB then
			$i_Len = $i_LenA
		Else
			$i_Len = $i_LenB
		EndIf

		for $i = 0 to $i_Len
			Switch $s_Opperator
				Case "+"
					$a_ArrayA[$i] += $a_ArrayB[$i]
				Case "-"
					$a_ArrayA[$i] -= $a_ArrayB[$i]
				Case "*"
					$a_ArrayA[$i] *= $a_ArrayB[$i]
				Case "/"
					$a_ArrayA[$i] /= $a_ArrayB[$i]
				Case "&"
					$a_ArrayA[$i] &= $a_ArrayB[$i]
				Case "="
					$a_ArrayA[$i] = $a_ArrayB[$i]
			EndSwitch
		Next

	elseif UBound($a_ArrayA, 0) = 2 and UBound($a_ArrayB, 0) = 2 Then
		; 2D Array
		Local $i_Len1, $i_Len2, $i_LenA1=UBound($a_ArrayA, 1)-1, $i_LenA2=UBound($a_ArrayA, 2)-1, _
			$i_LenB1=UBound($a_ArrayB,1)-1, $i_LenB2=UBound($a_ArrayB,2)-1

		if $i_LenA1 <= $i_LenB1 then
			$i_Len1 = $i_LenA1
		Else
			$i_Len1 = $i_LenB1
		EndIf

		if $i_LenA2 <= $i_LenB2 then
			$i_Len2 = $i_LenA2
		Else
			$i_Len2 = $i_LenB2
		EndIf

		for $i = 0 to $i_Len1
			for $j = 0 to $i_Len2
				Switch $s_Opperator
					Case "+"
						$a_ArrayA[$i][$j] += $a_ArrayB[$i][$j]
					Case "-"
						$a_ArrayA[$i][$j] -= $a_ArrayB[$i][$j]
					Case "*"
						$a_ArrayA[$i][$j] *= $a_ArrayB[$i][$j]
					Case "/"
						$a_ArrayA[$i][$j] /= $a_ArrayB[$i][$j]
					Case "&"
						$a_ArrayA[$i][$j] &= $a_ArrayB[$i][$j]
					Case "="
						$a_ArrayA[$i][$j] = $a_ArrayB[$i][$j]
				EndSwitch
			Next
		Next

	EndIf

	Return $a_ArrayA
EndFunc
Func __ConsoleWrite($s_Txt)
	if $a_System[$e_Sys_GameDebug] = 1 then ConsoleWrite($s_Txt)
EndFunc

#EndRegion -Unterfunktionen---------------------------------------------------------------------------------------------------------
