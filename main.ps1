
$ROOTLocation = Get-Location
Import-Module $ROOTLocation/module/Get-FileMetaDataList


if (Test-Path -Path $ROOTLocation/Driver.txt) {
    Write-Host "Driver.txt exists"
} else {
    driverquery.exe /V /FO list | Out-File -FilePath $ROOTLocation/Driver.txt -Encoding ascii
}
if (Test-Path -Path $ROOTLocation/Drivers) {
    Write-Host "Drivers folder exists"
} else {
    New-Item -Path $ROOTLocation/Drivers -ItemType Directory
}

# Parser the text file
$drivers = Get-Content -Path $ROOTLocation/Driver.txt | ForEach-Object { $_.Trim() }



# Module Name:       1394ohci
# Display Name:      1394 OHCI Compliant Host Controller
# Description:       1394 OHCI Compliant Host Controller
# Driver Type:       Kernel 
# Start Mode:        Manual
# State:             Stopped
# Status:            OK
# Accept Stop:       FALSE
# Accept Pause:      FALSE
# Paged Pool(bytes): 4,096
# Code(bytes):       233,472
# BSS(bytes):        0
# Link Date:         
# Path:              C:\Windows\system32\drivers\1394ohci.sys
# Init(bytes):       4,096

foreach ($driver in $drivers) {
    if ($driver.Contains("Path") -or $driver.Contains("Module Name")) {
        
        if ($driver.Contains("Path")){
            $driver_file = $driver.Replace("Path:", "").Replace("\??\","").Trim();
            Write-Host "Getting metadata for $driver_file"
            Get-FileMetaDataList $driver_file | Out-File -FilePath $ROOTLocation/DriverInfo.txt -Encoding utf8 -Append
            Write-Host "$driver_file to $ROOTLocation/Drivers" 
            Copy-Item -Path $driver_file -Destination $ROOTLocation/Drivers/    
        }
    }
}

# $driverInfos = Get-Content -Path $ROOTLocation/DriverInfo.txt | ForEach-Object { $_.Trim() }
# foreach ($driverInfo in $driverInfos) {
#     if ($driverInfo.Contains("Description")){
#         # Write-Host $driverInfo
#     }
# }
    

            


