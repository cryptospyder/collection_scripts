rip.exe -r %DST%\%NAME%\vol\%NAME%_SOFTWARE_Hive -p profilelist > %DST%\%NAME%\vol\All_users.txt


strings /accepteula %DST%\%NAME%\vol\All_users.txt |  grep -i sid | grep -v "S-1-5-18" | grep -v "S-1-5-19" | grep -v "S-1-5-20" | cut -d: -f2 > %DST%\%NAME%\vol\active_users.txt


for /f %%a IN (%DST%\%NAME%\vol\active_users.txt) do reg save hku\%%a %DST%\%NAME%\vol\%%a_ntuser.dat


ls %DST%\%NAME%\vol | grep ntuser > %DST%\%NAME%\vol\ntuser_files.txt


echo     Parsing ntuser.dat hives


for /f %%a in (%DST%\%NAME%\vol\ntuser_files.txt) do rip.exe -r %DST%\%NAME%\vol\%%a -f ntuser > %DST%\%NAME%\vol\%%a_ripped.txt
 