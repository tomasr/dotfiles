$svc = Get-WmiObject -Query "Select * from Win32_Service where Name='WLanSvc'"

Stop-Process -Force -Id $svc.ProcessId

Start-Service -Name WLanSvc