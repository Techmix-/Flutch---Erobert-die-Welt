#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Collision
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Calls for creating collision groups and for calculating collisions in the scene.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrGetCollisionGroupFromTerrain
;_IrrRemoveCollisionGroup
;_IrrRemoveAllCollisionGroupsFromCombination
;_IrrRemoveCollisionGroupFromCombination
;_IrrGetRayFromScreenCoordinates
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrGetCollisionGroupFromMesh
;_IrrGetCollisionGroupFromComplexMesh
;_IrrGetCollisionGroupFromBox
;_IrrCreateCombinedCollisionGroup
;_IrrAddCollisionGroupToCombination
;_IrrGetCollisionPoint
;_IrrGetCollisionNodeFromCamera
;_IrrGetCollisionNodeFromRay
;_IrrGetCollisionNodeFromScreenCoordinates
;_IrrGetScreenCoordinatesFrom3DPosition
;_IrrGet3DPositionFromScreenCoordinates
;_IrrGet2DPositionFromScreenCoordinates
;_IrrGetChildCollisionNodeFromRay
;_IrrGetChildCollisionNodeFromPoint
;_IrrGetNodeAndCollisionPointFromRay
;_IrrGetDistanceBetweenNodes
;_IrrAreNodesIntersecting
;_IrrIsPointInsideNode
;_IrrGetCollisionResultPosition
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionGroupFromMesh
; Description ...: Creates a collision object from the triangles contained within the specified mesh as applied to the position, rotation and scale of the supplied node.
; Syntax.........: _IrrGetCollisionGroupFromMesh($h_Mesh, $h_Node, $i_Frame = 0)
; Parameters ....: $h_Mesh - Handle of mesh the node was created from.
;                  $h_Node - Handle of the node to create a selector from.
;                  $i_Frame - [optional] Number of mesh frame to use.
; Return values .: Success - Handle to a selector object
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrGetCollisionGroupFromComplexMesh, _IrrGetCollisionGroupFromBox, _IrrGetCollisionGroupFromTerrain, _IrrRemoveCollisionGroup, _IrrCreateCombinedCollisionGroup
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetCollisionGroupFromMesh($h_Mesh, $h_Node, $i_Frame = 0)
; gets a collision object from an animated mesh
    Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetCollisionGroupFromMesh", "UINT_PTR", $h_Mesh, "UINT_PTR", $h_Node, "int", $i_Frame)
	If @error Or Not $aResult[0] Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetCollisionGroupFromMesh


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionGroupFromComplexMesh
; Description ...: Creates an optimized triangle selection group from a large complex mesh like a map.
; Syntax.........: _IrrGetCollisionGroupFromComplexMesh($h_Mesh, $h_Node, $i_Frame = 0)
; Parameters ....: $h_Mesh - Handle of mesh the node was created from.
;                  $h_Node - Handle of the node to create a selector from.
;                  $i_Frame - [optional] Number of mesh frame to use.
; Return values .: success - Handle to a selector object
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: The returned triangle selection group can then be used in collision functions to collide objects against this node.
; Related .......: _IrrGetCollisionGroupFromMesh, _IrrGetCollisionGroupFromBox, _IrrGetCollisionGroupFromTerrain, _IrrRemoveCollisionGroup, _IrrCreateCombinedCollisionGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetCollisionGroupFromComplexMesh($h_Mesh, $h_Node, $i_Frame = 0)
    Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetCollisionGroupFromComplexMesh", "UINT_PTR", $h_Mesh, "UINT_PTR", $h_Node, "int", $i_Frame)
	If @error Or Not $aResult[0] Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetCollisionGroupFromComplexMesh


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionGroupFromBox
; Description ...: Creates a collision object from the bounding box of a node.
; Syntax.........: _IrrGetCollisionGroupFromBox($h_Node)
; Parameters ....: $h_Node - Handle to a node.
; Return values .: Success - Handle to a selector object.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrGetCollisionGroupFromMesh, _IrrGetCollisionGroupFromComplexMesh, _IrrGetCollisionGroupFromTerrain, _IrrRemoveCollisionGroup, _IrrCreateCombinedCollisionGroup
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetCollisionGroupFromBox($h_Node)
    Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetCollisionGroupFromBox", "ptr", $h_Node)
	If @error Or Not $aResult[0] Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetCollisionGroupFromBox


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionGroupFromTerrain
; Description ...: Creates a collision object from a terrain node.
; Syntax.........: _IrrGetCollisionGroupFromTerrain($h_Node, $i_Lod = 1)
; Parameters ....: $h_Node - Handle to the terain node.
;                  $i_Lod - Level of detail
;                  |A higher level of detail improves the collision detection but consumes more resources and can effect the speed of the process.
; Return values .: Success - Handle to a terrain selector object.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrGetCollisionGroupFromMesh, _IrrGetCollisionGroupFromComplexMesh, _IrrGetCollisionGroupFromBox, _IrrRemoveCollisionGroup, _IrrCreateCombinedCollisionGroup
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetCollisionGroupFromTerrain($h_Node, $i_Lod)
    Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetCollisionGroupFromTerrain", "ptr", $h_Node, "int", $i_Lod)
	If @error Or Not $aResult[0] Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetCollisionGroupFromTerrain


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveCollisionGroup
; Description ...: Remove the collision selector from memory.
; Syntax.........: _IrrRemoveCollisionGroup($h_CollisionGroup, $h_Node)
; Parameters ....: $h_CollisionGroup - Handle to the collision selector object.
;                  $h_Node - Handle to the node.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: This collision selector must not be attached to another collision group when it is removed, the collision group is first removed from the node you supply.
; Related .......: _IrrGetCollisionGroupFromMesh, _IrrGetCollisionGroupFromComplexMesh, _IrrGetCollisionGroupFromBox, _IrrGetCollisionGroupFromTerrain, _IrrCreateCombinedCollisionGroup
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrRemoveCollisionGroup($h_CollisionGroup, $h_Node)
	DllCall($_irrDll, "none:cdecl", "IrrRemoveCollisionGroup", "ptr", $h_CollisionGroup, "ptr", $h_Node)
	Return Seterror(@error, 0, @error)
EndFunc   ;==>_IrrRemoveCollisionGroup


; #FUNCTION# =============================================================================================================
; Name...........: _IrrCreateCombinedCollisionGroup
; Description ...: Creates a collision object that can be used to combine several collision objects together.
; Syntax.........: _IrrCreateCombinedCollisionGroup()
; Parameters ....: None.
; Return values .: Success - Handle to a combined collision selector object.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: You could add a couple of maps and a terrain for example. Initially the combined collision object is empty.
; Related .......: _IrrGetCollisionGroupFromMesh, _IrrGetCollisionGroupFromComplexMesh, _IrrGetCollisionGroupFromBox, _IrrGetCollisionGroupFromTerrain, _IrrRemoveCollisionGroup
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrCreateCombinedCollisionGroup()
    Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrCreateCombinedCollisionGroup")
	If @error Or Not $aResult[0] Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrCreateCombinedCollisionGroup


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddCollisionGroupToCombination
; Description ...: Adds a collision object to group of collision objects.
; Syntax.........: _IrrAddCollisionGroupToCombination($h_CombinedCollisionGroup, $h_CollisionGroup)
; Parameters ....: $h_CombinedCollisionGroup - Handle to a combined collision selector object.
;                  $h_CollisionGroup - Handle to a collision selector object.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrCreateCombinedCollisionGroup, _IrrCreateCombinedCollisionGroup, _IrrRemoveAllCollisionGroupsFromCombination
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrAddCollisionGroupToCombination($h_CombinedCollisionGroup, $h_CollisionGroup)
    DllCall($_irrDll, "none:cdecl", "IrrAddCollisionGroupToCombination", "ptr", $h_CombinedCollisionGroup, "ptr", $h_CollisionGroup)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrAddCollisionGroupToCombination


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveAllCollisionGroupsFromCombination
; Description ...: Empty a collision group object so that you can add different collision groups to it.
; Syntax.........: _IrrRemoveAllCollisionGroupsFromCombination($h_CombinedCollisionGroup)
; Parameters ....: $h_CombinedCollisionGroup - Handle to a combined collision selector object.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddCollisionGroupToCombination, _IrrAddCollisionGroupToCombination
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrRemoveAllCollisionGroupsFromCombination($h_CombinedCollisionGroup)
	DllCall($_irrDll, "none:cdecl", "IrrRemoveAllCollisionGroupsFromCombination", "ptr", $h_CombinedCollisionGroup)
	Return Seterror(@error, 0, @error)
EndFunc   ;==>_IrrRemoveAllCollisionGroupsFromCombination


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveCollisionGroupFromCombination
; Description ...: Remove a single specified collision object from a group of collision objects.
; Syntax.........: _IrrRemoveCollisionGroupFromCombination($h_CombinedCollisionGroup, $h_CollisionGroup)
; Parameters ....: $h_CombinedCollisionGroup - Handle to a combined collision selector object.
;                  $h_CollisionGroup - Handle to a collision selector object.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrCreateCombinedCollisionGroup, _IrrAddCollisionGroupToCombination
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrRemoveCollisionGroupFromCombination($h_CombinedCollisionGroup, $h_CollisionGroup)
	DllCall($_irrDll, "none:cdecl", "IrrRemoveCollisionGroupFromCombination", "ptr", $h_CombinedCollisionGroup, "ptr", $h_CollisionGroup)
	Return Seterror(@error, 0, @error)
EndFunc   ;==>_IrrRemoveCollisionGroupFromCombination


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionPoint
; Description ...: [todo]
; Syntax.........: _IrrGetCollisionPoint($a_StartVector, $a_EndVector, $h_CollisionGroup, byRef $a_CollisionVector)
; Parameters ....: $a_StartVector - [explanation]
;                  $a_EndVector -
;                  $h_CollisionGroup - [explanation]
;                  $a_CollisionVector -
; Return values .: Success - True and the provided $a_CollisionVector contains the co-ordinates of the point of collision as a 1D Array
;                  |$a_CollisionVector[0] = X Vector
;                  |$a_CollisionVector[1] = Y Vector
;                  |$a_CollisionVector[2] = Z Vector
;                  Failure - False and set @error
;                  |@error 1 Failed dll call
;                  |@error 2 $a_StartVector Param invalid array
;                  |@error 3 $a_EndVector Param invalid array
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetCollisionPoint($a_StartVector, $a_EndVector, $h_CollisionGroup, byRef $a_CollisionVector)
	Local $tStartVector, $tEndVector, $tCollisionVector, $aResult
	$tStartVector = DllStructCreate("float;float;float")
	$tEndVector = DllStructCreate("float;float;float")
	For $i = 1 To 3
		DllStructSetData($tStartVector, $i, $a_StartVector[$i - 1])
	    DllStructSetData($tEndVector, $i, $a_EndVector[$i - 1])
	Next
	$tCollisionVector = DllStructCreate("float;float;float")
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrGetCollisionPoint", "ptr", DllStructGetPtr($tStartVector), _
				"ptr", DllStructGetPtr($tEndVector), "ptr", $h_CollisionGroup, "ptr", DllStructGetPtr($tCollisionVector))
	If @error Then Return Seterror(1, 0, False)
	Dim $a_CollisionVector[3]
	For $i =  1 To 3
		$a_CollisionVector[$i - 1] = DllStructGetData($tCollisionVector, $i)
	Next
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetCollisionPoint


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetRayFromScreenCoordinates
; Description ...: Gets a ray that goes from the specified camera and through the screen coordinates the information is copied into the supplied start and end vectors.
; Syntax.........: _IrrGetRayFromScreenCoordinates($i_X, $i_Y, $h_Camera)
; Parameters ....: $i_X - X screen coordinate integer value
;                  $i_Y - Y screen coordinate integer value
;                  $h_Camera - Handle of the camera
; Return values .: Success - 2D Array containing Start and End Vectors of float values
;                  |$Array[0][0] = Start X
;                  |$Array[0][1] = Start Y
;                  |$Array[0][2] = Start Z
;                  |$Array[1][0] = End X
;                  |$Array[1][1] = End Y
;                  |$Array[1][2] = End Z
;                  Failure - False and  @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: You can then use this ray in other collision operations.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetRayFromScreenCoordinates($i_X, $i_Y, $h_Camera)
	Local $tStartVector, $tEndVector, $aReturn[2][3]
	$tStartVector = DllStructCreate("float;float;float")
	$tEndVector = DllStructCreate("float;float;float")
	DllCall($_irrDll, "none:cdecl", "IrrGetRayFromScreenCoordinates", "int", $i_X, "int", $i_Y, "ptr", $h_Camera, "ptr", DllStructGetPtr($tStartVector), "ptr", DllStructGetPtr($tEndVector))
	If @error Then Return SetError(1, 0, False)
	For $i = 1 To 3
		$aReturn[0][$i - 1] = DllStructGetData($tStartVector, $i)
		$aReturn[1][$i - 1] = DllStructGetData($tEndVector, $i)
	Next
	Return SetError(0, 0, $aReturn)
EndFunc   ;==>_IrrGetRayFromScreenCoordinates


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionNodeFromCamera
; Description ...: A ray is cast through the camera and the nearest node that is hit by the ray is returned.
; Syntax.........: _IrrGetCollisionNodeFromCamera($h_Camera)
; Parameters ....: $h_Camera - Handle to a camera node.
; Return values .: Success - Handle of the node the camera ray is hitting. If no node is hit zero is returned for the object.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddCamera, _IrrAddFpsCamera
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetCollisionNodeFromCamera($h_Camera)
    Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetCollisionNodeFromCamera", "ptr", $h_Camera)
	If @error Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetCollisionNodeFromCamera


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionNodeFromRay
; Description ...: [todo]
; Syntax.........: _IrrGetCollisionNodeFromRay(byRef $h_StartVector, byRef $h_EndVector)
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
Func _IrrGetCollisionNodeFromRay(byRef $h_StartVector, byRef $h_EndVector)
; a ray is cast through the supplied coordinates and the nearest node that is
; hit by the ray is returned. if no node is hit zero is returned for the object
    Local $tStartVector, $tEndVector, $aResult
	$tStartVector = DllStructCreate("float;float;float")
	$tEndVector = DllStructCreate("float;float;float")
	For $i = 1 To 3
		DllStructSetData($tStartVector, $i, $h_StartVector[$i - 1])
		DllStructSetData($tEndVector, $i, $h_EndVector[$i - 1])
	Next
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetCollisionNodeFromRay", "ptr", DllStructGetPtr($tStartVector), "ptr", DllStructGetPtr($tEndVector))
	If @error Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetCollisionNodeFromRay


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionNodeFromScreenCoordinates
; Description ...: [todo]
; Syntax.........: _IrrGetCollisionNodeFromScreenCoordinates($i_X, $i_Y)
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
Func _IrrGetCollisionNodeFromScreenCoordinates($i_X, $i_Y)
; a ray is cast through the screen at the specified co-ordinates and the nearest
; node that is hit by the ray is returned. if no node is hit zero is returned
; for the object
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetCollisionNodeFromScreenCoordinates", "int", $i_X, "int", $i_Y)
	If @error Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetCollisionNodeFromScreenCoordinates


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetScreenCoordinatesFrom3DPosition
; Description ...: Screen co-ordinates are returned for the position of the specified 3D co-ordinates.
; Syntax.........: _IrrGetScreenCoordinatesFrom3DPosition(ByRef $i_ScreenX, ByRef $i_ScreenY, $a_3DPositionVector)
; Parameters ....: $i_ScreenX, $i_ScreenY - Variables which will contain coordinates after call of the function.
;                  $a_3DPositionVector - 1D array with three elements for x, y, z values of a position in space.
; Return values .: Success - True and sets passed $i_ScreenX and $i_ScreenY
;                  Failure - False and @error = 1
; Author ........:
; Modified.......:
; Remarks .......: Screen co-ordinates are returned for the position of the specified 3D co-ordinates as if an object were drawn at them on the screen, this is ideal for drawing 2D bitmaps or text around or on your 3D object on the screen for example in the HUD of an aircraft.
; Related .......: _IrrGet3DPositionFromScreenCoordinates, _IrrGet2DPositionFromScreenCoordinates
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetScreenCoordinatesFrom3DPosition(ByRef $i_ScreenX, ByRef $i_ScreenY, $a_3DPositionVector)
	If Not UBound($a_3DPositionVector) = 3 then Return Seterror(2, 0, False)
	Local $aResult
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetScreenCoordinatesFrom3DPosition", "int*", $i_ScreenX, "int*", $i_ScreenY, _
						"float", $a_3DPositionVector[0], "float", $a_3DPositionVector[1], "float", $a_3DPositionVector[2])
	If @error Then Return Seterror(1, 0, False)
	$i_ScreenX = $aResult[1]
	$i_ScreenY = $aResult[2]
	Return Seterror(0, 0, True)
EndFunc   ;==>_IrrGetScreenCoordinatesFrom3DPosition


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGet3DPositionFromScreenCoordinates
; Description ...: [todo]
; Syntax.........: _IrrGet3DPositionFromScreenCoordinates($i_X, $i_Y, ByRef $a_Vector3df, $h_Camera, $f_NormalX=0.0, $f_NormalY=0.0, $f_NormalZ=1.0, $f_DistanceFromOrigin=0.0)
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
Func _IrrGet3DPositionFromScreenCoordinates($i_X, $i_Y, ByRef $a_Vector3df, $h_Camera, $f_NormalX=0.0, $f_NormalY=0.0, $f_NormalZ=1.0, $f_DistanceFromOrigin=0.0)
; Calculates the intersection between a ray projected through the specified
; screen co-ordinates and a plane defined a normal and distance from the
; world origin (contributed by agamemnus)
	Local $aResult
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGet3DPositionFromScreenCoordinates", "int", $i_X, "int", $i_Y, _
				"float*", $a_Vector3df[0], "float*", $a_Vector3df[1], "float*", $a_Vector3df[2], _
				"ptr", $h_Camera, "float", $f_NormalX, "float", $f_NormalY, "float", $f_NormalZ, "float", $f_DistanceFromOrigin)
    If @error Then Return Seterror(1, 0, False)
	$a_Vector3df[0] = $aResult[3]
	$a_Vector3df[1] = $aResult[4]
	$a_Vector3df[2] = $aResult[5]
	Return Seterror(0, 0, $a_Vector3df)
EndFunc   ;==>_IrrGet3DPositionFromScreenCoordinates


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGet2DPositionFromScreenCoordinates
; Description ...: [todo]
; Syntax.........: _IrrGet2DPositionFromScreenCoordinates($i_X, $i_Y, ByRef $f_X, ByRef $f_Y, $h_Camera)
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
Func _IrrGet2DPositionFromScreenCoordinates($i_X, $i_Y, ByRef $f_X, ByRef $f_Y, $h_Camera)
; Calculates the intersection between a ray projected through the specified
; screen co-ordinates and a flat surface plane (contributed by agamemnus)
	Local $aResult
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGet2DPositionFromScreenCoordinates", "int", $i_X, "int", $i_Y, _
				"float*", $f_X, "float*", $f_Y, "ptr", $h_Camera)
	If @error Then Return Seterror(1, 0, False)
	$f_X = $aResult[3]
	$f_Y = $aResult[4]
	Return Seterror(0, 0, True)
EndFunc   ;==>_IrrGet2DPositionFromScreenCoordinates


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetChildCollisionNodeFromRay
; Description ...: [todo]
; Syntax.........: _IrrGetChildCollisionNodeFromRay($h_Node, $i_Mask, $i_Recurse, $a_StartVector, $a_EndVector)
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
Func _IrrGetChildCollisionNodeFromRay($h_Node, $i_Mask, $i_Recurse, $a_StartVector, $a_EndVector)
	Local $tStartVector, $tEndVector, $aResult
	$tStartVector = DllStructCreate("float;float;float")
	$tEndVector = DllStructCreate("float;float;float")
	For $i = 1 To 3
		DllStructSetData($tStartVector, $i, $a_StartVector[$i - 1])
		DllStructSetData($tEndVector, $i, $a_EndVector[$i - 1])
	Next
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetChildCollisionNodeFromRay", "ptr", $h_Node, "int", $i_Mask, "int", $i_Recurse, "ptr", DllStructGetPtr($tStartVector), "ptr", DllStructGetPtr($tEndVector) )
	If @error Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetChildCollisionNodeFromRay


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetChildCollisionNodeFromPoint
; Description ...: The node and its children are recursively tested and the first node that contains the matched point is returned.
; Syntax.........: _IrrGetChildCollisionNodeFromPoint($h_Node, $i_Mask, $i_Recurse, $a_PointVector)
; Parameters ....: $h_Node - [explanation]
;                  $i_Mask -
;                  $i_Recurse -
;                  $a_PointVector -
; Return values .: Success - [explanation]
;                  Failure - False and @error 1
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: If no node is hit zero is returned for the object, only a subset of objects are tested,
;                  i.e. the children of the supplied node that match the supplied id.
;                  If the recurse option is enabled the entire tree of child objects connected to this node are tested.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetChildCollisionNodeFromPoint($h_Node, $i_Mask, $i_Recurse, $a_PointVector)
	Local $tPointVector, $aResult
	$tPointVector = DllStructCreate("float;float;float")
	DllStructSetData($tPointVector, 1, $a_PointVector[0])
	DllStructSetData($tPointVector, 2, $a_PointVector[1])
	DllStructSetData($tPointVector, 3, $a_PointVector[2])
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetChildCollisionNodeFromPoint", "ptr", $h_Node, "int", $i_Mask, "int", $i_Recurse, "ptr", DllStructGetPtr($tPointVector))
	If @error Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetChildCollisionNodeFromPoint


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetNodeAndCollisionPointFromRay
; Description ...: [todo]
; Syntax.........: _IrrGetNodeAndCollisionPointFromRay($a_StartVector, $a_EndVector, ByRef $h_Node, ByRef $f_PosX, ByRef $f_PosY, ByRef $f_PosZ, ByRef $f_NormalX, ByRef $f_NormalY, ByRef $f_NormalZ, $i_ID = 0, $h_RootNode = $IRR_NO_OBJECT)
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
Func _IrrGetNodeAndCollisionPointFromRay($a_StartVector, $a_EndVector, ByRef $h_Node, ByRef $f_PosX, ByRef $f_PosY, ByRef $f_PosZ, ByRef $f_NormalX, ByRef $f_NormalY, ByRef $f_NormalZ, $i_ID = 0, $h_RootNode = $IRR_NO_OBJECT)
; a ray is cast through the specified co-ordinates and the nearest node that has
; a collision selector object that is hit by the ray is returned along with the
; coordinate of the collision and the normal of the triangle that is hit. if no
; node is hit zero is returned for the object
	Local $tStartVector, $tEndVector, $aResult
	$tStartVector = DllStructCreate("float;float;float")
	$tEndVector = DllStructCreate("float;float;float")
	For $i = 1 To 3
	    DllStructSetData($tStartVector, $i, $a_StartVector[$i - 1])
		DllStructSetData($tEndVector, $i, $a_EndVector[$i - 1])
	Next
 	$h_Node = DllStructCreate("UINT_PTR")
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetNodeAndCollisionPointFromRay", _
			"ptr", DllStructGetPtr($tStartVector), "ptr", DllStructGetPtr($tEndVector), "ptr*", $h_Node, _
			"float*", $f_PosX, "float*", $f_PosY, "float*", $f_PosZ, _
			"float*", $f_NormalX, "float*", $f_NormalY, "float*", $f_NormalZ, _
			"int", $i_ID, "ptr", $h_Node)
	If @error Then Return Seterror(1, 0, False)
	If $aResult[3] = 0 Then Return Seterror(0, 0, 0)
	$h_Node = $aResult[3]
	$f_PosX = $aResult[4]
	$f_PosY = $aResult[5]
	$f_PosZ = $aResult[6]
	$f_NormalX = $aResult[7]
	$f_NormalY = $aResult[8]
	$f_NormalZ = $aResult[9]
	Return $h_Node
EndFunc   ;==>_IrrGetNodeAndCollisionPointFromRay


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetDistanceBetweenNodes
; Description ...: The distance between two nodes is measured using fast maths functions that will show inaccuracies.
; Syntax.........: _IrrGetDistanceBetweenNodes($h_NodeA, $h_NodeB)
; Parameters ....: $h_NodeA - Handle to a node.
;                  $h_NodeB - Handle to another node.
; Return values .: Success - Distance between the 2 nodes
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: Useful for when it is nessecary to test distances between many nodes.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetDistanceBetweenNodes($h_NodeA, $h_NodeB)
	Local $aResult
	$aResult = DllCall($_irrDll, "float:cdecl", "IrrGetDistanceBetweenNodes", "ptr", $h_NodeA, "ptr", $h_NodeB)
	If @error Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetDistanceBetweenNodes


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAreNodesIntersecting
; Description ...: Tests whether the bounding boxes are two nodes are intersecting.
; Syntax.........: _IrrAreNodesIntersecting($h_NodeA, $h_NodeB)
; Parameters ....: $h_NodeA - Handle to a node.
;                  $h_NodeB - Handle to another node.
; Return values .: Success - 0 Nodes not Intersecting, 1 Nodes are Intersecting.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: Bounding boxes are axis aligned and do not rotate when you rotate the nodes.
;                  This should be kept in mind when testing for collisions.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAreNodesIntersecting($h_NodeA, $h_NodeB)
	Local $aResult
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrAreNodesIntersecting", "ptr", $h_NodeA, "ptr", $h_NodeB)
	If @error Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrAreNodesIntersecting


; #FUNCTION# =============================================================================================================
; Name...........: _IrrIsPointInsideNode
; Description ...: Determine if the specified point is inside the bounding box of the node.
; Syntax.........: _IrrIsPointInsideNode($h_Node, $f_X, $f_Y, $f_Z)
; Parameters ....: $h_Node - Handle to a node.
;                  $f_X - X position
;                  $f_Y - Y position
;                  $f_Z - Z position
; Return values .: Success - 0 point is outside the bounding box of the node., 1 the point is inside the bounding box of the node.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrIsPointInsideNode($h_NodeA, $f_X, $f_Y, $f_Z)
	Local $aResult
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrIsPointInsideNode", "ptr", $h_NodeA, "float", $f_X, "float", $f_Y, "float", $f_Z)
	If @error Then Return Seterror(1, 0, False)
	Return Seterror(0, 0, $aResult[0])

EndFunc   ;==>_IrrIsPointInsideNode


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionResultPosition
; Description ...: Collides moving ellipsoid with 3d world with gravity and returns resulting new position of the ellipsoid.
; Syntax.........: _IrrGetCollisionResultPosition($h_Selector, ByRef $a_EllipsoidPosition, ByRef $a_EllipsoidRadius, ByRef $a_Velocity, ByRef $a_Gravity, $f_SlidingSpeed, ByRef $a_OutPosition, ByRef $a_OutHitPosition, ByRef $i_OutFalling)
; Parameters ....: $h_Selector -
;                  $a_EllipsoidPosition -
;                  $a_EllipsoidRadius -
;                  $a_Velocity -
;                  $a_Gravity -
;                  $f_SlidingSpeed -
;                  $a_OutPosition -
;                  $a_OutHitPosition -
;                  $i_OutFalling -
; Return values .: Success - True and ...
;                  Failure - False @ @error 1
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: Returned resulting new position of the ellipsoid is the point at which the elipsoid collided with the surface and whether the ellipsoid is falling through the air.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetCollisionResultPosition($h_Selector, ByRef $a_EllipsoidPosition, ByRef $a_EllipsoidRadius, ByRef $a_Velocity, ByRef $a_Gravity, $f_SlidingSpeed, ByRef $a_OutPosition, ByRef $a_OutHitPosition, ByRef $i_OutFalling)
; Collides a moving ellipsoid with a 3d world with gravity and returns the
; resulting new position of the ellipsoid. (contributed by The Car)
	Local $tEllipsoidPosition, $tEllipsoidRadius, $tVelocity, $tGravity, $tOutPosition, $tOutHitPosition, $aResult
	$tEllipsoidPosition = DllStructCreate("float;float;float")
	$tEllipsoidRadius = DllStructCreate("float;float;float")
	$tVelocity = DllStructCreate("float;float;float")
	$tGravity = DllStructCreate("float;float;float")
	For $i = 1 To 3
		DllStructSetData($tEllipsoidPosition, $i, $a_EllipsoidPosition[$i - 1])
	    DllStructSetData($tEllipsoidRadius, $i, $a_EllipsoidRadius[$i - 1])
	    DllStructSetData($tVelocity, $i, $a_Velocity[$i - 1])
	    DllStructSetData($tGravity, $i, $a_Gravity[$i - 1])
	Next
	$tOutPosition = DllStructCreate("float;float;float")
	$tOutHitPosition = DllStructCreate("float;float;float")
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetCollisionResultPosition", "ptr", $h_Selector, "ptr", DllStructGetPtr($tEllipsoidPosition), "ptr", DllStructGetPtr($tEllipsoidRadius), _
			"ptr", DllStructGetPtr($tVelocity), "ptr", DllStructGetPtr($tGravity), "float", $f_SlidingSpeed, _
			"ptr", DllStructGetPtr($tOutPosition), "ptr", DllStructGetPtr($tOutHitPosition), "int*", $i_OutFalling)
	If @error Or Not IsArray($aResult) Then Return Seterror(1, 0, False)
	Dim $a_OutPosition[3], $a_OutHitPosition[3]
	For $i = 1 To 3
		$a_OutPosition[$i - 1] = DllStructGetData($tOutPosition, $i)
		$a_OutHitPosition[$i - 1] = DllStructGetData($tOutHitPosition, $i)
	Next
	$i_OutFalling = $aResult[9]
	Return Seterror(0, 0, True)
EndFunc   ;==>_IrrGetCollisionResultPosition
