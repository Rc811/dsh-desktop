Set sh = CreateObject("Wscript.Shell")
appDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
electron = appDir & "\node_modules\electron\dist\electron.exe"
sh.CurrentDirectory = appDir
sh.Run """" & electron & """ """" & appDir & """", 0, False
