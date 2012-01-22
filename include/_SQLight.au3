#include "_Const.au3"
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <String.au3>
#include-once
#RequireAdmin


#cs ================================================================================================================================
==== ChangeLog =====================================================================================================================
====================================================================================================================================

 AutoIt Version: 	3.3.7.23 (beta)
 Skript:			_SQLight.au3
 Author:         	Techmix

##	--------------------------------------------------------------------------------------------------------------------------------

	SQLight Datenmanagement

	Ausgelagerte Daten-Funktionen


##	--------------------------------------------------------------------------------------------------------------------------------

		V0.22:
	Grundfunktionen für den Mapper erweitert

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.21:
	DeBug: _GettingData()
	DeBug: _SettingData()
	DeBug: __GettingID()
	Grundfunktionen um __GettingColNames() erweitert

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.20:
	Grundfunktionen erweitert
	SQL-Struktur erweitert

##	--------------------------------------------------------------------------------------------------------------------------------

		V0.10:
	Grundfunktionen erstellt
	SQL-Struktur erstellt

##	================================================================================================================================
#ce

#Region -UDF-Variablen--------------------------------------------------------------------------------------------------------------

Global $s_Path_SQLFile = @ScriptDir & "\data\game\Game.db"
_SQLite_Startup()
if FileExists($s_Path_SQLFile) then _SQLite_Open($s_Path_SQLFile)


#EndRegion -UDF-Variablen-----------------------------------------------------------------------------------------------------------


#Region -Hauptfunktionen-------------------------------------------------------------------------------------------------------------

Func _GettingData($_ID="", $_EntNr="", $_RetArray=0)
	Local $_section = __GettingSection($_ID)
	if $_ID="" and $_section = "" then
		; New SQLight.db
		_SQLite_Close()
;~ 		if not FileExists($s_Path_SQLFile) then __MakeNewSQL()
		_SQLite_Open($s_Path_SQLFile)
		Return
	EndIf

	if $_RetArray=1 then
		; Normal Table (Array)
		Local $aResult, $iRows, $iColumns, $iRval
		$_SQLite_GetTable2d = "SELECT * FROM '"&$_section&"';"
		$iRval = _SQLite_GetTable2d(-1, $_SQLite_GetTable2d, $aResult, $iRows, $iColumns, -1, False)
		If $iRval = $SQLITE_OK Then
			if $_EntNr <> "" Then
				Local $aResult2[UBound($aResult, 2)]
				if IsNumber($_EntNr) Then
					for $i = 0 to UBound($aResult2)-1
						$aResult2[$i] = $aResult[$_EntNr][$i]
					Next
					Return $aResult2
				Else
					$a=_ArraySearch($aResult, $_EntNr)
					for $i = 0 to UBound($aResult,1)-1
						for $j = 0 to UBound($aResult,2)-1
							if $aResult[$i][$j] = $_EntNr then ExitLoop 2
						Next
					Next
					for $j = 0 to UBound($aResult,2)-1
						$aResult2[$j] = $aResult[$i][$j]
					Next
					__ConsoleWrite("_SQLight: _GettingData: "&$_ID&" = "&$aResult2&@CRLF)
					Return $aResult2
				EndIf
			EndIf

			__ConsoleWrite("_SQLight: _GettingData: "&$_ID&", (Array)"&@CRLF)
			Return $aResult
		EndIf

	Else
		; Normal Table
		dim $hQuery, $aNames, $aRow
		$_SQLite_Query = "SELECT * FROM '"&$_section&"' ORDER BY '"&$_ID&"';"
		_SQLite_Query(-1, $_SQLite_Query, $hQuery)
		While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK
			if $aRow[0] = $_ID then ExitLoop
		WEnd
		_SQLite_QueryFinalize($hQuery)
		if $_RetArray=0 and $aRow[0] = $_ID Then
			Return $aRow[1]
		EndIf

		if $_EntNr <> "" then
			; List Table
			Local $aResult, $iRows, $iColumns, $iRval
			$_SQLite_GetTable2d = "SELECT * FROM '"&$_section&"';"
			$iRval = _SQLite_GetTable2d(-1, $_SQLite_GetTable2d, $aResult, $iRows, $iColumns, -1, False)
			If $iRval = $SQLITE_OK Then
				if $_RetArray=0 Then
					if IsNumber($_EntNr) Then
						; Array
						for $i_Data = 0 to UBound($aResult,1)-1
							if $aResult[0][$i_Data] = $_ID then ExitLoop
						Next
						Return $aResult[$_EntNr][$i_Data]
					Else
						for $i_Data = 0 to UBound($aResult,2)-1
							if $aResult[0][$i_Data] = $_ID then ExitLoop
						Next
						for $i = 0 to UBound($aResult,1)-1
							for $j = 0 to UBound($aResult,2)-1
								if $aResult[$i][$j] = $_EntNr then ExitLoop 2
							Next
						Next
						$_EntNr = $i
						if UBound($aResult,1) <= $_EntNr then Return False
						__ConsoleWrite("_SQLight: _GettingData: "&$_ID&" = "&$aResult[$_EntNr][$i_Data]&@CRLF)
						Return $aResult[$_EntNr][$i_Data]

					EndIf
				Elseif $_RetArray=1 Then
					; Data
					__ConsoleWrite("_SQLight: _GettingData: "&$_ID&" (Array)"&@CRLF)
					Return $aResult
				EndIf
			EndIf
		EndIf
	EndIf

	Return False
EndFunc
Func _SettingData($_ID="", $_Data="", $_EntNr=0)
	Local $_SQLite_Exec, $_section = __GettingSection($_ID)
	Local $a_SQLData	= _GettingData($_ID, "", 1)
	Local $sSearch, $a_ColNames, $s_Values
	; Normal Table
	if IsArray($_Data) Then
		__ConsoleWrite("_SQLight: _SettingData: "&$_ID&", (Array)"&@CRLF)
		$sSearch		= _ArraySearch($a_SQLData, $_Data[0])
		$a_ColNames 	= __GettingColNames($_ID)

		if $sSearch = -1 then
			for $i = 0 to UBound($_Data)-1
				$s_Values &= "'"&$_Data[$i]&"', "
			Next
			$s_Values = StringTrimRight($s_Values, 2)
			$_SQLite_Exec = "INSERT INTO '"&$_section&"' VALUES ("&$s_Values&");"
			_SQLite_Exec(-1, $_SQLite_Exec)
			Return True
		Else
			for $i = 0 to UBound($_Data)-1
				$s_Values &= "'"&$a_ColNames[$i]&"', "
			Next
			$s_Values = StringTrimRight($s_Values, 2)
			for $i = 0 to UBound($_Data)-1
				$_SQLite_Exec = "UPDATE '"&$_section&"' SET '"&$a_ColNames[$i]&"' = '"&$_Data[$i]&"' WHERE rowid = "&$sSearch&";"
				_SQLite_Exec(-1, $_SQLite_Exec)
			Next
			Return True
		EndIf

	Else
		$sSearch		= __GettingID($_ID)
		__ConsoleWrite("_SQLight: _SettingData: "&$_ID&", "&$_Data&@CRLF)

		if $sSearch = -1 then
			$_SQLite_Exec = "INSERT INTO '"&$_section&"' VALUES ('"&$_ID&"', '"&$_Data&"');"
			_SQLite_Exec(-1, $_SQLite_Exec)
			Return True
		Else
			$_SQLite_Exec = "UPDATE '"&$_section&"' SET Data = '"&$_Data&"' WHERE rowid = "&$sSearch&";"
			_SQLite_Exec(-1, $_SQLite_Exec)
			Return True
		EndIf
	EndIf


	Return False
EndFunc
#EndRegion -Hauptfunktionen----------------------------------------------------------------------------------------------------------


#Region -Unterfunktionen------------------------------------------------------------------------------------------------------------

Func __GettingID($_key="")
	__ConsoleWrite("_SQLight: __GettingID($_key="&$_key&")"&@CRLF)
	Local $_section=__GettingSection($_key), $_zero="ID"

	; Normal Table
	dim $hQuery, $aRow, $i=1
	$_SQLite_Query = "SELECT * FROM '"&$_section&"' ORDER BY '"&$_key&"';"
	_SQLite_Query(-1, $_SQLite_Query, $hQuery)
	While _SQLite_FetchData ($hQuery, $aRow, False, False) = $SQLITE_OK
		if $aRow[0] = $_key then ExitLoop
		$i+=1
	WEnd
	_SQLite_QueryFinalize($hQuery)
	if $aRow[0] = $_key then
		Return $i
	EndIf

	; List Table
	Local $aResult, $iRows, $iColumns, $iRval
	$_SQLite_GetTable2d = "SELECT * FROM '"&$_section&"';"
	$iRval = _SQLite_GetTable2d(-1, $_SQLite_GetTable2d, $aResult, $iRows, $iColumns, -1, False)
	If $iRval = $SQLITE_OK Then
		; Array
		for $i_Data = 0 to UBound($aResult,2)-1
			if $aResult[0][$i_Data] = $_key then ExitLoop
		Next
		Return $i_Data
	EndIf

	Return False
EndFunc
Func __GettingColNames($_key="")
	__ConsoleWrite("_SQLight: __GettingColNames($_key="&$_key&")"&@CRLF)
	Local $_section=__GettingSection($_key), $a_Return[1]

	; List Table
	Local $aResult, $iRows, $iColumns, $iRval
	$_SQLite_GetTable2d = "SELECT * FROM '"&$_section&"';"
	$iRval = _SQLite_GetTable2d(-1, $_SQLite_GetTable2d, $aResult, $iRows, $iColumns, -1, False)
	If $iRval = $SQLITE_OK Then
		; Array
		for $i_Data = 0 to UBound($aResult,2)-1
			ReDim $a_Return[$i_Data+1]
			$a_Return[$i_Data] &= $aResult[0][$i_Data]
		Next
		Return $a_Return
	EndIf

	Return False
EndFunc
Func __GettingSection($_ID)
	Local $_section
	if StringInStr($_ID, "$e_", 1) Then
		; Section finder
		if StringInStr($_ID, "Player_", 1) Then
			$_section = "a_PlayerData"
		elseif StringInStr($_ID, "Sys_", 1) Then
			$_section = "a_System"
		elseif StringInStr($_ID, "Path_", 1) Then
			$_section = "a_Path"
		elseif StringInStr($_ID, "Map_", 1) Then
			$_section = "a_MapData"
		elseif StringInStr($_ID, "Item_", 1) Then
			$_section = "a_ItemData"
		EndIf
	EndIf
	Return $_section
EndFunc
Func __MakeNewSQL()
	Local $_SQLdata=""
	__ConsoleWrite("_SQLight: _MakeNewSQL: "&$s_Path_SQLFile&@CRLF)
	_SQLite_Close()
	_SQLite_Open($s_Path_SQLFile)

;~ ; System Data
;~ Enum $e_Sys_GameName, $e_Sys_GameVersion, $e_Sys_GameDebug, $e_Sys_ShowPanel, $e_Sys_Fullscreen, $e_Sys_ScreenWidth, $e_Sys_ScreenHeight, $e_Sys_DeviceType, $e_Sys_Use32Bit, $e_Sys_Shadows, $e_Sys_VSync, $e_Sys_DoubleBuffer, $e_Sys_Antialias, $e_Sys_HighPrecisionFpu, $e_Sys_ExtendedShaders, $e_Sys_Last
	$_SQLdata&="" & _
		"CREATE TABLE IF NOT EXISTS 'a_System' (" & _
		"'ID','Data'" & _
		");" & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_GameName', 			'Flutch - Erobert die Welt'); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_GameVersion', 		''); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_GameDebug', 		'1'); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_ShowPanel', 		'1'); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_Fullscreen', 		''); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_ScreenWidth', 		''); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_ScreenHeight', 		''); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_DeviceType', 		''); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_Use32Bit', 			''); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_Shadows', 			''); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_VSync', 			''); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_DoubleBuffer', 		''); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_Antialias', 		''); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_HighPrecisionFpu',	''); " & _
		"INSERT INTO 'a_System' VALUES ('$e_Sys_ExtendedShaders', 	''); "

;~ ; Path Data
;~ Enum $e_Path_Main, $e_Path_Map, $e_Path_Mesh, $e_Path_Item, $e_Path_Sky, $e_Path_Hud, $e_Path_Vid, $e_Path_Gfx, $e_Path_Font, $e_Path_Detail, $e_Path_Texturen, $e_Path_Masks, $e_Path_Data, $e_Path_Script, $e_Path_Last
	$_SQLdata&="" & _
		"CREATE TABLE IF NOT EXISTS 'a_Path' (" & _
		"'ID','Data'" & _
		");" & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Main', 		''); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Map', 		'\data\maps\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Mesh', 		'\data\meshes\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Item', 		'\data\item\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Sky', 		'\data\skyboxes\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Hud', 		'\data\hud\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Vid', 		'\data\vids\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Gfx', 		'\data\grafix\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Font', 		'\data\fonts\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Detail', 	'\data\grafix\Detail\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Texturen',	'\data\grafix\Texturen\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Masks', 		'\data\grafix\Masks\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Data', 		'\data\game\'); " & _
		"INSERT INTO 'a_Path' VALUES ('$e_Path_Script', 	'\data\game\scripte\'); "

;~ ; Player Data
;~ Enum $e_Player_Name, $e_Player_Path, $e_Player_Position, $e_Player_Rotation, $e_Player_Energie, $e_Player_Staerke, $e_Player_Sprung, $e_Player_Geschwindigkeit, $e_Player_Animation,
	$_SQLdata&="" & _
		"CREATE TABLE IF NOT EXISTS 'a_PlayerData' (" & _
		"'$e_Player_Name','$e_Player_Path','$e_Player_Position','$e_Player_Rotation','$e_Player_Energie','$e_Player_Staerke','$e_Player_Sprung','$e_Player_Geschwindigkeit','$e_Player_Animation','$e_Player_Scale'" & _
		");" & _
		"INSERT INTO 'a_PlayerData' VALUES ('Green','flutch_grn','100:0:100','0:0:0','8:8','4','6','5','0','0.3'); " & _
		"INSERT INTO 'a_PlayerData' VALUES ('Yellow','flutch_geb','100:0:100','0:0:0','6:6','2','8','8','0','0.25'); " & _
		"INSERT INTO 'a_PlayerData' VALUES ('Red','flutch_red','100:0:100','0:0:0','10:10','8','4','3','0','0.35'); "

;~ ; Map Data
;~ Enum $e_Map_Name, $e_Map_File, $e_Map_Mesh, $e_Map_Node, $e_Map_Tex0, $e_Map_Tex1, $e_Map_Collision, $e_Map_Sky, $e_Map_Last
	$_SQLdata&="" & _
		"CREATE TABLE IF NOT EXISTS 'a_MapData' (" & _
		"'$e_Map_Name','$e_Map_File'" & _
		");" & _
		"INSERT INTO 'a_MapData' VALUES ('WorldMap','WorldMap.map'); " & _
		"INSERT INTO 'a_MapData' VALUES ('TitleMap','TitleMap.map'); " & _
		"INSERT INTO 'a_MapData' VALUES ('PlanetenOberfläche','PlanetenOberfläche.map'); "

;~ ; Item Data
;~ Enum $e_Item_Name, $e_Item_Path, $e_Item_Position, $e_Item_Rotation, $e_Item_Data, $e_Item_Mesh, $e_Item_Node, $e_Item_Tex0, $e_Item_Tex1, $e_Item_Collision, $e_Item_Last
	$_SQLdata&="" & _
		"CREATE TABLE IF NOT EXISTS 'a_ItemData' (" & _
		"'$e_Item_Name','$e_Item_Path','$e_Item_Position','$e_Item_Rotation','$e_Item_Data'" & _
		");" & _
		"INSERT INTO 'a_ItemData' VALUES ('TestItem','1','0;0;2','0;0;0',';'); "

	_SQLite_Exec(-1,$_SQLdata)
EndFunc

Func __BaseDBData($sPath=@ScriptDir)
	_GettingData() ; StartUp

	; Getting SQLight
	$a_Path[$e_Path_Main] 		= _PathFull($sPath)
	$a_Path[$e_Path_Script] 	= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Script")
	$a_Path[$e_Path_Map] 		= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Map")
	$a_Path[$e_Path_Mesh] 		= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Mesh")
	$a_Path[$e_Path_Item]		= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Item")
	$a_Path[$e_Path_Hud]		= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Hud")
	$a_Path[$e_Path_Sky]		= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Sky")
	$a_Path[$e_Path_Font]		= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Font")
	$a_Path[$e_Path_Vid]		= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Vid")
	$a_Path[$e_Path_Gfx]		= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Gfx")
	$a_Path[$e_Path_Detail]		= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Detail")
	$a_Path[$e_Path_Texturen]	= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Texturen")
	$a_Path[$e_Path_Masks]		= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Masks")
	$a_Path[$e_Path_Data]		= $a_Path[$e_Path_Main] & _GettingData("$e_Path_Data")

	$a_System[$e_Sys_GameDebug]			= _GettingData("$e_Sys_GameDebug")
	$a_System[$e_Sys_GameName]			= _GettingData("$e_Sys_GameName")
	$a_System[$e_Sys_GameVersion]		= "V0.06"
	$a_System[$e_Sys_ShowPanel]			= _GettingData("$e_Sys_ShowPanel")
	$a_System[$e_Sys_Fullscreen]		= _GettingData("$e_Sys_Fullscreen")
	$a_System[$e_Sys_ScreenWidth]		= _GettingData("$e_Sys_ScreenWidth")
	$a_System[$e_Sys_ScreenHeight]		= _GettingData("$e_Sys_ScreenHeight")
	$a_System[$e_Sys_Use32Bit]			= _GettingData("$e_Sys_Use32Bit")
	$a_System[$e_Sys_DeviceType]		= _GettingData("$e_Sys_DeviceType")
	$a_System[$e_Sys_Shadows]			= _GettingData("$e_Sys_Shadows")
	$a_System[$e_Sys_VSync]				= _GettingData("$e_Sys_VSync")
	$a_System[$e_Sys_DoubleBuffer]		= _GettingData("$e_Sys_DoubleBuffer")
	$a_System[$e_Sys_Antialias]			= _GettingData("$e_Sys_Antialias")
	$a_System[$e_Sys_HighPrecisionFpu]	= _GettingData("$e_Sys_HighPrecisionFpu")
	$a_System[$e_Sys_ExtendedShaders]	= _GettingData("$e_Sys_ExtendedShaders")
EndFunc

#EndRegion -Unterfunktionen---------------------------------------------------------------------------------------------------------
