#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Lighting
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Calls to create and effect lighting in the scene.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrSetLightCastShadows
;_IrrSetLightSpecularColor
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrAddLight
;_IrrSetAmbientLight
;_IrrSetLightAmbientColor
;_IrrSetLightAttenuation
;_IrrSetLightDiffuseColor
;_IrrSetLightFalloff
;_IrrSetLightInnerCone
;_IrrSetLightOuterCone
;_IrrSetLightRadius
;_IrrSetLightType
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

;Lighting functions

; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddLight
; Description ...: Adds a light node into scene to naturally illuminate your scene.
; Syntax.........: _IrrAddLight($h_parentNode, $f_X, $f_Y, $f_Z, $f_Red, $f_Green, $f_Blue, $f_Size)
; Parameters ....: $h_parentNode - Handle of the node to attach the light to.
;                  |$IRR_NO_PARENT attaches to the root node of the scene.
;                  $f_X, $f_Y, $f_Z - Coordinates of the light in the scene
;                  $f_Red, $f_Green, $f_Blue - Intensity of the light.
;                  |<b>Red/green/blue are fractional values from 0 to 1!</b>
;                  $f_Size - Radius of effect of the light
; Return values .: Success - Handle of light node in the scene
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: When using shadows you probably only want one or two lights - they can be time consuming.
; Related .......: _IrrAddNodeShadow, _IrrSetAmbientLight
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddLight($h_parentNode, $f_X, $f_Y, $f_Z, $f_Red, $f_Green, $f_Blue, $f_Size)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddLight", "UINT_PTR", $h_parentNode, "float", $f_X, "float", $f_Y, "float", $f_Z, "float", $f_Red, "float", $f_Green, "float", $f_Blue, "float", $f_Size)
	If @error Or Not $aResult[0] Then Return Seterror(1, 0, False)
    Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddLight


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetAmbientLight
; Description ...: Sets the ambient lighting level across entire scene.
; Syntax.........: _IrrSetAmbientLight($f_Red, $f_Green, $f_Blue)
; Parameters ....: $f_Red, $f_Green, $f_Blue - Colour values for ambient lighting.
;                  |<b>Red/green/blue are fractional values from 0 to 1!</b>
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: Ambient light illuminates all surfaces in the scene uniformly. This is usually a low value to increase the overall lighting level.
;                  It should never be greater than the brightness of the darkest area of your scene, it can however reduce the number of lights you need in the scene.
; Related .......: _IrrSetLightAmbientColor
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetAmbientLight($f_Red, $f_Green, $f_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetAmbientLight", "float", $f_Red, "float", $f_Green, "float", $f_Blue)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetAmbientLight


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightAmbientColor
; Description ...: Set the ambient color emitted by the light.
; Syntax.........: _IrrSetLightAmbientColor($h_Light, $f_Red, $f_Green, $f_Blue)
; Parameters ....: $h_Light - Handle of a light node.
;                  $f_Red, $f_Green, $f_Blue - Colour values for ambient color.
;                  |<b>Red/green/blue are fractional values from 0 to 1!</b>
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: Ambient light casts light evenly across the entire scene and can be used to increase the overall lighting level.
;                  It should never be greater that the brightness of the darkest area of your scene,
;                  it can however reduce the number of lights you need in the scene.
; Related .......: _IrrAddLight
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetLightAmbientColor($h_Light, $f_Red, $f_Green, $f_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightAmbientColor", "ptr", $h_Light, "float", $f_Red, "float", $f_Green, "float", $f_Blue)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetLightAmbientColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightAttenuation
; Description ...: Changes the light strength fading over distance.
; Syntax.........: _IrrSetLightAttenuation($h_Light, $f_Constant, $f_Linear, $f_Quadratic)
; Parameters ....: $h_Light - Handle of a light node.
;                  $f_Constant, $f_Linea, $f_Quadratic - Values for light attenuation.
;                  |<b>Constant/Linea/Quadratic are fractional values from 0 to 1!</b>
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: Good values for distance effects use ( 1.0, 0.0, 0.0) and simply add small values to the second and third element.
; Related .......: _IrrAddLight
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetLightAttenuation($h_Light, $f_Constant, $f_Linear, $f_Quadratic)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightAttenuation", "ptr", $h_Light, "float", $f_Constant, "float", $f_Linear, "float", $f_Quadratic)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetLightAttenuation


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightCastShadows
; Description ...: Specifies whether the light casts shadows in the scene or not.
; Syntax.........: _IrrSetLightCastShadows($h_Light, $i_Shadows)
; Parameters ....: $h_Light - Handle of a light node.
;                  $i_Shadows - $IRR_ON cast shadows, $IRR_OFF don't cast shadows.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: Shadowing must be enabled in the IrrStart call and also on the nodes in the scene.
; Related .......: _IrrAddLight
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetLightCastShadows($h_Light, $i_Shadows)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightCastShadows", "ptr", $h_Light, "int", $i_Shadows)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetLightCastShadows


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightDiffuseColor
; Description ...: Set the light diffuse color.
; Syntax.........: _IrrSetLightDiffuseColor($h_Light, $f_Red, $f_Green, $f_Blue)
; Parameters ....: $h_Light - Handle of a light node.
;                  $f_Red, $f_Green, $f_Blue - The brightness in each color channel.
;                  |<b>Red/green/blue are fractional values from 0 to 1!</b>
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddLight
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetLightDiffuseColor($h_Light, $f_Red, $f_Green, $f_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightDiffuseColor", "ptr", $h_Light, "float", $f_Red, "float", $f_Green, "float", $f_Blue)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetLightDiffuseColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightFalloff
; Description ...: Sets the light strength's decrease between Outer and Inner cone.
; Syntax.........: _IrrSetLightFalloff($h_Light, $f_Falloff)
; Parameters ....: $h_Light - Handle of a light node.
;                  $f_Falloff - fractional value from 0 to 1 for Falloff. (eg: 0.8)
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddLight
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetLightFalloff($h_Light, $f_Falloff)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightFalloff", "ptr", $h_Light, "float", $f_Falloff)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetLightFalloff


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightInnerCone
; Description ...: The angle of the spot's inner cone. Ignored for other lights.
; Syntax.........: _IrrSetLightInnerCone($h_Light, $f_InnerCone)
; Parameters ....: $h_Light - Handle of a light node.
;                  $f_InnerCone - fractional value from 0 to 1 for InnerCone. (eg: 0.4)
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddLight
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetLightInnerCone($h_Light, $f_InnerCone)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightInnerCone", "ptr", $h_Light, "float", $f_InnerCone)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetLightInnerCone


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightOuterCone
; Description ...: The angle of the spot's outer cone. Ignored for other lights.
; Syntax.........: _IrrSetLightOuterCone($h_Light, $f_OuterCone)
; Parameters ....: $h_Light - Handle of a light node.
;                  $f_OuterCone - fractional value from 0 to 1 for InnerCone. (eg: 0.9)
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddLight
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetLightOuterCone($h_Light, $f_OuterCone)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightOuterCone", "ptr", $h_Light, "float", $f_OuterCone)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetLightOuterCone


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightRadius
; Description ...: Set the radius of light.
; Syntax.........: _IrrSetLightRadius($h_Light, $f_Radius)
; Parameters ....: $h_Light - Handle of a light node.
;                  $f_Radius - Radius float value (eg; 50.2)
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: Everything within this radius will be lighted.
;                  If some artefacts can be seen when the radius is changed in this instance simply make the radius a little larger.
; Related .......: _IrrAddLight
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetLightRadius($h_Light, $f_Radius)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightRadius", "ptr", $h_Light, "float", $f_Radius)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetLightRadius


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightSpecularColor
; Description ...: Sets specular color emitted by the light.
; Syntax.........: _IrrSetLightSpecularColor($h_Light, $f_Red, $f_Green, $f_Blue)
; Parameters ....: $h_Light - Handle of a light node.
;                  $f_Red, $f_Green, $f_Blue - Colour values for ambient lighting.
;                  |<b>Red/green/blue are fractional values from 0 to 1!</b>
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddLight
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetLightSpecularColor($h_Light, $f_Red, $f_Green, $f_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightSpecularColor", "ptr", $h_Light, "float", $f_Red, "float", $f_Green, "float", $f_Blue)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetLightSpecularColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightType
; Description ...: Set the type of light to be used.
; Syntax.........: _IrrSetLightType($h_Light, $i_Type)
; Parameters ....: $h_Light - Handle of a light node.
;                  $i_Type - All lights default to a point light but can be changed using one of the following values;
;                  |$ELT_POINT
;                  |$ELT_SPOT
;                  |$ELT_DIRECTIONAL
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddLight
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetLightType($h_Light, $i_Type)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightType", "ptr", $h_Light, "int", $i_Type)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetLightType
