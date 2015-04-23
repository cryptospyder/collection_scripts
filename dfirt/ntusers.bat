ECHO             Collecting Remaining NTUSER.DAT Files - creating list of files
dir /s /a /b c:\ | grep -i ntuser.dat | grep -v LOG > 06__list_of_NTUSER.DAT.txt

ECHO             Collecting Remaining NTUSER.DAT Files - copying the files
FOR %%g in 06_list_of_NTUSER.DAT.txt do echo %%g 