@echo OFF

set AUC_DIR="C:\Users\ottyajp\Desktop\videotemp\aviutl100\auc"
set AVU_DIR="C:\Users\ottyajp\Desktop\videotemp\aviutl100"
set AUI_INDEXER="C:\Users\ottyajp\Desktop\videotemp\aviutl100\aui_indexer_0.03\aui_indexer.exe"
set AUI_DIR="C:\Users\ottyajp\Desktop\videotemp\aviutl100\Plugins\lwinput.aui"

:LOOP
if "%~dpnx1" == "" goto END
echo Input: %~dpnx1
if "%~x1" == ".ts" goto TS
if "%~x1" == ".mp4" goto MP4

:TS
	C:\dtv\BonTsDemux\BonTsDemuxC.exe -i "%~dpnx1"
	if %ERRORLEVEL% == 1 echo error occurred.
	echo Generating index file...
	%AUI_INDEXER% -aui %AUI_DIR% "%~dpn1.m2v" > NUL
	echo executing aviutl...
	%AUC_DIR%\auc_exec %AVU_DIR%\aviutl.exe > NUL
	timeout /t 3 > NUL
	echo load m2v...
	%AUC_DIR%\auc_open "%~dpn1.m2v"
	timeout /t 3 > NUL
	echo load wav...
	%AUC_DIR%\auc_audioadd "%~dpn1.wav"
	goto WAIT

:MP4
	echo Generating index file...
	%AUI_INDEXER% -aui %AUI_DIR% "%~dpnx1" > NUL
	echo executing aviutl...
	%AUC_DIR%\auc_exec %AVU_DIR%\aviutl.exe > NUL
	timeout /t 3 > NUL
	echo load mp4...
	%AUC_DIR%\auc_open "%~dpn1.mp4"
	timeout /t 3 > NUL
	goto WAIT

:WAIT
echo waiting aviutl terminate...
:WAIT_AVIUTL_TERM
	%AUC_DIR%\auc_findwnd > NUL
	if not %ERRORLEVEL%==0 (
		timeout /t 1 > NUL
		goto WAIT_AVIUTL_TERM
	)
echo;
shift
goto LOOP

:END
echo all jobs were completed.
timeout /t -1