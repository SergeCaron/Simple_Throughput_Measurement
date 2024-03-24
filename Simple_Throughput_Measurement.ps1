##******************************************************************
## Revision date: 2024.03.23
##
## Simple Throughput Measurement
##
## Copyright (c) 2023-2024 PC-Évolution enr.
## This code is licensed under the GNU General Public License (GPL).
##
## THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
## ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
## IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
## PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
##
##******************************************************************

function HumanReadableSize([uint64] $ByteCount) {
	# Inspired by https://stackoverflow.com/questions/24616806/powershell-display-files-size-as-kb-mb-or-gb

	switch ([math]::truncate([math]::log($ByteCount, 1024))) {

		'0' { "$ByteCount Bytes" }

		'1' { "{0:n2}KB" -f ($ByteCount / 1KB) }

		'2' { "{0:n2}MB" -f ($ByteCount / 1MB) }

		'3' { "{0:n2}GB" -f ($ByteCount / 1GB) }

		'4' { "{0:n2}TB" -f ($ByteCount / 1TB) }

		'5' { "{0:n2}PB" -f ($ByteCount / 1PB) }

		Default { "{0:n2}EB" -f ($ByteCount / (1PB * 1024)) }
	}
}

# Select the endpoint of this test
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
	# InitialDirectory = [Environment]::GetFolderPath('Desktop') 
	InitialDirectory = $script:MyInvocation.MyCommand.Path
	Filter           = ''
	Title            = 'Please select a file in the test path endpoint'
}
$null = $FileBrowser.ShowDialog()
$TestPath = Split-Path -Path $FileBrowser.FileName

Write-Output ("                 Test path: {0}" -f $TestPath)

$TotalBytes = Get-ChildItem -Path $TestPath -File -Recurse | Measure-Object -Property length -Sum -Average
$ElapsedTime = Measure-Command { Get-ChildItem -Path $TestPath -File -Recurse | Get-FileHash -Algorithm SHA256 }

$MBps = ($TotalBytes.Sum / $ElapsedTime.TotalSeconds) / (1024 * 1024)

Write-Output ("               Total bytes: " + $(HumanReadableSize($TotalBytes.Sum)))
Write-Output ("       Duration in seconds: {0:n2}" -f $ElapsedTime.TotalSeconds)
Write-Output ("      Megabytes per second: {0:n2}" -f $MBps)
Write-Output ("                     Files: {0}" -f $TotalBytes.Count)
Write-Output ("Average file size in bytes: " + $( HumanReadableSize([System.Math]::Floor($TotalBytes.Average)) ))

Pause
