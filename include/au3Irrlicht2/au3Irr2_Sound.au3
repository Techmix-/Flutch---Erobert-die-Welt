#include-once


; #INDEX# =======================================================================================================================
; Title .........: Sound
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: 2D and 3D sound functions based on the IrrKlang engine.
; Author(s) .....: linus
;                  DLL functionality by Frank Dodd (IrrKlangWrapper.dll),
;                  and Nikolaus Gebhardt(IrrKlang.dll).
; Dll(s) ........: IrrKlangWrapper.dll, IrrKlang.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrKlangStart
;_IrrKlangStop
;_IrrKlangPlay2D
;_IrrKlangSetVolume
;_IrrKlangIsFinished
;_IrrReleaseSound
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

Global $_irrKlangDll
global ENUM _ ; E_STREAM_MODE
    $ESM_AUTO_DETECT, $ESM_STREAMING, $ESM_NO_STREAMING, $ESM_FORCE_32_BIT = 0x7fffffff



; #FUNCTION# =============================================================================================================
; Name...........: _IrrKlangStart
; Description ...: Starts the IrrKlang sound engine ready to manage sounds.
; Syntax.........: _IrrKlangStart()
; Parameters ....: None.
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........:
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrKlangStop
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
func _IrrKlangStart()
; only one irrklang device object is supported by this wrapper. this call creates the device object that is exposed to au3
	$_irrKlangDll = DllOpen("IrrKlangWrapper.dll")
	if $_irrKlangDll = -1 Then ; .dll cannot be opened - try to get it by extending %path%:
		EnvSet("PATH", @ScriptDir & "\bin;" & @ScriptDir & "\..\bin;" & EnvGet("PATH"))
		EnvUpdate()

		$_irrKlangDll = DllOpen("IrrKlangWrapper.dll")
		if $_irrKlangDll = -1 Then ; no chance, so return error:
			Return Seterror(2,0,False)
		EndIf
	EndIf

	DllCall($_irrKlangDll, "none:cdecl", "IrrKlangStart")
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrKlangStart



; #FUNCTION# =============================================================================================================
; Name...........: _IrrKlangStop
; Description ...: Stops the IrrKlang sound engine.
; Syntax.........: _IrrKlangStop()
; Parameters ....: None.
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........:
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrKlangStart
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
func _IrrKlangStop()
; Stop the sound engine
	DllCall($_irrKlangDll, "none:cdecl", "IrrKlangStop")
	if @error Then
		Return Seterror(1,0,False)
	Else
		DllClose($_irrKlangDll)
		Return true
	EndIf
EndFunc   ;==>_IrrKlangStop




; #FUNCTION# =============================================================================================================
; Name...........: _IrrKlangPlay2D
; Description ...: [todo]
; Syntax.........: _IrrKlangPlay2D($sFile, $bLooped = False, $bStartPaused = False, $bTrack = False, $iStreamMode = $ESM_AUTO_DETECT, $bSoundEffects = False)
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrKlangPlay2D($sFile, $bLooped = False, $bStartPaused = False, $bTrack = False, $iStreamMode = $ESM_AUTO_DETECT, $bSoundEffects = False)
; Play a 2D sound
	local $aResult = DllCall($_irrKlangDll, "UINT_PTR:cdecl", "IrrKlangPlay2D", "str", $sFile, "UINT", $bLooped, _
								"UINT", $bStartPaused, "UINT", $bTrack, "INT", $iStreamMode, "UINT", $bSoundEffects)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrKlangPlay2D



; #FUNCTION# =============================================================================================================
; Name...........: _IrrKlangSetVolume
; Description ...: [todo]
; Syntax.........: _IrrKlangSetVolume($hSound, $fVolume)
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrKlangSetVolume($hSound, $fVolume)
; Set the volume of the sound
	local $aResult = DllCall($_irrKlangDll, "none:cdecl", "IrrKlangSetVolume", "UINT_PTR", $hSound, "float", $fVolume)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrKlangSetVolume



; #FUNCTION# =============================================================================================================
; Name...........: _IrrKlangIsFinished
; Description ...: [todo]
; Syntax.........: _IrrKlangIsFinished($hSound)
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrKlangIsFinished($hSound)
; Determine if a sound has finished playing
	local $aResult = DllCall($_irrKlangDll, "UINT:cdecl", "IrrKlangIsFinished", "UINT_PTR", $hSound)
	Return SetError(@error, 0, $aResult[0])
EndFunc   ;==>_IrrKlangIsFinished



; #FUNCTION# =============================================================================================================
; Name...........: _IrrReleaseSound
; Description ...: [todo]
; Syntax.........: _IrrReleaseSound($hSound)
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrReleaseSound($hSound)
; Release the sound
	local $aResult = DllCall($_irrKlangDll, "none:cdecl", "IrrReleaseSound", "UINT_PTR", $hSound)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrReleaseSound



Func _IrrKlangSetAllSoundsPaused($bPaused)
; Pause all sounds
	local $aResult = DllCall($_irrKlangDll, "none:cdecl", "IrrKlangSetAllSoundsPaused", "BOOLEAN", $bPaused)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrKlangSetAllSoundsPaused
