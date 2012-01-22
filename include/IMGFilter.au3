#include-once
#include <gdiplus.au3>

;~ 	Orginal by: TheShadowAE


Func _or($bmp,$bmp2)
	If $bmp = 0 Then Return SetError(2, 1, 0)
	Local $w = _GDIPlus_ImageGetWidth($bmp), $h = _GDIPlus_ImageGetHeight($bmp)
	Local $hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bmp)
	Local $dc, $xbmp, $ptr
	$dc = _CreateNewBmp32($w, $h, $ptr, $xbmp)
	Local $xdc = _WinAPI_CreateCompatibleDC(0)
	_WinAPI_SelectObject($xdc, $hbmp)
	_WinAPI_BitBlt($dc, 0, 0, $w, $h, $xdc, 0, 0, $SRCCOPY)
	Local $dc2, $hbmp2, $ptr2
	$dc2 = _CreateNewBmp32($w, $h, $ptr2, $hbmp2)
	Local $xbmp2 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bmp2)
	Local $xdc2 = _WinAPI_CreateCompatibleDC(0)
	_WinAPI_SelectObject($xdc2, $xbmp2)
	_WinAPI_BitBlt($dc2, 0, 0, $w, $h, $xdc2, 0, 0, $SRCCOPY)
	Local $tCodeBuffer = DllStructCreate("byte[46]") ;reserve Memory for opcodes
	DllStructSetData($tCodeBuffer, 1,"0x8B5C24048B4C24088B44240CC1E8029090909090F30F6F03F30F6F09660FEBC1F30F7F0383C31083C1104875E7C3") ;write opcodes into memory
	DllCall("user32.dll", "none", "CallWindowProcW", "ptr", DllStructGetPtr($tCodeBuffer),"ptr",$ptr,"ptr",$ptr2,"int",$w*$h,"int",0)
	Local $ret = _GDIPlus_BitmapCreateFromHBITMAP($xbmp)
	_WinAPI_DeleteDC($xdc)
	_WinAPI_DeleteDC($xdc2)
	_DeleteBitmap32($dc,$ptr,$xbmp)
	_DeleteBitmap32($dc2,$ptr2,$hbmp2)
	_WinAPI_DeleteObject($hbmp)
	_WinAPI_DeleteObject($xbmp2)
	Return $ret
EndFunc

Func _PlusMinus($bmp,$plus,$minus)
	If $bmp = 0 Then Return SetError(2, 1, 0)
	Local $w = _GDIPlus_ImageGetWidth($bmp), $h = _GDIPlus_ImageGetHeight($bmp)
	Local $hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bmp)
	Local $dc, $xbmp, $ptr
	$dc = _CreateNewBmp32($w, $h, $ptr, $xbmp)
	Local $xdc = _WinAPI_CreateCompatibleDC(0)
	_WinAPI_SelectObject($xdc, $hbmp)
	_WinAPI_BitBlt($dc, 0, 0, $w, $h, $xdc, 0, 0, $SRCCOPY)
	Local $tCodeBuffer = DllStructCreate("byte[161]") ;reserve Memory for opcodes
	DllStructSetData($tCodeBuffer, 1,"0x8B5C24088B4C24048B030FB6D00FB674240C0FB67C241001F229FABE00000000BFFF0000000F42D681FAFF0000000F4FD788D00FB6D40FB674240D0FB67C241101F229FABE00000000BFFF0000000F42D681FAFF0000000F4FD788D4BA0000FF0021C225FFFF00FFC1EA100FB674240E0FB67C241201F229FABE00000000BFFF0000000F42D681FAFF0000000F4FD7C1E21009D0890383C304490F8568FFFFFFC3") ;write opcodes into memory
	DllCall("user32.dll", "none", "CallWindowProcW", "ptr", DllStructGetPtr($tCodeBuffer),"int", $w*$h, "ptr", $ptr,"int",$plus,"int",$minus)
	Local $ret = _GDIPlus_BitmapCreateFromHBITMAP($xbmp)
	_WinAPI_DeleteDC($xdc)
	_DeleteBitmap32($dc,$ptr,$xbmp)
	_WinAPI_DeleteObject($hbmp)
	Return $ret
EndFunc

Func _Mosaik1($bmp,$g)
	If $bmp = 0 Then Return SetError(2, 1, 0)
	Local $w = _GDIPlus_ImageGetWidth($bmp), $h = _GDIPlus_ImageGetHeight($bmp)
	If $g<1 Then $g=1
	If $g>$w Then $g=$w
	If $g>$h Then $g=$h
	$w-=Mod($w,$g)
	$h-=Mod($h,$g)
	Local $hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bmp)
	Local $dc, $xbmp, $ptr
	$dc = _CreateNewBmp32($w, $h, $ptr, $xbmp)
	Local $xdc = _WinAPI_CreateCompatibleDC(0)
	_WinAPI_SelectObject($xdc, $hbmp)
	_WinAPI_BitBlt($dc, 0, 0, $w, $h, $xdc, 0, 0, $SRCCOPY)
	Local $tCodeBuffer = DllStructCreate("byte[82]") ;reserve Memory for opcodes
	DllStructSetData($tCodeBuffer, 1,"0x8B5C240C8B7C24106BFF048B7424046BF6048B5424088B4C24048B035351528B54241C8B4C241C890383C3044975F801F329FB4A75ED5A595B01FB2B4C241075D98B442410480FAFC601C32B54241075C5C3") ;write opcodes into memory
	DllCall("user32.dll", "none", "CallWindowProcW", "ptr", DllStructGetPtr($tCodeBuffer),"int", $w,"int",$h, "ptr", $ptr,"int",$g)
	Local $ret = _GDIPlus_BitmapCreateFromHBITMAP($xbmp)
	_WinAPI_DeleteDC($xdc)
	_DeleteBitmap32($dc,$ptr,$xbmp)
	_WinAPI_DeleteObject($hbmp)
	Return $ret
EndFunc


Func _Mosaik2($bmp, $gr)
	If $bmp = 0 Then Return SetError(2, 1, 0)
	If $gr<1 Then $gr=1
	$bmp=_GDIPlus_BitmapCloneArea($bmp,0,0,_GDIPlus_ImageGetWidth($bmp),_GDIPlus_ImageGetHeight($bmp),$GDIP_PXF32ARGB)
	Local $w = _GDIPlus_ImageGetWidth($bmp), $h = _GDIPlus_ImageGetHeight($bmp)
	Local $c, $br = _GDIPlus_BrushCreateSolid(), $gra = _GDIPlus_ImageGetGraphicsContext($bmp)
	For $y = 0 To $h Step $gr
		For $x = 0 To $w Step $gr
			Local $r = 0, $g = 0, $b = 0
			For $xx = $x To $x + $gr
				For $yy = $y To $y + $gr
					$c = Hex(_GDIPlus_BitmapGetPixel($bmp, $xx, $yy),6)
					$r += Dec(StringMid($c, 1, 2))
					$g += Dec(StringMid($c, 3, 2))
					$b += Dec(StringMid($c, 5, 2))
				Next
			Next
			$r /=$gr^2
			$g /=$gr^2
			$b /=$gr^2
			If $r>255 Then $r=255
			If $g>255 Then $g=255
			If $b>255 Then $b=255
			$c = "0xFF" & Hex($r, 2) & Hex($g, 2) & Hex($b, 2)
			_GDIPlus_BrushSetSolidColor($br, $c)
			_GDIPlus_GraphicsFillRect($gra, $x, $y, $gr, $gr, $br)
		Next
	Next
	_GDIPlus_BrushDispose($br)
	_GDIPlus_GraphicsDispose($gra)
	Return $bmp
EndFunc   ;==>_Mosaik2

Func _Schwarzweiss($bmp)
	If $bmp = 0 Then Return SetError(2, 1, 0)
	Local $w = _GDIPlus_ImageGetWidth($bmp), $h = _GDIPlus_ImageGetHeight($bmp)
	Local $hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bmp)
	Local $dc, $xbmp, $ptr
	$dc = _CreateNewBmp32($w, $h, $ptr, $xbmp)
	Local $xdc = _WinAPI_CreateCompatibleDC(0)
	_WinAPI_SelectObject($xdc, $hbmp)
	_WinAPI_BitBlt($dc, 0, 0, $w, $h, $xdc, 0, 0, $SRCCOPY)
	Local $tCodeBuffer = DllStructCreate("byte[63]") ;reserve Memory for opcodes
	DllStructSetData($tCodeBuffer, 1, "0x8B5C24046BDB0483EB04035C24088B7424048B0B0FB6C10FB6FD01F8C1E9080FB6FD01F8B90300000031D2F7F188C288C6C1E20888C2891383EB044E75D4C3") ;write opcodes into memory
	DllCall("user32.dll", "none", "CallWindowProcW", "ptr", DllStructGetPtr($tCodeBuffer), "int", $w * $h, "ptr", $ptr, "int", 0, "int", 0)
	Local $ret = _GDIPlus_BitmapCreateFromHBITMAP($xbmp)
	_WinAPI_DeleteDC($xdc)
	_DeleteBitmap32($dc,$ptr,$xbmp)
	_WinAPI_DeleteObject($hbmp)
	Return $ret
EndFunc   ;==>_Schwarzweiss

Func _Negativ($bmp)
	If $bmp = 0 Then Return SetError(2, 1, 0)
	Local $w = _GDIPlus_ImageGetWidth($bmp), $h = _GDIPlus_ImageGetHeight($bmp)
	Local $hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bmp)
	Local $dc, $xbmp, $ptr
	$dc = _CreateNewBmp32($w, $h, $ptr, $xbmp)
	Local $xdc = _WinAPI_CreateCompatibleDC(0)
	_WinAPI_SelectObject($xdc, $hbmp)
	_WinAPI_BitBlt($dc, 0, 0, $w, $h, $xdc, 0, 0, $SRCCOPY)
	Local $tCodeBuffer = DllStructCreate("byte[55]") ;reserve Memory for opcodes
	DllStructSetData($tCodeBuffer, 1, "0xB8FFFFFFFF660F6EC8660F70C9008B5C24046BDB0483EB10035C24088B442404C1E80290F30F6F03660FEFC1F30F7F0383EB104875EEC3") ;write opcodes into memory
	DllCall("user32.dll", "none", "CallWindowProcW", "ptr", DllStructGetPtr($tCodeBuffer), "int", $w * $h, "ptr", $ptr, "int", 0, "int", 0)
	Local $ret = _GDIPlus_BitmapCreateFromHBITMAP($xbmp)
	_WinAPI_DeleteDC($xdc)
	_DeleteBitmap32($dc,$ptr,$xbmp)
	_WinAPI_DeleteObject($hbmp)
	Return $ret
EndFunc   ;==>_Negativ

Func _BitBild($bmp)
	If $bmp = 0 Then Return SetError(2, 1, 0)
	Local $w = _GDIPlus_ImageGetWidth($bmp), $h = _GDIPlus_ImageGetHeight($bmp)
	Local $hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bmp)
	Local $dc, $xbmp, $ptr
	$dc = _CreateNewBmp32($w, $h, $ptr, $xbmp)
	Local $xdc = _WinAPI_CreateCompatibleDC(0)
	_WinAPI_SelectObject($xdc, $hbmp)
	_WinAPI_BitBlt($dc, 0, 0, $w, $h, $xdc, 0, 0, $SRCCOPY)
	Local $tCodeBuffer = DllStructCreate("byte[66]") ;reserve Memory for opcodes
	DllStructSetData($tCodeBuffer, 1, "0x8B5C24046BDB0483EB04035C2408B87D0100008B7424048B0B0FB6D10FB6FD01FAC1E9080FB6FD01FA39C27E0EBAFFFFFFFF891383EB044E75DDC3BA000000FFEBF0") ;write opcodes into memory
	DllCall("user32.dll", "none", "CallWindowProcW", "ptr", DllStructGetPtr($tCodeBuffer), "int", $w * $h, "ptr", $ptr, "int", 0, "int", 0)
	Local $ret = _GDIPlus_BitmapCreateFromHBITMAP($xbmp)
	_WinAPI_DeleteDC($xdc)
	_DeleteBitmap32($dc,$ptr,$xbmp)
	_WinAPI_DeleteObject($hbmp)
	Return $ret
EndFunc   ;==>_BitBild


Func _FarbFilter($bmp, $f)
	If $bmp = 0 Then Return SetError(2, 1, 0)
	If $f <> "R" And $f <> "G" And $f <> "B" Then Return SetError(1, 1, 0)
	Local $w = _GDIPlus_ImageGetWidth($bmp), $h = _GDIPlus_ImageGetHeight($bmp)
	Local $hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bmp)
	Local $and
	Switch $f
		Case "R"
			$and = 0xFF0000
		Case "G"
			$and = 0x00FF00
		Case "B"
			$and = 0x0000FF
	EndSwitch
	Local $dc, $xbmp, $ptr
	$dc = _CreateNewBmp32($w, $h, $ptr, $xbmp)
	Local $xdc = _WinAPI_CreateCompatibleDC(0)
	_WinAPI_SelectObject($xdc, $hbmp)
	_WinAPI_BitBlt($dc, 0, 0, $w, $h, $xdc, 0, 0, $SRCCOPY)
	Local $tCodeBuffer = DllStructCreate("byte[62]") ;reserve Memory for opcodes
	DllStructSetData($tCodeBuffer, 1, "0x8B5C24046BDB0483EB04035C24088B44240C9BDBE3660F6EC8660F70C90031D28B442404B904000000F7F1F30F6F03660FDBC1F30F7F0383EB104875EEC3") ;write opcodes into memory
	DllCall("user32.dll", "none", "CallWindowProcW", "ptr", DllStructGetPtr($tCodeBuffer), "int", $w * $h, "ptr", $ptr, "int", $and, "int", 0)
	Local $ret = _GDIPlus_BitmapCreateFromHBITMAP($xbmp)
	_WinAPI_DeleteDC($xdc)
	_DeleteBitmap32($dc,$ptr,$xbmp)
	_WinAPI_DeleteObject($hbmp)
	Return $ret
EndFunc   ;==>_FarbFilter

Func _FarbFilterAnd($bmp, $and)
	If $bmp = 0 Then Return SetError(2, 1, 0)
	Local $w = _GDIPlus_ImageGetWidth($bmp), $h = _GDIPlus_ImageGetHeight($bmp)
	Local $hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bmp)
	Local $dc, $xbmp, $ptr
	$dc = _CreateNewBmp32($w, $h, $ptr, $xbmp)
	Local $xdc = _WinAPI_CreateCompatibleDC(0)
	_WinAPI_SelectObject($xdc, $hbmp)
	_WinAPI_BitBlt($dc, 0, 0, $w, $h, $xdc, 0, 0, $SRCCOPY)
	Local $tCodeBuffer = DllStructCreate("byte[56]") ;reserve Memory for opcodes
	DllStructSetData($tCodeBuffer, 1,"0x8B5C24046BDB0483EB04035C24088B44240C9BDBE3660F6EC8660F70C9008B442404C1E802F30F6F03660FDBC1F30F7F0383EB104875EEC3") ;write opcodes into memory
	DllCall("user32.dll", "none", "CallWindowProcW", "ptr", DllStructGetPtr($tCodeBuffer), "int", $w * $h, "ptr", $ptr, "dword", $and, "int", 0)
	; _assembleit("none","Farbfilter","int", $w * $h, "ptr", $ptr, "dword", $and)
	Local $ret = _GDIPlus_BitmapCreateFromHBITMAP($xbmp)
	_WinAPI_DeleteDC($xdc)
	_DeleteBitmap32($dc,$ptr,$xbmp)
	_WinAPI_DeleteObject($hbmp)
	Return $ret
EndFunc   ;==>_FarbFilterAnd


Func _CreateNewBmp32($iwidth, $iheight, ByRef $ptr, ByRef $hbmp) ;erstellt leere 32-bit-Bitmap; Rückgabe $HDC und $ptr und handle auf die Bitmapdaten
	$hcdc = _WinAPI_CreateCompatibleDC(0) ;Desktop-Kompatiblen DeviceContext erstellen lassen
	$tBMI = DllStructCreate($tagBITMAPINFO) ;Struktur der Bitmapinfo erstellen und Daten eintragen
	DllStructSetData($tBMI, "Size", DllStructGetSize($tBMI) - 4);Structgröße abzüglich der Daten für die Palette
	DllStructSetData($tBMI, "Width", $iwidth)
	DllStructSetData($tBMI, "Height", -$iheight) ;minus =standard = bottomup
	DllStructSetData($tBMI, "Planes", 1)
	DllStructSetData($tBMI, "BitCount", 32) ;32 Bit = 4 Bytes => AABBGGRR
	$adib = DllCall('gdi32.dll', 'ptr', 'CreateDIBSection', 'hwnd', 0, 'ptr', DllStructGetPtr($tBMI), 'uint', 0, 'ptr*', 0, 'ptr', 0, 'uint', 0)
	$hbmp = $adib[0] ;hbitmap handle auf die Bitmap, auch per GDI+ zu verwenden
	$ptr = $adib[4] ;pointer auf den Anfang der Bitmapdaten, vom Assembler verwendet
	_WinAPI_SelectObject($hcdc, $hbmp) ;objekt hbitmap in DC
	Return $hcdc ;DC der Bitmap zurückgeben
EndFunc   ;==>_CreateNewBmp32

Func _DeleteBitmap32($dc, $ptr, $hbmp)
	_WinAPI_DeleteDC($dc)
	_WinAPI_DeleteObject($hbmp)
	$ptr = 0
EndFunc   ;==>_DeleteBitmap32

Func _GDIPlus_ImageShow($img, $titel = "", $x = -1, $y = -1)
	;TheShadowAE
	If $img = 0 Then Return -1
	Local $wx, $wy
	If $x = -1 Or $x > @DesktopWidth - 50 Then
		$x = _GDIPlus_ImageGetWidth($img)
		If $x > @DesktopWidth - 50 Then $x = @DesktopWidth - 50
	EndIf
	If $y = -1 Or $y > @DesktopWidth - 50 Then
		$y = _GDIPlus_ImageGetHeight($img)
		If $y > @DesktopWidth - 50 Then $y = @DesktopWidth - 50
	EndIf
	$wx = $x
	$wy = $y
	Local $gui = GUICreate($titel, $x, $y, Default, Default, BitOR(0x00C00000, 0x00080000)) ;bitor($WS_CAPTION,$WS_SYSMENU)
	GUISetState(@SW_SHOW, $gui)
	Local $gra = _GDIPlus_GraphicsCreateFromHWND($gui)
	Local $buffer = _GDIPlus_BitmapCreateFromGraphics($wx, $wy, $gra)
	Local $backgra = _GDIPlus_ImageGetGraphicsContext($buffer)
	_GDIPlus_GraphicsSetSmoothingMode($backgra, 2)
	_GDIPlus_GraphicsClear($backgra)
	_GDIPlus_GraphicsDrawImageRect($backgra, $img, 0, 0, $wx, $wy)
	While GUIGetMsg() <> -3 ;$GUI_EVENT_CLOSE
		_WinAPI_RedrawWindow($gui, "", "", 1280) ;$RDW_UPDATENOW + $RDW_FRAME
		_GDIPlus_GraphicsDrawImageRect($gra, $buffer, 0, 0, $wx, $wy)
		Sleep(10)
	WEnd
	_GDIPlus_GraphicsDispose($backgra)
	_GDIPlus_BitmapDispose($buffer)
	_GDIPlus_GraphicsDispose($gra)
	GUIDelete($gui)
	Return 1
EndFunc   ;==>_GDIPlus_ImageShow




