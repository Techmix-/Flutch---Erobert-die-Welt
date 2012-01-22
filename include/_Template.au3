#include "_Const.au3"	; Alle Hauptvariablen verfügbar machen
#include-once
#RequireAdmin

#cs ================================================================================================================================
==== ChangeLog =====================================================================================================================
====================================================================================================================================

 AutoIt Version: 	3.3.7.23 (beta)
 Skript:			_Template.au3
 Author:

##	--------------------------------------------------------------------------------------------------------------------------------

	Template Datei zur Erweiterung des Hautprogrammes



##	--------------------------------------------------------------------------------------------------------------------------------

		V0.00:
	Hier wird der 'UDF' Fortschritt festgehalten

##	================================================================================================================================
#ce

#Region -UDF-Variablen--------------------------------------------------------------------------------------------------------------

; So werden die Variablen Deklariert. Es werden auch nur diejenigen Deklariert die auch tatsächlich in dieser UDF verwendet werden.
Global $i_Zahl, $f_Float, $s_String, $a_Array, $p_Pointer, $e_Enum, $irr_Irrlicht;, $tmp_Txt, $tmp_Array, ...

#EndRegion -UDF-Variablen-----------------------------------------------------------------------------------------------------------


#Region -Hauptfunktionen-------------------------------------------------------------------------------------------------------------

Func _Hauptfunktion() ; EIN Unterstrich
	__ConsoleWrite("_Template: _Template()"&@CRLF)
	Local $tmp_Txt = __Unterfunktion(5,1)
	Local $s_Txt = $a_System[$e_Sys_GameName] ; $a_System[$e_Sys_GameName] = _GettingData("$e_Sys_GameName")
	__ConsoleWrite("_Template: _Template: "&$s_Txt&@CRLF)

EndFunc

#EndRegion -Hauptfunktionen----------------------------------------------------------------------------------------------------------


#Region -Unterfunktionen------------------------------------------------------------------------------------------------------------

Func __Unterfunktion($i_A, $i_B, $s_C="+") ; ZWEI Unterstriche
	if $s_C="+" then Return $i_A + $i_B
EndFunc

#EndRegion -Unterfunktionen---------------------------------------------------------------------------------------------------------
