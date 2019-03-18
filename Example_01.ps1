# See: PowerShellNotesForProfessionals.pdf

# Keyboard Shortcuts:
# Run Selection: F8
# Run:           F5

# Clear terminal -> clear
# Clear PowerShell history -> Clear-History
# clear terminal's history -> Alt+F7

# Write-Output and Write-Host write to console.
# Write-Output writes to console and [success] stream.
# Write-Output supports stream redirection and piping.
# Write-Host writes only to console.
# Write-Host does not support stream redirection or piping.

<#
This is a multi-line
comment
#> 

# Write-Output writes to console
Write-Output "Write-Output test"
# Write-Host writes to console
Write-Host   "Write-Host test"

# Aliases for Write-Output
echo 'Hello world'
write 'Hello world'

# Write-Output redirected to file writes string to file
Write-Output "Write-Output test" > .\data\Write-Output_test.txt
# Write-Host redirected to file writes NOTHING to file
Write-Host   "Write-Host test"   > .\data\Write-Host_test.txt # empty file

# Write-Output to write a custom object
$myobject = @{first="Peter"; last="Thor"}
Write-Output $myobject # to console
Write-Output $myobject > .\data\Write-Output_myobject.txt # to file
Write-Output $myobject | Format-List # piped to format commandlet

# Write-Host to write a custom object
$myobject = @{first="Peter"; last="Thor"}
Write-Host $myobject # to console
Write-Host $myobject > .\data\Write-Host_myobject.txt # nothing redirected
Write-Host $myobject | Format-List # nothing piped

# Get-ChildItem commandlet: gets items and child items in location
# Location can be directory, registry hive, or certificate store.
# The default location is the current directory.
Get-ChildItem

# Select-Object Name -> only show the Name property of each object
Get-ChildItem | Select-Object Name 

# Aliases for Get-ChildItem
gci
dir
ls

# ForEach-Object cmdlet: performs operation on objects in collection
Get-ChildItem | ForEach-Object `
    { Write-Host $_.Name $_.LastWriteTime }

# An short syntax for the previous Commandlet
gci | % { Write-Host $_.Name $_.LastWriteTime }

# Set-Alias cmdlet creates an alias for a Commandlet
Set-Alias -Name tnc_ping -Value Test-NetConnection
tnc_ping

# Calling .Net library static method: Path.GetFileName()
[System.IO.Path]::GetFileName('C:\Windows\notepad.exe')

# Calling .Net library instance method: DateTime.AddHours()
$datetime = [System.DateTime]::Now
$datetime
$datetime.AddHours(3)
$datetime

# Create a DateTime object and store the object in variable
$dt = New-Object System.DateTime
$dt
# calling constructor with parameters
$sw = New-Object System.IO.StreamWriter -ArgumentList ".\data\StreamWriter_test.txt"
$sw
$sw.WriteLine("System.IO.StreamWriter object wrote this!");
$sw.Close();

# Hashtable literal syntax
$ht = @{ key1 = "red"; key2 = "green"; key3 = "blue"}
$ht

# Array literal syntax
$a = 1,2,3
$a
$a.GetType()
$a -join ','
$b = $a + 4
$b -join ','
$b.GetType()

# Array literal syntax using array operator @
$a = @(1,2,3)
$a
$a.GetType()
$a -join ','
$b = $a + 4
$b -join ','
$b.GetType()

$myArrayOfInts = 1,2,3,4
$myOtherArrayOfInts = 5,6,7
$myArrayOfInts = $myArrayOfInts + $myOtherArrayOfInts
$myArrayOfInts -join ',' # 1,2,3,4,5,6,7

# Using the Split method of String
$input = "foo.bar.baz"
$parts = $input.Split(".")
$foo = $parts[0]
$bar = $parts[1]
$baz = $parts[2]
$foo
$bar
$baz

# Using multi variable assignment
$rgb = "red|green|blue"
$r, $g, $b = $rgb.Split("|")
$r
$g
$b

# Parameter splatting
$colors = @{ForegroundColor = "black"; BackgroundColor = "yellow"}
Write-Host "This is a test." @colors
Write-Host @colors "This is another test."

# create a hash table based custom object 
$myObject = New-Object -TypeName PSObject -Property @{
    Key1 = 'Value1'
    Key2 = 'Value2'
}
$myObject.key1
$myObject.key2

# Create a PSCustomObject based custom object
$myPSObject = [PSCustomObject]@{    
    Key1 = 'Value1'
    Key2 = 'Value2'
}
$myPSObject.key1
$myPSObject.key2

# Simple comparison operators (all True)
2 -eq 2    # Equal to (==)
2 -ne 4    # Not equal to (!=)
5 -gt 2    # Greater-than (>)
5 -ge 5    # Greater-than or equal to (>=)
5 -lt 10   # Less-than (<)
5 -le 5    # Less-than or equal to (<=)

# Case-Insensitive Explicit (-ieq)
# Case-Sensitive Explicit (-ceq)
#Case-Insensitive is the default if not speciﬁed
"Hello" -eq "hello"  # True
"Hello" -ieq "hello" # True
"Hello" -ceq "hello" # False

"MyString" -like "*String"     # True match using wildcard (*)
"MyString" -notlike "Other*"   # True non-match using wildcard (*)
"MyString" -match '^String$'   # False match string using regex
"MyString" -notmatch '^Other$' # True non-match using regex

"abc", "def" -contains "def"    # True
"abc", "def" -notcontains "123" # True
"def" -in "abc", "def"          # True
"123" -notin "abc", "def"       # True

# Arithmetic Operators
1 + 2      # addition        3
1 - 2      # subtraction    -1
-1         # negation       -1
1 * 2      # multiplication  2
1 / 2      # division        0.5
1 % 2      # modulus         1

# Assignment Operators
$var  = 1 # assignment
$var += 2 # auto addition 
$var -= 1 # auto subtraction
$var *= 2 # auto multiplication
$var /= 2 # auto division
$var %= 2 # auto modulus
$var++    # auto increment
$var--    # auto decriment

# Redirection Operators
#Success output stream (cmdlet is a syntactic placeholder and is not defined here)
cmdlet > file     # Send success output to file, overwriting existing content
cmdlet >> file    # Send success output to file, appending to existing content
cmdlet 1>&2       # Send success and error output to error stream
#Error output stream:
cmdlet 2> file    # Send error output to file, overwriting existing content
cmdlet 2>> file   # Send error output to file, appending to existing content
cmdlet 2>&1       # Send success and error output to success output stream
#Warning output stream: (PowerShell 3.0+)
cmdlet 3> file    # Send warning output to file, overwriting existing content
cmdlet 3>> file   # Send warning output to file, appending to existing content
cmdlet 3>&1       # Send success and warning output to success output stream
#Verbose output stream: (PowerShell 3.0+)
cmdlet 4> file    # Send verbose output to file, overwriting existing content
cmdlet 4>> file   # Send verbose output to file, appending to existing content
cmdlet 4>&1       # Send success and verbose output to success output stream
#Debug output stream: (PowerShell 3.0+)
cmdlet 5> file    # Send debug output to file, overwriting existing content
cmdlet 5>> file   # Send debug output to file, appending to existing content
cmdlet 5>&1       # Send success and debug output to success output stream
#Information output stream: (PowerShell 5.0+)
cmdlet 6> file    # Send information output to file, overwriting existing content
cmdlet 6>> file   # Send information output to file, appending to existing content
cmdlet 6>&1       # Send success and information output to success output stream
#All output streams:
cmdlet *> file    # Send all output streams to file, overwriting existing content
cmdlet *>> file   # Send all output streams to file, appending to existing content
cmdlet *>&1       # Send all output streams to success output stream

# type of the left operand dictates the behavior
"4" + 2         # Gives "42" 
4 + "2"         # Gives 6 
1,2,3 + "Hello" # Gives 1,2,3,"Hello"
"Hello" + 1,2,3 # Gives "Hello1 2 3"
"3" * 2         # Gives "33"
2 * "3"         # Gives 6
1,2,3 * 2       # Gives 1,2,3,1,2,3
#2 * 1,2,3      # Gives an ERROR op_Multiply missing

Logical Operators
$true -and $true  # Logical and
$true -or $false  # Logical or
$true -xor $false # Logical exclusive or
-not $false       # Logical not
!$false           # Logical not

# String Manipulation Operators
"The rain in Spain" -replace 'rain','wine'  # returns "The wine in Spain"
# \w matches an ascii letter.
# $1 is the text matched by the first capturing group.
# + matches one or more occurrences
"sally@contoso.com" -replace '^[\w]+@(.+)', '$1'  # returns: contoso.com

# -split operator splits a string into an array of sub-strings.
"A B C" -split " "      #Returns an array of strings.
# -join operator joins an array of strings into a string.
"E","F","G" -join ":"   #Returns a single string

# Array subexpression operator @( )
@(Get-ChildItem $env:windir\System32\ntdll.dll) # return array with one item
@(Get-ChildItem $env:windir\System32)           # return expression as array

# Call operator &
$cmdlet = "get-executionpolicy" # assign Commandlet object to variable
$cmdlet   # display Commandlet object
& $cmdlet # invoke Commandlet object

# Index operator [ ]
$a = 1, 2, 3
$a[0]
$ht = @{key="value"; name="PowerShell"; version="2.0"}
$ht["name"]

# Dot sourcing operator
. .\scripts\Do-Something.ps1
Do-Something -Thing "***The Thing***"

#  Filtering: Where-Object / where / ?
$names = @( "Aaron", "Albert", "Alphonse","Bernie", "Charlie", "Danny", "Ernie", "Frank")
$names | Where-Object { $_ -like "A*" } 
$names | where { $_ -like "A*" }
$names | ? { $_ -like "A*" }

#  Ordering: Sort-Object / sort
$names = @( "Aaron", "Aaron", "Bernie", "Charlie", "Danny", "Joe" )
$names | Sort-Object
$names | sort
$names | Sort-Object -Descending
$names | sort -Descending
$names | Sort-Object { $_.length }

#  Grouping: Group-Object / group
$names = @( "Aaron", "Albert", "Alphonse","Bernie", "Charlie", "Danny", "Ernie", "Frank")
$names | Group-Object -Property Length
$names | group -Property Length

# Projecting: Select-Object / select
$dir = dir ".\"
$dir | Select-Object Name, FullName, Attributes
$dir | select Name, FullName, Attributes

#Selecting the ﬁrst element, and show all its properties:
$dir | select -first 1 *

# Conditional Logic 

# if statement
$test = "test"
if ($test -eq "test") { Write-Host -f yellow "condition met" }

# if-else statement
$test = "test"
if ($test -eq "test2") { Write-Host -f yellow "condition met" }
 else{Write-Host -f yellow "condition not met" }

# if-elseif statement
$test = "test"
if ($test -eq "test2") { Write-Host -f yellow "if condition met" }
elseif ($test -eq "test") { Write-Host -f yellow "ifelse condition met" }

# Negation with !
$test = "test"
if (!($test -eq "test2")){ Write-Host -f yellow "negated condition not met" }

# truthy and false values
$boolean = $false;
$string = "false";
$emptyString = "";
If ($boolean) { Write-Host "1 is not run" }     # not run (boolean $false is falsy)
If ($string) { Write-Host "2 is run" }          # run (non-empty string is truthy)
If ($emptyString){ Write-Host "3 is not run" }  # not run (empty string is falsy)
If ($null){ Write-Host "4 is not run" }         # not run ($null is falsy)

# Foreach Loop
$Names = @('Amy', 'Bob', 'Celine', 'David')
ForEach ($Name in $Names) { Write-Host "Hi, my name is $Name!" }

ForEach ($Number in 1..5) {
    $Number
}

$numbers = @()
ForEach ($number in 1..5) { $numbers += $number } 
Write-Host -NoNewline $numbers
Write-Host

# for loop
$numbers = for($i = 0; $i -le 5; $i++) { "$i" }
Write-Host -NoNewline $numbers
Write-Host

# ForEach() Method
(1..5).ForEach({$_ * $_})

# ForEach-Object
$names = @("Any","Bob","Celine","David")
$names | ForEach-Object { "Hi, my name is $_!" }
$names | foreach { "Hi, my name is $_!" }        # % foreach for ForEach-Object
$names | % { "Hi, my name is $_!" }              # % alias for ForEach-Object

# Advanced Foreach-Object Usage
$results = @()
"Any","Bob","Celine","David" | ForEach-Object -Begin {
    Write-Host "Foreach-Object -Begin"
} -Process {
    # Create and append message to $results
    Write-Host "Foreach-Object -Process"
    $results += "Hi, my name is $_!"
} -End {
    Write-Host "Foreach-Object -End"
    # Count messages and output $results
    Write-Host "Total messages: $($results.Count)"
    $results
}

#  Continue
$i =0
while ($i -lt 10) {
    $i++
    if ($i -eq 7) { continue } # 7 gets skipped
    Write-Host $i
}

#  Break
$i = 0
while ($i -lt 10) {
    $i++
    if ($i -eq 7) {break} # loop terminates when $i hits 7
    Write-Host $i
}

# Break Label
# This code will increment $i to 8 and $j to 13 which will cause $k to equal 104.
# Since $k exceed 100, the code will then break out of both loops. 
$i = 0
:mainLoop While ($i -lt 15) {
    Write-Host $i -ForegroundColor 'Cyan'
    $j = 0
    While ($j -lt 15) {
        Write-Host $j -ForegroundColor 'Magenta'
        $k = $i*$j
        Write-Host $k -ForegroundColor 'Green'
        if ($k -gt 100) {
            break mainLoop # break out to outer loop
        }
        $j++
    }
    $i++
}

#  While Loop
$i = 5
while($i -ge 0) {
    $i
    $i--
}

# 
Write-Host -f yellow "Notepad is starting."
Start-Process notepad.exe
# PowerShell will treat the existence of a return object as true
while(Get-Process notepad -ErrorAction SilentlyContinue) {
    Start-Sleep -Milliseconds 500 # poll for existence of Notepad process
}
# Notepad process must have been terminated, probably the user closed it.
Write-Host -f yellow "Notepad has terminated."

# Do while and Do until Loops run codeblock at least once. 
$i = 0
Do {
    $i++
    "Number $i"
} while ($i -ne 3)

$i = 0
Do {
    $i++
    "Number $i"
} until ($i -eq 3)

#  Switch statement
$color = 'green'
switch($color) {
    'red'   { Write-Host -f red 'red was selected' }     # no match
    'green' { Write-Host -f green 'green was selected' } # yes match
    'blue'  { Write-Host -f blue 'blue was selected' }   # no match
}

# Switch Statement without CaseSensitive Parameter
$color =  'Yellow'
switch ($color) {
    'yellow' { Write-Host -f yellow 'yellow was selected' } # yes match
    'Yellow' { Write-Host -f yellow 'Yellow was selected' } # yes match
    'YELLOW' { Write-Host -f yellow 'YELLOW was selected' } # yes match
}

# Switch Statement without CaseSensitive Parameter using breaks
$color =  'Yellow'
switch ($color) {
    'yellow' { Write-Host -f yellow 'yellow was selected'; break } # only first match
    'Yellow' { Write-Host -f yellow 'Yellow was selected'; break } # never get to this match
    'YELLOW' { Write-Host -f yellow 'YELLOW was selected'; break } # never get to this match
}

# Switch Statement with CaseSensitive Parameter
$color =  'Yellow'
switch -CaseSensitive ($color) {
    'yellow' { Write-Host -f yellow 'yellow was selected' } # no match
    'Yellow' { Write-Host -f yellow 'Yellow was selected' } # yes match
    'YELLOW' { Write-Host -f yellow 'YELLOW was selected' } # no match
}

# Switch Statement with Wildcard Parameter
$fg = $host.ui.RawUI.ForegroundColor
$host.ui.RawUI.ForegroundColor = "yellow"
switch -Wildcard ('Condition') {
    'Condition'         {'Normal match'}                 # yes match
    'Condit*'           {'Zero or more wildcard chars.'} # yes match
    'C[aoc]ndit[f-l]on' {'Range and set of chars.'}      # yes match
    'C?ndition'         {'Single char. wildcard'}        # yes match
    'Test*'             {'No match'} }                   # no match
$host.ui.RawUI.ForegroundColor = $fg

# Switch Statement with File Parameter
# The -file parameter allows the switch statement to receive input from a ﬁle.
# Each line of the ﬁle is evaluated by the switch statement.
$fg = $host.ui.RawUI.ForegroundColor
$host.ui.RawUI.ForegroundColor = "yellow"
switch -file .\data\Switch_file_input.txt {
    'good' { 'Good hair day.' }
    'bad'  { 'Bad hair day.' }
    'none' { 'No hair day.' }
    default { 'Unreconized hair day.' }
}
$host.ui.RawUI.ForegroundColor = $fg

# Switch Statement with Regex Parameter
$fg = $host.ui.RawUI.ForegroundColor
$host.ui.RawUI.ForegroundColor = "yellow"
$condition = "Con42dition" #try "Banana"
switch -Regex ($condition) {
    'Con42dition'     {'Perfect match'}                       # Yes perfect match
    'Con[0-9]+dition' {'One or more non-digits'}              # Yes match
    'Conditio*$'      {'Zero or more "o"'}                    # No match
    'C.n42dition'     {'Any single char.'}                    # Yes match
    '^C\w+ition$'     {'Anchors and one or more word chars.'} # Yes match
    'Banana'          {'Banana'}                              # No match
}
$host.ui.RawUI.ForegroundColor = $fg

#  Switch Statement with Exact Parameter
#  -Exact parameter enforces switch statements to perform exact case-insensitive matching
$fg = $host.ui.RawUI.ForegroundColor
$host.ui.RawUI.ForegroundColor = "yellow"
switch -Exact ('Condition')
{
    'condition'   {'First Action'}  # yes match
    'Condition'   {'Second Action'} # yes match
    'conditioN'   {'Third Action'}  # yes match
    '^*ondition$' {'Fourth Action'} # no match (wildcard strings fail)
    'Conditio*'   {'Fifth Action'}  # no match (wildcard strings fail)
 }
 $host.ui.RawUI.ForegroundColor = $fg

# Switch Statement with Expression Cases
$fg = $host.ui.RawUI.ForegroundColor
$host.ui.RawUI.ForegroundColor = "yellow"
$myInput = 0
switch($myInput) {
    # result of expression = 4, does not equal input 0 -> block is not run.
    (2+2)  { 'True. 2+2 == 4' }
    # result of  expression = 0, does equal input 0 -> block is run.
    (2-2) { 'True. 2-2 == 0' }
    # input 0 > -1 and < 1, so expression evaluates to true -> block is run.
    {$_ -gt -1 -and $_ -lt 1 } { 'True. 0 > -1 and 0 < 1' }
}
$host.ui.RawUI.ForegroundColor = $fg

#  Strings
$fg = $host.ui.RawUI.ForegroundColor
$host.ui.RawUI.ForegroundColor = "yellow"
"Hello`r`nWorld"
""
"Hello{0}World" -f [environment]::NewLine
""
"Hello
World"
""
# Using a here-string ( can use quotes without having to escape them using a backtick)
@"
    Simple
        Multiline string with "quotes"
"@ 

$string1 = "Power"
$string2 = "Shell"
"Greetings from $string1$string2"

$string1 = "Greetings from"
$string2 = "PowerShell"
$string1 + " " + $string2

"The title of this console is '" + $host.Name + "'" 

# Using subexpressions
"Tomorrow is $((Get-Date).AddDays(1).DayOfWeek)"

# Special characters
# When inside double-quoted string, escape character (backtick) represents
# special characters.

"`0"   # Null
"`a"   # Alert/Beep (you can hear this one)
"`b"   # Backspace
"`f"   # Form feed (used for printer output)
"`n "  # New line
"`r"   # Carriage return
"`t "  # Horizontal tab
"`v"   # Vertical tab (used for printer output)
"`#"     # Comment-operator
"`$"     # Variable operator
"``"     # Escape character
"`'"     # Single quote
"`" "    # Double quote

"This`tuses`ttabs.`r`nThis is on a second line." 

#  Format string
$hashtable = @{ city = 'Seattle' }
$result = 'You should visit {0}' -f $hashtable.city
Write-Host $result # prints "You should visit Seattle"

$host.ui.RawUI.ForegroundColor = $fg

