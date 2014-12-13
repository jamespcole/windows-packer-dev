:: Hide desktop icons because they are annoying
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V HideIcons /T REG_DWORD /D 1 /F

reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d C:\Windows\Web\Wallpaper\Theme1\img1.jpg /f
::RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

:: restore the start menu icons
copy /b/v/y a:\appsFolder.itemdata-ms "C:\Users\vagrant\AppData\Local\Microsoft\Windows\"
copy /b/v/y a:\appsFolder.bak "C:\Users\vagrant\AppData\Local\Microsoft\Windows\appsFolder.itemdata-ms.bak"

taskkill /f /im explorer.exe

start explorer.exe

::Set the date and time to the correct format
reg add "HKEY_CURRENT_USER\Control Panel\International" /t REG_SZ /v sShortDate /d "dd/MM/yyyy" /f

reg add "HKEY_CURRENT_USER\Control Panel\International" /t REG_SZ /v sShortTime /d "HH:mm" /f

reg add "HKEY_CURRENT_USER\Control Panel\International" /t REG_SZ /v sTimeFormat /d "HH:mm:ss" /f


reg add "HKEY_USERS\.Default\Control Panel\International" /t REG_SZ /v sShortDate /d "dd/MM/yyyy" /f

reg add "HKEY_USERS\.Default\Control Panel\International" /t REG_SZ /v sShortTime /d "HH:mm" /f

reg add "HKEY_USERS\.Default\Control Panel\International" /t REG_SZ /v sTimeFormat /d "HH:mm:ss" /f


::DEL /F /S /Q /A "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*"
::copy /y "%userprofile%\Desktop\Taskbar-Pinned-Apps-Backup\TaskBar" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" 

::REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F

::REG IMPORT "%userprofile%\Desktop\Taskbar-Pinned-Apps-Backup\Taskbar-Pinned-Apps-Backup.reg"