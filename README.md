# steamShortcuts

A simple (and ugly) powershell script to create startmenu shortcuts for all installed steamgames, so you can use the searchbar to quickly access them.

How to use:

Get steamcmd (https://developer.valvesoftware.com/wiki/SteamCMD) It's an official commandlinetool from valve. Put it into your steamfolder. Now open Powershell (just type it into the searchbar and hit enter) Browse to your steam installation directory by entering

cd 'C:\Program Files (x86)\Steam\' [enter]

(Adjust according to your installation dir)

Now copy and paste the script int your powershell and hit enter.

This creates real shortcuts (.lnk) of all installed steam-games instead of .url files into your startmenu in a folder named steam. Those shortcuts can be found by the search, pinned as a tile and have the icons set according to the game they are for. The script does NOT overwrite any preexisting lnk files.

Note: steam uses ':' in game names. The script simply removes them, as they are not allowed in filenames. The script doesn't check for any other unallowed characters, it may fail for some games.

Note2: You can also save the script into a file into your steamdirectory with .ps1 extension and execute it via '.\scriptpath\scriptname'. You may need to execute 'Set-ExecutionPolicy RemoteSigned Process' before the script, to allow scriptexecution for the duration of the powershellsession.
