#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Filling System
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: These calls deal with the way irrlicht operates with the filing system and adds archives to its
;                  a virtual filling system allowing you to compress data into zipfiles that you can access without
;                  decompressing them.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrAddZipFile
;_IrrChangeWorkingDirectory
;_IrrGetWorkingDirectory
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddZipFile
; Description ...: Adds a zip archive to the filing system allowing to load files out of the zip file.
; Syntax.........: _IrrAddZipFile($s_Zipfile, $i_IgnoreCase, $i_IgnorePaths)
; Parameters ....: $s_ZipFile - Path to the zipfile (or pk3 file)
;                  $i_IgnoreCase - Should be one of the following values:
;                  |$IRR_USE_CASE
;                  |$IRR_IGNORE_CASE
;                  $i_IgnorePaths - Ignore paths allows you to simply use the filename without the path, the filename should always be unique in the archive when using this option. The value should be one of the following:
;                  |$IRR_USE_PATHS
;                  |$IRR_IGNORE_PATHS
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: Files inside the .zip can be opened as if they were in the current working directory.
;                  Common pk3 files are simply zip files.
; Related .......: None
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddZipFile($s_Zipfile, $i_IgnoreCase, $i_IgnorePaths)
	DllCall($_irrDll, "none:cdecl", "IrrAddZipFile", "str", $s_Zipfile, "int", $i_IgnoreCase, "int", $i_IgnorePaths)
    Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrAddZipFile


; #FUNCTION# =============================================================================================================
; Name...........: _IrrChangeWorkingDirectory
; Description ...: Change the working directory of the Irrlicht Environment.
; Syntax.........: _IrrChangeWorkingDirectory($s_WorkingDir)
; Parameters ....: $s_WorkingDir - Path of new working directory.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrGetWorkingDirectory
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrChangeWorkingDirectory($s_WorkingDir)
	DllCall($_irrDll, "none:cdecl", "IrrChangeWorkingDirectory", "str", $s_WorkingDir)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrChangeWorkingDirectory


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetWorkingDirectory
; Description ...: Get the current working directory of the Irrlicht Environment.
; Syntax.........: _IrrGetWorkingDirectory()
; Parameters ....: None.
; Return values .: Success - Path of current working directory.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrChangeWorkingDirectory
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetWorkingDirectory()
	Local $aResult
	$aResult = DllCall($_irrDll, "str:cdecl", "IrrGetWorkingDirectory")
	If @error Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetWorkingDirectory
