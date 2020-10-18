function executeSteamCmd {
Write-Host "Executing Steamcmd"
	if($PSScriptRoot){
		$myScriptRoot = "$PSScriptRoot\"
	}
	$arguments = @()
	for($i=0; $i -lt $args.count; $i++){
		for($j=0; $j -lt $args[$i].count; $j++){
			if($args[$i].GetType() -eq [String]){
				$arguments += $args[$i]
				break
			}
			$arguments += $args[$i][$j]
		}
	}
	#forcing the pipe to flush by spamming some useless output
	for($i=0; $i -lt 50; $i++){
		$arguments+="+app_info_print 0"
	}
	$arguments+="+quit"
	[string]$out= & (Get-Item "$($myScriptRoot)steamcmd.exe").FullName $arguments
	$out
}



function createShortcut{
	if($PSScriptRoot){
		$myScriptRoot = "$PSScriptRoot\"
	}
	
	Write-Host "creating Shortcut"
	$shell = New-Object -comObject WScript.Shell
	if(Test-Path "$Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\$($args[0].Name).lnk"){
		Write-Host "skipping shortcut $Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\$($args[0].Name).lnk (file already exists)"
		return
	}
	Write-Host "creating shortcut $Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\$($args[0].Name).lnk"
	$lnk = $shell.CreateShortcut("$Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\$($args[0].Name).lnk")
	$lnk.TargetPath = (Get-Item "$($myScriptRoot)steam.exe").FullName
	$lnk.Arguments = "-applaunch $($args[0].AppID)"
	if(Test-Path $args[0].Icon){
		$lnk.IconLocation = $args[0].Icon
	}else{
		$lnk.IconLocation = $args[0].Path
	}
	$lnk.Save()
}




	[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
	if($PSScriptRoot){
		$myScriptRoot = "$PSScriptRoot\"
	}
	Write-Host "start"
	if(-not (Test-Path "$Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\")){
		mkdir "$Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\"
	}
	$tmp = (executeSteamCmd "+apps_installed" | Select-String "AppID (\d*) : `"([^`"]*)`" : (.*?)  " -AllMatches).Matches
	$installed = @()
	for($i=0; $i -lt $tmp.count; $i++){
		$installed += (,@{"AppID" = $tmp[$i].Groups[1].value; "Name"=$tmp[$i].Groups[2].value.replace(":",""); "Path" = $tmp[$i].Groups[3].value; "Icon" = ""})
	}
	$arguments = $installed.AppID|%{"+app_info_print $_"}
	$tmp = ((executeSteamCmd $arguments[0..$arguments.count]) | Select-String "AppID : (\d*),.*?`"clienticon`"\s*`"([^`"]*)`".*?`"executable`"\s*`"([^`"]*?\.exe)`"" -AllMatches).Matches
	#"
	for($i=0; $i -lt $tmp.count; $i++){
		$installed[$installed.AppID.indexOf([string]($tmp[$i].Groups[1].value))].Path+="\$($tmp[$i].Groups[3].value)"
		$installed[$installed.AppID.indexOf([string]($tmp[$i].Groups[1].value))].Icon="$($(Get-Item "$($myScriptRoot)steam\games\").FullName)$($tmp[$i].Groups[2].value).ico"
	}
	for($i=0; $i -lt $installed.count; $i++){
		createShortcut $installed[$i]
	}
    
