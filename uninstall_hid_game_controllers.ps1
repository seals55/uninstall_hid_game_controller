# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}


$HID_Game_Controllers = @(Get-WmiObject Win32_PnPSignedDriver | Where-Object DeviceName -eq "HID-compliant game controller" | Select-Object DeviceID -Unique | ForEach-Object { $_.DeviceID })
ForEach ($ID in $HID_Game_Controllers) {
    Disable-PnpDevice -InstanceId "$ID" -Confirm:$false
}
