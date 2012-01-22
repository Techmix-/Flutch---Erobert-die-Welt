#include <Array.au3>
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Description=Session Loader V2.0
#AutoIt3Wrapper_Res_Field=Compiled by|Techmix
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Opt("TrayIconHide", 1)


; Einstellungen:
Global $_UseSciTE_Session, $_RunHelpFile, $_ShowDir, $_UseKoda_Session
$_UseSciTE_Session 	= 1
$_RunHelpFile		= 1
$_ShowDir			= 1
$_UseKoda_Session	= 0

; Globals
Global $_Au3Path, $_SciTEPath
$tmp = StringSplit(@AutoItExe, "\", 1)
for $i = 1 to $tmp[0]
	$_Au3Path &= $tmp[$i]&"\"
	if $tmp[$i] = "AutoIt3" then ExitLoop
Next
$_SciTEPath = $_Au3Path & "SciTE\SciTE.exe -loadsession:"


if $_UseSciTE_Session 	= 1 Then 	; Projekt-Session öffnen
	Local $a_Files, $_Session, $_WorkingDir, $_TempReplace
	$a_Files = FileOpen(@ScriptDir&"\SciTE.session", 0)
	$i=0
	While 1
		$temp = FileReadLine(@ScriptDir&"\SciTE.session", $i)
		If @error = -1 Then ExitLoop
		if StringInStr($temp, "buffer.1.path", 1) then ExitLoop
		$i+=1
	Wend
	$_Session = FileRead($a_Files)
	FileClose($a_Files)
	; Den alten Session-Pfad auslesen
	$tmp = StringSplit($temp, '=', 1)
	$tmp = StringSplit($tmp[2], "\", 1)
	for $i = 1 to $tmp[0] -1
		$_TempReplace &= $tmp[$i]&"\"
	Next
	$_TempReplace = StringTrimRight($_TempReplace, 1)
	; Die Session Datei anpassen
	$_Session = StringReplace($_Session, $_TempReplace, @ScriptDir)
	$a_Files = FileOpen(@ScriptDir&"\SciTE.session", 10)
	FileWrite($a_Files, $_Session)
	FileClose($a_Files)
	; SciTE Session starten
	$tmp=StringSplit(@ScriptDir, '\', 1)
	for $i = 1 to $tmp[0]
		$_WorkingDir &= $tmp[$i] & "\\"
	Next
	$_WorkingDir &= "SciTE.session"
	Run($_SciTEPath & $_WorkingDir, "", @SW_MAXIMIZE)
	while 1
		Sleep(1)
		if _ProcessGetCPU(ProcessExists("SciTE.exe"), 100) = 0 then ExitLoop
	WEnd
EndIf

if $_RunHelpFile		= 1 Then  	; Helpfile öffnen
	WinSetState(ProcessExists("SciTE.exe"), "", @SW_MAXIMIZE)
	send("{F1}")
	while 1
		Sleep(1)
		if _ProcessGetCPU(ProcessExists("AutoIt3Help.exe"), 33) = 0 then ExitLoop
	WEnd
	WinSetState(ProcessExists("AutoIt3Help.exe"), "", @SW_MINIMIZE)
EndIf

if $_ShowDir 			= 1 Then  	; Projektordner öffnen
	Run(@ComSpec & ' /c ' &'explorer.exe ' & @ScriptDir, "", @SW_HIDE)
EndIf

if $_UseKoda_Session	= 1 Then  	; Koda GUI Session öffnen
	Local $_GUIPath, $search, $a_Files[1]
	; GUI´s erfassen
	$_GUIPath = @ScriptDir & "\include\Mapper GUI´s\"
	$search = FileFindFirstFile($_GUIPath&"*.kxf")
	While 1
		$a_Files[UBound($a_Files)-1] = FileFindNextFile($search)
		If @error Then ExitLoop
		ReDim $a_Files[UBound($a_Files)+1]
	WEnd
	FileClose($search)
	ReDim $a_Files[UBound($a_Files)-1]
	;
	for $i = 0 to UBound($a_Files)-1
		ShellExecute($_GUIPath & $a_Files[$i], "", @SW_MAXIMIZE)
		while 1
			Sleep(1)
			if _ProcessGetCPU(ProcessExists("FD.exe"), 1) = 0 then ExitLoop
		WEnd
	Next
	WinSetState(ProcessExists("FD.exe"), "", @SW_MINIMIZE)
;~ 	WinSetState("[ACTIVE]", "", @SW_MINIMIZE)
EndIf

WinSetState(ProcessExists("SciTE.exe"), "", @SW_MAXIMIZE)



Func _ProcessGetCPU($strProcess = "Idle", $iSampleTime = 500, $sComputerName = @ComputerName)
;		by novaTek    ...ver 0.11
;~      All Parameters are optional:
;~          - Idle process will be measured if first parameter is not set
;~          - 500 ms is default sample time
;~          - This computer will be measured by default
;~      Process could be string ("Name") or PID number (1234)
;~      When more processes are runing with identical name, then the last opened is measured (use PID for other)
;~      For NORMAL MODE(one time measuring): set Sample value to more than 0 ms
;~                  ( average CPU usage will be measured during sleep time within function)
;~      For LOOP MODE (continuous measuring): set Sample value to 0 ms
;~                  ( average CPU usage will be measured between two function calls )
;~      Total CPU usage is: ( 100 - _ProcessGetCPU())
;~      Success: Returns process CPU usage in percent
;~              (Sample times below 100ms may return inaccurate results)
;~              (First result in Loop Mode may be inaccurate,
;~               because first call in Loop Mode is only used to trigger counters)
;~      Failure: Returns -1  ( wrong process name or PID )
;~             : Returns -2  ( WMI service not found or Computer not found)

    if $strProcess = "" then $strProcess = "Idle"
    if $iSampleTime = "" AND IsString($iSampleTime) then $iSampleTime = 500
    if $sComputerName = "" then $sComputerName = @ComputerName

    if not IsDeclared("iP1") AND $iSampleTime = 0 then      ;first time in loop mode
        $bFirstTimeInLoopMode = 1
    else
        $bFirstTimeInLoopMode = 0
    endif

    if not IsDeclared("iP1") then
        assign("iP1", 0, 2)     ;forced global declaration first time
        assign("iT1", 0, 2)
    endif


    $objWMIService = ObjGet("winmgmts:\\" & $sComputerName & "\root\CIMV2")
    if @error then return -2

    if number($strProcess) then
        $strProcess = " WHERE IDProcess = '" & $strProcess & "'"
    else
        $strProcess = " WHERE Name = '" & $strProcess & "'"
    endif

    if $iSampleTime OR $bFirstTimeInLoopMode = 1 then   ;skip if Loop Mode, but not First time

        $colItems = $objWMIService.ExecQuery ("SELECT * FROM Win32_PerfRawData_PerfProc_Process" & $strProcess)

        For $objItem In $colItems

            $iT1 = $objItem.TimeStamp_Sys100NS
            $iP1 = $objItem.PercentProcessorTime
        next

        if  $objItem = "" then return -1    ;process not found

        sleep($iSampleTime)
    endif


    $colItems = $objWMIService.ExecQuery ("SELECT * FROM Win32_PerfRawData_PerfProc_Process" & $strProcess)

    For $objItem In $colItems

        $iP2 = $objItem.PercentProcessorTime
        $iT2 = $objItem.TimeStamp_Sys100NS
    next

    if  $objItem = "" then return -1    ;process not found

    $iPP = ($iP2 - $iP1)
    $iTT = ($iT2 - $iT1)

    if $iTT = 0 Then return 100     ;do not divide by 0

    $iCPU = round( ($iPP/$iTT) * 100, 0)

    $iP1 = $iP2
    $iT1 = $iT2
    Return $iCPU
EndFunc
