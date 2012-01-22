#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Terrain
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Calls to create and alter the properties of terrain meshes,
;                  special nodes that are used to create large expansive landscapes.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrAttachTile
;_IrrSetTileStructure
;_IrrLoadSphericalTerrainVertexColor
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrAddTerrain
;_IrrAddTerrainTile
;_IrrAddSphericalTerrain
;_IrrGetTerrainHeight
;_IrrScaleTexture
;_IrrGetTerrainTileHeight
;_IrrScaleTileTexture
;_IrrSetTileColor
;_IrrScaleSphericalTexture
;_IrrSetSphericalTerrainTexture
;_IrrGetSphericalTerrainSurfacePosition
;_IrrGetSphericalTerrainSurfacePositionAndAngle
;_IrrGetSphericalTerrainLogicalSurfacePosition
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

;Terrain functions

; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddTerrain
; Description ...: Creates a terrain object from a gray scale bitmap.
; Syntax.........: _IrrAddTerrain($s_Path, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_VertexAlpha = 255, $i_VertexRed = 255, $i_VertexGreen = 255, $i_VertexBlue = 255, $i_Smoothing = 0, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
; Parameters ....: $s_Path - Filename of a gray scale image used to define the contours of the surface
;                  $f_PosX, $f_PosY, $f_PosZ - [optional] Define position of the terrain
;                  $f_RotX, $f_RotY, $f_RotZ - [optional] Define rotation of the terrain
;                  $f_ScaleX, $f_ScaleY, $f_ScaleZ - [optional] Define scaling of the terrain
;                  $i_VertexAlpha - [optional] Alpha value for the vertex colour from 0 to 255.
;                  $i_VertexRed, $i_VertexGreen, $i_VertexBlue - [optional] Define the vertex colour of all points in the terrain (values from 0 to 255)
;                  $i_Smoothing - [optional] True or false defines whether the contours of the surface of the terrain are smoothed over.
;                  $i_MaxLOD, $i_PatchSize - [optional] Control the properties of the level of detail calculations applied to the terrain.
;                  |It is recommended that these are left at default values.
;                  |<br><u>Valid values for $i_PatchSize:</u>
;                  |$ETPS_9 (patch size of 9, at most, use 4 levels of detail with this patch size)
;                  |$ETPS_17 (patch size of 17, at most, use 5 levels of detail with this patch size)
;                  |$ETPS_33 (patch size of 33, at most, use 6 levels of detail with this patch size)
;                  |$ETPS_65 (patch size of 65, at most, use 7 levels of detail with this patch size)
;                  |$ETPS_129 (patch size of 129, at most, use 8 levels of detail with this patch size)
; Return values .: Success - Handle of the terrain object
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: The terrain is created from a gray scale bitmap where bright pixels are high points on the terrain and black pixels are low points.
;                  You will inevitablly have to rescale the terrain during the call or after it is created.
;                  The Terrain object is a special dynamic mesh whose resoloution is reduced in the distance to reduce the number of triangles it consumes.
; Related .......: _IrrScaleTexture
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddTerrain($s_Path, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_VertexAlpha = 255, $i_VertexRed = 255, $i_VertexGreen = 255, $i_VertexBlue = 255, $i_Smoothing = 0, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddTerrain", "str", $s_Path, "float", $f_PosX, "float", $f_PosY, "float", $f_PosZ, "float", $f_RotX, "float", $f_RotY, "float", $f_RotZ, "float", $f_ScaleX, "float", $f_ScaleY, "float", $f_ScaleZ, "int", $i_VertexAlpha, "int", $i_VertexRed, "int", $i_VertexGreen, "int", $i_VertexBlue, "int", $i_Smoothing, "int", $i_MaxLOD, "int", $i_PatchSize)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddTerrain


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddTerrainTile
; Description ...: Creates a tilable terrain object from a gray scale bitmap where bright pixels are high points on the terrain and black pixels are low points.
; Syntax.........: _IrrAddTerrainTile($h_Image, $i_TileSize = 256, $i_DataX = 0, $i_DataY = 0, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_Smoothing = 1, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
; Parameters ....: $h_Image - File loaded with _IrrGetImage and containing a gray scale image used to define the contours of the surface.
;                  $i_TileSize - Size of the terrain independantly of the size of the image used to create it.
;                  $i_DataX -
;                  $i_DataY -
;                  $f_PosX, $f_PosY, $f_PosZ - Defines the position of the terrain.
;                  $f_RotX, $f_RotY, $f_RotZ - Defines the rotation of the terrain.
;                  $f_ScaleX, $f_ScaleY, $f_ScaleZ - Defines the scale of the terrain.
;                  $i_Smoothing - Defines whether the contours of the surface of the terrain are smoothed over.
;                  $i_MaxLOD, $i_PatchSize - control the properties of the level of detail calculations applied to the terrain,
;                  |It is recommended that these are left at default values.
;                  |<br><u>Valid values for $i_PatchSize:</u>
;                  |$ETPS_9 (patch size of 9, at most, use 4 levels of detail with this patch size)
;                  |$ETPS_17 (patch size of 17, at most, use 5 levels of detail with this patch size)
;                  |$ETPS_33 (patch size of 33, at most, use 6 levels of detail with this patch size)
;                  |$ETPS_65 (patch size of 65, at most, use 7 levels of detail with this patch size)
;                  |$ETPS_129 (patch size of 129, at most, use 8 levels of detail with this patch size)
; Return values .: Success - Handle of a terrain node.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: You will inevitablly have to rescale the terrain during the call or after it is created.
;                  The Terrain object is a special dynamic mesh whose resoloution is reduced in the distance to reduce the number of triangles it consumes.
;                  Unlike the origonal terrain object the tileable terrain object can be attached to other terrain tile objects without being affected by cracks between tiles caused by the level of detail mechanism.
;                  When working with tile terrains it should be noted that the terrain is internally divided up into patches that are patchSize - 1 and there is always one invisible row of patches at the top and left of the terrain.
;                  Essentially this means that if your tileSize is 128 x 128 the visible size of your terrain will be 112 x 112 (with a patchSize of ETPS_17)
;                  Note: Tiled Terrain object can be automatically control with the Zone Manager objects please refer to them for further details.
; Related .......: _IrrGetImage
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrAddTerrainTile($h_Image, $i_TileSize = 256, $i_DataX = 0, $i_DataY = 0, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_Smoothing = 1, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddTerrainTile", "UINT_PTR", $h_Image, "int", $i_TileSize, _
			"int", $i_DataX, "int", $i_DataY, "float", $f_PosX, "float", $f_PosY, "float", $f_PosZ, _
			"float", $f_RotX, "float", $f_RotY, "float", $f_RotZ, "float", _
			$f_ScaleX, "float", $f_ScaleY, "float", $f_ScaleZ, "int", $i_Smoothing, "int", $i_MaxLOD, "int", $i_PatchSize)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddTerrainTile



; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddSphericalTerrain
; Description ...: Creates a spherical terrain that represents a planetary body.
; Syntax.........: _IrrAddSphericalTerrain($s_TopPath, $s_FrontPath, $s_BackPath, $s_LeftPath, $s_RightPath, $s_BottomPath, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_VertexAlpha = 255, $i_VertexRed = 255, $i_VertexGreen = 255, $i_VertexBlue = 255, $i_Smoothing = 0, $i_Spherical = 0, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
; Parameters ....: $s_TopPath - Path of gray scale bitmap where bright pixels are high points on the terrain and black pixels are low points.
;                  $s_FrontPath - Path of gray scale bitmap where bright pixels are high points on the terrain and black pixels are low points.
;                  $s_BackPath - Path of gray scale bitmap where bright pixels are high points on the terrain and black pixels are low points.
;                  $s_LeftPath - Path of gray scale bitmap where bright pixels are high points on the terrain and black pixels are low points.
;                  $s_RightPath - Path of gray scale bitmap where bright pixels are high points on the terrain and black pixels are low points.
;                  $s_BottomPath - Path of gray scale bitmap where bright pixels are high points on the terrain and black pixels are low points.
;                  $f_PosX, $f_PosY, $f_PosZ - Defines the position of the spherical terrain.
;                  $f_RotX, $f_RotY, $f_RotZ - Defines the rotation of the spherical terrain.
;                  $f_ScaleX, $f_ScaleY, $f_ScaleZ - Defines the scale of the spherical terrain.
;                  $i_VertexAlpha, $i_VertexRed, $i_VertexGreen, $i_VertexBlue - Set the vertex color of all the verticies in the spherical terrain (0 ~ 255).
;                  $i_Smoothing - Defines whether the contours of the surface of the terrain are smoothed over.
;                  $i_Spherical - ???
;                  $i_MaxLOD, $i_PatchSize - control the properties of the level of detail calculations applied to the terrain,
;                  |It is recommended that these are left at default values.
;                  |<br><u>Valid values for $i_PatchSize:</u>
;                  |$ETPS_9 (patch size of 9, at most, use 4 levels of detail with this patch size)
;                  |$ETPS_17 (patch size of 17, at most, use 5 levels of detail with this patch size)
;                  |$ETPS_33 (patch size of 33, at most, use 6 levels of detail with this patch size)
;                  |$ETPS_65 (patch size of 65, at most, use 7 levels of detail with this patch size)
;                  |$ETPS_129 (patch size of 129, at most, use 8 levels of detail with this patch size)
; Return values .: Success - Handle to a spherical terrain node.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: When using this terrain it is better to think of it as a cube rather than a sphere,
;                  in fact it is a cube that is distorted so that its surface becomes spherical,
;                  like a cube it has a top, bottom, left, right, front and back and co-ordinates are thought of as being at position X,Y on cube face N.
;                  In someways this makes working with placing things on the object simpler as you can think of it as six flat surfaces.
;                  When creating heightmaps for the faces of the terrain you will need to ensure that the height of pixels at the edge of adjoining sides of
;                  the terrain are the same otherwise large visible cracks will appear at the edges of the faces,
;                  the easiest way to do this is to create terrain texture and then copy and/or rotate it onto its adjacent face.
;                  You can get some suprisingly effective planets and asteroids with textures as small as 32x32 but the object also runs well with a terrain size at the maximum 256 x 256.
; Related .......: _IrrScaleSphericalTexture, _IrrSetSphericalTerrainTexture, _IrrLoadSphericalTerrainVertexColor
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrAddSphericalTerrain($s_TopPath, $s_FrontPath, $s_BackPath, $s_LeftPath, $s_RightPath, $s_BottomPath, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_VertexAlpha = 255, $i_VertexRed = 255, $i_VertexGreen = 255, $i_VertexBlue = 255, $i_Smoothing = 0, $i_Spherical = 0, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddSphericalTerrain", _
			"str", $s_TopPath, "str", $s_FrontPath, "str", $s_BackPath, "str", $s_LeftPath, "str", $s_RightPath, "str", $s_BottomPath, _
			"float", $f_PosX, "float", $f_PosY, "float", $f_PosZ, "float", $f_RotX, "float", $f_RotY, "float", $f_RotZ, _
			"float", $f_ScaleX, "float", $f_ScaleY, "float", $f_ScaleZ, _
			"int", $i_VertexAlpha, "int", $i_VertexRed, "int", $i_VertexGreen, "int", $i_VertexBlue, _
			"int", $i_Smoothing, "int", $i_Spherical, "int", $i_MaxLOD, "int", $i_PatchSize)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddSphericalTerrain


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetTerrainHeight
; Description ...: Get the height of a point on a terrain.
; Syntax.........: _IrrGetTerrainHeight($h_Terrain, $f_X, $f_Z)
; Parameters ....: $h_Terrain - Handle to terrain node.
;                  $f_X - X position
;                  $f_Z - Z position
; Return values .: Success - Y float value height of the terrain at the requested position.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: This can be a particularlly fast and accurate way to move an object over a terrain.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetTerrainHeight($h_Terrain, $f_X, $f_Z)
	Local $aResult
	$aResult = DllCall($_irrDll, "float:cdecl", "IrrGetTerrainHeight", "ptr", $h_Terrain, "float", $f_X, "float", $f_Z)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetTerrainHeight


; #FUNCTION# =============================================================================================================
; Name...........: _IrrScaleTexture
; Description ...: Specifies the scaling of a terrain object detail texture
; Syntax.........: _IrrScaleTexture($h_Terrain, $f_X, $f_Y)
; Parameters ....: $h_Terrain - Handle of a terrain object
;                  $f_X, $f_Y - Scaling values for detail texture along x and y axis
; Return values .: success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: As a terrain object is a particularly huge mesh when textures are applied to it they look extremely pixelated.
;                  To get over this effect a terrain object can have two materials applied to it, one to give general surface color and a second that is copied across the surface like tiles to give a rough detailed texture.
;                  This call specifies the scaling of this detail texture.
; Related .......: _IrrAddTerrain
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrScaleTexture($h_Terrain, $f_X, $f_Y)
	DllCall($_irrDll, "none:cdecl", "IrrScaleTexture", "ptr", $h_Terrain, "float", $f_X, "float", $f_Y)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrScaleTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetTerrainTileHeight
; Description ...: Get the height of a point on a terrain tile.
; Syntax.........: _IrrGetTerrainTileHeight($h_Terrain, $f_X, $f_Z)
; Parameters ....: $h_Terrain - Handle to terrain node.
;                  $f_X - X position
;                  $f_Z - Z position
; Return values .: Success - Y float value height of the terrain tile at the requested position.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: This can be a particularlly fast and accurate way to move an object over a terrain.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetTerrainTileHeight($h_Terrain, $f_X, $f_Z)
	Local $aResult
	$aResult = DllCall($_irrDll, "float:cdecl", "IrrGetTerrainTileHeight", "ptr", $h_Terrain, "float", $f_X, "float", $f_Z)
	If @error Then Return Seterror(1, 0, False)
    Return Seterror(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetTerrainTileHeight


; #FUNCTION# =============================================================================================================
; Name...........: _IrrScaleTileTexture
; Description ...: This call specifies the scaling of the detail texture.
; Syntax.........: _IrrScaleTileTexture($h_Terrain, $f_X, $f_Y)
; Parameters ....: $h_Terrain - Handle to terrain node.
;                  $f_X - X position
;                  $f_Y - Y position
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: As a tile terrain object is a particularly huge mesh when textured are applied to it they look extremely pixelated.
;                  To get over this effect a terrain object can have two materials applied to it,
;                  one to give general surface color and a second that is copied across the surface like tiles to give a rough detailed texture.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrScaleTileTexture($h_Terrain, $f_X, $f_Y)
	DllCall($_irrDll, "none:cdecl", "IrrScaleTileTexture", "UINT_PTR", $h_Terrain, "float", $f_X, "float", $f_Y)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrScaleTileTexture


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrAttachTile
; Description ...: Set the adjacent tile to this tile node.
; Syntax.........: _IrrAttachTile($h_Terrain, $h_Neighbor, $i_Edge)
; Parameters ....: $h_Terrain - Handle to terrain node.
;                  $h_Neighbor - Handle to a neighbouring terrain node.
;                  $i_Edge - Can be one of the following; $TOP_EDGE, $BOTTOM_EDGE, $LEFT_EDGE, $RIGHT_EDGE
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: To avoid cracks appearing between tiles, tiles need to know which tiles are their neighbours and which edges they are attached too.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrAttachTile($h_Terrain, $h_Neighbor, $i_Edge)
	DllCall($_irrDll, "none:cdecl", "IrrAttachTile", "UINT_PTR", $h_Terrain, "UINT_PTR", $h_Neighbor, "uint", $i_Edge)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrAttachTile


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetTileStructure
; Description ...: Loads the tile structure from the supplied image file.
; Syntax.........: _IrrSetTileStructure($h_Terrain, $h_Image, $i_X, $i_Y)
; Parameters ....: $h_Terrain - Handle to terrain node.
;                  $h_Image - Handle to an image object as returned by _IrrGetImage (read remarks for further info)
;                  $i_X - X position to load the structure from a specific point on the bitmap.
;                  $i_Y - Y position to load the structure from a specific point on the bitmap.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: Unlike the image in the origonal call to create a terrain tile this image has a different structure.
;                  The image should be in RGBA format, the alpha value is used to set the height of the terrain and the RGB values are used to set the color of the verticies.
;                  This can either be for loading precalculated lighting into the scene or it can be used with the new IRR_EMT_FOUR_DETAIL_MAP material type to
;                  define the weight of each of the greyscale detail maps in the RGB channels of the detail map.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetTileStructure($h_Terrain, $h_Image, $i_X, $i_Y)
	DllCall($_irrDll, "none:cdecl", "IrrSetTileStructure", "UINT_PTR", $h_Terrain, "UINT_PTR", $h_Image, "int", $i_X, "int", $i_Y)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetTileStructure



; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetTileColor
; Description ...: Loads the tile vertex colors from the supplied image file.
; Syntax.........: _IrrSetTileColor($h_Terrain, $h_Image, $i_X=0, $i_Y=0)
; Parameters ....: $h_Terrain - Handle to terrain node.
;                  $h_Image - Handle to an image object as returned by _IrrGetImage (read remarks for further info)
;                  $i_X - X position to load the structure from a specific point on the bitmap.
;                  $i_Y - Y position to load the structure from a specific point on the bitmap.
; Return values .: Success - True
;                  Failure - False
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: The RGB values are used to set the color of the verticies.
;                  This can either be for loading precalculated lighting into the scene or it can be used with the new IRR_EMT_FOUR_DETAIL_MAP material type
;                  to define the weight of each of the greyscale detail maps in the RGB channels of the detail map.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetTileColor($h_Terrain, $h_Image, $i_X=0, $i_Y=0)
	DllCall($_irrDll, "none:cdecl", "IrrSetTileColor", "UINT_PTR", $h_Terrain, "UINT_PTR", $h_Image, "int", $i_X, "int", $i_Y)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetTileColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrScaleSphericalTexture
; Description ...: This call specifies the scaling of the detail texture.
; Syntax.........: _IrrScaleSphericalTexture($h_Terrain, $f_X, $f_Y)
; Parameters ....: $h_Terrain - Handle to a spherical terrain node.
;                  $i_X - X position
;                  $i_Y - Y position
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: As the surfaces of a sphereical terrain object are a particularly huge mesh when textures are applied to them they look extremely pixelated.
;                  To get over this effect a spherical terrain object can have two materials applied to it,
;                  one to give general surface color and a second that is copied across the surface like tiles to give a rough detailed texture.
; Related .......: _IrrAddSphericalTerrain, _IrrSetSphericalTerrainTexture, _IrrLoadSphericalTerrainVertexColor
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrScaleSphericalTexture($h_Terrain, $f_X, $f_Y)
	DllCall($_irrDll, "none:cdecl", "IrrScaleSphericalTexture", "UINT_PTR", $h_Terrain, "float", $f_X, "float", $f_Y)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrScaleSphericalTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetSphericalTerrainTexture
; Description ...: Apply six textures to the surface of a spherical terrain.
; Syntax.........: _IrrSetSphericalTerrainTexture($h_Terrain, $h_Top, $h_Front, $h_Back, $h_Left, $h_Right, $h_Bottom, $i_MaterialIndex = 0)
; Parameters ....: $h_Terrain - Handle to a spherical terrain node.
;                  $h_Top - Handle to texture as returned by _IrrGetTexture
;                  $h_Front - Handle to texture as returned by _IrrGetTexture
;                  $h_Back - Handle to texture as returned by _IrrGetTexture
;                  $h_Left - Handle to texture as returned by _IrrGetTexture
;                  $h_Right- Handle to texture as returned by _IrrGetTexture
;                  $h_Bottom - Handle to texture as returned by _IrrGetTexture
;                  $i_MaterialIndex - By using the material index you can set the color or the detail maps.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrGetTexture, _IrrAddSphericalTerrain, _IrrLoadSphericalTerrainVertexColor, _IrrScaleSphericalTexture
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetSphericalTerrainTexture($h_Terrain, $h_Top, $h_Front, $h_Back, $h_Left, $h_Right, $h_Bottom, $i_MaterialIndex = 0)
	DllCall($_irrDll, "none:cdecl", "IrrSetSphericalTerrainTexture", "UINT_PTR", $h_Terrain, "ptr", $h_Top, "ptr", $h_Front, "ptr", $h_Back, "ptr", $h_Left, "ptr", $h_Right, "ptr", $h_Bottom, "int", $i_MaterialIndex)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetSphericalTerrainTexture


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrLoadSphericalTerrainVertexColor
; Description ...: Apply six images to the vertex colors of the faces.
; Syntax.........: _IrrLoadSphericalTerrainVertexColor($h_Terrain, $h_Top, $h_Front, $h_Back, $h_Left, $h_Right, $h_Bottom)
; Parameters ....: $h_Terrain - Handle to a spherical terrain node.
;                  $h_Top - Handle to image as returned by _IrrGetImage
;                  $h_Front - Handle to image as returned by _IrrGetImage
;                  $h_Back - Handle to image as returned by _IrrGetImage
;                  $h_Left - Handle to image as returned by _IrrGetImage
;                  $h_Right- Handle to image as returned by _IrrGetImage
;                  $h_Bottom - Handle to image as returned by _IrrGetImage
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: This is useful for setting the verticies so that they can be used with simple terrain spattering as described in tiled terrains.
; Related .......: _IrrGetImage, _IrrAddSphericalTerrain, _IrrScaleSphericalTexture, _IrrSetSphericalTerrainTexture
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrLoadSphericalTerrainVertexColor($h_Terrain, $h_Top, $h_Front, $h_Back, $h_Left, $h_Right, $h_Bottom)
	DllCall($_irrDll, "none:cdecl", "IrrLoadSphericalTerrainVertexColor", "ptr", $h_Terrain, "ptr", $h_Top, "ptr", $h_Front, "ptr", $h_Back, "ptr", $h_Left, "ptr", $h_Right, "ptr", $h_Bottom)
	Return Seterror(@error, 0, @error = 0)
EndFunc   ;==>_IrrLoadSphericalTerrainVertexColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetSphericalTerrainSurfacePosition
; Description ...: Get the surface position of a logical point on the terrain.
; Syntax.........: _IrrGetSphericalTerrainSurfacePosition($h_Terrain, $i_Face, $f_LogicalX, $f_LogicalZ)
; Parameters ....: $h_Terrain - Handle to a Spherical Terrain object as returned by _IrrAddSphericalTerrain function
;                  $i_Face - Integer value of a Face to calculate for.
;                  $f_LogicalX - Float value for Logical X position.
;                  $f_LogicalZ - Float value for Logical Z position.
; Return values .: Success - 1D Array with the returned values
;                  |$Array[0] = X float value
;                  |$Array[1] = Y float value
;                  |$Array[2] = Z float value
;                  Failure - False and set @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: You supply a face number and a logical X, Y position on that face and this call will return the height of that point on the terrain sphere.
;                  X, Y, Z is returned in a 1D Array.
;                  Note: By subtracting the center of the sphere from this co-ordinate and converting this vector to angles you can find the upward direction of the point on the surface.
; Related .......: _IrrAddSphericalTerrain
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetSphericalTerrainSurfacePosition($h_Terrain, $i_Face, $f_LogicalX, $f_LogicalZ)
    Local $aResult, $aReturn[3]
    $aResult = DllCall($_irrDll, "none:cdecl", "IrrGetSphericalTerrainSurfacePosition", "ptr", $h_Terrain, "int", $i_Face, "float", $f_LogicalX, "float", $f_LogicalZ, "float*", 0, "float*", 0, "float*", 0)
    If @error Or Not IsArray($aResult) Then Return SetError(1, 0, False)
    For $i = 0 To 2
        $aReturn[$i] = $aResult[$i + 5]
    Next
    Return SetError(0, 0, $aReturn)
EndFunc   ;==>_IrrGetSphericalTerrainSurfacePosition


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetSphericalTerrainSurfacePositionAndAngle
; Description ...: Get the surface position and angle of a logical point on the terrain.
; Syntax.........: _IrrGetSphericalTerrainSurfacePositionAndAngle($h_Terrain, $i_Face, $f_LogicalX, $f_LogicalZ)
; Parameters ....: $h_Terrain - Handle to a spherical terrain node.
;                  $i_Face - Integer value of a Face to calculate for.
;                  $f_LogicalX - Float value for Logical X position.
;                  $f_LogicalZ - Float value for Logical Z position.
; Return values .: Success - 2D Array with position and angle in float values
;                  |$Array[0][0] = X Position
;                  |$Array[0][1] = Y Position
;                  |$Array[0][2] = Z Position
;                  |$Array[1][0] = X Rotation
;                  |$Array[1][1] = Y Rotation
;                  |$Array[1][2] = Z Rotation
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: This is not the normal of the surface but essentially the angles to the gravitational center.
; Related .......: _IrrAddSphericalTerrain
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetSphericalTerrainSurfacePositionAndAngle($h_Terrain, $i_Face, $f_LogicalX, $f_LogicalZ)
	Local $aResult, $aReturn[2][3]
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetSphericalTerrainSurfacePositionAndAngle", "ptr", $h_Terrain, "int", $i_Face, "float", $f_LogicalX, "float", $f_LogicalZ, "float*", 0, "float*", 0, "float*", 0, "float*", 0, "float*", 0, "float*", 0)
	If @error Then Return SetError(1, 0, False)
	For $i =  0 To 2
		$aReturn[0][$i] = $aResult[$i + 5]
		$aReturn[1][$i] = $aResult[$i + 8]
	Next
    Return SetError(0, 0, $aReturn)
EndFunc   ;==>_IrrGetSphericalTerrainSurfacePositionAndAngle


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetSphericalTerrainLogicalSurfacePosition
; Description ...: Convert a co-ordinate into a logical Spherical terrain position.
; Syntax.........: _IrrGetSphericalTerrainLogicalSurfacePosition($h_Terrain, $f_PosX, $f_PosY, $f_PosZ)
; Parameters ....: $h_Terrain - Handle to a spherical terrain node.
;                  $f_PosX - X Position
;                  $f_PosY - Y Position
;                  $f_PosZ - Z Position
; Return values .: Success - 1D Array with Face number and Logical X & Z position
;                  |$Array[0] = Face number
;                  |$Array[1] = Logical X position
;                  |$Array[2] = Logical Z position
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: Thanks for the example from "David" posted on Infinity-Universe forum
;                  Please note that this calculation is not 100% accurate, it is advised that the translation is done at altitude and the difference either ignored or blended as the observer decends.
;                  Note: The height above the surface can be calculated simply by calculating the length of the center of the planet to the surface and then the center of the planet to the space coordinate and subracting the two.
;                  Note: The momentum could be calculated by converting two samples and then measing the difference in height and X and Z on the face
; Related .......: _IrrAddSphericalTerrain
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetSphericalTerrainLogicalSurfacePosition($h_Terrain, $f_PosX, $f_PosY, $f_PosZ)
	Local $aResult, $aReturn[3]
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetSphericalTerrainLogicalSurfacePosition", "ptr", $h_Terrain, "float", $f_PosX, "float", $f_PosY, "float", $f_PosZ, "int*", 0, "float*", 0, "float*", 0)
	If @error Then Return SetError(1, 0, False)
	For $i = 0 To 2
		$aReturn[$i] = $aResult[$i + 5]
	Next
	Return SetError(0, 0, $aReturn)
EndFunc   ;==>_IrrGetSphericalTerrainLogicalSurfacePosition
