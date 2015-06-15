@ECHO off
CLS

REM --------------------------------------------------------------------
REM 
REM Usage: dfirt.bat <output location>
REM        dfirt.bat f:\
REM        dfirt.bat f:\evidence
REM
REM --------------------------------------------------------------------

REM --------------------------------------------------------------------
REM             Allow The Use Of Multi-Colored Text
REM --------------------------------------------------------------------

setlocal EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
color 0B


REM --------------------------------------------------------------------
REM                         Set Version Number
REM --------------------------------------------------------------------
SET VER=5
SET DST=%1
SET DELAY=%2

IF NOT "%DST%"==""   GOTO dst_ok
ECHO.
ECHO LOCAL data collection tool v%VER%
ECHO Please provide the destination path for the output
ECHO.
ECHO usage: dfirt ^<dst drive^> [delay]
ECHO.
ECHO eg. dfirt F:\
ECHO.
GOTO end

:dst_ok
SET DELAY=1

 
 
REM --------------------------------------------------------------------
REM                 User Awareness ANTI SNAFU Section
REM --------------------------------------------------------------------

ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO. 
call :color 0c "********************************************************************************"
ECHO.
call :color 0c "*                                                                              *"
ECHO.
call :color 0c "*                                CAUTION                                       *"
ECHO.
call :color 0c "*                                                                              *"
ECHO.
call :color 0c "********************************************************************************"
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
call :color 0e "Information will be written to the following path: " 
ECHO %1
ECHO.
call :color 0e "Please ensure this is what you want "
call :color 0c "(BE REALLY SURE)"
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
PAUSE


REM --------------------------------------------------------------------
REM                   Pre-Processing
REM --------------------------------------------------------------------


ECHO     Initializing Pre-Processing
ECHO [%DATE% %TIME%] Initializing Pre-Processing >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO.
ECHO. 
CALL :color 0F "                           (Pre-Processing Phase 1 of 5)" 
ECHO [%DATE% %TIME%] (Pre-Processing Phase 1 of 5) >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO.

MKDIR %DST%\%COMPUTERNAME% 
ECHO [%DATE% %TIME%] Creating Output Folder >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

ECHO                                Obtaining Host Name  
ECHO [%DATE% %TIME%] Obtaining Host Name >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO.


IF "%COMPUTERNAME%"==""  GOTO need_host
SET NAME=%COMPUTERNAME%
GOTO host_ok


:need_host
SET /P name=    Unable To Retrieve Host Name, Provide The Hostname: 
ECHO [%DATE% %TIME%] Unable To Retrieve Host Name, User Promted for Hostname >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
IF "%NAME%"=="" GOTO need_host


:host_ok
ECHO.
ECHO.


CALL :color 0F "                           (Pre-Processing Phase 2 of 5)"  
ECHO [%DATE% %TIME%] (Pre-Processing Phase 2 of 5) >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO.
ECHO                               Creating Directories
ECHO [%DATE% %TIME%] Creating Directories >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO.

IF NOT EXIST %DST%\%NAME%     (ECHO     ERROR: Can't create directory %DST%\%NAME% && ECHO [%DATE% %TIME%] Unable to Create Directory %DST%\%NAME% >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log && GOTO end)

MKDIR %DST%\%NAME%\vol
ECHO [%DATE% %TIME%] Directory Created %DST%\%NAME%\vol >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

IF NOT EXIST %DST%\%NAME%\vol (ECHO     ERROR: Can't create directory %DST%\%NAME%\vol && ECHO [%DATE% %TIME%] Unable to Create Directory %DST%\%NAME%\vol >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log && GOTO end)


MKDIR %DST%\%NAME%\mem
ECHO [%DATE% %TIME%] Directory Created %DST%\%NAME%\mem >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

IF NOT EXIST %DST%\%NAME%\mem (ECHO     ERROR: Can't create directory %DST%\%NAME%\mem && ECHO [%DATE% %TIME%] Unable to Create Directory %DST%\%NAME%\mem >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log && GOTO end)


MKDIR %DST%\%NAME%\image
ECHO [%DATE% %TIME%] Directory Created %DST%\%NAME%\image >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

IF NOT EXIST %DST%\%NAME%\image (ECHO     ERROR: Can't create directory %DST%\%NAME%\image && ECHO [%DATE% %TIME%] Unable to Create Directory %DST%\%NAME%\image >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log && GOTO end)


MKDIR %DST%\%NAME%\timeline
ECHO [%DATE% %TIME%] Directory Created %DST%\%NAME%\timeline >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

IF NOT EXIST %DST%\%NAME%\timeline (ECHO     ERROR: Can't create directory %DST%\%NAME%\timeline && ECHO [%DATE% %TIME%] Unable to Create Directory %DST%\%NAME%\timeline >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log && GOTO end)


MKDIR %DST%\%NAME%\reg
ECHO [%DATE% %TIME%] Directory Created %DST%\%NAME%\reg >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

IF NOT EXIST %DST%\%NAME%\reg (ECHO     ERROR: Can't create directory %DST%\%NAME%\malware && ECHO [%DATE% %TIME%] Unable to Create Directory %DST%\%NAME%\reg >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log && GOTO end)
 

ECHO.
ECHO.
CALL :color 0F "                           (Pre-Processing Phase 3 of 5)" 
ECHO [%DATE% %TIME%] (Pre-Processing Phase 3 of 5) >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

ECHO.
ECHO                                Evidence Selection
ECHO [%DATE% %TIME%] Evidence Selection >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

ECHO.
:SETOSTYPE
SET /P OSTYPE=	Is this Windows XP? [Y/N]
ECHO [%DATE% %TIME%] Is this Windows XP? [Y/N]: %OSTYPE% >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

IF /I "%OSTYPE%"=="N" goto SETOSTYPE_PASS
IF /I NOT "%OSTYPE%"=="Y" goto SETOSTYPE
:SETOSTYPE_PASS


:GETIMAGE
SET /P GETIMAGE=    Would you like to create a disk image? [Y/N]
ECHO [%DATE% %TIME%] Would you like to create a disk image? [Y/N]: %GETIMAGE% >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

IF /I "%GETIMAGE%"=="N" goto GETIMAGE_PASS
IF /I NOT "%GETIMAGE%"=="Y" goto GETIMAGE
:GETIMAGE_PASS

:MEM
SET /P MEM=    Do you want to collect memory? [Y/N]
ECHO [%DATE% %TIME%] Do you want to collect memory? [Y/N]: %MEM% >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

IF /I "%MEM%"=="N" goto MEM_PASS
IF /I NOT "%MEM%"=="Y" goto MEM
:MEM_PASS


IF /I "%MEM%" EQU "y" GOTO systype


ECHO.
ECHO.
CALL :color 0F "                           (Pre-Processing Phase 4 of 5)" 
ECHO [%DATE% %TIME%] (Pre-Processing Phase 4 of 5) >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO.                         
ECHO                           Skipping Memory Acquisition
ECHO [%DATE% %TIME%] Skipping Memory Acquisition >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
GOTO grab_vol


:systype
ECHO.
ECHO.
CALL :color 0F "                           (Pre-Processing Phase 4 of 5)" 
ECHO [%DATE% %TIME%] (Pre-Processing Phase 4 of 5) >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

ECHO.
ECHO                                Memory Acquisition
ECHO [%DATE% %TIME%] Memory Acquisition >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

ECHO.
@SET /P MEM2=    Is this a 32 bit system? [Y/N]
ECHO [%DATE% %TIME%] Is this a 32 bit system? [Y/N]: %MEM2% >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
@IF /I "%MEM2%" EQU "y" GOTO grabmem32
@IF /I "%MEM2%" EQU "n" GOTO grabmem64
@GOTO grabmem32


:grabmem32
ECHO Capturing 32 Bit Memory
ECHO [%DATE% %TIME%] Capturing 32 Bit Memory >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

.\DFIR_win32dd.exe /m 1 /r /a /f %DST%\%NAME%\mem\mem.img
ECHO [%DATE% %TIME%] ".\DFIR_win32dd.exe /m 1 /r /a /f %DST%\%NAME%\mem\mem.img" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

.\DFIR_DELAY.EXE 3
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE 3" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

ECHO generating MD5 sum of mem.img
ECHO [%DATE% %TIME%] generating MD5 sum of mem.img >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

.\DFIR_md5deep.exe -b %DST%\%NAME%\mem\mem.img > %DST%\%NAME%\mem\mem.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\mem\mem.img > %DST%\%NAME%\mem\mem.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

GOTO grab_vol


:grabmem64
ECHO Capturing 64 Bit Memory
ECHO [%DATE% %TIME%] Capturing 64 Bit Memory >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

.\DFIR_win64dd.exe /m 0 /r /a /f %DST%\%NAME%\mem\mem.img
ECHO [%DATE% %TIME%] ".\DFIR_win64dd.exe /m 0 /r /a /f %DST%\%NAME%\mem\mem.img">> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

.\DFIR_DELAY.EXE 3
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE 3" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

ECHO generating MD5 sum of mem.img
ECHO [%DATE% %TIME%] generating MD5 sum of mem.img >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

.\DFIR_md5deep.exe -b %DST%\%NAME%\mem\mem.img > %DST%\%NAME%\mem\mem.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\mem\mem.img > %DST%\%NAME%\mem\mem.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
GOTO grab_vol 
 
 
:mem_ok 
ECHO Current Directory - %CD%
ECHO     Memory parsing complete
ECHO [%DATE% %TIME%] "Memory Parsing Complete" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO.


:grab_vol
ECHO.
ECHO.
ECHO                           (Pre-Processing Phase 5 of 5)
ECHO [%DATE% %TIME%] (Pre-Processing Phase 5 of 5) >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

ECHO.
ECHO                            Adminitrative Access Check
ECHO [%DATE% %TIME%] "Administrative ACcess Check" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO.
.\DFIR_isadmin.exe -q
IF %ERRORLEVEL%==1 GOTO     admin_ok 
IF %ERRORLEVEL%==2 ECHO     WARNING: You are logged in as Administrator, but UAC is on... Disable UAC or continue on your own risk! && ECHO [%DATE% %TIME%] "WARNING: You are logged in as Administrator, but UAC is on... Disable UAC or continue on your own risk!" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
IF %ERRORLEVEL%==0 ECHO     WARNING: You are not logged in as Administrator... Log in as Administrator or continue on your own risk! && ECHO [%DATE% %TIME%] "WARNING: You are not logged in as Administrator... Log in as Administrator or continue on your own risk!" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO     WARNING: If you want to stop now, press CTRL+C . . .
PAUSE

 
:admin_ok
ECHO.
ECHO.
ECHO     Administrator Privileges Confirmed
ECHO [%DATE% %TIME%] "Administrator Privileges Confirmed" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

ECHO     Proceding with volatile data acquisition
ECHO [%DATE% %TIME%] "Proceding with volatile data acquisition" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

ECHO.
ECHO.


ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.


REM --------------------------------------------------------------------
REM                         Acquisition Phase
REM --------------------------------------------------------------------

CALL :color 0F "                         ******************************* "
ECHO.
CALL :color 0F "                         (Acquisition Phase Initialized) "
ECHO.
CALL :color 0F "                         ******************************* "
ECHO [%DATE% %TIME%] "*****************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO [%DATE% %TIME%] "Acquisition Phase Initialized" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO [%DATE% %TIME%] "*****************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
.\DFIR_Delay 3
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO.
ECHO.

CALL :color 0F "            **********************************************************"
ECHO.
CALL :color 0F "             (Acquisition Phase 1 of 9 - Listing of Prefetch Entries)"     
ECHO.       
CALL :color 0F "            **********************************************************"


ECHO [%DATE% %TIME%] "********************************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO [%DATE% %TIME%] "(Acquisition Phase 1 of 9 - Listing of Prefetch Entries)" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log
ECHO [%DATE% %TIME%] "********************************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log


ECHO.  
ECHO.
ECHO.


ECHO     Collecting List of Prefetch Entries: ls -latr %systemroot%\prefetch  
ECHO [%DATE% %TIME%] Collecting List of Prefetch Entries: ls -latr %systemroot%\prefetch >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

.\DFIR_ls -latr %systemroot%\prefetch > %DST%\%NAME%\vol\01_PREFETCH_prefetch.txt
ECHO [%DATE% %TIME%] ".\DFIR_ls -latr %systemroot%\prefetch > %DST%\%NAME%\vol\01_PREFETCH_prefetch.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\01_PREFETCH_prefetch.txt > %DST%\%NAME%\vol\01_PREFETCH_prefetch.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\01_PREFETCH_prefetch.txt > %DST%\%NAME%\vol\01_PREFETCH_prefetch.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
 
 
 REM   I need to add a copy of the prefetch files here
 
 
ECHO.
ECHO.
CALL :color 0F "           ************************************************************"     
ECHO.
CALL :color 0F "           (Acquisition Phase 2 of 9 - System Date, Time, and Timezone)"
ECHO.        
CALL :color 0F "           ************************************************************"


ECHO [%DATE% %TIME%] "************************************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "(Acquisition Phase 2 of 9 - System Date, Time, and Timezone)" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "************************************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO.
ECHO.
ECHO.


ECHO      Collecting Date and Time Information
ECHO [%DATE% %TIME%] Collecting Date and Time Information >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Collecting Date: Date /T
ECHO [%DATE% %TIME%] Collecting Date: Date /T >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

Date /T > %DST%\%NAME%\vol\02_DATE-TIME_date-time.txt  
ECHO [%DATE% %TIME%] "Date /T > %DST%\%NAME%\vol\02_DATE-TIME_date-time.txt " >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log                                

ECHO          Collecting Time: Time /T  
ECHO [%DATE% %TIME%] Collecting Time: Time /T >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

Time /T > %DST%\%NAME%\vol\02_DATE-TIME_date-time.txt 
ECHO [%DATE% %TIME%] "Time /T > %DST%\%NAME%\vol\02_DATE-TIME_date-time.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log                                

ECHO          Collecting System Time Zone
ECHO [%DATE% %TIME%] Collecting System Time Zone >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

systeminfo | findstr /C:"Time Zone" > %DST%\%NAME%\vol\02_DATE-TIME_date-time.txt
ECHO [%DATE% %TIME%] "systeminfo | findstr /C:"Time Zone" > %DST%\%NAME%\vol\02_DATE-TIME_date-time.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\02_DATE-TIME_date-time.txt > %DST%\%NAME%\vol\02_DATE-TIME_date-time.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\02_DATE-TIME_date-time.txt > %DST%\%NAME%\vol\02_DATE-TIME_date-time.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%   
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 





ECHO.
ECHO.

CALL :color 0F "                 *****************************************" 
ECHO.    
CALL :color 0F "                 (Acquisition Phase 3 of 9 - Network Data)" 
ECHO.           
CALL :color 0F "                 *****************************************"


ECHO [%DATE% %TIME%] "*****************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "(Acquisition Phase 3 of 9 - Network Data)" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "*****************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO.
ECHO.
ECHO.


ECHO      Collecting Network Status Information
ECHO [%DATE% %TIME%] "Collecting Network Status Information" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
IF /I "%OSTYPE%" EQU "n" GOTO netstat_win7 

ECHO          Network Status 1 of 5: netstat -an   
ECHO [%DATE% %TIME%] Network Status 1 of 5: netstat -an >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_netstat.exe -an > %DST%\%NAME%\vol\03_NETWORK_netstat_an.txt
ECHO [%DATE% %TIME%] ".\DFIR_netstat.exe -an > %DST%\%NAME%\vol\03_NETWORK_netstat_an.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_an.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_an.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_an.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_an.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%                                   
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO          Network Status 2 of 5: netstat -ano   
ECHO [%DATE% %TIME%] Network Status 2 of 5: netstat -ano >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_netstat.exe -ano > %DST%\%NAME%\vol\03_NETWORK_netstat_ano.txt
ECHO [%DATE% %TIME%] ".\DFIR_netstat.exe -ano > %DST%\%NAME%\vol\03_NETWORK_netstat_ano.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_ano.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_ano.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_ano.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_ano.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%                                   
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

 
ECHO          Network Status 3 of 5: netstat -anob
ECHO [%DATE% %TIME%] "Network Status 3 of 5: netstat -anob" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_netstat.exe -anob > %DST%\%NAME%\vol\03_NETWORK_netstat_anob.txt
ECHO [%DATE% %TIME%] ".\DFIR_netstat.exe -anob > %DST%\%NAME%\vol\03_NETWORK_netstat_anob.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_anob.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_anob.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_anob.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_anob.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY% 
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          Network Status 4 of 5: netstat -rn  
ECHO [%DATE% %TIME%] "Network Status 4 of 5: netstat -rn" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_netstat.exe -rn > %DST%\%NAME%\vol\03_NETWORK_netstat_rn.txt
ECHO [%DATE% %TIME%] ".\DFIR_netstat.exe -rn > %DST%\%NAME%\vol\03_NETWORK_netstat_rn.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_rn.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_rn.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_rn.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_rn.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

goto tcpvcon

REM netstat for Windows 7
:netstat_win7 

ECHO          Network Status 1 of 5: netstat -an                
ECHO [%DATE% %TIME%] "ECHO          Network Status 1 of 5: netstat -an" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\win7exes\DFIR_netstat.exe -an > %DST%\%NAME%\vol\03_NETWORK_netstat_an.txt
ECHO [%DATE% %TIME%] ".\win7exes\DFIR_netstat.exe -an > %DST%\%NAME%\vol\03_NETWORK_netstat_an.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_an.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_an.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_an.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_an.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%                                   
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          Network Status 2 of 5: netstat -ano               
ECHO [%DATE% %TIME%] "ECHO          Network Status 2 of 5: netstat -ano" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\win7exes\DFIR_netstat.exe -ano > %DST%\%NAME%\vol\03_NETWORK_netstat_ano.txt
ECHO [%DATE% %TIME%] ".\win7exes\DFIR_netstat.exe -ano > %DST%\%NAME%\vol\03_NETWORK_netstat_ano.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_ano.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_ano.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_ano.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_ano.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%  
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          Network Status 3 of 5: netstat -anob           
ECHO [%DATE% %TIME%] "Network Status 3 of 5: netstat -anob" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\win7exes\DFIR_netstat.exe -anob > %DST%\%NAME%\vol\03_NETWORK_netstat_anob.txt
ECHO [%DATE% %TIME%] ".\win7exes\DFIR_netstat.exe -anob > %DST%\%NAME%\vol\03_NETWORK_netstat_anob.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_anob.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_anob.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_anob.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_anob.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY% 
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          Network Status 4 of 5: netstat -rn  
ECHO [%DATE% %TIME%] "Network Status 4 of 5: netstat -rn" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\win7exes\DFIR_netstat.exe -rn > %DST%\%NAME%\vol\03_NETWORK_netstat_rn.txt
ECHO [%DATE% %TIME%] ".\win7exes\DFIR_netstat.exe -rn > %DST%\%NAME%\vol\03_NETWORK_netstat_rn.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_rn.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_rn.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_netstat_rn.txt > %DST%\%NAME%\vol\03_NETWORK_netstat_rn.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

:tcpvcon

ECHO          Network Status 5 of 5: tcpvcon.exe -can /accepteula 
ECHO [%DATE% %TIME%] "Network Status 5 of 5: tcpvcon.exe -can /accepteula " >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_tcpvcon.exe -can /accepteula > %DST%\%NAME%\vol\03_NETWORK_tcpvcon.csv 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_tcpvcon.exe -can /accepteula > %DST%\%NAME%\vol\03_NETWORK_tcpvcon.csv 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_tcpvcon.csv > %DST%\%NAME%\vol\03_NETWORK_tcpvcon.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_tcpvcon.csv > %DST%\%NAME%\vol\03_NETWORK_tcpvcon.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%                                   
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO      Collecting Open Ports
ECHO [%DATE% %TIME%] "Collecting Open Ports" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO.

ECHO          Open Ports 1 of 2: fport.exe /p      
ECHO [%DATE% %TIME%] "Open Ports 1 of 2: fport.exe /p" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_fport.exe /p > %DST%\%NAME%\vol\03_NETWORK_fport.txt
ECHO [%DATE% %TIME%] ".\DFIR_fport.exe /p > %DST%\%NAME%\vol\03_NETWORK_fport.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_fport.txt > %DST%\%NAME%\vol\03_NETWORK_fport.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_fport.txt > %DST%\%NAME%\vol\03_NETWORK_fport.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          Open Ports 2 of 2: openports.exe -lines -path 
ECHO [%DATE% %TIME%] "Open Ports 2 of 2: openports.exe -lines -path " >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

REM this will crash on x64/64 + DEP-aware boxes ...Althought it will work on Win7 Home...sort of.

.\DFIR_openports.exe -lines -path > %DST%\%NAME%\vol\03_NETWORK_openports.txt
ECHO [%DATE% %TIME%] ".\DFIR_openports.exe -lines -path > %DST%\%NAME%\vol\03_NETWORK_openports.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_openports.txt > %DST%\%NAME%\vol\03_NETWORK_openports.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_openports.txt > %DST%\%NAME%\vol\03_NETWORK_openports.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY% 
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO      Collecting External IP Address
ECHO [%DATE% %TIME%] "Collecting External IP Address" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_wget -q -O - checkip.dyndns.org | .\DFIR_gawk "{print $4,$5,$6}" | .\DFIR_cut -d"<" -f1 > %DST%\%NAME%\vol\03_NETWORK_External_IP_Address.txt 
ECHO [%DATE% %TIME%] ".\DFIR_wget -q -O - checkip.dyndns.org | .\DFIR_gawk "{print $4,$5,$6}" | .\DFIR_cut -d"<" -f1 > %DST%\%NAME%\vol\03_NETWORK_External_IP_Address.txt " >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_External_IP_Address.txt > %DST%\%NAME%\vol\03_NETWORK_External_IP_Address.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_External_IP_Address.txt > %DST%\%NAME%\vol\03_NETWORK_External_IP_Address.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.

ECHO      Collecting RAS Connections: RASconns.exe                  
ECHO [%DATE% %TIME%] "Collecting RAS Connections: RASconns.exe " >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_RASConns.exe > %DST%\%NAME%\vol\03_NETWORK_RASConns.txt
ECHO [%DATE% %TIME%] ".\DFIR_RASConns.exe > %DST%\%NAME%\vol\03_NETWORK_RASConns.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_RASConns.txt > %DST%\%NAME%\vol\03_NETWORK_RASConns.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_RASConns.txt > %DST%\%NAME%\vol\03_NETWORK_RASConns.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%                                   
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO      Collecting ARP Cache: arp.exe -a
ECHO [%DATE% %TIME%] "Collecting ARP Cache: arp.exe -a" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

IF /I  "%OSTYPE%" EQU "n" GOTO arp_win7

.\DFIR_arp.exe -a  > %DST%\%NAME%\vol\03_NETWORK_arp.txt
ECHO [%DATE% %TIME%] ".\DFIR_arp.exe -a  > %DST%\%NAME%\vol\03_NETWORK_arp.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_arp.txt > %DST%\%NAME%\vol\03_NETWORK_arp.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_arp.txt > %DST%\%NAME%\vol\03_NETWORK_arp.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%                                   
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
goto netBIOS

:arp_win7

.\win7exes\DFIR_arp.exe -a  > %DST%\%NAME%\vol\03_NETWORK_arp.txt
ECHO [%DATE% %TIME%] ".\win7exes\DFIR_arp.exe -a  > %DST%\%NAME%\vol\03_NETWORK_arp.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_arp.txt > %DST%\%NAME%\vol\03_NETWORK_arp.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_arp.txt > %DST%\%NAME%\vol\03_NETWORK_arp.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%                                   
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


:netBIOS
ECHO.
ECHO.
ECHO      Collecting NetBIOS information
ECHO [%DATE% %TIME%] "Collecting NetBIOS information" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          NetBIOS Information 1 of 2: nbtstat.exe -c
ECHO [%DATE% %TIME%] "NetBIOS Information 1 of 2: nbtstat.exe -c" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_nbtstat.exe -c > %DST%\%NAME%\vol\03_NETWORK_nbtstat_cache.txt
ECHO [%DATE% %TIME%] ".\DFIR_nbtstat.exe -c > %DST%\%NAME%\vol\03_NETWORK_nbtstat_cache.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_nbtstat_cache.txt   > %DST%\%NAME%\vol\03_NETWORK_nbtstat_cache.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_nbtstat_cache.txt   > %DST%\%NAME%\vol\03_NETWORK_nbtstat_cache.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          NetBIOS Information 2 of 2: nbtstat.exe -S
ECHO [%DATE% %TIME%] "ECHO          NetBIOS Information 2 of 2: nbtstat.exe -S" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_nbtstat.exe -S > %DST%\%NAME%\vol\03_NETWORK_nbtstat_session.txt
ECHO [%DATE% %TIME%] ".\DFIR_nbtstat.exe -S > %DST%\%NAME%\vol\03_NETWORK_nbtstat_session.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_nbtstat_session.txt > %DST%\%NAME%\vol\03_NETWORK_nbtstat_session.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_nbtstat_session.txt > %DST%\%NAME%\vol\03_NETWORK_nbtstat_session.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO      Collecting Logged-On User Data : psloggedon.exe    
ECHO [%DATE% %TIME%] "Collecting Logged-On User Data : psloggedon.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_psloggedon.exe /accepteula > %DST%\%NAME%\vol\03_NETWORK_psloggedon.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_psloggedon.exe /accepteula > %DST%\%NAME%\vol\03_NETWORK_psloggedon.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_psloggedon.txt > %DST%\%NAME%\vol\03_NETWORK_psloggedon.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_psloggedon.txt > %DST%\%NAME%\vol\03_NETWORK_psloggedon.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO      Collecting IPconfig Data
ECHO [%DATE% %TIME%] "Collecting IPconfig Data" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
IF /I "%OSTYPE%" EQU "n" GOTO ipconfig_win7


ECHO          IPconfig Data 1 of 2: ipconfig.exe /all  
ECHO [%DATE% %TIME%] "IPconfig Data 1 of 2: ipconfig.exe /all" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_ipconfig.exe /all  > %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.txt
ECHO [%DATE% %TIME%] ".\DFIR_ipconfig.exe /all  > %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.txt              > %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.md5
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO          IPconfig Data 2 of 2: ipconfig.exe /displaydns  
ECHO [%DATE% %TIME%] "IPconfig Data 2 of 2: ipconfig.exe /displaydns" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_ipconfig.exe /displaydns > %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.txt
ECHO [%DATE% %TIME%] ".\DFIR_ipconfig.exe /displaydns > %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.txt > %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.txt > %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

goto netshare

:ipconfig_win7

ECHO          IPconfig Data 1 of 2: ipconfig.exe /all  
ECHO [%DATE% %TIME%] "IPconfig Data 1 of 2: ipconfig.exe /all" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\win7exes\DFIR_ipconfig.exe /all  > %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.txt
ECHO [%DATE% %TIME%] ".\win7exes\DFIR_ipconfig.exe /all  > %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.txt              > %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.txt              > %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          IPconfig Data 2 of 2: ipconfig.exe /displaydns  
ECHO [%DATE% %TIME%] "IPconfig Data 2 of 2: ipconfig.exe /displaydns" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\win7exes\DFIR_ipconfig.exe /displaydns > %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.txt
ECHO [%DATE% %TIME%] ".\win7exes\DFIR_ipconfig.exe /displaydns > %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.txt > %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.txt > %DST%\%NAME%\vol\03_NETWORK_ipconfig_displaydns.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

:netshare 

ECHO.
ECHO.


ECHO      Collecting Network Share Information
ECHO [%DATE% %TIME%] "Collecting Network Share Information" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Network Share Information 1 of 2: dumpwin - h
ECHO [%DATE% %TIME%] "Network Share Information 1 of 2: dumpwin - h" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_dumpwin.exe -h                                      > %DST%\%NAME%\vol\03_NETWORK_share.txt
ECHO [%DATE% %TIME%] ".\DFIR_dumpwin.exe -h" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_share.txt           > %DST%\%NAME%\vol\03_NETWORK_share.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_share.txt           > %DST%\%NAME%\vol\03_NETWORK_share.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

:netshare
ECHO          Network Share Information 2 of 2: di.exe
ECHO [%DATE% %TIME%] "Network Share Information 2 of 2: di.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_di.exe > %DST%\%NAME%\vol\03_NETWORK_di.txt
ECHO [%DATE% %TIME%] ".\DFIR_di.exe > %DST%\%NAME%\vol\03_NETWORK_di.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_di.txt > %DST%\%NAME%\vol\03_NETWORK_di.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_di.txt > %DST%\%NAME%\vol\03_NETWORK_di.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO.
ECHO.


ECHO      Collecting Network Adapter Mode Information: Promiscdetect.exe
ECHO [%DATE% %TIME%] " Collecting Network Adapter Mode Information: Promiscdetect.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_promiscdetect.exe > %DST%\%NAME%\vol\03_NETWORK_promisc.txt
ECHO [%DATE% %TIME%] ".\DFIR_promiscdetect.exe > %DST%\%NAME%\vol\03_NETWORK_promisc.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_promisc.txt > %DST%\%NAME%\vol\03_NETWORK_promisc.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_promisc.txt > %DST%\%NAME%\vol\03_NETWORK_promisc.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting Local Share Details: net.exe share
ECHO [%DATE% %TIME%] "Collecting Local Share Details: net.exe share" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

IF /I "%OSTYPE%" EQU "n" GOTO net_win7

.\DFIR_net.exe share > %DST%\%NAME%\vol\03_NETWORK_local_shares.txt
ECHO [%DATE% %TIME%] ".\DFIR_net.exe share > %DST%\%NAME%\vol\03_NETWORK_local_shares.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_local_shares.txt > %DST%\%NAME%\vol\03_NETWORK_local_shares.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_local_shares.txt > %DST%\%NAME%\vol\03_NETWORK_local_shares.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

goto phase4

:net_win7

.\win7exes\DFIR_net.exe share > %DST%\%NAME%\vol\03_NETWORK_local_shares.txt
ECHO [%DATE% %TIME%] ".\win7exes\DFIR_net.exe share > %DST%\%NAME%\vol\03_NETWORK_local_shares.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_local_shares.txt > %DST%\%NAME%\vol\03_NETWORK_local_shares.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\03_NETWORK_local_shares.txt > %DST%\%NAME%\vol\03_NETWORK_local_shares.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

:phase4

ECHO.
ECHO.
CALL :color 0F "           ********************************************************"    
ECHO. 
CALL :color 0F "            Acquisition Phase 4 of 9 - Running Process Information " 
ECHO.           
CALL :color 0F "           ********************************************************"
ECHO.
ECHO [%DATE% %TIME%] "******************************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "Acquisition Phase 4 of 9 - Running Process Information" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "******************************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

 
ECHO.     
ECHO.
ECHO      Collecting OS Information  
ECHO [%DATE% %TIME%] "Collecting OS Information" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          OS Information 1 of 2: OSTest.exe   
ECHO [%DATE% %TIME%] "OS Information 1 of 2: OSTest.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_OSTest.exe > %DST%\%NAME%\vol\04_PROCESSES_OSTest.txt
ECHO [%DATE% %TIME%] ".\DFIR_OSTest.exe > %DST%\%NAME%\vol\04_PROCESSES_OSTest.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_OSTest.txt > %DST%\%NAME%\vol\04_PROCESSES_OSTest.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_OSTest.txt > %DST%\%NAME%\vol\04_PROCESSES_OSTest.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          OS Information 2 of 2: systeminfo.exe
ECHO [%DATE% %TIME%] "OS Information 2 of 2: systeminfo.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_systeminfo.exe > %DST%\%NAME%\vol\04_PROCESSES_Systeminfo.txt
ECHO [%DATE% %TIME%] ".\DFIR_systeminfo.exe > %DST%\%NAME%\vol\04_PROCESSES_Systeminfo.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_Systeminfo.txt      > %DST%\%NAME%\vol\04_PROCESSES_Systeminfo.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_Systeminfo.txt      > %DST%\%NAME%\vol\04_PROCESSES_Systeminfo.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting Contents of Clipboard: pclip.exe           
ECHO [%DATE% %TIME%] "Collecting Contents of Clipboard: pclip.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_pclip.exe > %DST%\%NAME%\vol\04_PROCESSES_clipboard.txt
ECHO [%DATE% %TIME%] ".\DFIR_pclip.exe > %DST%\%NAME%\vol\04_PROCESSES_clipboard.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_clipboard.txt > %DST%\%NAME%\vol\04_PROCESSES_clipboard.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_clipboard.txt > %DST%\%NAME%\vol\04_PROCESSES_clipboard.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.

ECHO      Collecting Process Information 
ECHO [%DATE% %TIME%] "Collecting Process Information" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Proccess CLI arguments 1 of 6: cmdline.exe
ECHO [%DATE% %TIME%] "Proccess CLI arguments 1 of 6: cmdline.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_cmdline.exe > %DST%\%NAME%\vol\04_PROCESSES_cmdline.txt
ECHO [%DATE% %TIME%] ".\DFIR_cmdline.exe > %DST%\%NAME%\vol\04_PROCESSES_cmdline.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_cmdline.txt > %DST%\%NAME%\vol\04_PROCESSES_cmdline.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_cmdline.txt > %DST%\%NAME%\vol\04_PROCESSES_cmdline.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO          Proccess Dependencies  2 of 6: dumpwin.exe -p
ECHO [%DATE% %TIME%] "Proccess Dependencies  2 of 6: dumpwin.exe -p" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_dumpwin.exe -p > %DST%\%NAME%\vol\04_PROCESSES_progs.txt
ECHO [%DATE% %TIME%] ".\DFIR_dumpwin.exe -p > %DST%\%NAME%\vol\04_PROCESSES_progs.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_progs.txt > %DST%\%NAME%\vol\04_PROCESSES_progs.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_progs.txt > %DST%\%NAME%\vol\04_PROCESSES_progs.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          Proccess Listing (1) 3 of 6: cprocess.exe /stext
ECHO [%DATE% %TIME%] "Proccess Listing (1) 3 of 6: cprocess.exe /stext" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_cprocess.exe /stext %DST%\%NAME%\vol\04_PROCESSES_cprocess.txt
ECHO [%DATE% %TIME%] ".\DFIR_cprocess.exe /stext %DST%\%NAME%\vol\04_PROCESSES_cprocess.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_cprocess.txt > %DST%\%NAME%\vol\04_PROCESSES_cprocess.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_cprocess.txt > %DST%\%NAME%\vol\04_PROCESSES_cprocess.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO          Proccess Listing (2) 4 of 6: tasklist.exe -V
ECHO [%DATE% %TIME%] "Proccess Listing (2) 4 of 6: tasklist.exe -V" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_tasklist.exe -V > %DST%\%NAME%\vol\04_PROCESSES_proc_usr_map.txt
ECHO [%DATE% %TIME%] ".\DFIR_tasklist.exe -V > %DST%\%NAME%\vol\04_PROCESSES_proc_usr_map.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_proc_usr_map.txt    > %DST%\%NAME%\vol\04_PROCESSES_proc_usr_map.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_proc_usr_map.txt    > %DST%\%NAME%\vol\04_PROCESSES_proc_usr_map.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          Proccess Listing (3) 5 of 6: tlist.exe -v
ECHO [%DATE% %TIME%] "Proccess Listing (3) 5 of 6: tlist.exe -v" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_tlist.exe -v > %DST%\%NAME%\vol\04_PROCESSES_tlist_v.txt
ECHO [%DATE% %TIME%] ".\DFIR_tlist.exe -v > %DST%\%NAME%\vol\04_PROCESSES_tlist_v.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_tlist_v.txt > %DST%\%NAME%\vol\04_PROCESSES_tlist_v.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_tlist_v.txt > %DST%\%NAME%\vol\04_PROCESSES_tlist_v.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO          Proccess Listing (4) 6 of 6: pslist.exe -xmd /accepteula
ECHO [%DATE% %TIME%] "Proccess Listing (4) 6 of 6: pslist.exe -xmd /accepteula" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_pslist.exe -xmd /accepteula  > %DST%\%NAME%\vol\04_PROCESSES_pslist.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_pslist.exe -xmd /accepteula  > %DST%\%NAME%\vol\04_PROCESSES_pslist.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_pslist.txt > %DST%\%NAME%\vol\04_PROCESSES_pslist.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_pslist.txt > %DST%\%NAME%\vol\04_PROCESSES_pslist.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO      Collecting Open Files
ECHO [%DATE% %TIME%] "Collecting Open Files" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Open Files (Local)  1 of 2: openedfilesview.exe
ECHO [%DATE% %TIME%] "Open Files (Local)  1 of 2: openedfilesview.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_openedfilesview.exe /stext %DST%\%NAME%\vol\04_PROCESSES_openfiles.txt
ECHO [%DATE% %TIME%] ".\DFIR_openedfilesview.exe /stext %DST%\%NAME%\vol\04_PROCESSES_openfiles.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_openfiles.txt > %DST%\%NAME%\vol\04_PROCESSES_openfiles.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_openfiles.txt > %DST%\%NAME%\vol\04_PROCESSES_openfiles.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          Open Files (Remote) 2 of 2: psfile.exe /accepteula
ECHO [%DATE% %TIME%] "Open Files (Remote) 2 of 2: psfile.exe /accepteula" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_psfile.exe /accepteula > %DST%\%NAME%\vol\04_PROCESSES_psfile.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_psfile.exe /accepteula > %DST%\%NAME%\vol\04_PROCESSES_psfile.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_psfile.txt > %DST%\%NAME%\vol\04_PROCESSES_psfile.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_psfile.txt > %DST%\%NAME%\vol\04_PROCESSES_psfile.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO      Collecting Open Handle Information
ECHO [%DATE% %TIME%] "Collecting Open Handle Information" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Handle Listing 1 of 2: handle.exe -a /accepteula  
ECHO [%DATE% %TIME%] " Handle Listing 1 of 2: handle.exe -a /accepteula" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_handle.exe -a /accepteula > %DST%\%NAME%\vol\04_PROCESSES_handles.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_handle.exe -a /accepteula > %DST%\%NAME%\vol\04_PROCESSES_handles.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_handles.txt > %DST%\%NAME%\vol\04_PROCESSES_handles.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_handles.txt > %DST%\%NAME%\vol\04_PROCESSES_handles.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          Handle Listing 2 of 2: handle.exe -s /accepteula
ECHO [%DATE% %TIME%] "Handle Listing 2 of 2: handle.exe -s /accepteula" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_handle.exe -s /accepteula > %DST%\%NAME%\vol\04_PROCESSES_handles_stats.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_handle.exe -s /accepteula > %DST%\%NAME%\vol\04_PROCESSES_handles_stats.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_handles_stats.txt > %DST%\%NAME%\vol\04_PROCESSES_handles_stats.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_handles_stats.txt > %DST%\%NAME%\vol\04_PROCESSES_handles_stats.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO      Collecting Driver Details
ECHO [%DATE% %TIME%] "Collecting Driver Details" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Collecting Drivers 1 of 2: drivers.exe
ECHO [%DATE% %TIME%] "Collecting Drivers 1 of 2: drivers.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_drivers.exe > %DST%\%NAME%\vol\04_PROCESSES_drivers.txt
ECHO [%DATE% %TIME%] ".\DFIR_drivers.exe > %DST%\%NAME%\vol\04_PROCESSES_drivers.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_drivers.txt > %DST%\%NAME%\vol\04_PROCESSES_drivers.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_drivers.txt > %DST%\%NAME%\vol\04_PROCESSES_drivers.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          Collecting Drivers 2 of 2: dumpwin.exe -m
ECHO [%DATE% %TIME%] "Collecting Drivers 2 of 2: dumpwin.exe -m" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_dumpwin.exe -m > %DST%\%NAME%\vol\04_PROCESSES_modem.txt
ECHO [%DATE% %TIME%] ".\DFIR_dumpwin.exe -m > %DST%\%NAME%\vol\04_PROCESSES_modem.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_modem.txt > %DST%\%NAME%\vol\04_PROCESSES_modem.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_modem.txt > %DST%\%NAME%\vol\04_PROCESSES_modem.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO          Collecting Network Drivers 1 of 1: sc.exe
ECHO [%DATE% %TIME%] "Collecting Network Drivers 1 of 1: sc.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_sc.exe query type= driver group= NDIS > %DST%\%NAME%\vol\04_PROCESSES_ndis.txt
ECHO [%DATE% %TIME%] ".\DFIR_sc.exe query type= driver group= NDIS > %DST%\%NAME%\vol\04_PROCESSES_ndis.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_ndis.txt > %DST%\%NAME%\vol\04_PROCESSES_ndis.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_ndis.txt > %DST%\%NAME%\vol\04_PROCESSES_ndis.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO      Collecting Service Listings
ECHO [%DATE% %TIME%] "Collecting Service Listings" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Service Listing 1 of 2: psservice.exe
ECHO [%DATE% %TIME%] "Service Listing 1 of 2: psservice.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_psservice.exe /accepteula > %DST%\%NAME%\vol\04_PROCESSES_services.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_psservice.exe /accepteula > %DST%\%NAME%\vol\04_PROCESSES_services.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_services.txt > %DST%\%NAME%\vol\04_PROCESSES_services.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_services.txt > %DST%\%NAME%\vol\04_PROCESSES_services.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO          Service Listing 2 of 2: dumpwin.exe -v
ECHO [%DATE% %TIME%] "Service Listing 2 of 2: dumpwin.exe -v" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_dumpwin.exe -v > %DST%\%NAME%\vol\04_PROCESSES_services_2.txt
ECHO [%DATE% %TIME%] ".\DFIR_dumpwin.exe -v > %DST%\%NAME%\vol\04_PROCESSES_services_2.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_services_2.txt > %DST%\%NAME%\vol\04_PROCESSES_services_2.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_services_2.txt > %DST%\%NAME%\vol\04_PROCESSES_services_2.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO      Collecting Autorun, Startup, and Scheduled Process 
ECHO [%DATE% %TIME%] "Collecting Autorun, Startup, and Scheduled Process" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Autorun Proccess: autorunsc.exe -a -c 
ECHO [%DATE% %TIME%] "Autorun Proccess: autorunsc.exe -a -c " >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_autorunsc.exe -a -c /accepteula > %DST%\%NAME%\vol\04_PROCESSES_autorun.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_autorunsc.exe -a -c /accepteula > %DST%\%NAME%\vol\04_PROCESSES_autorun.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_autorun.txt > %DST%\%NAME%\vol\04_PROCESSES_autorun.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_autorun.txt > %DST%\%NAME%\vol\04_PROCESSES_autorun.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Startup Processes: dumpwin -t
ECHO [%DATE% %TIME%] "Startup Processes: dumpwin -t" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_dumpwin.exe -t > %DST%\%NAME%\vol\04_PROCESSES_startup.txt
ECHO [%DATE% %TIME%] ".\DFIR_dumpwin.exe -t > %DST%\%NAME%\vol\04_PROCESSES_startup.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_startup.txt > %DST%\%NAME%\vol\04_PROCESSES_startup.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_startup.txt > %DST%\%NAME%\vol\04_PROCESSES_startup.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Scheduled Processes: at.exe
ECHO [%DATE% %TIME%] "Scheduled Processes: at.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

IF /I "%OSTYPE%" EQU "n" GOTO at_win7

.\DFIR_at.exe > %DST%\%NAME%\vol\04_PROCESSES_at.txt
ECHO [%DATE% %TIME%] ".\DFIR_at.exe > %DST%\%NAME%\vol\04_PROCESSES_at.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_at.txt > %DST%\%NAME%\vol\04_PROCESSES_at.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_at.txt > %DST%\%NAME%\vol\04_PROCESSES_at.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log  

goto phase5

 :at_win7
 
.\win7exes\DFIR_at.exe > %DST%\%NAME%\vol\04_PROCESSES_at.txt
ECHO [%DATE% %TIME%] ".\win7exes\DFIR_at.exe > %DST%\%NAME%\vol\04_PROCESSES_at.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_at.txt > %DST%\%NAME%\vol\04_PROCESSES_at.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\04_PROCESSES_at.txt > %DST%\%NAME%\vol\04_PROCESSES_at.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

:phase5

ECHO.
ECHO.
CALL :color 0F "              ********************************************" 
ECHO.     
CALL :color 0F "              (Acquisition Phase 5 of 9 -  Hard Disk Data)"  
ECHO.          
CALL :color 0F "              ********************************************"

ECHO [%DATE% %TIME%] "********************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "(Acquisition Phase 5 of 9 -  Hard Disk Data)" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "********************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO.
ECHO.

ECHO      Collecting Alternate Data Streams
ECHO [%DATE% %TIME%] "Collecting Alternate Data Streams" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Alternate Data Streams from C:\
ECHO [%DATE% %TIME%] "Alternate Data Streams from C:\" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_lads.exe C:\ > %DST%\%NAME%\vol\05_HDD_lads_c.txt
ECHO [%DATE% %TIME%] ".\DFIR_lads.exe C:\ > %DST%\%NAME%\vol\05_HDD_lads_c.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_lads_c.txt > %DST%\%NAME%\vol\05_HDD_lads_c.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_lads_c.txt > %DST%\%NAME%\vol\05_HDD_lads_c.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO          Alternate Data Streams from %SystemRoot%
ECHO [%DATE% %TIME%] "Alternate Data Streams from %SystemRoot%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_lads.exe %SystemRoot% > %DST%\%NAME%\vol\05_HDD_lads_systemroot.txt
ECHO [%DATE% %TIME%] ".\DFIR_lads.exe %SystemRoot% > %DST%\%NAME%\vol\05_HDD_lads_systemroot.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_lads_systemroot.txt > %DST%\%NAME%\vol\05_HDD_lads_systemroot.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_lads_systemroot.txt > %DST%\%NAME%\vol\05_HDD_lads_systemroot.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO          Alternate Data Streams from %SystemRoot%\system32
ECHO [%DATE% %TIME%] ".Alternate Data Streams from %SystemRoot%\system32" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_lads.exe %SystemRoot%\System32 > %DST%\%NAME%\vol\05_HDD_lads_system32.txt
ECHO [%DATE% %TIME%] ".\DFIR_lads.exe %SystemRoot%\System32 > %DST%\%NAME%\vol\05_HDD_lads_system32.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_lads_system32.txt > %DST%\%NAME%\vol\05_HDD_lads_system32.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_lads_system32.txt > %DST%\%NAME%\vol\05_HDD_lads_system32.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting Resotre Point Information: sr.exe
ECHO [%DATE% %TIME%] "Collecting Resotre Point Information: sr.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_sr.exe > %DST%\%NAME%\vol\05_HDD_restore_points.txt
ECHO [%DATE% %TIME%] ".\DFIR_sr.exe > %DST%\%NAME%\vol\05_HDD_restore_points.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_restore_points.txt > %DST%\%NAME%\vol\05_HDD_restore_points.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_restore_points.txt > %DST%\%NAME%\vol\05_HDD_restore_points.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO.
ECHO     Directory Listing from C: with Created Times: dir c:\ /TC /S /A /X     
ECHO [%DATE% %TIME%] "Directory Listing from C: with Created Times: dir c:\ /TC /S /A /B" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

dir c:\ /TC /S /A /X > %DST%\%NAME%\vol\05_HDD_dir_c_sax_created.txt 2>&1
ECHO [%DATE% %TIME%] "dir c:\ /TC /S /A /X > %DST%\%NAME%\vol\05_HDD_dir_c_sax_created.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_dir_c_sax_created.txt > %DST%\%NAME%\vol\05_HDD_dir_c_sax_created.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_dir_c_sax_created.txt > %DST%\%NAME%\vol\05_HDD_dir_c_sax_created.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO     Directory Listing from C: with Modified Times: dir c:\ /TW /S /A /X  
ECHO [%DATE% %TIME%] "Directory Listing from C: with Modified Times: dir c:\ /TW /S /A /X" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

dir c:\ /TW /S /A /X > %DST%\%NAME%\vol\05_HDD_dir_c_sax_modified.txt 2>&1
ECHO [%DATE% %TIME%] "c:\ /TW /S /A /X > %DST%\%NAME%\vol\05_HDD_dir_c_sax_modified.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_dir_c_sax_modified.txt > %DST%\%NAME%\vol\05_HDD_dir_c_sax_modified.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_dir_c_sax_modified.txt > %DST%\%NAME%\vol\05_HDD_dir_c_sax_modified.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO.ECHO     Directory Listing from C: with Full Paths: dir c:\ /S /A /B      
ECHO [%DATE% %TIME%] "Directory Listing from C: with Modified Times: dir c:\ /S /A /B" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

dir c:\  /S /A /B > %DST%\%NAME%\vol\05_HDD_dir_c_sab.txt 2>&1
ECHO [%DATE% %TIME%] "c:\ /S /A /B > %DST%\%NAME%\vol\05_HDD_dir_c_sab.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_dir_c_sab.txt > %DST%\%NAME%\vol\05_HDD_dir_c_sab.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\05_HDD_dir_c_sab.txt > %DST%\%NAME%\vol\05_HDD_dir_c_sab.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.

CALL :color 0F "             ***********************************************" 
ECHO.    
CALL :color 0F "             (Acquisition Phase 6 of 9 - System Information)"  
ECHO.          
CALL :color 0F "             ***********************************************"


ECHO [%DATE% %TIME%] "***********************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "(Acquisition Phase 6 of 9 - System Information)" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "***********************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO.
ECHO.
ECHO.

ECHO.
ECHO      Collecting Account Lockout Details: dumpwin.exe -n
ECHO [%DATE% %TIME%] "Collecting Account Lockout Details: dumpwin.exe -n" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_dumpwin.exe -n > %DST%\%NAME%\vol\06_SYSTEMINFO_lockout.txt
ECHO [%DATE% %TIME%] ".\DFIR_dumpwin.exe -n > %DST%\%NAME%\vol\06_SYSTEMINFO_lockout.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_lockout.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_lockout.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_lockout.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_lockout.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO.
ECHO      Collecting Audit Policy: auditpol.exe
ECHO [%DATE% %TIME%] "Collecting Audit Policy: auditpol.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_auditpol.exe > %DST%\%NAME%\vol\06_SYSTEMINFO_audit.txt
ECHO [%DATE% %TIME%] ".\DFIR_auditpol.exe > %DST%\%NAME%\vol\06_SYSTEMINFO_audit.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_audit.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_audit.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_audit.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_audit.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting Login History 1 of 5: netlast.exe -v -null 
ECHO [%DATE% %TIME%] "Collecting Login History 1 of 5: netlast.exe -v -null" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_ntlast.exe -v -null > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast.txt
ECHO [%DATE% %TIME%] ".\DFIR_ntlast.exe -v -null > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting Login History 2 of 5 (successful): netlast.exe -s -v 
ECHO [%DATE% %TIME%] "Collecting Login History 2 of 5 (successful): netlast.exe -s -v" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_ntlast.exe -s -v > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_success.txt
ECHO [%DATE% %TIME%] ".\DFIR_ntlast.exe -s -v > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_success.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_success.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_success.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_success.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_success.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting Login History 3 of 5 (Failed): netlast.exe -f -v  
ECHO [%DATE% %TIME%] "Collecting Login History 3 of 5 (Failed): netlast.exe -f -v" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_ntlast.exe -f -v > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_fail.txt
ECHO [%DATE% %TIME%] ".\DFIR_ntlast.exe -f -v > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_fail.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_fail.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_fail.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_fail.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_fail.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting Login History 4 of 5 (Interactive): netlast.exe -i -v 
ECHO [%DATE% %TIME%] "Collecting Login History 4 of 5 (Interactive): netlast.exe -i -v" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_ntlast.exe -i -v > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_inter.txt
ECHO [%DATE% %TIME%] ".\DFIR_ntlast.exe -i -v > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_inter.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_inter.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_inter.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_inter.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_inter.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting Login History 5 of 5 (Remote): netlast.exe -r -v
ECHO [%DATE% %TIME%] "Collecting Login History 5 of 5 (Remote): netlast.exe -r -v" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_ntlast.exe -r -v > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_remote.txt
ECHO [%DATE% %TIME%] ".\DFIR_ntlast.exe -r -v > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_remote.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_remote.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_remote.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_remote.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_ntlast_remote.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting Group Policy Details: gplist.exe 
ECHO [%DATE% %TIME%] "Collecting Group Policy Details: gplist.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_gplist.exe > %DST%\%NAME%\vol\06_SYSTEMINFO_grp_pol.txt
ECHO [%DATE% %TIME%] ".\DFIR_gplist.exe > %DST%\%NAME%\vol\06_SYSTEMINFO_grp_pol.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_grp_pol.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_grp_pol.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_grp_pol.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_grp_pol.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting System Information: psinfo.exe -h -s -d
ECHO [%DATE% %TIME%] "Collecting System Information: psinfo.exe -h -s -d" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_psinfo.exe -h -s -d /accepteula > %DST%\%NAME%\vol\06_SYSTEMINFO_psinfo.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_psinfo.exe -h -s -d /accepteula > %DST%\%NAME%\vol\06_SYSTEMINFO_psinfo.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_psinfo.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_psinfo.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_psinfo.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_psinfo.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO.
ECHO      Collecing Installed Program Listing: dumpwin -i
ECHO [%DATE% %TIME%] "Collecing Installed Program Listing: dumpwin -i" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_dumpwin.exe -i > %DST%\%NAME%\vol\06_SYSTEMINFO_progs.txt
ECHO [%DATE% %TIME%] ".\DFIR_dumpwin.exe -i > %DST%\%NAME%\vol\06_SYSTEMINFO_progs.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_progs.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_progs.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_progs.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_progs.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO     Collecting Disk Settings: hdd.exe
ECHO [%DATE% %TIME%] "Collecting Disk Settings: hdd.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_hdd.exe > %DST%\%NAME%\vol\06_SYSTEMINFO_hdd.txt
ECHO [%DATE% %TIME%] ".\DFIR_hdd.exe > %DST%\%NAME%\vol\06_SYSTEMINFO_hdd.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_hdd.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_hdd.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_hdd.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_hdd.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO     Collecting USB Device Settings: USBDeview.exe
ECHO [%DATE% %TIME%] "Collecting USB Device Settings: USBDeview.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_USBDeview.exe /stext %DST%\%NAME%\vol\06_SYSTEMINFO_usb.txt
ECHO [%DATE% %TIME%] ".\DFIR_USBDeview.exe /stext %DST%\%NAME%\vol\06_SYSTEMINFO_usb.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_usb.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_usb.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_usb.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_usb.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO     Collecting Volume Information: volume_dump.exe
ECHO [%DATE% %TIME%] "Collecting Volume Information: volume_dump.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_volume_dump.exe > %DST%\%NAME%\vol\volume.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_volume.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_volume_dump.exe > %DST%\%NAME%\vol\volume.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_volume.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_volume.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_volume.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\06_SYSTEMINFO_volume.txt > %DST%\%NAME%\vol\06_SYSTEMINFO_volume.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


CALL :color 0F "               **************************************" 
ECHO.    
CALL :color 0F "               (Acquisition Phase 7 of 9 - Logs Data)"  
ECHO.          
CALL :color 0F "               **************************************"

ECHO [%DATE% %TIME%] "**************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "(Acquisition Phase 7 of 9 - Logs Data)" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "**************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO.

ECHO.
ECHO      Collecting System Logs
ECHO [%DATE% %TIME%] "Collecting System Logs" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Event Logs(Security): psloglist.exe -s -x security
ECHO [%DATE% %TIME%] "Event Logs(Security): psloglist.exe -s -x security" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_psloglist.exe -s -x security /accepteula > %DST%\%NAME%\vol\07_LOGS_evt_sec.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_psloglist.exe -s -x security /accepteula > %DST%\%NAME%\vol\07_LOGS_evt_sec.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_evt_sec.txt > %DST%\%NAME%\vol\07_LOGS_evt_sec.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_evt_sec.txt > %DST%\%NAME%\vol\07_LOGS_evt_sec.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO          Event Logs(System): psloglist.exe -s -x system
ECHO [%DATE% %TIME%] "Event Logs(System): psloglist.exe -s -x system" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_psloglist.exe -s -x system /accepteula > %DST%\%NAME%\vol\07_LOGS_evt_sys.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_psloglist.exe -s -x system /accepteula > %DST%\%NAME%\vol\07_LOGS_evt_sys.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_evt_sys.txt > %DST%\%NAME%\vol\07_LOGS_evt_sys.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_evt_sys.txt > %DST%\%NAME%\vol\07_LOGS_evt_sys.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO          Event Logs(Application): psloglist.exe -s -x application 
ECHO [%DATE% %TIME%] "Event Logs(Application): psloglist.exe -s -x application" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_psloglist.exe -s -x application /accepteula > %DST%\%NAME%\vol\07_LOGS_evt_app.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_psloglist.exe -s -x application /accepteula > %DST%\%NAME%\vol\07_LOGS_evt_app.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_evt_app.txt > %DST%\%NAME%\vol\07_LOGS_evt_app.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_evt_app.txt > %DST%\%NAME%\vol\07_LOGS_evt_app.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Generating Text Copies of Logs (Security):dumpel.exe 
ECHO [%DATE% %TIME%] "Generating Text Copies of Logs (Security):dumpel.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_dumpel.exe -l security -f %DST%\%NAME%\vol\07_LOGS_Security_Event_Log.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_dumpel.exe -l security -f %DST%\%NAME%\vol\07_LOGS_Security_Event_Log.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_Security_Event_Log.txt > %DST%\%NAME%\vol\07_LOGS_Security_Event_Log.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_Security_Event_Log.txt > %DST%\%NAME%\vol\07_LOGS_Security_Event_Log.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Generating Text Copies of Logs (System):dumpel.exe 
ECHO [%DATE% %TIME%] "Generating Text Copies of Logs (System):dumpel.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_dumpel.exe -l system -f %DST%\%NAME%\vol\07_LOGS_System_Event_Log.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_dumpel.exe -l system -f %DST%\%NAME%\vol\07_LOGS_System_Event_Log.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_System_Event_Log.txt > %DST%\%NAME%\vol\07_LOGS_System_Event_Log.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_System_Event_Log.txt > %DST%\%NAME%\vol\07_LOGS_System_Event_Log.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Generating Text Copies of Logs (Application):dumpel.exe
ECHO [%DATE% %TIME%] "Generating Text Copies of Logs (Application):dumpel.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_dumpel.exe -l application -f %DST%\%NAME%\vol\07_LOGS_Application_Event_Log.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_dumpel.exe -l application -f %DST%\%NAME%\vol\07_LOGS_Application_Event_Log.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_Application_Event_Log.txt > %DST%\%NAME%\vol\07_LOGS_Application_Event_Log.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_Application_Event_Log.txt > %DST%\%NAME%\vol\07_LOGS_Application_Event_Log.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


IF NOT EXIST %SystemRoot%\system32\config\secevent.evt goto skip_evt

ECHO.
ECHO           Copying Logs as Evidence 1 of 3: copy secevent.evt
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 1 of 3: copy secevent.evt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy %SystemRoot%\system32\config\secevent.evt %DST%\%NAME%\vol\07_LOGS_secevent.evt
ECHO [%DATE% %TIME%] "%SystemRoot%\system32\config\secevent.evt %DST%\%NAME%\vol\07_LOGS_secevent.evt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_secevent.evt > %DST%\%NAME%\vol\07_LOGS_secevent.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_secevent.evt > %DST%\%NAME%\vol\07_LOGS_secevent.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.

ECHO           Copying Logs as Evidence 2 of 3: copy sysevent.evt
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 2 of 3: copy sysevent.evt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy %SystemRoot%\system32\config\sysevent.evt %DST%\%NAME%\vol\07_LOGS_sysevent.evt
ECHO [%DATE% %TIME%] "%SystemRoot%\system32\config\sysevent.evt %DST%\%NAME%\vol\07_LOGS_sysevent.evt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_sysevent.evt > %DST%\%NAME%\vol\07_LOGS_sysevent.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_sysevent.evt > %DST%\%NAME%\vol\07_LOGS_sysevent.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
 
ECHO.
ECHO           Copying Logs as Evidence 3 of 3: copy appevent.evt
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 3 of 3: copy appevent.evt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy %SystemRoot%\system32\config\appevent.evt %DST%\%NAME%\vol\07_LOGS_appevent.evt
ECHO [%DATE% %TIME%] "%SystemRoot%\system32\config\appevent.evt %DST%\%NAME%\vol\07_LOGS_appevent.evt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_appevent.evt > %DST%\%NAME%\vol\07_LOGS_appevent.md5  
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\07_LOGS_appevent.evt > %DST%\%NAME%\vol\07_LOGS_appevent.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

:skip_evt
IF NOT EXIST %SystemRoot%\System32\winevt\Logs\Application.evtx goto skip_evtx

ECHO.
ECHO           Copying Logs as Evidence 1 of 11: copy "%SystemRoot%\System32\winevt\Logs\Application.evtx"
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 1 of 11: copy "%SystemRoot%\System32\winevt\Logs\Application.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy "%SystemRoot%\System32\winevt\Logs\Application.evtx" "%DST%\%NAME%\vol\07_LOGS_Application.evtx"
ECHO [%DATE% %TIME%] "copy "%SystemRoot%\System32\winevt\Logs\Application.evtx" "%DST%\%NAME%\vol\07_LOGS_Application.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Application.evtx" > "%DST%\%NAME%\vol\07_LOGS_Application.md5"
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Application.evtx" > "%DST%\%NAME%\vol\07_LOGS_Application.md5"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO           Copying Logs as Evidence 2 of 11: copy "%SystemRoot%\System32\winevt\Logs\Replication.evtx"
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 2 of 11: copy "%SystemRoot%\System32\winevt\Logs\Replication.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy "%SystemRoot%\System32\winevt\Logs\DFS Replication.evtx" "%DST%\%NAME%\vol\07_LOGS_DFS Replication.evtx"
ECHO [%DATE% %TIME%] "copy "%SystemRoot%\System32\winevt\Logs\DFS Replication.evtx" "%DST%\%NAME%\vol\07_LOGS_DFS Replication.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_DFS Replication.evtx" > "%DST%\%NAME%\vol\07_LOGS_DFS Replication.md5"
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_DFS Replication.evtx" > "%DST%\%NAME%\vol\07_LOGS_DFS Replication.md5"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO           Copying Logs as Evidence 3 of 11: copy "%SystemRoot%\System32\winevt\Logs\HardwareEvents.evtx"
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 3 of 11: copy "%SystemRoot%\System32\winevt\Logs\HardwareEvents.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy "%SystemRoot%\System32\winevt\Logs\HardwareEvents.evtx" "%DST%\%NAME%\vol\07_LOGS_HardwareEvents.evtx"
ECHO [%DATE% %TIME%] "copy "%SystemRoot%\System32\winevt\Logs\HardwareEvents.evtx" "%DST%\%NAME%\vol\07_LOGS_HardwareEvents.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_HardwareEvents.evtx" > "%DST%\%NAME%\vol\07_LOGS_HardwareEvents.md5"
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_HardwareEvents.evtx" > "%DST%\%NAME%\vol\07_LOGS_HardwareEvents.md5"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO           Copying Logs as Evidence 4 of 11: copy "%SystemRoot%\System32\winevt\Logs\Internet Explorer.evtx"
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 4 of 11: copy "%SystemRoot%\System32\winevt\Logs\Internet Explorer.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy "%SystemRoot%\System32\winevt\Logs\Internet Explorer.evtx" "%DST%\%NAME%\vol\07_LOGS_Internet Explorer.evtx"
ECHO [%DATE% %TIME%] "%SystemRoot%\System32\winevt\Logs\Internet Explorer.evtx" "%DST%\%NAME%\vol\07_LOGS_Internet Explorer.evtx" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Internet Explorer.evtx" > "%DST%\%NAME%\vol\07_LOGS_Internet Explorer.md5"
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Internet Explorer.evtx" > "%DST%\%NAME%\vol\07_LOGS_Internet Explorer.md5"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO.

ECHO           Copying Logs as Evidence 5 of 11: copy "%SystemRoot%\System32\winevt\Logs\Key Management Servce.evtx"
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 5 of 11: copy "%SystemRoot%\System32\winevt\Logs\Key Management Servce.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy "%SystemRoot%\System32\winevt\Logs\Key Management Service.evtx" "%DST%\%NAME%\vol\07_LOGS_Key Management Service.evtx"
ECHO [%DATE% %TIME%] "copy "%SystemRoot%\System32\winevt\Logs\Key Management Service.evtx" "%DST%\%NAME%\vol\07_LOGS_Key Management Service.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Key Management Service.evtx" > "%DST%\%NAME%\vol\07_LOGS_Key Management Service.md5"
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Key Management Service.evtx" > "%DST%\%NAME%\vol\07_LOGS_Key Management Service.md5"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO           Copying Logs as Evidence 6 of 11: copy "%SystemRoot%\System32\winevt\Logs\Media Center.evtx"
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 6 of 11: copy "%SystemRoot%\System32\winevt\Logs\Media Center.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy "%SystemRoot%\System32\winevt\Logs\Media Center.evtx" "%DST%\%NAME%\vol\07_LOGS_Media Center.evtx"
ECHO [%DATE% %TIME%] "copy "%SystemRoot%\System32\winevt\Logs\Media Center.evtx" "%DST%\%NAME%\vol\07_LOGS_Media Center.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Media Center.evtx" > "%DST%\%NAME%\vol\07_LOGS_Media Center.md5"
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Media Center.evtx" > "%DST%\%NAME%\vol\07_LOGS_Media Center.md5"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO           Copying Logs as Evidence 7 of 11: copy "%SystemRoot%\System32\winevt\Logs\ODiag.evtx"
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 7 of 11: copy "%SystemRoot%\System32\winevt\Logs\ODiag.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy "%SystemRoot%\System32\winevt\Logs\ODiag.evtx" "%DST%\%NAME%\vol\07_LOGS_ODiag.evtx"
ECHO [%DATE% %TIME%] "copy "%SystemRoot%\System32\winevt\Logs\ODiag.evtx" "%DST%\%NAME%\vol\07_LOGS_ODiag.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_ODiag.evtx" > "%DST%\%NAME%\vol\07_LOGS_ODiag.md5"
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_ODiag.evtx" > "%DST%\%NAME%\vol\07_LOGS_ODiag.md5"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO           Copying Logs as Evidence 8 of 11: copy "%SystemRoot%\System32\winevt\Logs\OSession.evtx"
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 8 of 11: copy "%SystemRoot%\System32\winevt\Logs\OSession.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy "%SystemRoot%\System32\winevt\Logs\OSession.evtx" "%DST%\%NAME%\vol\07_LOGS_OSession.evtx"
ECHO [%DATE% %TIME%] "copy "%SystemRoot%\System32\winevt\Logs\OSession.evtx" "%DST%\%NAME%\vol\07_LOGS_OSession.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_OSession.evtx" > "%DST%\%NAME%\vol\07_LOGS_OSession.md5"
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_OSession.evtx" > "%DST%\%NAME%\vol\07_LOGS_OSession.md5"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO           Copying Logs as Evidence 9 of 11: copy "%SystemRoot%\System32\winevt\Logs\Security.evtx"
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 9 of 11: copy "%SystemRoot%\System32\winevt\Logs\Security.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy "%SystemRoot%\System32\winevt\Logs\Security.evtx" "%DST%\%NAME%\vol\07_LOGS_Security.evtx"
ECHO [%DATE% %TIME%] "copy "%SystemRoot%\System32\winevt\Logs\Security.evtx" "%DST%\%NAME%\vol\07_LOGS_Security.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Security.evtx" > "%DST%\%NAME%\vol\07_LOGS_Security.md5"
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Security.evtx" > "%DST%\%NAME%\vol\07_LOGS_Security.md5"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO           Copying Logs as Evidence 10 of 11: copy "%SystemRoot%\System32\winevt\Logs\Setup.evtx" 
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 10 of 11: copy "%SystemRoot%\System32\winevt\Logs\Setup.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy "%SystemRoot%\System32\winevt\Logs\Setup.evtx" "%DST%\%NAME%\vol\07_LOGS_Setup.evtx"
ECHO [%DATE% %TIME%] "copy "%SystemRoot%\System32\winevt\Logs\Setup.evtx" "%DST%\%NAME%\vol\07_LOGS_Setup.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Setup.evtx" > "%DST%\%NAME%\vol\07_LOGS_Setup.md5"
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_Setup.evtx" > "%DST%\%NAME%\vol\07_LOGS_Setup.md5"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO           Copying Logs as Evidence 11 of 11: copy "%SystemRoot%\System32\winevt\Logs\System.evtx"
ECHO [%DATE% %TIME%] "Copying Logs as Evidence 11 of 11: copy "%SystemRoot%\System32\winevt\Logs\System.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

copy "%SystemRoot%\System32\winevt\Logs\System.evtx" "%DST%\%NAME%\vol\07_LOGS_System.evtx"
ECHO [%DATE% %TIME%] "copy "%SystemRoot%\System32\winevt\Logs\System.evtx" "%DST%\%NAME%\vol\07_LOGS_System.evtx"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_System.evtx" > "%DST%\%NAME%\vol\07_LOGS_System.md5"
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b "%DST%\%NAME%\vol\07_LOGS_System.evtx" > "%DST%\%NAME%\vol\07_LOGS_System.md5"" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

:skip_evtx












ECHO.
ECHO.
CALL :color 0F "              ******************************************"  
ECHO.   
CALL :color 0F "              (Acquisition Phase 8 of 9 - Registry Data)"  
ECHO.          
CALL :color 0F "              ******************************************"
ECHO.
ECHO.
ECHO.

ECHO [%DATE% %TIME%] "******************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "(Acquisition Phase 8 of 9 - Registry Data)" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "******************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting User Assist Information: uassist_lv.exe
ECHO [%DATE% %TIME%] "Collecting User Assist Information: uassist_lv.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_uassist_lv.exe > %DST%\%NAME%\vol\08_REGISTRY_UserAssist.txt
ECHO [%DATE% %TIME%] ".\DFIR_uassist_lv.exe > %DST%\%NAME%\vol\08_REGISTRY_UserAssist.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\08_REGISTRY_UserAssist.txt > %DST%\%NAME%\vol\08_REGISTRY_UserAssist.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\08_REGISTRY_UserAssist.txt > %DST%\%NAME%\vol\08_REGISTRY_UserAssist.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 


ECHO      Collecting Registry Hives 
ECHO [%DATE% %TIME%] "Collecting Registry Hives" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO           Registry Hives 1 of 4 (SAM): reg save HKLM\SAM %DST%\%NAME%\reg\SAM
ECHO [%DATE% %TIME%] "Registry Hives 1 of 4 (SAM): reg save HKLM\SAM %DST%\%NAME%\reg\SAM" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_reg save HKLM\SAM %DST%\%NAME%\reg\SAM 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_reg save HKLM\SAM %DST%\%NAME%\reg\SAM 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\reg\SAM > %DST%\%NAME%\reg\SAM.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\reg\SAM > %DST%\%NAME%\reg\SAM.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Registry Hives 2 of 4 (SYSTEM): reg save HKLM\SAM %DST%\%NAME%\reg\SYSTEM
ECHO [%DATE% %TIME%] "Registry Hives 2 of 4 (SYSTEM): reg save HKLM\SAM %DST%\%NAME%\reg\SYSTEM" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_reg save HKLM\SYSTEM %DST%\%NAME%\reg\SYSTEM 2>&1 
ECHO [%DATE% %TIME%] ".\DFIR_reg save HKLM\SYSTEM %DST%\%NAME%\reg\SYSTEM 2>&1 " >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\reg\SYSTEM > %DST%\%NAME%\reg\SYSTEM.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\reg\SYSTEM > %DST%\%NAME%\reg\SYSTEM.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO          Registry Hives 3 of 4 (SECURITY): reg save HKLM\SAM %DST%\%NAME%\reg\SECURITY
ECHO [%DATE% %TIME%] "Registry Hives 3 of 4 (SECURITY): reg save HKLM\SAM %DST%\%NAME%\reg\SECURITY" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_reg save HKLM\SECURITY %DST%\%NAME%\reg\SECURITY 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_reg save HKLM\SECURITY %DST%\%NAME%\reg\SECURITY 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\reg\SECURITY > %DST%\%NAME%\reg\SECURITY.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\reg\SECURITY > %DST%\%NAME%\reg\SECURITY.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
 
ECHO.
ECHO          Registry Hives 4 of 4 (SOFTWARE): reg save HKLM\SAM %DST%\%NAME%\reg\SOFTWARE
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_reg save HKLM\SOFTWARE %DST%\%NAME%\reg\SOFTWARE 2>&1
ECHO [%DATE% %TIME%] "Registry Hives 4 of 4 (SOFTWARE): reg save HKLM\SAM %DST%\%NAME%\reg\SOFTWARE" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\reg\SOFTWARE > %DST%\%NAME%\reg\SOFTWARE.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\reg\SOFTWARE > %DST%\%NAME%\reg\SOFTWARE.md5%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_DELAY.EXE %DELAY%
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Using Harlan Carvey's Regripper
ECHO [%DATE% %TIME%] "Using Harlan Carvey's Regripper" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO             Regripper 1 of 4 (SAM): rip.exe -r %DST%\%NAME%\reg\SAM -f sam
ECHO [%DATE% %TIME%] "Regripper 1 of 4 (SAM): rip.exe -r %DST%\%NAME%\reg\SAM -f sam" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_rip.exe -r %DST%\%NAME%\reg\SAM -f sam > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SAM_ripped.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_rip.exe -r %DST%\%NAME%\reg\SAM -f sam > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SAM_ripped.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SAM_ripped.txt > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SAM_ripped.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SAM_ripped.txt > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SAM_ripped.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO             Regripper 2 of 4 (SYSTEM): rip.exe -r %DST%\%NAME%\reg\SAM -f SYSTEM 2>&1
ECHO [%DATE% %TIME%] "Regripper 2 of 4 (SYSTEM): rip.exe -r %DST%\%NAME%\reg\SAM -f SYSTEM 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_rip.exe -r %DST%\%NAME%\reg\SYSTEM -f system > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SYSTEM_ripped.txt
ECHO [%DATE% %TIME%] ".\DFIR_rip.exe -r %DST%\%NAME%\reg\SYSTEM -f system > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SYSTEM_ripped.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SYSTEM_ripped.txt > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SYSTEM_ripped.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SYSTEM_ripped.txt > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SYSTEM_ripped.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO             Regripper 3 of 4 (SOFTWARE): rip.exe -r %DST%\%NAME%\reg\SAM -f SOFTWARE 2>&1
ECHO [%DATE% %TIME%] "Regripper 3 of 4 (SOFTWARE): rip.exe -r %DST%\%NAME%\reg\SAM -f SOFTWARE 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_rip.exe -r %DST%\%NAME%\reg\SOFTWARE -f software > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SOFTWARE_ripped.txt
ECHO [%DATE% %TIME%] ".\DFIR_rip.exe -r %DST%\%NAME%\reg\SOFTWARE -f software > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SOFTWARE_ripped.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SOFTWARE_ripped.txt > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SOFTWARE_ripped.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SOFTWARE_ripped.txt > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SOFTWARE_ripped.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO             Regripper 4 of 4 (SECURITY): rip.exe -r %DST%\%NAME%\reg\SAM -f SECURITY 2>&1
ECHO [%DATE% %TIME%] "Regripper 4 of 4 (SECURITY): rip.exe -r %DST%\%NAME%\reg\SAM -f SECURITY 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_rip.exe -r %DST%\%NAME%\reg\SECURITY -f security > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SECURITY_ripped.txt
ECHO [%DATE% %TIME%] ".\DFIR_rip.exe -r %DST%\%NAME%\reg\SECURITY -f security > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SECURITY_ripped.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SECURITY_ripped.txt > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SECURITY_ripped.md5
ECHO [%DATE% %TIME%] ".\DFIR_md5deep.exe -b %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SECURITY_ripped.txt > %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SECURITY_ripped.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO      Collecting Users from Registry 
ECHO [%DATE% %TIME%] "Collecting Users from Registry" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO 		     Collecting Current Users's NTUSER.DAT: Reg Save KEY_CURRENT_USER
ECHO [%DATE% %TIME%] "Collecting Current Users's NTUSER.DAT: Reg Save KEY_CURRENT_USER" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
.\DFIR_rip.exe -r %DST%\%NAME%\reg\SOFTWARE -p profilelist > %DST%\%NAME%\vol\All_users.txt
ECHO [%DATE% %TIME%] ".\DFIR_rip.exe -r %DST%\%NAME%\reg\SOFTWARE -p profilelist > %DST%\%NAME%\vol\All_users.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.

.\DFIR_strings /accepteula %DST%\%NAME%\vol\All_users.txt |  .\DFIR_grep -i sid | .\DFIR_cut -d: -f2 > %DST%\%NAME%\vol\active_users.txt 2>&1
ECHO [%DATE% %TIME%] ".\DFIR_strings /accepteula %DST%\%NAME%\vol\All_users.txt |  .\DFIR_grep -i sid | .\DFIR_cut -d: -f2 > %DST%\%NAME%\vol\active_users.txt 2>&1" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
for /f %%a IN (%DST%\%NAME%\vol\active_users.txt) do .\DFIR_reg save hku\%%a %DST%\%NAME%\reg\%%a_ntuser.dat
ECHO [%DATE% %TIME%] "for /f %%a IN (%DST%\%NAME%\vol\active_users.txt) do .\DFIR_reg save hku\%%a %DST%\%NAME%\reg\%%a_ntuser.dat" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO.

.\DFIR_ls %DST%\%NAME%\reg | .\DFIR_grep ntuser > %DST%\%NAME%\vol\ntuser_files.txt
ECHO [%DATE% %TIME%] ".\DFIR_ls %DST%\%NAME%\reg | .\DFIR_grep ntuser > %DST%\%NAME%\vol\ntuser_files.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

echo     Parsing ntuser.dat hives
ECHO [%DATE% %TIME%] "echo     Parsing ntuser.dat hives" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
for /f %%a in (%DST%\%NAME%\vol\ntuser_files.txt) do .\DFIR_rip.exe -r %DST%\%NAME%\reg\%%a -f ntuser > %DST%\%NAME%\vol\%%a_ripped.txt
ECHO [%DATE% %TIME%] "for /f %%a in (%DST%\%NAME%\vol\ntuser_files.txt) do .\DFIR_rip.exe -r %DST%\%NAME%\reg\%%a -f ntuser > %DST%\%NAME%\vol\%%a_ripped.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log  

ECHO.
CALL :color 0F "             **********************************************"
ECHO.
CALL :color 0F "             (Acquisition Phase 9 of 9 - Timeline Creation)"  
ECHO.          
CALL :color 0F "             **********************************************"
ECHO.

ECHO [%DATE% %TIME%] "**********************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "(Acquisition Phase 9 of 9 - Timeline Creation)" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "**********************************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO      Creating Body File - fls.exe 
ECHO [%DATE% %TIME%] "Creating Body File - fls.exe" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_fls.exe -m C: -r \\.\C: >%DST%\%NAME%\timeline\fs_body
ECHO [%DATE% %TIME%] "REM .\DFIR_fls.exe -m C: -r \\.\C: >%DST%\%NAME%\timeline\fs_body" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_md5deep.exe -b %DST%\%NAME%\timeline\fs_body > %DST%\%NAME%\timeline\fs_body.md5
ECHO [%DATE% %TIME%] "REM .\DFIR_md5deep.exe -b %DST%\%NAME%\timeline\fs_body > %DST%\%NAME%\timeline\fs_body.md5" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 



ECHO Data Acquisition Table
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

.\DFIR_strings %DST%\%NAME%\vol\08_REGISTRY__%NAME%_SYSTEM_ripped.txt | .\DFIR_grep -i "computername" | .\DFIR_cut -c 19-39 > %DST%\%NAME%\vol\09_data_acquisition.txt
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

IF /I "%OSTYPE%" EQU "n" GOTO DA_IP_WIN7

.\DFIR_strings %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.txt | .\DFIR_grep "IP Address" | .\DFIR_cut -b 45-65 >> %DST%\%NAME%\vol\09_data_acquisition.txt
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

echo. >> %DST%\%NAME%\vol\09_data_acquisition.txt

GOTO DA_OSNAME

:DA_IP_WIN7

.\DFIR_strings %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.txt | .\DFIR_grep "IPv4 Address" | .\DFIR_cut -b 45-65 >> %DST%\%NAME%\vol\09_data_acquisition.txt
ECHO [%DATE% %TIME%] ".\DFIR_strings %DST%\%NAME%\vol\03_NETWORK_ipconfig_all.txt | .\DFIR_grep "IPv4 Address" | .\DFIR_cut -b 45-65 >> %DST%\%NAME%\vol\09_data_acquisition.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

echo. >> %DST%\%NAME%\vol\09_data_acquisition.txt

:DA_OSNAME
.\DFIR_strings %DST%\%NAME%\vol\08_REGISTRY_6_%NAME%_SOFTWARE_ripped.txt | .\DFIR_grep "ProductName =" | .\DFIR_cut -c 15-65 >> %DST%\%NAME%\vol\09_data_acquisition.txt
ECHO [%DATE% %TIME%] ".\DFIR_strings %DST%\%NAME%\vol\08_REGISTRY_6_%NAME%_SOFTWARE_ripped.txt | .\DFIR_grep "ProductName =" | .\DFIR_cut -c 15-65 >> %DST%\%NAME%\vol\09_data_acquisition.txt" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.

CALL :color 0F "                         ****************************** "
ECHO.
CALL :color 0F "                           Acquisition Phase Complete!  "
ECHO.
CALL :color 0F "                         ****************************** "
ECHO [%DATE% %TIME%] "******************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "  Acquisition Phase Complete! " >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "******************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
.\DFIR_DELAY.EXE 3


ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.


.\DFIR_Delay 3
ECHO [%DATE% %TIME%] ".\DFIR_DELAY.EXE %DELAY%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

IF /I "%GETIMAGE%" EQU "y" GOTO IMAGE  

GOTO end 

:image
REM --------------------------------------------------------------------
REM                         Imaging Phase
REM --------------------------------------------------------------------

CALL :color 0F "                         ******************************* "
ECHO.
CALL :color 0F "                            Imaging Phase Initialized    "
ECHO.
CALL :color 0F "                         ******************************* "

ECHO [%DATE% %TIME%] "*******************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "   Imaging Phase Initialized   " >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
ECHO [%DATE% %TIME%] "*******************************" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 

ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.

DFIR_ftkimager.exe \\.\PHYSICALDRIVE0 %DST%\%NAME%\image\%NAME%_Disk_Image --e01 --compress 1 --frag 2G --case-number %NAME%  --evidence-number %NAME% --description %NAME%
ECHO [%DATE% %TIME%] "IF /I "%GETIMAGE%" EQU "y" DFIR_ftkimager.exe \\.\PHYSICALDRIVE0 %DST%\%NAME%\image\%NAME%_Disk_Image --e01 --compress 1 --frag 2G --case-number %NAME%  --evidence-number %NAME% --description %NAME%" >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 



GOTO end
:color
set "param=^%~2" !
set "param=!param:"=\"!"
findstr /p /A:%1 "." "!param!\..\X" nul
<nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
exit /b


:end
ECHO.
ECHO    Done!
ECHO [%DATE% %TIME%] DFIRT Complete >> %DST%\%COMPUTERNAME%\%COMPUTERNAME%_DFIRT.log 
PAUSE


 
