# From: https://github.com/johnthebrit/PowerShellMC/blob/master/Sample.ps1

# Keyboard Shortcuts:
# Run Selection: F8
# Run:           F5

# Get-Help cmdlet: view the local help files
Get-Help Write-Host

# Hello World
Write-Output "Hello World"
Write-Host "Hello World"

Write-Host "no newline test " -NoNewline
Write-Host "second string"

# Use a variable
$name = "John"
Write-Output "Hello $name"

#Use an environment variable
Write-Output "Hello $Env:USERNAME"
Write-Output "This computer is $env:computername"

# Basic Pipeline
dir | Sort-Object -Descending
dir | Sort-Object lastwritetime
dir | sort-object –descending –property lastwritetime

# To show the object types being passed (using commandlet and alias)
Get-ChildItem | ForEach-Object {"$($_.GetType().fullname)  -  $_.name"}  # proper commandlet version
dir | foreach {"$($_.GetType().fullname)  -  $_.name"}  # lazy quick alias version

#Modules
Get-Module # see loaded modules
Get-Module –listavailable # see all available modules
Import-Module NetTCPIP  # add NetTCPIP module to PowerShell instance
Get-Command –Module NetTCPIP # list commands in a module
Get-Command -Module NetTCPIP | Select-Object -Unique Noun | Sort-Object Noun
Get-Command -Module NetTCPIP | Select -Unique Noun | Sort Noun  # lazy version
(Get-Module NetTCPIP).Version  # make sure module imported first or will not get output

# Az.Compute: cmdlets for Azure Resource Manager.
# Get-Module cmdlet: gets the modules that are already imported
# or that can be imported into the current session.
Get-Module Az.Compute.version 
$fqn = @{ModuleName="Microsoft.PowerShell.Management";ModuleVersion="3.1.0.0"}
Get-Module -FullyQualifiedName $fqn | Format-Table -Property Name,Version

# Install-Module cmdlet gets one or more modules that meet
# specified criteria from an online repository.
# dbatools: community module enables SQL Server to automate database dev and admin
# Get-InstalledModule cmdlet: gets PowerShell modules installed on local computer.
# Uninstall-Module cmdlet: uninstalls specified module from local computer. 
Install-Module dbatools              # Requires Administrator (takes a few minutes)
Get-InstalledModule -Name "dbatools"
Uninstall-Module -Name "dbatools"    # (takes a few minutes)
Get-InstalledModule -Name "dbatools" # Error: No match was found for the specified search...

# Get-Command cmdlet: gets list of commands installed on local computer.
Get-Command –Module NetTCPIP # gets cmdlets in module NetTCPIP
Get-Command –Noun NetTCPIP   # sorts cmdlets alphabetically by noun in cmdlet name

#Looking at variable type
notepad
$proc = Get-Process –name notepad # assign process object to variable
$proc                             # display process object
$proc.GetType().fullname          # type of object is System.Diagnostics.Process
$proc | Get-Member                # Get-Member: Get properties and methods of object
# Process handles property is number of handles that process has opened.
Get-Process | Where-Object {$_.handles -gt 900} | Sort-Object -Property handles |
    Format-Table name, handles -AutoSize

# Get-WinEvent commandlet: Gets events from event logs and event tracing logs on local and remote computers. 
Get-WinEvent -LogName security -MaxEvents 10 | 
    Select-Object -Property Id, TimeCreated, Message |
    Sort-Object -Property TimeCreated | convertto-html | out-file .\out\sec.html

# Reading and processing XML data

curl -Uri http://www.ibiblio.org/xml/examples/shakespeare/r_and_j.xml | `
    Select-Object -ExpandProperty Content | `
    Out-File -FilePath .\r_and_j\r_and_j.xml

$xml = [xml](get-content .\R_and_j\R_and_j.xml)
$xml.PLAY
$xml.PLAY.ACT
$xml.PLAY.ACT[0].SCENE[0].SPEECH
$xml.PLAY.ACT.SCENE.SPEECH | Group-Object speaker | Sort-Object count

# Output to file
Get-Process > procs.txt
Get-Process | Out-File .\out\procs.txt     # plain text
get-process | Export-csv .\out\proc.csv    # csv formatted text
get-process | Export-clixml .\out\proc.xml # xml formatted text

# Limiting objects returned
Get-Process | Sort-Object -Descending -Property StartTime | Select-Object -First 5

# Measure-Object commandlet: Calculates numeric properties of objects, and characters, words, and lines in string objects.
Get-ChildItem | Measure-Object       # Count the files and folders in a directory
Get-ChildItem | Measure-Object -Property length -Minimum -Maximum -Average
Get-Content .\R_and_j\R_and_j.xml | Measure-Object -Character -Line -Word
# Get-Process commandlet: gets processes running on local computer
Get-Process | Measure-Object                 # Only meaningful measure here is process count
Get-Process | Measure-Object WorkingSet -Sum # WorkingSet (WS) is process memory in bytes

# Get-EventLog cmdlet: Gets events from event log, or list of event logs, on local or remote computers.
Get-EventLog -LogName Security -newest 10
# Invoke-Command commandlet: Runs commands on local and remote computers.
# The backtick escapes newline in command (i.e. word-wrap)
# A script block is a statement list in braces
Invoke-Command `
    -ScriptBlock {Get-EventLog -LogName Security -newest 10}

# Compare-Object cmdlet: compares two sets of objects.
# One set of objects is the "reference set", the other set is the "difference set."
# The <= output indicates a property value only in the reference set.
# The => output indicates a property value only in the difference set.
# The == output indicates a property value in both reference set and difference set.
# This example: Get-Process is written to disk and then compared to 2nd Get-Process call
# They sould be mostly the same.
Get-Process | Export-csv .\out\proc.csv
Compare-Object `
    -ReferenceObject (Import-Csv .\out\proc.csv) `
    -DifferenceObject (Get-Process) `
    -Property Name `
    -IncludeEqual

# Start-Sleep commandlet: Suspends script/session for time period.
notepad
$procs1 = get-process
Start-Sleep -s 2
get-process -Name notepad | Stop-Process
$procs2 = get-process
Compare-Object -ReferenceObject $procs1 `
    -DifferenceObject $procs2 -Property Name

# $_ is an automatic variable for the current value in the pipe line.
# $_ is short for the $PSItem automatic variable
# the '%' symbol and ForEach are an alias for Foreach-Object
1,2,3 | Foreach-Object { write-host $PSItem }
4,5,6 | Foreach { write-host $_ }
7,8,9 | %{ write-host $PSItem }

# Where-Object commandlet: Selects objects from collection based on property values.
# Here we start notpad, then prompt to continue, then kill it
notepad
Read-Host -Prompt "Press any key to continue." 
Get-Process | Where-Object {$_.name –eq "notepad"} | Stop-Process

# These different syntax variations all do the same thing
Get-Process | Where-Object {$_.HandleCount -gt 900}
Get-Process | where {$_.HandleCount -gt 900}
Get-Process | where {$psitem.HandleCount -gt 900}
Get-Process | where HandleCount -gt 900
Get-Process | ? HandleCount -gt 900

# New-PSSession commandlet: Creates persistent connection to local or remote computer.
# NOTE: This example rewuires PowerShell run as administrator option.
Enable-PSRemoting -Force -SkipNetworkProfileCheck
$credential = Get-Credential -Credential PETERTHOR-PC\peterthor
$session = New-PSSession -ComputerName localhost -Credential $credential
Invoke-Command -Session $session -ScriptBlock {$myvar=10}
Invoke-Command -Session $session {$myvar*2} # 10*2 = 20
Get-PSSession
$session | Remove-PSSession

# Execution operator &
$comm = "get-process"
$comm   # Nope
&$comm  # Yep!

#Shows write-host vs write-output
# Write-Host writes to the console directly, not to the pipeline
# Write-Output, on the other hand, writes to the pipeline
function Receive-Output
{
    process { write-host $_ -ForegroundColor Green}
}
Write-Output "this test 1" | Receive-Output # The string object sent via pipe (green)
Write-Host "this is test 2" | Receive-Output   # No string object sent via pipe
Write-Output "this is test 3"                  # No pipe provided
Write-Host "this is test 4"                    # No pipe provided
[console]::WriteLine("this is test 5")         # Same as Write-Host