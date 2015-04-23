SET /P OSTYPE=	Is this Windows XP? [Y/N]

IF /I "%OSTYPE%" EQU "n" GOTO netstatwin7 
ECHO you should not see this if you put "n"

:netstatwin7